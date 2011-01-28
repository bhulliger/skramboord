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

abstract class BaseController {
	def springSecurityService
	
	def beforeInterceptor = [action:this.&doBefore]
	
	def doBefore() {
		if (!session.theme) {
			def systemPreferences = getSystemPreferences()
			session.theme = systemPreferences.theme
		}
		
		if (!session.logo) {
			def systemPreferences = getSystemPreferences()
			session.logo = systemPreferences.logo
		}
		
		if (!session.logoUrl) {
			def systemPreferences = getSystemPreferences()
			session.logoUrl = systemPreferences.logoUrl
		}
		
		if (springSecurityService && springSecurityService.isLoggedIn()) {
			def username = springSecurityService.getPrincipal().username
			if (username && !username.equals(session.username)) {
				User user = User.withCriteria(uniqueResult:true) {
					eq('username', username)
				}
				session.user = user
			}
		}
	}
	
	protected SystemPreferences getSystemPreferences() {
		return SystemPreferences.getPreferences(SystemPreferences.APPLICATION_NAME).list().first()
	}
}
