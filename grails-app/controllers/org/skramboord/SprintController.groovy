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
		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}

	def list = {
		flash.project = getProject()
		
		flash.twitterAppSettings = getSystemPreferences().twitterSettings

		// check if this user has access rights
		if (sprintViewPermission(session.user, flash.project)) {
			redirect(controller:'project', action:'list')
		}

		flash.watchList = User.followers(flash.project).list()
		flash.teamList = User.projectTeam(flash.project).list()

		flash.fullList = new HashSet<User>()
		flash.fullList.addAll(flash.watchList)
		flash.fullList.addAll(flash.teamList)
		flash.fullList.add(flash.project.owner)
		flash.fullList.add(flash.project.master)
		flash.fullList = flash.fullList.sort{it.username }

		flash.personList = User.list(params)
		flash.personList.removeAll(flash.fullList)

		flash.releaseList = Release.withCriteria {
			eq('project', flash.project)
			order('name','asc')
		}

		flash.taskNumberingEnabled = flash.project.taskNumberingEnabled
		
		// teammate or follower?
		if (sprintWritePermission(session.user, flash.project)) {
			flash.teammate = true
		}

		flash.priorityList=Priority.list()
		flash.taskTypes=TaskType.list()
		
		// product backlog
		flash.backlogLow = Task.projectBacklogWithPriority(flash.project, Priority.byName(Priority.LOW).list()?.first()).list()
		flash.backlogNormal = Task.projectBacklogWithPriority(flash.project, Priority.byName(Priority.NORMAL).list()?.first()).list()
		flash.backlogHigh = Task.projectBacklogWithPriority(flash.project, Priority.byName(Priority.HIGH).list()?.first()).list()
		flash.backlogUrgent = Task.projectBacklogWithPriority(flash.project, Priority.byName(Priority.URGENT).list()?.first()).list()
		flash.backlogImmediate = Task.projectBacklogWithPriority(flash.project, Priority.byName(Priority.IMMEDIATE).list()?.first()).list()
	}

	/**
	 * Add new sprint
	 */
	def addSprint = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
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

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}
	
	def edit = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
			if (params.sprint) {
				flash.sprintEdit = Sprint.get(params.sprint)
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}

	/**
	 * Sprint edit action
	 */
	def update = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
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

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}

	/**
	 * Sprint delete action
	 */
	def delete = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
			if (params.sprint) {
				def sprint = Sprint.get(params.sprint)
				sprint.delete()

				flash.message = message(code:"sprint.deleted", args:[sprint.name])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}

	/**
	 * Sets a new scrum master.
	 */
	def movePersonToScrumMaster = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			flash.project.refresh()
			if (flash.project.owner.id != user.id) {
				if (User.projectTeam(flash.project).list().contains(user)) {
					// Remove as developer
					removeDeveloper(user, flash.project)
				}
				if (User.followers(flash.project).list().contains(user)) {
					// Remove as follower
					Follow.unlink(flash.project, user)
				}

				flash.project.master = user
				flash.project.save()
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}

	/**
	 * Sets a new product owner.
	 */
	def movePersonToProdctOwner = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			flash.project.refresh()
			if (flash.project.master.id != user.id) {
				if (User.projectTeam(flash.project).list().contains(user)) {
					// Remove as developer
					removeDeveloper(user, flash.project)
				}
				if (User.followers(flash.project).list().contains(user)) {
					// Remove as follower
					Follow.unlink(flash.project, user)
				}

				flash.project.owner = user
				flash.project.save()
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}

	/**
	 * Moves a person back to the user list.
	 */
	def movePersonToUsers = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			flash.project.refresh()
			if (flash.project.master.id != user.id && flash.project.owner.id != user.id) {
				if (User.projectTeam(flash.project).list().contains(user)) {
					// Remove as developer
					removeDeveloper(user, flash.project)
				}
				if (User.followers(flash.project).list().contains(user)) {
					// Remove as follower
					Follow.unlink(flash.project, user)
				}

				flash.project.save()
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}

	/**
	 * Adds a person to a project as follower.
	 */
	def movePersonToFollowers = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			flash.project.refresh()
			if (flash.project.master.id != user.id && flash.project.owner.id != user.id) {
				if (User.projectTeam(flash.project).list().contains(user)) {
					// Remove as developer
					removeDeveloper(user, flash.project)
				}
				// Add as follower
				Follow.link(flash.project, user)
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
	}

	/**
	 * Adds a person to a project as developer.
	 */
	def movePersonToDevelopers = {
		flash.project = getProject()
		if (sprintWritePermission(session.user, flash.project)) {
			User user = User.get(removePersonPrefix(params.personId))
			flash.project.refresh()
			if (flash.project.master.id != user.id && flash.project.owner.id != user.id) {
				if (User.followers(flash.project).list().contains(user)) {
					// Remove as follower
					Follow.unlink(flash.project, user)
				}
				// Add as developer
				Membership.link(flash.project, user)
			} else {
				flash.message = message(code:"project.error.masterOrOwnerRemoved")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
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
