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

import java.awt.Color;

class User {
	static transients = ['pass']
	static hasMany = [authorities:Role, tasks:Task, portlets:DashboardPortlet, projects:Membership, watch:Follow]
	static belongsTo = Role
	
	static mapping = {
		owner lazy:false
		master lazy:false
		projects cascade:"all,delete-orphan"
		watch cascade:"all,delete-orphan"
	}
	
	/** Username */
	String username
	/** Frist Name */
	String prename
	/** Name */
	String name
	/** MD5 Password */
	String passwd
	/** enabled */
	boolean enabled

	String email
	boolean emailShow

	/** description */
	String description = ''

	/** Dashboard */
	SortedSet portlets
		
	/** task color */
	Color color

	/** plain password to create a MD5 password */
	String pass = '[secret]'
		
	static constraints = {
		username(blank: false, unique: true)
		prename(blank: false)
		name(blank: false)
		passwd(blank: false)
		email(blank: false, email: true)
		enabled()
		color(nullable: true)
	}
	
	static namedQueries = {
		projectTeam { fromProject ->
			projects {
				eq('project', fromProject)
			}
		}
		
		followers { fromProject ->
			watch {
				eq('project', fromProject)
			}
		}
	}
	
	def initDashboard() {
		addToPortlets(new DashboardPortlet(name: "tasks", portletsOrder: 0, owner: this))
		addToPortlets(new DashboardPortlet(name: "sprints", portletsOrder: 1, owner: this))
		addToPortlets(new DashboardPortlet(name: "projects", portletsOrder: 2, owner: this))
	}
	
	def getUserDashboard() {
		if (portlets.size() == 0) {
			// init dashboard first
			initDashboard()
		}
		
		String portletString = ""
		boolean first = true
		for (DashboardPortlet portlet : portlets) {
			if (!first) {
				portletString += ","
			} else {
				first = false
			}
			portletString += "${portlet.name}"
		}

		return portletString
	}
	
	def getPortletStates() {
		if (portlets.size() == 0) {
			// init dashboard first
			initDashboard()
		}
		
		String state = ""
		boolean first = true
		for (DashboardPortlet portlet : portlets) {
			if (!first) {
				state += ","
			} else {
				first = false
			}
			state += "${portlet.enabled}"
		}

		return state
	}
	
	def getUserRealName() {
		return "${prename} ${name}"
	}
	
	def getTaskColor() {
		if (color) {
			String hex = Integer.toHexString(color.getRGB() & 0x00ffffff)
			// add leading zeros if necessary
			while(hex.length() < 6) {
				hex = "0" + hex
			}
			return hex
		}
		// return default
		return "009700"
	}
}
