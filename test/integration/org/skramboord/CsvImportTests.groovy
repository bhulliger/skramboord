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

import org.springframework.context.MessageSource
import org.springframework.mock.web.MockMultipartFile
import org.springframework.mock.web.MockMultipartHttpServletRequest

class CsvImportTests extends GroovyTestCase {
	
	def controller
	
	protected void setUp() {		
		controller = new TaskController()
		controller.metaClass.request = new MockMultipartHttpServletRequest()
		super.setUp()
	}

	protected void tearDown() {
		super.tearDown()
	}
	
	private void prepareController(){
		/*controller.request.clearAttributes()
		controller.request.removeAllParameters()
		
		controller.response.reset()
		controller.response.committed = false*/
		controller.flash.project = Project.get(1)
		controller.session.user = User.findByUsername('admin')		
		controller.params.fwdTo = 'task'
		controller.params.target = 'sprint'		
	}
	
	private MockMultipartFile createCSVFile(id, pro, cat, des, est, pri, sta, ass, ign) {
		def csvContentType = 'text/csv'
		def csvContent = "Id,Project,Category,Description,Schätzung in PT,Priority,Status,Assigned To,ignore on skramboord"
		csvContent += id + "," + pro + "," + cat + "," + des + "," + est + "," + pri+ "," + sta + "," + ass + "," + ign
		csvContent = csvContent.getBytes('UTF-8')
		return new MockMultipartFile('cvsFile', 'test.csv', csvContentType, csvContent)
	}
	
	void _testInvalidCSV() {
		// invalid format
		prepareController()
		def csvContent = "Id,Project,Category,Description,Schätzung in PT,Priority,Status,Assigned To,ignore on skramboord"
		csvContent += "1,2"
		csvContent = csvContent.getBytes('UTF-8')
		controller.metaClass.request = new MockMultipartHttpServletRequest()
		controller.request.addFile(new MockMultipartFile('cvsFile', 'test.csv', 'text/csv', csvContent))
		controller.importCSV()

		println controller.flash.message.toString()
		
		// missing columns
		prepareController()
		csvContent = "Id,Project,Category,Description,Schätzung in PT,Priority,ignore on skramboord"
		csvContent += "1,2,3,4,5,6,7"
		csvContent = csvContent.getBytes('UTF-8')
		controller.request.addFile(new MockMultipartFile('cvsFile', 'test.csv', 'text/csv', csvContent))
		controller.importCSV()
		
		println controller.flash.message.toString()
	}

	void testImportCSV() {
		prepareController()
		controller.request.addFile(createCSVFile(3721, 'Wartung', 'TODO', 'Der Profiler ist anzupassen.', '', 'normal', 'new', 'bhulliger', ''))

		controller.importCSV()

		println controller.flash.message.toString()

		//assertEquals HttpServletResponse.SC_OK, controller.response.status
	}
}
