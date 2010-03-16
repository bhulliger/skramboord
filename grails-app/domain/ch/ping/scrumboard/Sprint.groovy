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

package ch.ping.scrumboard

class Sprint {
	String name
	String goal
	Date startDate
	Date endDate
	static hasMany = [tasks:Task]
	static belongsTo = [project:Project]

    static constraints = {
		name(nullable:false, minSize: 1, unique: ['project'])
		goal(nullable:true)
		startDate(nullable:false)
		endDate(nullable:false)
		project(nullable:false)
    }
	
	/**
	 * Returns true if end date of sprint is after today.
	 * 
	 * @return true if active
	 */
	def isSprintActive() {
		Date today = new Date()
		today.hours = 0
		today.minutes = 0
		today.seconds = 0
		return today.before(endDate)
	}
}
