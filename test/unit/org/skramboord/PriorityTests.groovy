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

class PriorityTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
		PluginManagerHolder.pluginManager = [hasGrailsPlugin: { String name -> true }] as GrailsPluginManager
		
        mockForConstraintsTests(Priority)
    }

    protected void tearDown() {
        super.tearDown()
		PluginManagerHolder.pluginManager = null
    }

    /**
     * Correct Priority
     */
    void testCorrectPriority() {
		// given
		Priority low = new Priority(name: "low", color: Color.GREEN)
		
		// when
		
		// then
		assertTrue low.validate()
    }
	
	/**
	 * Invalid priority with missing color
	 */
	void testPriorityWithMissingColor() {
		// given
		Priority low = new Priority(name: "low")
		
		// when
		
		// then
		assertFalse low.validate()
	}
	
	/**
	 * Invalid priority with missing name
	 */
	void testPriorityWithMissingName() {
		// given
		Priority low = new Priority(color: Color.GREEN)
		
		// when
		
		// then
		assertFalse low.validate()
	}
}
