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

import grails.util.GrailsUtil

import java.awt.Color
import java.util.Calendar

import org.skramboord.StateTaskCodereview;
import org.skramboord.SystemPreferences
import org.skramboord.Theme
import org.skramboord.StateTask
import org.skramboord.StateTaskCheckedOut
import org.skramboord.StateTaskDone
import org.skramboord.StateTaskNext
import org.skramboord.StateTaskOpen
import org.skramboord.StateTaskStandBy
import org.skramboord.Task
import org.skramboord.Today
import org.skramboord.DashboardPortlet
import org.skramboord.Priority
import org.skramboord.Sprint
import org.skramboord.Project
import org.skramboord.User
import org.skramboord.UserRole
import org.skramboord.Role
import org.skramboord.Membership
import org.skramboord.Follow
import org.skramboord.Requestmap
import org.skramboord.TaskType
import org.apache.commons.codec.digest.DigestUtils
import org.skramboord.Release

class BootStrap {

	def springSecurityService
	
	Role roleSuperUser
	Role roleAdmin
	Role roleUser
	User userAdmin
	StateTaskOpen taskStateOpen
	StateTaskCheckedOut taskStateChecked
	StateTaskCodereview taskCodereview
	StateTaskDone taskStateDone
	StateTaskNext taskStateNext
	StateTaskStandBy taskStateStandBy
	Priority low
	Priority normal
	Priority high
	Priority urgent
	Priority immediate
	TaskType bug
	TaskType feature
	TaskType documentation
	TaskType token
	
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
		def userDevChief = createUser('wmozart', 'Wolfgang', 'Mozart', true, true, 'wolfgang.mozart@skramboord.org', "1234")
		def userDev1 = createUser('lbeethoven', 'Ludwig', 'Beethoven', true, true, 'ludwig.beethoven@skramboord.org', "1234")
		def userDev2 = createUser('asalieri', 'Antonio', 'Salieri', true, true, 'antonio.salieri@skramboord.org', "1234")
		def userDev3 = createUser('jbach', 'Johann', 'Bach', true, true, 'johann.bach@skramboord.org', "1234")
		def userClient1 = createUser('hmuster', 'Hans', 'Muster', true, true, 'hans.muster@skramboord.org', "1234")
		
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

		// Initialize Project skramboord
		Project skramboord = new Project(name: "skramboord", owner: userAdmin, master: userDevChief)
		skramboord.save()
		
		// Releases
		Release release1_0 = new Release(name: "1.0", goal: "Login System", project: skramboord)
		release1_0.save()
		Release release1_1 = new Release(name: "1.1", goal: "Usability Improvements", project: skramboord)
		release1_1.save()

		// Sprint 1
		Sprint sprint1_0 = new Sprint(name: "#1", goal: "Login System", personDays: 26, startDate: date4, endDate: date3, tasks: [], release: release1_0)
		createTask(userDev1, sprint1_0, "Mantis 1812", "Long names", "Long names of the tasks should be shortened.", 2.0, url, taskStateDone, normal, bug, date4 + 1)
		createTask(userDev3, sprint1_0, "Mantis 1798", "CSS style", "Change CSS style of the whole application to blue/white.", 4.0, url, taskStateDone, normal, feature, date4 + 3)
		createTask(userDev1, sprint1_0, "Mantis 1765", "hmmm.... nothing", null, 4.5, url, taskStateDone, high, feature, date4 + 4)
		createTask(userDev3, sprint1_0, "Mantis 1705", "nope! nothing.", null, 3.5, url, taskStateDone, normal, feature, date4 + 5)
		createTask(userDev3, sprint1_0, "Mantis 1731", "tooltip", "This is just a sentence about nothing to show how this tooltip works with a long text. Maybe this text should be much longer. Or maybe it should also has formatted stuff in it like <b>bold</b> or <i>italic</i>...", 2.0, url, taskStateDone, low, bug, date4 + 6)
		createTask(userDev1, sprint1_0, "Mantis 1733", "nada!", null, 2.5, url, taskStateDone, low, documentation, date4 + 8)
		createTask(userDev2, sprint1_0, "Mantis 1722", "niente!", null, 0.5, url, taskStateDone, low, feature, date4 + 9)
		createTask(userDev2, sprint1_0, "Mantis 1700", "n��t!", null, 4, url, taskStateDone, low, feature, date4 + 10)
		sprint1_0.save()

		// Sprint 2
		Sprint sprint1_1 = new Sprint(name: "#2", goal: "Drag'n'Drop Functionality", personDays: 28.5, startDate: date3, endDate: date2, tasks: [], release: release1_0)
		createTask(userDev2, sprint1_1, "Mantis 1980", "Leere Menge", null, 5.5, url, taskStateDone, normal, feature, date3 + 2)
		createTask(userDev3, sprint1_1, "Mantis 2100", "maybe?! no, nothing.", null, 2.0, url, taskStateDone, immediate, feature, date3 + 4)
		createTask(null, sprint1_1, "Mantis 2001", "nonononothing", null, 2.0, url, taskStateOpen, normal, feature, null)
		createTask(null, sprint1_1, "Mantis 2015", "CSS style", "Change CSS style of the whole application to yellow/black/white.", 3.5, url, taskStateOpen, urgent, feature, null)
		createTask(null, sprint1_1, "Mantis 1987", "this is a title", null, 0.5, url, taskStateOpen, high, documentation, null)
		createTask(null, sprint1_1, "Mantis 1950", "message in a bottle", null, 2.5, url, taskStateOpen, normal, bug, null)
		createTask(userDev1, sprint1_1, "Mantis 1999", "another title to read", null, 1.0, url, taskStateChecked, immediate, feature, null)
		createTask(null, sprint1_1, "Mantis 2012", "Titugschicht", null, 1.5, url, taskStateNext, normal, feature, null)
		createTask(null, sprint1_1, "Mantis 2014", "CSS style", "Change CSS style of the whole application to orange/white.", 5.0, url, taskStateNext, low, feature, null)
		sprint1_1.save()

