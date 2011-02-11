/******************************************************************************* 
 * Copyright (c) 2010 Pablo Hess. All rights reserved.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/

package org.skramboord

import java.text.Format
import java.text.SimpleDateFormat
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;

class SprintController extends BaseController {

	def index = {
		redirect(controller:'sprint', action:'list')
	}

	def list = {
		flash.twitterAppSettings = getSystemPreferences().twitterSettings

		if (params.project) {
			session.project = Project.get(params.project)
		} else {
			session.project = Project.get(session.project.id)
		}

		// check if this user has access rights
		if (sprintViewPermission(session.user, session.project)) {
			redirect(controller:'project', action:'list')
		}

		flash.watchList = User.followers(session.project).list()
		flash.teamList = User.projectTeam(session.project).list()

		flash.fullList = new HashSet<User>()
		flash.fullList.addAll(flash.watchList)
		flash.fullList.addAll(flash.teamList)
		flash.fullList.add(session.project.owner)
		flash.fullList.add(session.project.master)
		flash.fullList = flash.fullList.sort{it.username }

		flash.personList = User.list(params)
		flash.personList.removeAll(flash.fullList)

		flash.releaseList = Release.withCriteria {
			eq('project', session.project)
			order('name','asc')
		}

		// teammate or follower?
		if (sprintWritePermission(session.user, session.project)) {
			flash.teammate = true
		}

		flash.priorityList=Priority.list()

		// product backlog
		flash.backlogLow = Task.projectBacklogWithPriority(session.project, Priority.byName(Priority.LOW).list()?.first()).list()
		flash.backlogNormal = Task.projectBacklogWithPriority(session.project, Priority.byName(Priority.NORMAL).list()?.first()).list()
		flash.backlogHigh = Task.projectBacklogWithPriority(session.project, Priority.byName(Priority.HIGH).list()?.first()).list()
		flash.backlogUrgent = Task.projectBacklogWithPriority(session.project, Priority.byName(Priority.URGENT).list()?.first()).list()
		flash.backlogImmediate = Task.projectBacklogWithPriority(session.project, Priority.byName(Priority.IMMEDIATE).list()?.first()).list()
	}

	/**
	 * Add new sprint
	 */
	def addSprint = {
		if (sprintWritePermission(session.user, session.project)) {
			def startDate = params.startDateHidden ? new Date(params.startDateHidden) : null
			def endDate = params.endDateHidden ? new Date(params.endDateHidden) : null

			Sprint sprint = new Sprint(name: params.sprintName, goal: params.sprintGoal, personDays: params.sprintPersonDays, startDate: startDate, endDate: endDate, release: Release.get(params.releaseId))
			if (!sprint.save()) {
				Format formatter = new SimpleDateFormat("yy-MM-dd")
				flash.sprintStartDate = formatter.format(startDate)
				flash.sprintEndDate = formatter.format(endDate)

				flash.sprintIncomplete=sprint
				flash.objectToSave=sprint
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	def edit = {
		if (sprintWritePermission(session.user, session.project)) {
			if (params.sprint) {
				flash.sprintEdit = Sprint.get(params.sprint)
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	/**
	 * Sprint edit action
	 */
	def update = {
		if (sprintWritePermission(session.user, session.project)) {
			if (params.sprintId) {
				def sprint = Sprint.get(params.sprintId)
				sprint.name = params.sprintName
				sprint.goal = params.sprintGoal
				sprint.personDays = params.sprintPersonDays ?  params.sprintPersonDays.toDouble() : null

				if (params.startDateHidden) {
					sprint.startDate = new Date(params.startDateHidden)
				}
				if (params.endDateHidden) {
					sprint.endDate = new Date(params.endDateHidden)
				}
				if (!sprint.save()) {
					flash.objectToSave=sprint
				}
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	/**
	 * Sprint delete action
	 */
	def delete = {
		if (sprintWritePermission(session.user, session.project)) {
			if (params.sprint) {
				def sprint = Sprint.get(params.sprint)
				sprint.delete()

				flash.message = message(code:"sprint.deleted", args:[sprint.name])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	/**
	 * Sets a new scrum master.
	 */
	def movePersonToScrumMaster = {
		if (sprintWritePermission(session.user, session.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			session.project.refresh()
			if (session.project.owner.id != user.id) {
				if (User.projectTeam(session.project).list().contains(user)) {
					// Remove as developer
					removeDeveloper(user, session.project)
				}
				if (User.followers(session.project).list().contains(user)) {
					// Remove as follower
					Follow.unlink(session.project, user)
				}

				session.project.master = user
				session.project.save()
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	/**
	 * Sets a new product owner.
	 */
	def movePersonToProdctOwner = {
		if (sprintWritePermission(session.user, session.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			session.project.refresh()
			if (session.project.master.id != user.id) {
				if (User.projectTeam(session.project).list().contains(user)) {
					// Remove as developer
					removeDeveloper(user, session.project)
				}
				if (User.followers(session.project).list().contains(user)) {
					// Remove as follower
					Follow.unlink(session.project, user)
				}

				session.project.owner = user
				session.project.save()
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	/**
	 * Moves a person back to the user list.
	 */
	def movePersonToUsers = {
		if (sprintWritePermission(session.user, session.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			session.project.refresh()
			if (session.project.master.id != user.id && session.project.owner.id != user.id) {
				if (User.projectTeam(session.project).list().contains(user)) {
					// Remove as developer
					removeDeveloper(user, session.project)
				}
				if (User.followers(session.project).list().contains(user)) {
					// Remove as follower
					Follow.unlink(session.project, user)
				}

				session.project.save()
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	/**
	 * Adds a person to a project as follower.
	 */
	def movePersonToFollowers = {
		if (sprintWritePermission(session.user, session.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			session.project.refresh()
			if (session.project.master.id != user.id && session.project.owner.id != user.id) {
				if (User.projectTeam(session.project).list().contains(user)) {
					// Remove as developer
					removeDeveloper(user, session.project)
				}
				// Add as follower
				Follow.link(session.project, user)
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	/**
	 * Adds a person to a project as developer.
	 */
	def movePersonToDevelopers = {
		if (sprintWritePermission(session.user, session.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			session.project.refresh()
			if (session.project.master.id != user.id && session.project.owner.id != user.id) {
				if (User.followers(session.project).list().contains(user)) {
					// Remove as follower
					Follow.unlink(session.project, user)
				}
				// Add as developer
				Membership.link(session.project, user)
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	/**
	 * Removes a developer froma project. Set checked out task back to open.
	 * 
	 * @param user
	 * @param project
	 */
	private void removeDeveloper(User user, Project project) {
		// set checked out tasks from this user back to open.
		def tasks = Task.checkedOutTasksFromUserInProject(user, project).list()
		for (def task : tasks) {
			task.user = null
			task.state = StateTask.getStateOpen()
			task.save()
		}

		Membership.unlink(project, user)
	}

	/**
	 * Removes prefix 'personId_'
	 *
	 * @param String
	 * @return person id
	 */
	private String removePersonPrefix(String personId) {
		return personId.replaceFirst("personId_", "")
	}

	private boolean sprintViewPermission(User user, Project project) {
		return Project.accessRight(project, user, springSecurityService).list().first() == 0
	}

	private boolean sprintWritePermission(User user, Project project) {
		return SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER) || user.id.equals(project.owner.id) || user.id.equals(project.master.id)
	}
}
