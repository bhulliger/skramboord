package ch.ping.scrumboard

class TaskController {
	
	def index = { redirect(controller:'task', action:'list')
	}
	
	def list = {
		def taskList = Task.list(sort:'name', ignoreCase:false)

		session.priorityList=Priority.list()

		session.taskListOpen = Task.withCriteria {
			eq('state', StateTask.getStateOpen())
			order('name',"asc")
		}
		session.taskListCheckout = Task.withCriteria {
			eq('state', StateTask.getStateCheckedOut())
			order('name',"asc")
		}
		session.taskListDone = Task.withCriteria {
			eq('state', StateTask.getStateDone())
			order('name',"asc")
		}
		session.taskListStandBy = Task.withCriteria {
			eq('state', StateTask.getStateStandBy())
			order('name',"asc")
		}
		session.taskListNext = Task.withCriteria {
			eq('state', StateTask.getStateNext())
			order('name',"asc")
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
		
		new Task(name: taskName, effort: taskEffort, url: new Url(url: taskLink).save(), state: StateTask.getStateOpen(), priority: priority).save()
		
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
		def taskId = params.taskId
		
		// Prefix von JavaScript entfernen
		taskId = taskId.replaceFirst("taskId_", "")
		
		Task task = Task.get(taskId)
		task.state.open(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to checkout
	 */
	def changeTaskStateToCheckOut = {
		def taskId = params.taskId
		
		// Prefix von JavaScript entfernen
		taskId = taskId.replaceFirst("taskId_", "")
		
		Task task = Task.get(taskId)
		task.state.checkOut(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to done
	 */
	def changeTaskStateToDone = {
		def taskId = params.taskId
		
		// Prefix von JavaScript entfernen
		taskId = taskId.replaceFirst("taskId_", "")
		
		Task task = Task.get(taskId)
		task.state.done(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to next
	 */
	def changeTaskStateToNext = {
		def taskId = params.taskId
		
		// Prefix von JavaScript entfernen
		taskId = taskId.replaceFirst("taskId_", "")
		
		Task task = Task.get(taskId)
		task.state.next(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
	
	/**
	 * Changes status of a task to standby
	 */
	def changeTaskStateToStandBy = {
		def taskId = params.taskId
		
		// Prefix von JavaScript entfernen
		taskId = taskId.replaceFirst("taskId_", "")
		
		Task task = Task.get(taskId)
		task.state.standBy(task)
		task.save()
		
		redirect(controller:'task', action:'list')
	}
}
