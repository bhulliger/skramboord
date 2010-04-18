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

package ch.ping.skramboord

class StateTaskStandBy extends StateTask {
	String name = "Stand By"
	
	def checkOut(Task task) {
		task.state = super.getStateCheckedOut()
		task.finishedDate = null
	}
	
	def open(Task task) {
		task.state = super.getStateOpen()
		task.finishedDate = null
	}
	
	def next(Task task) {
		task.state = super.getStateNext()
		task.finishedDate = null
	}
}