		// Sprint 1
		Sprint sprint1_2 = new Sprint(name: "#1", goal: "Email Warning System", personDays: null, startDate: date2, endDate: date1, tasks: [], release: release1_1)
		sprint1_2.save()

		// Sprint 2
		Sprint sprint1_3 = new Sprint(name: "#2", goal: "Usability Improvements", personDays: null, startDate: date1, endDate: date0, tasks: [], release: release1_1)
		sprint1_3.save()

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
			// Themes
			Theme defaultTheme = new Theme(name: "skramboord", css: "jquery-ui-1.8rc3.custom.css", background: "postit.skramboord.jpg").save()
			new Theme(name: "shark", css: "jquery-ui-1.8.9.custom.css", background: "postit.shark.jpg").save()
			new Theme(name: "sunflower", css: "jquery-ui-1.8.9.custom.css", background: "postit.sunflower.jpg").save()
			new Theme(name: "chili", css: "jquery-ui-1.8.9.custom.css", background: "postit.chili.jpg").save()
			new Theme(name: "zebra", css: "jquery-ui-1.8.9.custom.css", background: "postit.zebra.jpg").save()
			
			SystemPreferences systemPreferences = new SystemPreferences(name: SystemPreferences.APPLICATION_NAME, theme: defaultTheme, logoUrl: "http://www.skramboord.org").save()
		}
		
		// Initialize states
		if (StateTaskOpen.list()?.isEmpty()) {
			taskStateOpen = new StateTaskOpen().save()
		}
		if (StateTaskCheckedOut.list()?.isEmpty()) {
			taskStateChecked = new StateTaskCheckedOut().save()
		}
		if (StateTaskCodereview.list()?.isEmpty()) {
			taskCodereview = new StateTaskCodereview().save()
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
		def superuserList = Role.withAuthority(Role.ROLE_SUPERUSER).list()
		if (superuserList.isEmpty()) {
			roleSuperUser = new Role(authority:Role.ROLE_SUPERUSER, description:'superuser').save()
		} else {
			roleSuperUser = superuserList.first()
		}

		def adminList = Role.withAuthority(Role.ROLE_ADMIN).list()
		if (adminList.isEmpty()) {
			roleAdmin = new Role(authority:Role.ROLE_ADMIN, description:'administration').save()
		} else {
			roleAdmin = adminList.first()
		}
		
		def userList = Role.withAuthority(Role.ROLE_USER).list()
		if (userList.isEmpty()) {
			roleUser = new Role(authority:Role.ROLE_USER, description:'user').save()						
		} else {
			roleUser = userList.first()
		}
		
		// SuperUser
		if (UserRole.withRole(roleSuperUser).list()?.isEmpty()) {
			userAdmin = createUser('admin', 'Hans', 'Boss', true, true, 'info@skramboord.org', "admin")
			UserRole.create(userAdmin, roleSuperUser)
		}
		
		// Initialize priorities
		if (Priority.list()?.isEmpty()) {
			low = new Priority(Priority.LOW).save()
			normal = new Priority(Priority.NORMAL).save()
			high = new Priority(Priority.HIGH).save()
			urgent = new Priority(Priority.URGENT).save()
			immediate = new Priority(Priority.IMMEDIATE).save()
		}
		
		// Initialize task types
		if (TaskType.list()?.isEmpty()) {
			bug = new TaskType(name: TaskType.BUG, color: "green").save()
			feature = new TaskType(name: TaskType.FEATURE, color: "yellow").save()
			documentation = new TaskType(name: TaskType.DOCUMENTATION, color: "purple").save()
			token = new TaskType(name: TaskType.TOKEN, color: "blue").save()
		}
	}
	
	/**
	 * Creates a new task an adds it to a sprint.
	 * 
	 * @param sprint
	 * @param number
	 * @param title
	 * @param effort
	 * @param url
	 * @param state
	 * @param priority
	 * @param finished
	 */
	def createTask(User user, Sprint sprint, String number, String title, String description, Double effort, String url, StateTask state, Priority priority, TaskType type, Date finished) {
		Task task = new Task(user: user, number: number, title: title, description: description, effort: effort, url: url, state: state, priority: priority, type: type, finishedDate: finished, sprint: sprint, project: null)
		sprint.addToTasks(task)
	}
	
	/**
	 * Creates a new user and initializes his dashboard.
	 * 
	 * @param username
	 * @param prename
	 * @param name
	 * @param enabled
	 * @param emailShow
	 * @param email
	 * @param password
	 * @return
	 */
	User createUser(String username, String prename, String name, boolean enabled, boolean emailShow, String email, String password) {
		User user = new User(username: username, prename: prename, name: name, enabled: enabled, emailShow: emailShow, email: email, password: springSecurityService.encodePassword(password)).save()
		user.addToPortlets(new DashboardPortlet(name: DashboardPortlet.PORTLET_TASKS, portletsOrder: 0, owner: user))
		user.addToPortlets(new DashboardPortlet(name: DashboardPortlet.PORTLET_SPRINTS, portletsOrder: 1, owner: user))
		user.addToPortlets(new DashboardPortlet(name: DashboardPortlet.PORTLET_PROJECTS, portletsOrder: 2, owner: user))
		return user.save()
	}
}