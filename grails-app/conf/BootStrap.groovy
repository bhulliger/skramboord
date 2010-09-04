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

import grails.util.GrailsUtil;

import java.awt.Color;
import java.util.Calendar;

import org.skramboord.StateTask;
import org.skramboord.StateTaskCheckedOut;
import org.skramboord.StateTaskDone;
import org.skramboord.StateTaskNext;
import org.skramboord.StateTaskOpen;
import org.skramboord.StateTaskStandBy;
import org.skramboord.Task;
import org.skramboord.Today;
import org.skramboord.Url;
import org.skramboord.Priority;
import org.skramboord.Sprint;
import org.skramboord.Project;
import org.skramboord.User;
import org.skramboord.UserRole;
import org.skramboord.Role;
import org.skramboord.Membership;
import org.skramboord.Follow;
import org.skramboord.Requestmap;
import org.apache.commons.codec.digest.DigestUtils
import org.skramboord.Release;

class BootStrap {
	
	def springSecurityService
	
	def init = { servletContext ->
		
		switch (GrailsUtil.environment) {
			case "development":
			initDevelopment()
			break
			case "production":
			initDevelopment()
			break 
		}
	}
	def destroy = {
	}
	
	def initDevelopment() {
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
		def userAdmin = new User(username:'admin', prename:'Pablo', name:'Hess', enabled: true, emailShow: true, email: 'admin@skramboord.org', password: springSecurityService.encodePassword("admin")).save()
		def userDevChief = new User(username:'wmozart', prename:'Wolfgang', name:'Mozart', enabled: true, emailShow: true, email: 'wolfgang.mozart@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		def userDev1 = new User(username:'lbeethoven', prename:'Ludwig', name:'Beethoven', enabled: true, emailShow: true, email: 'ludwig.beethoven@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		def userDev2 = new User(username:'asalieri', prename:'Antonio', name:'Salieri', enabled: true, emailShow: true, email: 'antonio.salieri@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		def userDev3 = new User(username:'jbach', prename:'Johann', name:'Bach', enabled: true, emailShow: true, email: 'johann.bach@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		def userClient1 = new User(username:'hmuster', prename:'Hans', name:'Muster', enabled: true, emailShow: true, email: 'hans.muster@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		
		// Adding user to roles
		UserRole.create(userAdmin, roleSuperUser)
		UserRole.create(userAdmin, roleAdmin)
		UserRole.create(userDevChief, roleAdmin)
		UserRole.create(userAdmin, roleUser)
		UserRole.create(userDevChief, roleUser)
		UserRole.create(userDev1, roleUser)
		UserRole.create(userDev2, roleUser)
		UserRole.create(userDev3, roleUser)
		UserRole.create(userClient1, roleUser)
		
		// Initialize priorities
		Priority low = new Priority(name: "low", color: Color.decode("0x808080"))
		low.save()
		Priority normal = new Priority(name: "normal", color: Color.decode("0x42a642"))
		normal.save()
		Priority high = new Priority(name: "high", color: Color.decode("0x3d3da8"))
		high.save()
		Priority urgent = new Priority(name: "urgent", color: Color.decode("0x968136"))
		urgent.save()
		Priority immediate = new Priority(name: "immediate", color: Color.decode("0xad3e3e"))
		immediate.save()
		
		// Initialize dates
		Date date0 = Today.getInstance() + 25
		Date date1 = date0 - 10
		Date date2 = date1 - 10
		Date date3 = date2 - 10
		Date date4 = date3 - 10
		
		// Releases
		Release release1_0 = new Release(name: "1.0", goal: "Login System")
		Release release1_1 = new Release(name: "1.1", goal: "Usability Improvements")
		
		// Sprint 1
		Sprint sprint1_0 = new Sprint(name: "#1", goal: "Login System", startDate: date4, endDate: date3, tasks: [])
		createTask(userDev1, sprint1_0, "Mantis 1812", "Long names of the tasks should be shortened.", 2.0, urlPuzzle, taskStateDone, normal, date4 + 1)
		createTask(userDev3, sprint1_0, "Mantis 1798", "Change CSS style of the whole application to blue/white.", 4.0, urlPuzzle, taskStateDone, normal, date4 + 3)
		createTask(userDev1, sprint1_0, "Mantis 1765", null, 4.5, urlPuzzle, taskStateDone, high, date4 + 4)
		createTask(userDev3, sprint1_0, "Mantis 1705", null, 3.5, urlPuzzle, taskStateDone, normal, date4 + 5)
		createTask(userDev3, sprint1_0, "Mantis 1731", "This is just a sentence about nothing to show how this tooltip works with a long text. Maybe this text should be much longer. Or maybe it should also has formatted stuff in it like <b>bold</b> or <i>italic</i>...", 2.0, urlPuzzle, taskStateDone, low, date4 + 6)
		createTask(userDev1, sprint1_0, "Mantis 1733", null, 2.5, urlPuzzle, taskStateDone, low, date4 + 8)
		createTask(userDev2, sprint1_0, "Mantis 1722", null, 0.5, urlPuzzle, taskStateDone, low, date4 + 9)
		createTask(userDev2, sprint1_0, "Mantis 1700", null, 4, urlPuzzle, taskStateDone, low, date4 + 10)
		
		// Sprint 2
		Sprint sprint1_1 = new Sprint(name: "#2", goal: "Drag'n'Drop Functionality", startDate: date3, endDate: date2, tasks: [])
		createTask(userDev2, sprint1_1, "Mantis 1980", null, 5.5, urlPuzzle, taskStateDone, normal, date3 + 2)
		createTask(userDev3, sprint1_1, "Mantis 2100", null, 2.0, urlPuzzle, taskStateDone, immediate, date3 + 4)
		createTask(null, sprint1_1, "Mantis 2001", null, 2.0, urlPuzzle, taskStateOpen, normal, null)
		createTask(null, sprint1_1, "Mantis 2015", "Change CSS style of the whole application to yellow/black/white.", 3.5, urlPuzzle, taskStateOpen, urgent, null)
		createTask(null, sprint1_1, "Mantis 1987", null, 0.5, urlPuzzle, taskStateOpen, high, null)
		createTask(null, sprint1_1, "Mantis 1950", null, 2.5, urlPuzzle, taskStateOpen, normal, null)
		createTask(userDev1, sprint1_1, "Mantis 1999", null, 1.0, urlPuzzle, taskStateChecked, immediate, null)
		createTask(null, sprint1_1, "Mantis 2012", null, 1.5, urlPuzzle, taskStateNext, normal, null)
		createTask(null, sprint1_1, "Mantis 2014", "Change CSS style of the whole application to orange/white.", 5.0, urlPuzzle, taskStateNext, low, null)
		
		// Sprint 1
		Sprint sprint1_2 = new Sprint(name: "#1", goal: "Email Warning System", startDate: date2, endDate: date1, tasks: [])
		sprint1_2.save()
		
		// Sprint 2
		Sprint sprint1_3 = new Sprint(name: "#2", goal: "Usability Improvements", startDate: date1, endDate: date0, tasks: [])
		sprint1_3.save()
		
		// Initialize Project skramboord
		Project skramboord = new Project(name: "skramboord", owner: userAdmin, master: userDevChief)
		skramboord.addToReleases(release1_0)
		skramboord.addToReleases(release1_1)
		skramboord.save()
		
		// Initialize Releases
		release1_0.addToSprints(sprint1_0)
		release1_0.addToSprints(sprint1_1)
		release1_1.addToSprints(sprint1_2)
		release1_1.addToSprints(sprint1_3)
		release1_0.save()
		release1_1.save()

		Membership.link(skramboord, userDev1)
		Membership.link(skramboord, userDev3)
		Follow.link(skramboord, userClient1)
						
		// Initialize Project Grails
		Project grails = new Project(name: "grails", owner: userAdmin, master: userDevChief)
		grails.save()
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
	def createTask(User user, Sprint sprint, String name, String description, Double effort, String url, StateTask state, Priority priority, Date finished) {
		Task task = new Task(user: user, name: name, description: description, effort: effort, url: url, state: state, priority: priority, finishedDate: finished, sprint: sprint, project: null)
		task.save()
	}
} 