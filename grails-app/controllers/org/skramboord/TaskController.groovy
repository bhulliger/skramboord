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

class TaskController extends BaseControllerController {
	
	def index = { redirect(controller:'task', action:'list')
	}
	
	def list = {
		session.priorityList=Priority.list()
		
		if (params.sprint) {
			session.sprint = Sprint.get(params.sprint)
		}
		
		session.taskListOpen = Task.withCriteria {
			eq('state', StateTask.getStateOpen())
			eq('sprint', session.sprint)
			order('priority',"desc")
		}
		session.taskListCheckout = Task.withCriteria {
			eq('state', StateTask.getStateCheckedOut())
			eq('sprint', session.sprint)
			order('priority',"desc")
		}
		session.taskListDone = Task.withCriteria {
			eq('state', StateTask.getStateDone())
			eq('sprint', session.sprint)
			order('priority',"desc")
		}
		session.taskListStandBy = Task.withCriteria {
			eq('state', StateTask.getStateStandBy())
			eq('sprint', session.sprint)
			order('priority',"desc")
		}
		session.taskListNext = Task.withCriteria {
			eq('state', StateTask.getStateNext())
			eq('sprint', session.sprint)
			order('priority',"desc")
		}
		
		session.numberOfTasks = session.taskListOpen.size() + session.taskListCheckout.size() + session.taskListDone.size() + session.taskListStandBy.size()
		Double totalEffort = 0
		Double totalEffortDone = 0
		for (Task task : session.taskListOpen) {
			totalEffort += task.effort
		}
		for (Task task : session.taskListCheckout) {
			totalEffort += task.effort
		}
		for (Task task : session.taskListDone) {
			totalEffort += task.effort
			totalEffortDone += task.effort
		}
		for (Task task : session.taskListStandBy) {
			totalEffort += task.effort
		}
		session.totalEffort = totalEffort
		session.totalEffortDone = totalEffortDone
		
		// Burn down target
		def datesXTarget = []
		def burnDownEffort = session.totalEffort
		session.burndownReal = []
		session.burndownReal.add([session.sprint.startDate.getTime(), burnDownEffort])
		for (Date startDate = session.sprint.startDate; startDate <= session.sprint.endDate; startDate++) {
			datesXTarget.add(startDate.getTime())
			
			def taskListDone = Task.withCriteria {
				eq('state', StateTask.getStateDone())
				eq('sprint', session.sprint)
				eq('finishedDate', startDate)
			}
			def tmpEffort = 0
			for (Task task : taskListDone) {
				tmpEffort += task.effort
			}
			burnDownEffort -= tmpEffort
			if (tmpEffort > 0) {
				session.burndownReal.add([startDate.getTime(), burnDownEffort])
			}
		}
		session.burndownTargetXSize = datesXTarget.size()-1
		session.burndownTargetX = datesXTarget
		session.today = Today.getInstance().getTime()
	}
	
	/**
	 * Add task
	 */
	def addTask = {
		Task task = new Task(name: params.taskName, effort: params.taskEffort, url: params.taskLink, state: StateTask.getStateOpen(), priority: Priority.get(params.taskPriority), sprint: Sprint.find(session.sprint))
		if (!task.save()) {
			flash.task = task
		}
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Task delete action
	 */
	def delete = {
		if (taskWritePermission(session.user, session.project)) {
			if (params.task) {
				def task = Task.get(params.task)
				task.delete()
				
				flash.message = "Task $task.name deleted."
			}
		} else {
			flash.message = "Only Super User and admins can delete tasks."
		}
		
		redirect(controller:'task', action:'list')
	}
	
	def edit = {
		if (taskWritePermission(session.user, session.project)) {
			if (params.task) {
				flash.taskEdit = Task.get(params.task)
			}
		} else {
			flash.message = "Only Super User and admins can edit tasks."
		}
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Task edit action
	 */
	def editTask = {
		if (taskWritePermission(session.user, session.project)) {
			if (params.taskId) {
				def task = Task.get(params.taskId)
				
				task.name = params.taskName
				task.effort = params.taskEffort?.toDouble()
				task.url = params.taskLink
				task.priority = Priority.get(params.taskPriority)

				if (!task.save()) {
					flash.task=task
				}
			}
		} else {
			flash.message = "Only Super User and admins can edit tasks."
		}
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to open
	 */
	def changeTaskStateToOpen = {
		Task task = Task.get(removeTaskPrefix(params.taskId))
		task.state.open(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to checkout
	 */
	def changeTaskStateToCheckOut = {
		Task task = Task.get(removeTaskPrefix(params.taskId))
		task.user = session.user
		task.state.checkOut(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to done
	 */
	def changeTaskStateToDone = {
		Task task = Task.get(removeTaskPrefix(params.taskId))
		task.state.done(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to next
	 */
	def changeTaskStateToNext = {
		Task task = Task.get(removeTaskPrefix(params.taskId))
		task.state.next(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to standby
	 */
	def changeTaskStateToStandBy = {
		Task task = Task.get(removeTaskPrefix(params.taskId))
		task.state.standBy(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Removes prefix 'taskId_'
	 * 
	 * @param String
	 * @return task id
	 */
	private String removeTaskPrefix(String taskId) {
		return taskId.replaceFirst("taskId_", "")
	}
	
	private boolean taskWritePermission(User user, Project project) {
		return authenticateService.ifAnyGranted('ROLE_SUPERUSER') || user.equals(project.owner) || user.equals(project.master)
	}
}
