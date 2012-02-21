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

import javax.servlet.http.HttpServletResponse

import org.codehaus.groovy.grails.exceptions.InvalidPropertyException;
import org.grails.plugins.csv.CSVMapReader;

abstract class BaseController {
	def springSecurityService
	
	def beforeInterceptor = [action:this.&doBefore]
	
	def doBefore() {
		if (session) {
			if (!session.theme) {
				def systemPreferences = getSystemPreferences()
				session.theme = systemPreferences.theme
			}
			
			if (!session.logo) {
				def systemPreferences = getSystemPreferences()
				session.logo = systemPreferences.logo
			}
			
			if (!session.logoUrl) {
				def systemPreferences = getSystemPreferences()
				session.logoUrl = systemPreferences.logoUrl
			}
		}
		
		if (springSecurityService) {
			session.user = springSecurityService.currentUser
		}
	}
	
	protected SystemPreferences getSystemPreferences() {
		return SystemPreferences.getPreferences(SystemPreferences.APPLICATION_NAME).list().first()
	}
	
	protected Project getProject() {
		def project = Project.get(params.project)
		
		if (project == null){
			response.sendError(HttpServletResponse.SC_NOT_FOUND)
			return null
		}
		return project
	}
	
	protected Sprint getSprint() {
		def sprint = Sprint.get(params.sprint)
		
		if (project == null){
			response.sendError(HttpServletResponse.SC_NOT_FOUND)
			return null
		}
		return sprint
	}
	
	protected def createRedirect(String fwdTo, Project project, Sprint sprint) {
		def paramList = []
		if (project?.id != null && sprint?.id != null) {
			return redirect(mapping: fwdTo, action: 'list', params: [project: project.id, sprint: sprint.id])
		} else if (project?.id != null) {
			return redirect(mapping: fwdTo, action: 'list', params: [project: project.id])
		} else {
			return redirect(mapping: fwdTo, action: 'list')
		}
	}
	
	/**
	* Returns true if this user is allowed to change the state of the tasks.
	*
	* @param user
	* @param project
	* @return
	*/
   protected boolean taskWorkPermission(User user, Project project) {
	   return Project.changeRight(project, user, springSecurityService).list().first() != 0
   }

   /**
	 * Import tasks from CSV
	 */
	protected def importCSVTaskFile(String fwdTo, Project project, Sprint sprint) {

		if (taskWorkPermission(session.user, project)) {

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
						taskObject = Task.findByNumber(task.number)
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
					if (sprint == null || taskObject.state.name == "Open") {
						taskObject.project = project
					} else {
						taskObject.sprint= sprint
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
							} 
							else 
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

		createRedirect(fwdTo, project, sprint)
	}

	

}