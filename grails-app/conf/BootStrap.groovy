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

import org.apache.catalina.connector.ResponseFacade.DateHeaderPrivilegedAction;

import ch.ping.scrumboard.StateTaskCheckedOut;
import ch.ping.scrumboard.StateTaskDone;
import ch.ping.scrumboard.StateTaskNext;
import ch.ping.scrumboard.StateTaskOpen;
import ch.ping.scrumboard.StateTaskStandBy;
import ch.ping.scrumboard.Task;
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
		Date date1 = new Date()
		Date date2 = date1-10
		Date date3 = date2-10
		
		// Sprint 1.0
		// Initialize tasks
		Task task1812 = new Task(name:"Mantis 1812", effort: 2.0, url: urlPuzzle, state: taskStateDone, priority: normal)
		task1812.save()
		Task task1798 = new Task(name:"Mantis 1798", effort: 7.0, url: urlPuzzle, state: taskStateDone, priority: normal)
		task1798.save()
		Task task1765 = new Task(name:"Mantis 1765", effort: 9.5, url: urlPuzzle, state: taskStateDone, priority: high)
		task1765.save()
		Task task1722 = new Task(name:"Mantis 1722", effort: 0.5, url: urlPuzzle, state: taskStateDone, priority: low)
		task1722.save()

		// Initialize sprints
		Sprint sprint1_0 = new Sprint(name:"1.0", goal:"Some Mantis Tasks", startDate:date3, endDate:date2, tasks: [])
		sprint1_0.addToTasks(task1812)
		sprint1_0.addToTasks(task1798)
		sprint1_0.addToTasks(task1765)
		sprint1_0.addToTasks(task1722)
		sprint1_0.save()

		// Sprint 1.1
		// Initialize tasks
		Task task2001 = new Task(name:"Mantis 2001", effort: 2.0, url: urlPuzzle, state: taskStateOpen, priority: normal)
		task2001.save()
		Task task2015 = new Task(name:"Mantis 2015", effort: 3.5, url: urlPuzzle, state: taskStateOpen, priority: urgent)
		task2015.save()
		Task task1987 = new Task(name:"Mantis 1987", effort: 0.5, url: urlPuzzle, state: taskStateOpen, priority: high)
		task1987.save()
		Task task1950 = new Task(name:"Mantis 1950", effort: 2.5, url: urlPuzzle, state: taskStateOpen, priority: normal)
		task1950.save()
		Task task1999 = new Task(name:"Mantis 1999", effort: 1.0, url: urlPuzzle, state: taskStateChecked, priority: immediate)
		task1999.save()
		Task task2012 = new Task(name:"Mantis 2012", effort: 1.5, url: urlPuzzle, state: taskStateNext, priority: normal)
		task2012.save()
		Task task2014 = new Task(name:"Mantis 2014", effort: 5.0, url: urlPuzzle, state: taskStateNext, priority: low)
		task2014.save()

		// Initialize sprints
		Sprint sprint1_1 = new Sprint(name:"1.1", goal:"Lots Mantis Tasks", startDate:date2, endDate:date1, tasks: [])
		sprint1_1.addToTasks(task2001)
		sprint1_1.addToTasks(task2015)
		sprint1_1.addToTasks(task1987)
		sprint1_1.addToTasks(task1950)
		sprint1_1.addToTasks(task1999)
		sprint1_1.addToTasks(task2012)
		sprint1_1.addToTasks(task2014)
		sprint1_1.save()
		
		// Initialize Project skramboord
		Project skramboord = new Project(name: "skramboord")
		skramboord.addToSprints(sprint1_0)
		skramboord.addToSprints(sprint1_1)
		skramboord.save()
     }
     def destroy = {
     }
} 