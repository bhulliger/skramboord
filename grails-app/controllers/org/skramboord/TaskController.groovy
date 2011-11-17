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

import org.codehaus.groovy.grails.exceptions.InvalidPropertyException

import twitter4j.Status
import twitter4j.Twitter
import twitter4j.TwitterFactory
import twitter4j.conf.*

class TaskController extends BaseController {
	def twitterService

	final CSV_DATA_FIELDS = [
		'Id',
		'Project',
		'Category',
		'Description',
		'Schätzung in PT',
		'Priority',
		'Status',
		'Assigned To',
		'ignore on skramboord'
	]

	final CSV_URL_TEMPLATE = 'https://mantis.puzzle.ch/view.php?id=%1s'

	def index = {
		redirect(controller:'task', action:'list')
	}

	def list = {
		if (params.sprint) {
			session.sprint = Sprint.get(params.sprint)
			session.project = session.sprint.release.project
		}

		// check if this user has access rights
		if (!taskViewPermission(session.user, session.project)) {
			redirect(controller:'project', action:'list')
		}

		// teammate or follower?
		if (taskWorkPermission(session.user, session.project)) {
			flash.teammate = true
		}
		// Scrum master, product owner or superuser
		if (taskWritePermission(session.user, session.project)) {
			flash.scrumMaster = true
		}

		flash.priorityList=Priority.list()
		flash.taskTypes=TaskType.list()

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

		if (flash.totalEffort > session.sprint.personDays) {
			flash.message = message(code:"sprint.toMuchEffort", args:[
				flash.totalEffort,
				session.sprint.personDays
			])
		}

		// Burn down target
		def datesXTarget = []
		def burnDownEffort = flash.totalEffort
		flash.burndownReal = []
		flash.burndownReal.add([
			session.sprint.startDate.getTime(),
			burnDownEffort
		])
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
				flash.burndownReal.add([
					startDate.getTime(),
					burnDownEffort
				])
			} else if (Today.isDateToday(startDate)) {
				// if there is no task done yet today, paint a horizontal line for the rest.
				flash.burndownReal.add([
					Today.getInstance().getTime(),
					lastEffort
				])
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
		if (taskWorkPermission(session.user, session.project)) {
			Task task = new Task(name: params.taskName, description: params.taskDescription,
					effort: params.taskEffort, url: params.taskLink, state: StateTask.getStateOpen(),
					priority: Priority.byName(params.taskPriority).list().first(),
					type: TaskType.byName(params.taskType).list().first())
			if ("sprint".equals(params.target)) {
				task.sprint= Sprint.find(session.sprint)
			} else {
				task.project = Project.get(session.project.id)
			}
			if (!task.save()) {
				flash.taskIncomplete = task
				flash.objectToSave = task
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:params.fwdTo, action:'list')
	}

	/**
	 * Task delete action
	 */
	def delete = {
		if (taskWritePermission(session.user, session.project)) {
			if (params.task) {
				def task = Task.get(params.task)
				task.delete()

				flash.message = message(code:"task.deleted", args:[task.name])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:params.fwdTo, action:'list')
	}

	def edit = {
		if (taskWritePermission(session.user, session.project)) {
			if (params.task) {
				flash.taskEdit = Task.get(params.task)
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:params.fwdTo, action:'list')
	}

	/**
	 * Task edit action
	 */
	def update = {
		if (taskWritePermission(session.user, session.project)) {
			if (params.taskId) {
				def task = Task.get(params.taskId)

				task.name = params.taskName
				task.description = params.taskDescription
				task.effort = params.taskEffort ? params.taskEffort.toDouble() : null
				task.url = params.taskLink
				task.priority = Priority.byName(params.taskPriority).list().first()
				task.type = TaskType.byName(params.taskType).list().first()

				if (!task.save()) {
					flash.objectToSave=task
				}
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:params.fwdTo, action:'list')
	}

	/**
	 * Parse CSV entry
	 */
	def parseCSVEntry(map) throws InvalidPropertyException{

		def data = [:]

		if (map.Id == null || map.Id.size() < 1) {
			throw new InvalidPropertyException(message(code:"error.csvInvalidField", args:['Id']))
		}

		// map state
		def state = StateTask.getStateOpen()
		switch (map.Status) {
			case 'feedback':
				state = StateTask.getStateStandBy()
				break
			case 'assigned':
				state = StateTask.getStateCheckedOut()
				break
			case [
				'resolved',
				'closed',
				'inList'
			]:
				state = StateTask.getStateDone()
				break
		}

		// map priority
		def priority = Priority.byName(map.Priority.toLowerCase()).list()
		if (priority != null && priority.size() == 1) {
			priority = priority.first()
		}else {
			throw new InvalidPropertyException(message(code:"error.csvInvalidField", args:['Priority']))
		}

		// map task type
		def taskType = null
		if (map.Project == 'Wartung') {
			if (map.Category == 'Fehler') {
				taskType = TaskType.byName(TaskType.BUG).list().first()
			} else {
				taskType = TaskType.byName(TaskType.DOCUMENTATION).list().first()
			}
		} else if(map.Project == 'Entwicklung') {
			if(map.Category == 'Erweiterung'){
				taskType = TaskType.byName(TaskType.FEATURE).list().first()
			} else if(map.Category == 'Garantie') {
				taskType = TaskType.byName(TaskType.BUG).list().first()
			} else {
				taskType = TaskType.byName(TaskType.DOCUMENTATION).list().first()
			}
		} else {
			throw new InvalidPropertyException(message(code:"error.csvInvalidField", args:['Project']))
		}

		// map effort
		def effort = 0

		if (!map['Schätzung in PT'].isNumber()) {
			throw new InvalidPropertyException(message(code:"error.csvInvalidField", args:['Schätzung in PT']))
		} else {
			effort = map['Schätzung in PT']
		}

		def user
		// map user
		if(User.findByUsername(map['Assigned To']) == null){
			throw new InvalidPropertyException(message(code:"error.csvInvalidField", args:['Assigned To']))
		}else{
			user = User.findByUsername(map['Assigned To'])
		}

		data.user = user
		data.name = map.Id
		data.description = map.Description?:''
		data.effort = effort.toDouble()
		data.url = String.format(CSV_URL_TEMPLATE, map.Id)
		data.state = state
		data.priority = priority
		data.type = taskType

		return data
	}

	/**
	 * Import tasks from CSV
	 */
	def importCSV = {
		if (taskWorkPermission(session.user, session.project)) {

			if (params.importtaskid) {
				for (task in session[params.importtaskid]) {
					def taskObject

					// decide if update or new
					if(Task.findByName(task.name) == null){
						taskObject = new Task()
					}else{
						taskObject = Task.findByName(task.name)
					}
					
					taskObject.user = task.user
					taskObject.name = task.name
					taskObject.description = task.description
					taskObject.effort = task.effort
					taskObject.url = task.url
					taskObject.priority = task.priority
					taskObject.type = task.type
					
					// update status on new tasks only
					if(taskObject.state == null){
						taskObject.state = task.state
					}
					
					// decide if task should go into the backlog
					if(taskObject.state.name == "Open"){
						taskObject.project = Sprint.find(session.sprint).release.project
					}else{
						taskObject.sprint= Sprint.find(session.sprint)
					}
					
					if (!taskObject.save()) {
						flash.taskIncomplete = taskObject
						flash.objectToSave = taskObject
					}
					
					// cleanup session
					session.removeAttribute(params.importtaskid)
					flash.message = message(code:"sprint.importDone")
				}
			} else {
				def csv = request.getFile('cvsFile')
				def errors = []
				if (!csv.empty) {

					def reader = csv.inputStream.toCsvReader(['charset':'UTF-8'])
					def formatError = false
					def importReport = ['errors':[:], 'stats': ['new': 0, 'update': 0, 'ignore': 0]]
					def task
					def importtaskid = UUID.randomUUID().toString()

					session[importtaskid] = []

					try {
						new CSVMapReader(reader).eachWithIndex{ map, i ->

							// check fields
							if (i==0) {
								if (map.keySet() as String[] != CSV_DATA_FIELDS) {
									flash.message = message(code:"error.invalidCSVColumns")
									formatError = true
								}
							}

							// process tasks
							if (!formatError) {
								def data

								// check if the task can be ignored
								if((map['ignore on skramboord']?:'false').toLowerCase() == 'true'){
									importReport.stats.ignore += 1
									return
								}

								try {
									data = parseCSVEntry(map)
								} catch (InvalidPropertyException ipe) {
									importReport.errors[(i+2)] = ipe.message
								}

								// calc stats
								if(Task.findByName(map.Id) == null){
									importReport.stats['new'] += 1
								}else{
									importReport.stats.update += 1
								}

								// store data to session as long as there are no parse errors
								if (importReport.errors.size() == 0) {
									session[importtaskid] << data
								}else{
									session.removeAttribute(importtaskid)
								}
							}
						}

						// render the import or parse report
						flash.importtaskid = importtaskid
						flash.importReport = importReport
					} catch (ArrayIndexOutOfBoundsException e) {
						flash.message = message(code:"error.invalidCSVFormat")
					}
				} else {
					flash.message = message(code:"error.emptyFile")
				}
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:params.fwdTo, action:'list')
	}

	/**
	 * Changes status of a task to open
	 */
	def changeTaskStateToOpen = {
		if (taskWorkPermission(session.user, session.project)) {
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
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		redirect(controller:'task', action:'list')
	}

	/**
	 * Changes status of a task to checkout
	 */
	def changeTaskStateToCheckOut = {
		if (taskWorkPermission(session.user, session.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.user = session.user
			task.state.checkOut(task)
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'task', action:'list')
	}

	/**
	 * Changes status of a task to done
	 */
	def changeTaskStateToDone = {
		if (taskWorkPermission(session.user, session.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.state.done(task)
			task.save()

			// tweet it!
			sendTwitterMessage(session.project, (String)"Task '${task.name}' done by '${task.user?.userRealName}', ${new Date()}")
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'task', action:'list')
	}

	/**
	 * Changes status of a task to next
	 */
	def changeTaskStateToNext = {
		if (taskWorkPermission(session.user, session.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.state.next(task)
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'task', action:'list')
	}

	/**
	 * Changes status of a task to standby
	 */
	def changeTaskStateToStandBy = {
		if (taskWorkPermission(session.user, session.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.state.standBy(task)
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'task', action:'list')
	}

	/**
	 * Copy Task to Backlog
	 */
	def copyTaskToBacklog = {
		if (taskWorkPermission(session.user, session.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))

			task.sprint = null
			task.project = Project.get(session.project.id)
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'task', action:'list')
	}

	/**
	 * Changes task priority
	 */
	def changeTaskPrio = {
		if (taskWorkPermission(session.user, session.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.priority = Priority.byName(params.taskPrio).list()?.first()
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(controller:'sprint', action:'list')
	}

	def enableBacklog = {
		if (params.enableBacklog) {
			session.enableBacklog = Boolean.valueOf(params.enableBacklog)
		}
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

	/**
	 * Returns true if the user is allowed to access this sprint.
	 * 
	 * @param user
	 * @param project
	 * @return
	 */
	private boolean taskViewPermission(User user, Project project) {
		return Project.accessRight(session.project, session.user, springSecurityService).list().first() != 0
	}

	/**
	 * Returns true if this user is allowed to change the state of the tasks.
	 * 
	 * @param user
	 * @param project
	 * @return
	 */
	private boolean taskWorkPermission(User user, Project project) {
		return Project.changeRight(session.project, session.user, springSecurityService).list().first() != 0
	}

	/**
	 * Returns true if this user is allowed to change and delete the existing tasks.
	 * 
	 * @param user
	 * @param project
	 * @return
	 */
	private boolean taskWritePermission(User user, Project project) {
		return SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER) || user.id.equals(project.owner.id) || user.id.equals(project.master.id)
	}

	/**
	 * Sends Twitter message if project has a Twitter account.
	 * 
	 * @param user
	 * @param project
	 * @param message
	 */
	private void sendTwitterMessage(Project project, String message) {
		def twitterAppSettings = getSystemPreferences().twitterSettings
		if (project.twitter && project.twitter.enabled  && twitterAppSettings && twitterAppSettings.enabled) {
			ConfigurationBuilder cb = new ConfigurationBuilder()
			cb.setDebugEnabled(true)
					.setOAuthConsumerKey(twitterAppSettings.consumerKey)
					.setOAuthConsumerSecret(twitterAppSettings.consumerSecret)
					.setOAuthAccessToken(project.twitter.token)
					.setOAuthAccessTokenSecret(project.twitter.tokenSecret)
			TwitterFactory tf = new TwitterFactory(cb.build())
			Twitter twitter = tf.getInstance()
			Status status = twitter.updateStatus(message)
		}
	}
}
