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

import java.util.Date;

class Task {	
	String name
	Double effort
	String url
	StateTask state
	Priority priority
	Date finishedDate
	static belongsTo = [sprint:Sprint, user:User]
	
	static mapping = {
		priority lazy:false
	}
	                    
	static constraints = {
		name(nullable:false)
		effort(nullable:false)
		url(nullable:true, url:true, blank:false)
		state(nullable:false)
		priority(nullable:false)
		finishedDate(nullable:true)
		user(nullable:true)
    }
}
