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

class SprintController extends BaseController {
	
	def index = { redirect(controller:'sprint', action:'list')
	}
	
	def list = {
		if (params.project) {
			session.project = Project.get(params.project)
		} else {
			session.project = Project.get(session.project.id)
		}
		
		session.sprintList = Sprint.withCriteria {
			eq('project', session.project)
			order('endDate','desc')
			order('startDate', 'desc')
		}
	}
	
	/**
	 * Add new sprint
	 */
	def addSprint = {
		def sprintName = params.sprintName
		def sprintGoal = params.sprintGoal
		def endDate = params.startDateHidden ? new Date(params.startDateHidden) : null
		def startDate = params.endDateHidden ? new Date(params.endDateHidden) : null
		
		Project project = Project.find(session.project)
		
		Sprint sprint = new Sprint(name: sprintName, goal: sprintGoal, startDate: startDate, endDate: endDate, project: project)
		if (!sprint.save()) {
			flash.sprint=sprint
		}
		
		redirect(controller:'sprint', action:'list')
	}
	
	def edit = {
		if (sprintWritePermission(session.user, session.project)) {
			if (params.sprint) {
				flash.sprintEdit = Sprint.get(params.sprint)
			}
		} else {
			flash.message = "Only Super User and admins can edit sprints."
		}
		
		redirect(controller:'sprint', action:'list')
	}
	
	/**
	 * Sprint edit action
	 */
	def editSprint = {
		if (sprintWritePermission(session.user, session.project)) {
			if (params.sprintId) {
				def sprint = Sprint.get(params.sprintId)
				sprint.name = params.sprintName
				sprint.goal = params.sprintGoal
				
				if (params.startDateHidden) {
					sprint.startDate = new Date(params.startDateHidden)
				}
				if (params.endDateHidden) {
					sprint.endDate = new Date(params.endDateHidden)
				}
				if (!sprint.save()) {
					flash.sprint=sprint
				}
			}
		} else {
			flash.message = "Only Super User and admins can edit sprints."
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
				
				flash.message = "Sprint $sprint.name deleted."
			}
		} else {
			flash.message = "Only Super User and admins can delete sprints."
		}
		
		redirect(controller:'sprint', action:'list')
	}
	
	private boolean sprintWritePermission(User user, Project project) {
		return authenticateService.ifAnyGranted('ROLE_SUPERUSER') || user.equals(project.owner) || user.equals(project.master)
	}
}