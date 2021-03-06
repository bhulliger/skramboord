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

class TodayTests extends GrailsUnitTestCase {
	protected void setUp() {
		super.setUp()
	}
	
	protected void tearDown() {
		super.tearDown()
	}
	
	/**
	 * Tests if getInstance() returns the correct date.
	 */
	void testTodayInstance() {
		// given
		Calendar calendar = Calendar.getInstance()
		Date today = Date.parse("dd.MM.yyyy", "${calendar.get(Calendar.DATE)}.${calendar.get(Calendar.MONTH)+1}.${calendar.get(Calendar.YEAR)}")
		
		// when
		
		// then
		assertEquals today, Today.getInstance()
	}
}
