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

import grails.test.*

class SprintTests extends GrailsUnitTestCase {
	Date today
	
	protected void setUp() {
		super.setUp()
		
		mockForConstraintsTests(Sprint)
		
		today = Today.getInstance()
	}
	
	protected void tearDown() {
		super.tearDown()
	}
	
	/**
	 * Tests if sprint is active between date in past and date in future.
	 */
	void testSprintActive() {
		// given
		Date end =  today + 10
		Date start =  today - 10
		Sprint sprint = new Sprint(name: "test", startDate: start, endDate: end)
		
		// when
		
		// then
		assertTrue sprint.isSprintActive()
	}
	
	/**
	 * Tests if sprint is active between date in past and date in future.
	 */
	void testSprintActiveLastDay() {
		// given
		Date end = today
		Date start = today - 10
		Sprint sprint = new Sprint(name: "test", startDate: start, endDate: end)
		
		// when
		
		// then
		assertTrue sprint.isSprintActive()
	}
	
	/**
	 * Tests if sprint is active between date in past and date in future.
	 */
	void testSprintActiveInFuture() {
		// given
		Date end = today + 20
		Date start = today + 10
		Sprint sprint = new Sprint(name: "test", startDate: start, endDate: end)
		
		// when
		
		// then
		assertTrue sprint.isSprintActive()
	}
	
	
	/**
	 * Tests if sprint is passiv.
	 */
	void testSprintPassiv() {
		// given
		Date end = today - 1
		Date start = today - 10
		Sprint sprint = new Sprint(name: "test", startDate: start, endDate: end)
		
		// when
		
		// then
		assertFalse sprint.isSprintActive()
	}
}
