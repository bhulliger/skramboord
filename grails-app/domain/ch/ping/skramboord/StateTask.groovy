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

class StateTask {
	String name = "Abstract state"
	
	protected StateTask() {}
	
	def checkOut(Task task) {
		// do nothing
	}
	
	def open(Task task) {
		// do nothing
	}
	
	def done(Task task) {
		// do nothing
	}
	
	def next(Task task) {
		// do nothing
	}
	
	def standBy(Task task) {
		// do nothing
	}
	
	static StateTaskOpen getStateOpen() {
		return StateTaskOpen.withCriteria(uniqueResult:true) {
		}
	}
	
	static StateTaskCheckedOut getStateCheckedOut() {
		return StateTaskCheckedOut.withCriteria(uniqueResult:true) {
		}
	}
	
	static StateTaskDone getStateDone() {
		return StateTaskDone.withCriteria(uniqueResult:true) {
		}
	}
	
	static StateTaskNext getStateNext() {
		return StateTaskNext.withCriteria(uniqueResult:true) {
		}
	}
	
	static StateTaskStandBy getStateStandBy() {
		return StateTaskStandBy.withCriteria(uniqueResult:true) {
		}
	}
}
