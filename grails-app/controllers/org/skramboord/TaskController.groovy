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

class TaskController extends BaseController {
	
	def index = { redirect(controller:'task', action:'list')
	}
	
	def list = {
		if (params.sprint) {
			session.sprint = Sprint.get(params.sprint)
			session.project = session.sprint.project
		}
		
		// check if this user has access rights
		if (taskViewPermission(session.user, session.project)) {
			redirect(controller:'project', action:'list')
		}
		
		flash.priorityList=Priority.list()
		
		flash.projectBacklog = Task.projectBacklog(session.project).list()
		
		flash.taskListOpen = Task.fromSprint(session.sprint, StateTask.getStateOpen()).list()
		flash.taskListCheckout = Task.fromSprint(session.sprint, StateTask.getStateCheckedOut()).list()
		flash.taskListDone = Task.fromSprint(session.sprint, StateTask.getStateDone()).list()
		flash.taskListStandBy = Task.fromSprint(session.sprint, StateTask.getStateStandBy()).list()
		flash.taskListNext = Task.fromSprint(session.sprint, StateTask.getStateNext()).list()
		
		flash.numberOfTasks = flash.taskListOpen.size() + flash.taskListCheckout.size() + flash.taskListDone.size() + flash.taskListStandBy.size()

		def totalEffort = Task.effortTasksTotal(session.sprint).list()?.first()
		def totalEffortDone = Task.effortTasksDone(session.sprint).list()?.first()
		
		flash.totalEffort = totalEffort ? totalEffort : 0
		flash.totalEffortDone = totalEffortDone ? totalEffortDone : 0
		
		// Burn down target
		def datesXTarget = []
		def burnDownEffort = flash.totalEffort
		flash.burndownReal = []
		flash.burndownReal.add([session.sprint.startDate.getTime(), burnDownEffort])
		def lastEffort = 0
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
				lastEffort = burnDownEffort
				flash.burndownReal.add([startDate.getTime(), burnDownEffort])
			} else if (Today.isDateToday(startDate)) {
				// if there is no task done yet today, paint a horizontal line for the rest.
				flash.burndownReal.add([Today.getInstance().getTime(), lastEffort])
			}
		}
		flash.burndownTargetXSize = datesXTarget.size()-1
		flash.burndownTargetX = datesXTarget
		flash.today = Today.getInstance().getTime()
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
		if (task.project) {
			// task from backlog -> set state to open
			task.state = StateTask.getStateOpen()
			task.project = null
			task.sprint = Sprint.get(session.sprint.id)
			task.save()
		} else {
			// Change to state open
			task.state.open(task)
		}
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
	 * Copy Task to Backlog
	 */
	def copyTaskToBacklog = {
		Task task = Task.get(removeTaskPrefix(params.taskId))

		task.sprint = null
		task.project = Project.get(session.project.id)
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
	
	private boolean taskViewPermission(User user, Project project) {
		return Project.accessRight(session.project, session.user, authenticateService).list().first() == 0
	}
	
	private boolean taskWritePermission(User user, Project project) {
		return authenticateService.ifAnyGranted('ROLE_SUPERUSER') || user.equals(project.owner) || user.equals(project.master)
	}
}
