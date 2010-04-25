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

/**
 * User domain class.
 */
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

	/** plain password to create a MD5 password */
	String pass = '[secret]'
		
	static constraints = {
		username(blank: false, unique: true)
		prename(blank: false)
		name(blank: false)
		passwd(blank: false)
		email(blank: false, email: true)
		enabled()
	}
	
	def getUserRealName() {
		return "${prename} ${name}"
	}
}
