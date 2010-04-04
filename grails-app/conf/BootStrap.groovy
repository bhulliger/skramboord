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

import java.awt.Color;
import java.util.Calendar;

import org.apache.catalina.connector.ResponseFacade.DateHeaderPrivilegedAction;

import ch.ping.scrumboard.StateTask;
import ch.ping.scrumboard.StateTaskCheckedOut;
import ch.ping.scrumboard.StateTaskDone;
import ch.ping.scrumboard.StateTaskNext;
import ch.ping.scrumboard.StateTaskOpen;
import ch.ping.scrumboard.StateTaskStandBy;
import ch.ping.scrumboard.Task;
import ch.ping.scrumboard.Today;
import ch.ping.scrumboard.Url;
import ch.ping.scrumboard.Priority;
import ch.ping.scrumboard.Sprint;
import ch.ping.scrumboard.Project;
import ch.ping.scrumboard.User;
import ch.ping.scrumboard.Role;
import ch.ping.scrumboard.Requestmap;
import org.apache.commons.codec.digest.DigestUtils

class BootStrap {
	
	def authenticateService
	
	def init = { servletContext ->
		// Create some test data
		String urlPuzzle = "http://www.puzzle.ch"
		
		// Initialize states
		StateTaskOpen taskStateOpen = new StateTaskOpen()
		taskStateOpen.save()
		StateTaskCheckedOut taskStateChecked = new StateTaskCheckedOut()
		taskStateChecked.save()
		StateTaskDone taskStateDone = new StateTaskDone()
		taskStateDone.save()
		StateTaskNext taskStateNext = new StateTaskNext()
		taskStateNext.save()
		StateTaskStandBy taskStateStandBy = new StateTaskStandBy()
		taskStateStandBy.save()
		
		// Adding Roles
		def roleSuperUser = new Role(authority:'ROLE_SUPERUSER', description:'role superuser').save()
		def roleAdmin = new Role(authority:'ROLE_ADMIN', description:'role administration').save()
		def roleUser = new Role(authority:'ROLE_USER', description:'role user').save()
		
		// Adding Users
		def userAdmin = new User(username:'admin', userRealName:'Pablo Hess', enabled: true, emailShow: true, email: 'admin@skramboord.ch', passwd: authenticateService.encodePassword("admin")).save()
		def userDevChief = new User(username:'wmozart', userRealName:'Wolfgang Mozart', enabled: true, emailShow: true, email: 'wolfgang.mozart@skramboord.ch', passwd: authenticateService.encodePassword("1234")).save()
		def userDev1 = new User(username:'lbeethoven', userRealName:'Ludwig Beethoven', enabled: true, emailShow: true, email: 'ludwig.beethoven@skramboord.ch', passwd: authenticateService.encodePassword("1234")).save()
		def userDev2 = new User(username:'asalieri', userRealName:'Antonio Salieri', enabled: true, emailShow: true, email: 'antonio.salieri@skramboord.ch', passwd: authenticateService.encodePassword("1234")).save()
		def userDev3 = new User(username:'jbach', userRealName:'Johann Bach', enabled: true, emailShow: true, email: 'johann.bach@skramboord.ch', passwd: authenticateService.encodePassword("1234")).save()
		
		// Adding user to roles
		roleSuperUser.addToPeople(userAdmin)
		roleAdmin.addToPeople(userAdmin)
		roleAdmin.addToPeople(userDevChief)
		roleUser.addToPeople(userAdmin)
		roleUser.addToPeople(userDevChief)
		roleUser.addToPeople(userDev1)
		roleUser.addToPeople(userDev2)
		roleUser.addToPeople(userDev3)
		
		// Initialize priorities
		Priority low = new Priority(name: "low", color: Color.GRAY)
		low.save()
		Priority normal = new Priority(name: "normal", color: Color.GREEN)
		normal.save()
		Priority high = new Priority(name: "high", color: Color.BLUE)
		high.save()
		Priority urgent = new Priority(name: "urgent", color: Color.ORANGE)
		urgent.save()
		Priority immediate = new Priority(name: "immediate", color: Color.RED)
		immediate.save()
		
		// Initialize dates
		Date date0 = Today.getInstance() + 25
		Date date1 = date0 - 10
		Date date2 = date1 - 10
		Date date3 = date2 - 10
		Date date4 = date3 - 10
		
		// Sprint 1.0
		Sprint sprint1_0 = new Sprint(name: "1.0", goal: "Login System", startDate: date4, endDate: date3, tasks: [])
		createTask(userDev1, sprint1_0, "Mantis 1812", 2.0, urlPuzzle, taskStateDone, normal, date4 + 1)
		createTask(userDev3, sprint1_0, "Mantis 1798", 4.0, urlPuzzle, taskStateDone, normal, date4 + 3)
		createTask(userDev1, sprint1_0, "Mantis 1765", 4.5, urlPuzzle, taskStateDone, high, date4 + 4)
		createTask(userDev3, sprint1_0, "Mantis 1705", 3.5, urlPuzzle, taskStateDone, normal, date4 + 5)
		createTask(userDev3, sprint1_0, "Mantis 1731", 2.0, urlPuzzle, taskStateDone, low, date4 + 6)
		createTask(userDev1, sprint1_0, "Mantis 1733", 2.5, urlPuzzle, taskStateDone, low, date4 + 8)
		createTask(userDev2, sprint1_0, "Mantis 1722", 0.5, urlPuzzle, taskStateDone, low, date4 + 9)
		createTask(userDev2, sprint1_0, "Mantis 1700", 4, urlPuzzle, taskStateDone, low, date4 + 10)
		
		// Sprint 1.1
		Sprint sprint1_1 = new Sprint(name: "1.1", goal: "Drag'n'Drop Functionality", startDate: date3, endDate: date2, tasks: [])
		createTask(userDev2, sprint1_1, "Mantis 1980", 5.5, urlPuzzle, taskStateDone, normal, date3 + 2)
		createTask(userDev3, sprint1_1, "Mantis 2100", 2.0, urlPuzzle, taskStateDone, immediate, date3 + 4)
		createTask(null, sprint1_1, "Mantis 2001", 2.0, urlPuzzle, taskStateOpen, normal, null)
		createTask(null, sprint1_1, "Mantis 2015", 3.5, urlPuzzle, taskStateOpen, urgent, null)
		createTask(null, sprint1_1, "Mantis 1987", 0.5, urlPuzzle, taskStateOpen, high, null)
		createTask(null, sprint1_1, "Mantis 1950", 2.5, urlPuzzle, taskStateOpen, normal, null)
		createTask(userDev1, sprint1_1, "Mantis 1999", 1.0, urlPuzzle, taskStateChecked, immediate, null)
		createTask(null, sprint1_1, "Mantis 2012", 1.5, urlPuzzle, taskStateNext, normal, null)
		createTask(null, sprint1_1, "Mantis 2014", 5.0, urlPuzzle, taskStateNext, low, null)
		
		// Sprint 1.2
		Sprint sprint1_2 = new Sprint(name: "1.2", goal: "Email Warning System", startDate: date2, endDate: date1, tasks: [])
		sprint1_2.save()
		
		// Sprint 1.3
		Sprint sprint1_3 = new Sprint(name: "1.3", goal: "Usability Improvements", startDate: date1, endDate: date0, tasks: [])
		sprint1_3.save()
		
		// Initialize Project skramboord
		Project skramboord = new Project(name: "skramboord")
		skramboord.addToSprints(sprint1_0)
		skramboord.addToSprints(sprint1_1)
		skramboord.addToSprints(sprint1_2)
		skramboord.addToSprints(sprint1_3)
		skramboord.save()
		
		// Initialize Project Grails
		Project grails = new Project(name: "grails")
		grails.save()
	}
	def destroy = {
	}
	
	/**
	 * Creates a new task an adds it to a sprint.
	 * 
	 * @param sprint
	 * @param name
	 * @param effort
	 * @param url
	 * @param state
	 * @param priority
	 * @param finished
	 */
	def createTask(User user, Sprint sprint, String name, Double effort, String url, StateTask state, Priority priority, Date finished) {
		Task task = new Task(user: user, name: name, effort: effort, url: url, state: state, priority: priority, finishedDate: finished)
		task.save()
		sprint.addToTasks(task)
		sprint.save()
	}
} 