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

package ch.ping.scrumboard

import grails.test.*

class SprintTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
		
        mockForConstraintsTests(Sprint)
    }

    protected void tearDown() {
        super.tearDown()
    }

    /**
     * Tests if sprint is active between date in past and date in future.
     */
    void testSprintActive() {
		// given
		Date end = new Date()+10
		Date start = new Date()-10
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
		Date end = new Date()
		Date start = new Date()-10
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
		Date end = new Date()+20
		Date start = new Date()+10
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
		Date end = new Date()-1
		Date start = new Date()-10
		Sprint sprint = new Sprint(name: "test", startDate: start, endDate: end)
		
		// when
		
		// then
		assertFalse sprint.isSprintActive()
	}
}
