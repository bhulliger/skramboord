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
	static hasMany = [authorities:Role, tasks:Task]
	static belongsTo = Role

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
		color(nullable:true)
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
