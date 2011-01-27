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
import java.util.Set;


class User {

	String username
	String prename
	String name
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	String email
	boolean emailShow = true
	String description = ''
	SortedSet portlets
	Color color
	
	static hasMany = [tasks:Task, portlets:DashboardPortlet, projects:Membership, watch:Follow]

	static constraints = {
		username blank: false, unique: true
		password blank: false
		name blank: false
		prename blank: false
		email blank: false, email: true
		color nullable: true
	}

	static mapping = {
		password column: '`password`'
		owner lazy:false
		master lazy:false
		projects cascade:"all,delete-orphan"
		watch cascade:"all,delete-orphan"
	}

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this).collect { it.role } as Set
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
	
	def getUserDashboard() {
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
