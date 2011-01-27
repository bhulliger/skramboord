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

class DashboardPortlet implements Comparable {
	static String PORTLET_TASKS = "tasks"
	static String PORTLET_SPRINTS = "sprints"
	static String PORTLET_PROJECTS = "projects"
	
	String name
	boolean enabled = true
	int portletsOrder
	static belongsTo = [owner:User]

    static constraints = {
		name(blank:false, unique: ['portletsOrder','owner'])
    }
	
   int compareTo(obj) {
		portletsOrder.compareTo(obj.portletsOrder)
   }
}
