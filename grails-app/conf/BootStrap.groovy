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

class BootStrap {
	
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
		Date date0 = Today.getInstance() + 15
		Date date1 = date0 - 10
		Date date2 = date1 - 10
		Date date3 = date2 - 10
		
		// Sprint 1.0
		Sprint sprint1_0 = new Sprint(name: "1.0", goal: "Login System", startDate: date3, endDate: date2, tasks: [])
		createTask(sprint1_0, "Mantis 1812", 2.0, urlPuzzle, taskStateDone, normal, date3 + 1)
		createTask(sprint1_0, "Mantis 1798", 4.0, urlPuzzle, taskStateDone, normal, date3 + 3)
		createTask(sprint1_0, "Mantis 1765", 4.5, urlPuzzle, taskStateDone, high, date3 + 4)
		createTask(sprint1_0, "Mantis 1705", 3.5, urlPuzzle, taskStateDone, normal, date3 + 5)
		createTask(sprint1_0, "Mantis 1731", 2.0, urlPuzzle, taskStateDone, low, date3 + 6)
		createTask(sprint1_0, "Mantis 1733", 2.5, urlPuzzle, taskStateDone, low, date3 + 8)
		createTask(sprint1_0, "Mantis 1722", 0.5, urlPuzzle, taskStateDone, low, date3 + 9)
		createTask(sprint1_0, "Mantis 1700", 4, urlPuzzle, taskStateDone, low, date3 + 10)
		
		// Sprint 1.1
		Sprint sprint1_1 = new Sprint(name: "1.1", goal: "Drag'n'Drop Functionality", startDate: date2, endDate: date1, tasks: [])
		createTask(sprint1_1, "Mantis 1980", 5.5, urlPuzzle, taskStateDone, normal, date2 + 2)
		createTask(sprint1_1, "Mantis 2100", 2.0, urlPuzzle, taskStateDone, immediate, date2 + 4)
		createTask(sprint1_1, "Mantis 2001", 2.0, urlPuzzle, taskStateOpen, normal, null)
		createTask(sprint1_1, "Mantis 2015", 3.5, urlPuzzle, taskStateOpen, urgent, null)
		createTask(sprint1_1, "Mantis 1987", 0.5, urlPuzzle, taskStateOpen, high, null)
		createTask(sprint1_1, "Mantis 1950", 2.5, urlPuzzle, taskStateOpen, normal, null)
		createTask(sprint1_1, "Mantis 1999", 1.0, urlPuzzle, taskStateChecked, immediate, null)
		createTask(sprint1_1, "Mantis 2012", 1.5, urlPuzzle, taskStateNext, normal, null)
		createTask(sprint1_1, "Mantis 2014", 5.0, urlPuzzle, taskStateNext, low, null)
		
		// Sprint 1.2
		Sprint sprint1_2 = new Sprint(name: "1.2", goal: "Email Warning System", startDate: date1, endDate: date0, tasks: [])
		sprint1_2.save()
		
		// Initialize Project skramboord
		Project skramboord = new Project(name: "skramboord")
		skramboord.addToSprints(sprint1_0)
		skramboord.addToSprints(sprint1_1)
		skramboord.addToSprints(sprint1_2)
		skramboord.save()
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
	def createTask(Sprint sprint, String name, Double effort, String url, StateTask state, Priority priority, Date finished) {
		Task task = new Task(name: name, effort: effort, url: url, state: state, priority: priority, finishedDate: finished)
		task.save()
		sprint.addToTasks(task)
		sprint.save()
	}
} 