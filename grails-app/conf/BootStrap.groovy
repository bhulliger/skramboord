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

import org.skramboord.SystemPreferences
import org.skramboord.StateTask;
import org.skramboord.StateTaskCheckedOut;
import org.skramboord.StateTaskDone;
import org.skramboord.StateTaskNext;
import org.skramboord.StateTaskOpen;
import org.skramboord.StateTaskStandBy;
import org.skramboord.Task;
import org.skramboord.Today;
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
	
	Role roleSuperUser
	Role roleAdmin
	Role roleUser
	User userAdmin
	StateTaskOpen taskStateOpen
	StateTaskCheckedOut taskStateChecked
	StateTaskDone taskStateDone
	StateTaskNext taskStateNext
	StateTaskStandBy taskStateStandBy
	Priority low
	Priority normal
	Priority high
	Priority urgent
	Priority immediate
	
	def init = { servletContext ->
		switch (GrailsUtil.environment) {
			case "development":
				initBasics()
				initTestdata()
				break
			case "test":
				initBasics()
				initTestdata()
				break
			case "production":
				initBasics()
				break
		}
	}
	def destroy = {
	}

	def initTestdata() {
		// Create some test data
		String url = "http://www.skramboord.org"
		
		// Adding Users
		def userDevChief = new User(username:'wmozart', prename:'Wolfgang', name:'Mozart', enabled: true, emailShow: true, email: 'wolfgang.mozart@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		def userDev1 = new User(username:'lbeethoven', prename:'Ludwig', name:'Beethoven', enabled: true, emailShow: true, email: 'ludwig.beethoven@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		def userDev2 = new User(username:'asalieri', prename:'Antonio', name:'Salieri', enabled: true, emailShow: true, email: 'antonio.salieri@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		def userDev3 = new User(username:'jbach', prename:'Johann', name:'Bach', enabled: true, emailShow: true, email: 'johann.bach@skramboord.org', password: springSecurityService.encodePassword("1234")).save()
		def userClient1 = new User(username:'hmuster', prename:'Hans', name:'Muster', enabled: true, emailShow: true, email: 'hans.muster@skramboord.org', password: springSecurityService.encodePassword("1234")).save()

		// Adding user to roles
		UserRole.create(userDevChief, roleAdmin)
		UserRole.create(userDev1, roleUser)
		UserRole.create(userDev2, roleUser)
		UserRole.create(userDev3, roleUser)
		UserRole.create(userClient1, roleUser)

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
		createTask(userDev1, sprint1_0, "Mantis 1812", "Long names of the tasks should be shortened.", 2.0, url, taskStateDone, normal, date4 + 1)
		createTask(userDev3, sprint1_0, "Mantis 1798", "Change CSS style of the whole application to blue/white.", 4.0, url, taskStateDone, normal, date4 + 3)
		createTask(userDev1, sprint1_0, "Mantis 1765", null, 4.5, url, taskStateDone, high, date4 + 4)
		createTask(userDev3, sprint1_0, "Mantis 1705", null, 3.5, url, taskStateDone, normal, date4 + 5)
		createTask(userDev3, sprint1_0, "Mantis 1731", "This is just a sentence about nothing to show how this tooltip works with a long text. Maybe this text should be much longer. Or maybe it should also has formatted stuff in it like <b>bold</b> or <i>italic</i>...", 2.0, url, taskStateDone, low, date4 + 6)
		createTask(userDev1, sprint1_0, "Mantis 1733", null, 2.5, url, taskStateDone, low, date4 + 8)
		createTask(userDev2, sprint1_0, "Mantis 1722", null, 0.5, url, taskStateDone, low, date4 + 9)
		createTask(userDev2, sprint1_0, "Mantis 1700", null, 4, url, taskStateDone, low, date4 + 10)

		// Sprint 2
		Sprint sprint1_1 = new Sprint(name: "#2", goal: "Drag'n'Drop Functionality", startDate: date3, endDate: date2, tasks: [])
		createTask(userDev2, sprint1_1, "Mantis 1980", null, 5.5, url, taskStateDone, normal, date3 + 2)
		createTask(userDev3, sprint1_1, "Mantis 2100", null, 2.0, url, taskStateDone, immediate, date3 + 4)
		createTask(null, sprint1_1, "Mantis 2001", null, 2.0, url, taskStateOpen, normal, null)
		createTask(null, sprint1_1, "Mantis 2015", "Change CSS style of the whole application to yellow/black/white.", 3.5, url, taskStateOpen, urgent, null)
		createTask(null, sprint1_1, "Mantis 1987", null, 0.5, url, taskStateOpen, high, null)
		createTask(null, sprint1_1, "Mantis 1950", null, 2.5, url, taskStateOpen, normal, null)
		createTask(userDev1, sprint1_1, "Mantis 1999", null, 1.0, url, taskStateChecked, immediate, null)
		createTask(null, sprint1_1, "Mantis 2012", null, 1.5, url, taskStateNext, normal, null)
		createTask(null, sprint1_1, "Mantis 2014", "Change CSS style of the whole application to orange/white.", 5.0, url, taskStateNext, low, null)

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

	def initBasics() {
		// System Preferences
		if (SystemPreferences.list()?.isEmpty()) {
			SystemPreferences systemPreferences = new SystemPreferences(name: SystemPreferences.APPLICATION_NAME).save()
		}
		
		// Initialize states
		if (StateTaskOpen.list()?.isEmpty()) {
			taskStateOpen = new StateTaskOpen().save()
		}
		if (StateTaskCheckedOut.list()?.isEmpty()) {
			taskStateChecked = new StateTaskCheckedOut().save()
		}
		if (StateTaskDone.list()?.isEmpty()) {
			taskStateDone = new StateTaskDone().save()
		}
		if (StateTaskNext.list()?.isEmpty()) {
			taskStateNext = new StateTaskNext().save()
		}
		if (StateTaskStandBy.list()?.isEmpty()) {
			taskStateStandBy = new StateTaskStandBy().save()
		}
		
		// Adding Roles
		if (Role.list()?.isEmpty()) {
			roleSuperUser = new Role(authority:Role.ROLE_SUPERUSER, description:'superuser').save()
			roleAdmin = new Role(authority:Role.ROLE_ADMIN, description:'administration').save()
			roleUser = new Role(authority:Role.ROLE_USER, description:'user').save()
		}
		
		// SuperUser
		if (UserRole.withRole(roleSuperUser).list()?.isEmpty()) {
			userAdmin = new User(username:'admin', prename:'YourPrename', name:'YourName', enabled: true, emailShow: true, email: 'youremail@internet.com', password: springSecurityService.encodePassword("admin")).save()
			UserRole.create(userAdmin, roleSuperUser)
		}
		
		// Initialize priorities
		if (Priority.list()?.isEmpty()) {
			low = new Priority("low", Color.decode("0x808080")).save()
			normal = new Priority("normal", Color.decode("0x42a642")).save()
			high = new Priority("high", Color.decode("0x3d3da8")).save()
			urgent = new Priority("urgent", Color.decode("0x968136")).save()
			immediate = new Priority("immediate", Color.decode("0xad3e3e")).save()
		}
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