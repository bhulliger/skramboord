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


abstract class BaseParser {
	
	def nameColumn
	
	/**
	* Parse CSV entry
	*
	* @param csvData raw CSV data
	* @return normalized task data
	*/
	def parseEntry(csvData) throws InvalidPropertyException {}
	
	/**
	 * Check CSV header data
	 * 
	 * @param csvData
	 * @return true if headers are valid
	 */
	def isValidHeader(csvData)  {}
	
	def getName(value, field) throws InvalidPropertyException {
		if (value == null || value.size() < 1) {
			throw new InvalidPropertyException(field)
		}
		return value
	}	
	
	def getPriority(name, field) throws InvalidPropertyException {
		def priority = Priority.byName(name.toLowerCase()).list()
		if (priority != null && priority.size() == 1) {
			return priority.first()
		} else {
			throw new InvalidPropertyException(field)
		}
	}
	
	def getUser(username, field) throws InvalidPropertyException {
		if (User.findByUsername(username) == null) {
			throw new InvalidPropertyException(field)
		} else {
			return User.findByUsername(username)
		}
	}
	
	def getEffort(value, field) throws InvalidPropertyException {
		if (!value.isNumber()) {
			throw new InvalidPropertyException(field)
		}
		return value.toDouble()
	}
	
	def getTaskType(type, field) throws InvalidPropertyException {
		if (type.toLowerCase() in [TaskType.FEATURE, TaskType.BUG, TaskType.DOCUMENTATION, TaskType.TOKEN]) {
			return TaskType.byName(type.toLowerCase()).list().first()
		}else{
			throw new InvalidPropertyException(field)
		}		
	}
	
	def getStateTask(state, field) throws InvalidPropertyException {
		def stateTask
		switch (state) {
			case "Open":
				stateTask = StateTask.getStateOpen()
				break
			case "Checked out":
				stateTask = StateTask.getStateCheckedOut()
				break
			case "Codereview":
				stateTask = StateTask.getStateCodereview()
				break
			case "Done":
				stateTask = StateTask.getStateDone()
				break
			case "Next":
				stateTask = StateTask.getStateNext()
				break
			case "Stand By":
				stateTask = StateTask.getStateStandBy()
				break
			default:
				throw new InvalidPropertyException(field)
		}
	
		return stateTask
	}
}
