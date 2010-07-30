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
import java.awt.Color;
import grails.test.*
import org.codehaus.groovy.grails.plugins.GrailsPluginManager
import org.codehaus.groovy.grails.plugins.PluginManagerHolder

class TaskTests extends GrailsUnitTestCase {
	Url urlPuzzle
	Priority immediate
	Priority normal
	StateTaskOpen taskStateOpen
	StateTaskCheckedOut taskStateChecked
	Sprint sprint
	
    protected void setUp() {
        super.setUp()
		PluginManagerHolder.pluginManager = [hasGrailsPlugin: { String name -> true }] as GrailsPluginManager

        mockForConstraintsTests(Task)

        urlPuzzle = new Url(url:"http://www.puzzle.ch")
		immediate = new Priority(name: "immediate", color: Color.RED)
		normal = new Priority(name: "normal", color: Color.GREEN)
		taskStateOpen = new StateTaskOpen()
		taskStateChecked = new StateTaskCheckedOut()
        
		Date date0 = Today.getInstance() + 15
		Date date1 = date0 - 10
        sprint = new Sprint(name: "1.1", goal: "GOOOOAAAAL!", startDate: date1, endDate: date0, tasks: [])
    }

    protected void tearDown() {
        super.tearDown()
		PluginManagerHolder.pluginManager = null
    }

    /**
     * Test with a correct task
     */
    void testCorrectTask() {
		// given
		Task task = new Task(name:"Mantis 2001", effort: 2.0, url: urlPuzzle, state: taskStateOpen, priority: normal, finishedDate: null, sprint: sprint)
		
		// when
		
		// then
		assertTrue task.validate()
    }
	
	/**
	 * Another test with a correct task
	 */
	void testAnotherCorrectTask() {
		// given
		Task task = new Task(name:"Mantis 3050", effort: 100.0, url: urlPuzzle, state: taskStateChecked, priority: immediate, finishedDate: null, sprint: sprint)
		
		// when
		
		// then
		assertTrue task.validate()
	}
	
	/**
	 * Task without url is still valid
	 */
	void testTaskWithoutUrl() {
		// given
		Task task = new Task(name:"Mantis 3050", effort: 1.0, state: taskStateChecked, priority: normal, finishedDate: null, sprint: sprint)
		
		// when
		
		// then
		assertTrue task.validate()
	}
	
	/**
	 * Each task needs his effort time
	 */
	void testTaskWithMissingEffort() {
		// given
		Task task = new Task(name:"Mantis 2001", url: urlPuzzle, state: taskStateChecked, priority: normal, finishedDate: null, sprint: sprint)
		
		// when
		
		// then
		assertFalse task.validate()
	}
	
	/**
	 * Task without name is invalid
	 */
	void testTaskWithMissingName() {
		// given
		Task task = new Task(effort: 2.0, url: urlPuzzle, state: taskStateChecked, priority: normal, finishedDate: null, sprint: sprint)
		
		// when
		
		// then
		assertFalse task.validate()
	}
	
	/**
	 * Task without priority
	 */
	void testTaskWithMissingPriority() {
		// given
		Task task = new Task(name:"Mantis 3050", effort: 100.0, url: urlPuzzle, state: taskStateChecked, finishedDate: null, sprint: sprint)
		
		// when
		
		// then
		assertFalse task.validate()
	}
	
	/**
	 * Test without task state
	 */
	void testTaskWithMissingState() {
		// given
		Task task = new Task(name:"Mantis 3050", effort: 100.0, url: urlPuzzle, priority: normal, finishedDate: null, sprint: sprint)
		
		// when
		
		// then
		assertFalse task.validate()
	}
}
