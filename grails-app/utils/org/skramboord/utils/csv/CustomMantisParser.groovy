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

class CustomMantisParser extends BaseParser {

	final PROJECT_SERVICE = 'Wartung'
	final PROJECT_DEVELOPMENT = 'Entwicklung'

	final CATEGORY_ERROR = 'Fehler'
	final CATEGORY_EXTENSION = 'Erweiterung'
	final CATEGORY_WARRANTY = 'Garantie'

	final STATE_FEEDBACK = 'feedback'
	final STATE_ASSIGNED = 'assigned'
	final STATE_RESOLVED = 'resolved'
	final STATE_CLOSED = 'closed'

	final FIELD_ID = 'Id'
	final FIELD_PROJECT = 'Project'
	final FIELD_CATEGORY = 'Category'
	final FIELD_DESCRIPTION = 'Summary'
	final FIELD_ESTIMATE = 'Estimate'
	final FIELD_PRIORITY = 'Priority'
	final FIELD_STATE = 'Status'
	final FIELD_USER = 'Assigned'
	final FIELD_IGNORE = 'ignore on skramboord'

	final CSV_DATA_FIELDS = [
		FIELD_ID,
		FIELD_PROJECT,
		FIELD_CATEGORY,
		FIELD_DESCRIPTION,
		FIELD_ESTIMATE,
		FIELD_PRIORITY,
		FIELD_STATE,
		FIELD_USER,
		FIELD_IGNORE
	]

	final CSV_URL_TEMPLATE = 'https://mantis.puzzle.ch/view.php?id=%1s'

	@Override
	def parseEntry(csvData) throws InvalidPropertyException{

		def data = [:]
		def subtractFromToken = false

		// map state
		def state = StateTask.getStateOpen()
		switch (csvData.Status) {
			case STATE_FEEDBACK:
				state = StateTask.getStateStandBy()
				break
			case STATE_ASSIGNED:
				state = StateTask.getStateCheckedOut()
				break
			case [
				STATE_RESOLVED,
				STATE_CLOSED,
				'inList'
			]:
				state = StateTask.getStateDone()
				break
		}

		// map task type and project
		def taskType = null
		def project = csvData.Project
		if (project == PROJECT_SERVICE) {
			if (csvData.Category == CATEGORY_ERROR) {
				taskType = TaskType.byName(TaskType.BUG).list().first()
			} else {
				taskType = TaskType.byName(TaskType.DOCUMENTATION).list().first()
			}
			subtractFromToken = true
		} else if(project == PROJECT_DEVELOPMENT) {
			if (csvData.Category == CATEGORY_EXTENSION) {
				taskType = TaskType.byName(TaskType.FEATURE).list().first()
			} else if(csvData.Category == CATEGORY_WARRANTY) {
				taskType = TaskType.byName(TaskType.BUG).list().first()
			} else {
				taskType = TaskType.byName(TaskType.DOCUMENTATION).list().first()
			}
		} else {
			throw new InvalidPropertyException(FIELD_PROJECT)
		}

		data.name = getName(csvData[FIELD_ID], FIELD_ID)
		data.user = getUser(csvData[FIELD_USER], FIELD_USER)
		data.effort = getEffort(csvData[FIELD_ESTIMATE], FIELD_ESTIMATE)
		data.priority = getPriority(csvData[FIELD_PRIORITY], FIELD_PRIORITY)
		data.url = String.format(CSV_URL_TEMPLATE, csvData[FIELD_ID])
		data.description = csvData[FIELD_DESCRIPTION]?:''
		data.state = state
		data.subtractFromToken = subtractFromToken
		data.type = taskType

		return data
	}

	@Override
	public isValidHeader(csvHeaders) {
		return csvHeaders == CSV_DATA_FIELDS
	}
}