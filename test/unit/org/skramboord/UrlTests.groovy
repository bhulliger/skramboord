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

class UrlTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
		mockForConstraintsTests(Url)
    }

    protected void tearDown() {
        super.tearDown()
    }
	
	/**
	 * Url can't be null
	 */
	void testNullAsUrl() {
		// given
		def correctUrl = new Url(url:null)
		
		// when
		
		// then
		assertFalse correctUrl.validate()
	}
	
    /**
     * Positive test HTTP
     */
    void testCorrectUrlHttp() {
		// given
    	def correctUrl = new Url(url:"http://www.puzzle.ch")
		
		// when
		
		// then
		assertTrue correctUrl.validate()
    }
	
	/**
	 * Negative test: Missing domain
	 */
	void testInCorrectUrlMissingDomain() {
		// given
		def incorrectUrl = new Url(url:"http://www.puzzle")
		
		// when
		
		// then
		assertFalse incorrectUrl.validate()
	}
	
	/**
	 * Positive test HTTPS
	 */
	void testCorrectUrlHttps() {
		// given
		def correctUrl = new Url(url:"https://www.puzzle.ch")
		
		// when
		
		// then
		assertTrue correctUrl.validate()
	}
	
	/**
	 * Negative test: Missing protocol
	 */
	void testInCorrectUrlMissingProtocol() {
		// given
		def incorrectUrl = new Url(url:"www.puzzle.ch")
		
		// when
		
		// then
		assertFalse incorrectUrl.validate()
	}
	
	/**
	 * Negative test: url with lot of whitespace
	 */
	void testInCorrectUrlWithWhitespace() {
		// given
		def incorrectUrl = new Url(url:"htt p:/ /ww w. puz z l e")
		
		// when
		
		// then
		assertFalse incorrectUrl.validate()
	}
}
