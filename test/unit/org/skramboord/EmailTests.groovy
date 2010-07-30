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
import org.codehaus.groovy.grails.plugins.GrailsPluginManager
import org.codehaus.groovy.grails.plugins.PluginManagerHolder

class EmailTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
		PluginManagerHolder.pluginManager = [hasGrailsPlugin: { String name -> true }] as GrailsPluginManager
        mockForConstraintsTests(Email)
    }

    protected void tearDown() {
        super.tearDown()
		PluginManagerHolder.pluginManager = null
    }
	
	/**
	 * Test null as email address
	 */
	void testNullAsEmail() {
		// given
		def correctEmail = new Email(email:null)
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
	
    /**
     * Test correct email address
     */
    void testCorrectEmail() {
		// given
		def correctEmail = new Email(email:"info@puzzle.ch")
		
		// when
		
		// then
		assertTrue correctEmail.validate()
    }
	
	/**
	 * Test incorrect email address: missing @
	 */
	void testIncorrectEmailMissingAt() {
		// given
		def correctEmail = new Email(email:"infopuzzle.ch")
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: missing domain
	 */
	void testIncorrectEmailMissingDomain() {
		// given
		def correctEmail = new Email(email:"info@puzzle")
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: missing name
	 */
	void testIncorrectEmailMissingName() {
		// given
		def correctEmail = new Email(email:"@puzzle")
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: address with whitespace
	 */
	void testIncorrectEmailWithWhitespace() {
		// given
		def correctEmail = new Email(email:"in fo@p u zzle")
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
}
