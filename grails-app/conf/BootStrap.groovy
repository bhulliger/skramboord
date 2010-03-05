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

import ch.ping.scrumboard.StateTaskCheckedOut;
import ch.ping.scrumboard.StateTaskDone;
import ch.ping.scrumboard.StateTaskNext;
import ch.ping.scrumboard.StateTaskOpen;
import ch.ping.scrumboard.StateTaskStandBy;
import ch.ping.scrumboard.Task;
import ch.ping.scrumboard.Url;
import ch.ping.scrumboard.Priority;

class BootStrap {

     def init = { servletContext ->
		// Create some test data
		Url urlPuzzle = new Url(url:"http://www.puzzle.ch")
		urlPuzzle.save()

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

		// Initialize tasks for scrum board		
		new Task(name:"Mantis 2001", effort: 2.0, url: urlPuzzle, state: taskStateOpen, priority: normal).save()
		new Task(name:"Mantis 2015", effort: 3.5, url: urlPuzzle, state: taskStateOpen, priority: urgent).save()
		new Task(name:"Mantis 1987", effort: 0.5, url: urlPuzzle, state: taskStateOpen, priority: high).save()
		new Task(name:"Mantis 1950", effort: 2.5, url: urlPuzzle, state: taskStateOpen, priority: normal).save()
		new Task(name:"Mantis 1999", effort: 1.0, url: urlPuzzle, state: taskStateChecked, priority: immediate).save()
		new Task(name:"Mantis 2012", effort: 1.5, url: urlPuzzle, state: taskStateNext, priority: normal).save()
		new Task(name:"Mantis 2014", effort: 5.0, url: urlPuzzle, state: taskStateNext, priority: low).save()
     }
     def destroy = {
     }
} 