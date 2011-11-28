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

package org.skramboord.utils.csv

import org.codehaus.groovy.grails.exceptions.InvalidPropertyException
import org.skramboord.Priority
import org.skramboord.StateTask
import org.skramboord.TaskType
import org.skramboord.User

import twitter4j.conf.*

class ExampleParser extends BaseParser {

	final FIELD_NAME = 'name'
	final FIELD_DESCRIPTION = 'description'	
	final FIELD_USER = 'user'
	final FIELD_EFFORT = 'effort'
	final FIELD_PRIORITY = 'priority'
	final FIELD_TYPE = 'type'
	final FIELD_STATE = 'state'
	
	final CSV_DATA_FIELDS = [
		FIELD_NAME,
		FIELD_DESCRIPTION,
		FIELD_USER,
		FIELD_EFFORT,
		FIELD_PRIORITY,
		FIELD_TYPE,
		FIELD_STATE,
	]

	final CSV_URL_TEMPLATE = 'https://example.com/task/%1s/'

	@Override
	def parseEntry(csvData) throws InvalidPropertyException{

		def data = [:]
		data.name = getName(csvData[FIELD_NAME], FIELD_NAME)
		data.description = csvData[FIELD_DESCRIPTION]?:''
		data.user = getUser(csvData[FIELD_USER], FIELD_USER)
		data.effort = getEffort(csvData[FIELD_EFFORT], FIELD_EFFORT)
		data.priority = getPriority(csvData[FIELD_PRIORITY], FIELD_PRIORITY)
		data.url = String.format(CSV_URL_TEMPLATE, csvData[FIELD_NAME])
		data.type = getTaskType(csvData[FIELD_TYPE], FIELD_TYPE)
		data.state = getStateTask(csvData[FIELD_STATE], FIELD_STATE)
		data.subtractFromToken = false // set this to true if you want to subtract the task effort from a token task

		return data
	}

	@Override
	public isValidHeader(headers) {
		return headers == CSV_DATA_FIELDS
	}
}
