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

package ch.ping.scrumboard

class TaskController {
	
	def index = { redirect(controller:'task', action:'list')
	}
	
	def list = {
		session.priorityList=Priority.list()
		
		if (params.sprint) {
			session.sprint = Sprint.get(params.sprint)
		}
		
		session.project = Project.get(1)
		
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
	}
	
	/**
	 * Add task
	 */
	def addTask = {
		def taskName = params.taskName
		def taskEffort = params.taskEffort
		def taskLink = params.taskLink
		def taskPriority = params.taskPriority
		
		Priority priority = Priority.withCriteria(uniqueResult:true) {
			eq('name', taskPriority)
		}
		
		Sprint sprint = Sprint.find(session.sprint)
		
		Task task = new Task(name: taskName, effort: taskEffort, url: taskLink, state: StateTask.getStateOpen(), priority: priority, sprint: sprint)
		if (!task.save()) {
			flash.task = task
		}
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * remove Task
	 */
	def removeTask = {
		def taskId = params?.TaskId
		
		if(taskId) {
			Task task = Task.withCriteria(uniqueResult:true) {
				eq('id', Long.valueOf(taskId))
			}
			task.delete()
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
}
