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

import org.codehaus.groovy.grails.exceptions.InvalidPropertyException;
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;
import org.grails.plugins.csv.CSVMapReader;
import twitter4j.TwitterFactory;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.conf.*;
import twitter4j.http.AccessToken;
import twitter4j.http.RequestToken;

class TaskController extends BaseController {
	def twitterService
	def csvParser

	def index = {
		redirect(controller:'task', action:'list')
	}

	def list = {
		flash.project = getProject()
		flash.sprint = getSprint()

		// check if this user has access rights
		if (!taskViewPermission(session.user, flash.project)) {
			redirect(controller:'project', action:'list')
		}

		// teammate or follower?
		if (taskWorkPermission(session.user, flash.project)) {
			flash.teammate = true
		}
		// Scrum master, product owner or superuser
		if (taskWritePermission(session.user, flash.project)) {
			flash.scrumMaster = true
		}

		flash.priorityList=Priority.list()
		flash.taskTypes=TaskType.list()

		flash.projectBacklog = Task.projectBacklog(flash.project).list()

		flash.taskListOpen = Task.fromSprint(flash.sprint, StateTask.getStateOpen()).list()
		flash.taskListCheckout = Task.fromSprint(flash.sprint, StateTask.getStateCheckedOut()).list()
		flash.taskListCodereview = Task.fromSprint(flash.sprint, StateTask.getStateCodereview()).list()
		flash.taskListDone = Task.fromSprint(flash.sprint, StateTask.getStateDone()).list()
		flash.taskListStandBy = Task.fromSprint(flash.sprint, StateTask.getStateStandBy()).list()
		flash.taskListNext = Task.fromSprint(flash.sprint, StateTask.getStateNext()).list()

		flash.numberOfTasks = flash.taskListOpen.size() + flash.taskListCheckout.size() + flash.taskListCodereview.size() + flash.taskListDone.size() + flash.taskListStandBy.size()

		flash.taskNumberingEnabled = flash.project.taskNumberingEnabled
		
		def totalEffort = Task.effortTasksTotal(flash.sprint).list()?.first()
		def totalEffortDone = Task.effortTasksDone(flash.sprint).list()?.first()

		flash.totalEffort = totalEffort ? totalEffort : 0
		flash.totalEffortDone = totalEffortDone ? totalEffortDone : 0

		if (flash.totalEffort > flash.sprint.personDays) {
			flash.message = message(code:"sprint.toMuchEffort", args:[
				flash.totalEffort,
				flash.sprint.personDays
			])
		}

		// Burn down target
		def datesXTarget = []
		def burnDownEffort = flash.totalEffort
		flash.burndownReal = []
		flash.burndownReal.add([
			flash.sprint.startDate.getTime(),
			burnDownEffort
		])
		def lastEffort = 0
		for (Date startDate = flash.sprint.startDate; startDate <= flash.sprint.endDate; startDate++) {
			datesXTarget.add(startDate.getTime())

			def taskListDone = Task.withCriteria {
				eq('state', StateTask.getStateDone())
				eq('sprint', flash.sprint)
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
		flash.project = getProject()

		flash.sprint = getSprint()
		if (taskWorkPermission(session.user, flash.project)) {
			
			def project = Project.get(flash.project.id)
			def number = params.taskNumber
			if (project.taskNumberingEnabled) {
				number = String.format(project.taskNumberingPattern, project.taskCounter)
			}
			
			Task task = new Task(number: number, title: params.taskTitle, description: params.taskDescription,
					effort: params.taskEffort, url: params.taskLink, state: StateTask.getStateOpen(),
					priority: Priority.byName(params.taskPriority).list().first(),
					type: TaskType.byName(params.taskType).list().first())
			if ("sprint".equals(params.target)) {
				task.sprint= Sprint.find(flash.sprint)
			} else {
				task.project = Project.get(flash.project.id)
			}
			if (!task.save()) {
				flash.taskIncomplete = task
				flash.objectToSave = task
			} else {
				++project.taskCounter
				project.save()
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		createRedirect(params.fwdTo, flash.project, getSprint())
	}
	
	/**
	 * Task delete action
	 */
	def delete = {
		flash.project = getProject()
		if (taskWritePermission(session.user, flash.project)) {
			if (params.task) {
				def task = Task.get(params.task)
				task.delete()

				flash.message = message(code:"task.deleted", args:[task.number])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		createRedirect(params.fwdTo, flash.project, getSprint())
	}

	def edit = {
		flash.project = getProject()
		if (taskWritePermission(session.user, flash.project)) {
			if (params.task) {
				flash.taskEdit = Task.get(params.task)
				flash.taskNumberingEnabled = flash.project.taskNumberingEnabled
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		createRedirect(params.fwdTo, flash.project, getSprint())
	}

	/**
	 * Task edit action
	 */
	def update = {
		flash.project = getProject()
		if (taskWritePermission(session.user, flash.project)) {
			if (params.taskId) {
				def task = Task.get(params.taskId)

				def project = Project.get(flash.project.id)
				if (!project.taskNumberingEnabled) {
					task.number = params.taskNumber
				}
				
				task.title = params.taskTitle
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

		createRedirect(params.fwdTo, flash.project, getSprint())
	}

	/**
	 * Import tasks from CSV
	 */
	def importCSV = {
		flash.project = getProject()

		if (taskWorkPermission(session.user, flash.project)) {

			if (params.importtaskid) {

				def tokenTaskType = TaskType.byName(TaskType.TOKEN).list().first()
				def tokenTask = null

				if (Task.findAllByType(tokenTaskType).size() == 1) {
					tokenTask = Task.findAllByType(tokenTaskType).first()
				}

				for (task in session[params.importtaskid]) {
					def taskObject

					// decide if update or new

					if (task.number == null || Task.findByNumber(task.number) == null) {
						taskObject = new Task()
					} else {
						taskObject = Task.findByName(task.number)
					}

					taskObject.user = task.user
					taskObject.number = task.number
					taskObject.title = task.title
					taskObject.description = task.description
					taskObject.effort = task.effort
					taskObject.url = task.url
					taskObject.priority = task.priority
					taskObject.type = task.type

					// update status on new tasks only
					if (taskObject.state == null) {
						taskObject.state = task.state
					}

					// decide if task should go into the backlog
					if (taskObject.state.name == "Open") {
						taskObject.project = Sprint.find(flash.sprint).release.project
					} else {
						taskObject.sprint= Sprint.find(flash.sprint)
					}

					// subtract current effort form token task if any
					if (task.subtractFromToken && tokenTask) {
						tokenTask.effort -= task.effort
						tokenTask.save()
					}

					if (!taskObject.save()) {
						flash.taskIncomplete = taskObject
						flash.objectToSave = taskObject
					}
				}
				
				// cleanup session
				session.removeAttribute(params.importtaskid)
				flash.message = message(code:"sprint.importDone")
				
			} 
			else {
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
								if (! csvParser.isValidHeader(map.keySet() as String[])) {
									flash.message = message(code:"error.invalidCSVColumns")
									formatError = true
								}
							}
							// process tasks
							if (!formatError) {
								
								def data

								// check if the task can be ignored
								if ((map['ignore on skramboord']?:'false').toLowerCase() == 'true') {
									importReport.stats.ignore += 1
									return
								}

								try {
									data = csvParser.parseEntry(map)
								} catch (InvalidPropertyException ipe) {									
									importReport.errors[(i+2)] = message(code:"error.csvInvalidField", args:[ipe.message])
								}

								// calc stats
								if (Task.findByNumber(map[csvParser.nameColumn]) == null) {
									importReport.stats['new'] += 1
								} else {
									importReport.stats.update += 1
								}
								
								// store data to session as long as there are no parse errors
								if (importReport.errors.size() == 0) {
									session[importtaskid] << data
								} else {
									session.removeAttribute(importtaskid)
								}
							} else 
							{
								flash.message = message(code:"error.invalidCSVFormat")
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

		createRedirect(params.fwdTo, flash.project, getSprint())
	}

	/**
	 * Changes status of a task to open
	 */
	def changeTaskStateToOpen = {
		flash.project = getProject()
		flash.sprint = getSprint()
		if (taskWorkPermission(session.user, flash.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			if (task.project) {
				// task from backlog -> set state to open
				task.state = StateTask.getStateOpen()
				task.project = null
				task.sprint = Sprint.get(flash.sprint.id)
				task.save()
			} else {
				// Change to state open
				task.state.open(task)
			}
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		createRedirect("task", flash.project, getSprint())
	}

	/**
	 * Changes status of a task to checkout
	 */
	def changeTaskStateToCheckOut = {
		flash.project = getProject()
		if (taskWorkPermission(session.user, flash.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.user = session.user
			task.state.checkOut(task)
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		createRedirect("task", flash.project, getSprint())
	}

	/**
	 * Changes status of a task to codereview
	 */
	def changeTaskStateToCodereview = {
		flash.project = getProject()
		if (taskWorkPermission(session.user, flash.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.state.codereview(task)
			task.save()

			// tweet it!
			sendTwitterMessage(flash.project, (String)"Task '${task.number}' by '${task.user?.userRealName}' ready to review, ${new Date()}")
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		createRedirect("task", flash.project, getSprint())
	}

	/**
	 * Changes status of a task to done
	 */
	def changeTaskStateToDone = {
		flash.project = getProject()
		if (taskWorkPermission(session.user, flash.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.state.done(task)
			task.save()

			// tweet it!
			sendTwitterMessage(flash.project, (String)"Task '${task.number}' done by '${task.user?.userRealName}', ${new Date()}")
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		createRedirect("task", flash.project, getSprint())
	}

	/**
	 * Changes status of a task to next
	 */
	def changeTaskStateToNext = {
		flash.project = getProject()
		if (taskWorkPermission(session.user, flash.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.state.next(task)
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		createRedirect("task", flash.project, getSprint())
	}

	/**
	 * Changes status of a task to standby
	 */
	def changeTaskStateToStandBy = {
		flash.project = getProject()
		if (taskWorkPermission(session.user, flash.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.state.standBy(task)
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		createRedirect("task", flash.project, getSprint())
	}

	/**
	 * Copy Task to Backlog
	 */
	def copyTaskToBacklog = {
		flash.project = getProject()
		if (taskWorkPermission(session.user, flash.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))

			task.sprint = null
			task.project = Project.get(flash.project.id)
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		createRedirect("task", flash.project, getSprint())
	}

	/**
	 * Changes task priority
	 */
	def changeTaskPrio = {
		flash.project = getProject()
		if (taskWorkPermission(session.user, flash.project)) {
			Task task = Task.get(removeTaskPrefix(params.taskId))
			task.priority = Priority.byName(params.taskPrio).list()?.first()
			task.save()
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(mapping: 'sprint', action: 'list', params:[project: flash.project.id])
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
		return Project.accessRight(project, user, springSecurityService).list().first() != 0
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