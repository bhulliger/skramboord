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

class Sprint {
	String name
	String goal
	Date startDate
	Date endDate
	Double personDays
	static hasMany = [tasks:Task]
	static belongsTo = [release:Release]

    static constraints = {
		name(nullable:false, blank:false, unique: ['release'])
		goal(nullable:true)
		personDays(nullable:false)
		startDate(nullable:false)
		endDate(nullable:false, validator: {val, obj ->
			if (val && val.before(obj.startDate)) {
				return 'endDateshouldbegreater'
			}

		})
		release(nullable:false)
    }
	
	static mapping = {
		sort endDate:"desc"
		//sort:'endDate desc, startDate desc'
	}
	
	static namedQueries = {
		startDateRelease { fromRelease ->
			release {
				eq('id', fromRelease.id)
			}
			projections {
				min("startDate")
			}
		}
		
		endDateRelease { fromRelease ->
			release {
				eq('id', fromRelease.id)
			}
			projections {
				max("endDate")
			}
		}
	}
	
	/**
	 * Returns true if today is between start and end date.
	 * 
	 * @return true if sprint is running
	 */
	def isSprintRunning() {
		Date today = Today.getInstance()
		return (today.after(startDate) || today.equals(startDate)) && (today.before(endDate) || today.equals(endDate))
	}
	
	/**
	 * Returns true if end date of sprint is after today.
	 * 
	 * @return true if sprint is active
	 */
	def isSprintActive() {
		Date today = Today.getInstance()
		return today.before(endDate) || today.equals(endDate)
	}
}
