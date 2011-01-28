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
import java.security.MessageDigest

class AdministrationController extends BaseController {
	
	def index = {
		redirect(controller:'administration', action:'list')
	}
	
	def list = {
		SystemPreferences systemPreferences = getSystemPreferences()
		flash.twitterAppSettings = systemPreferences?.twitterSettings
		flash.userRoles = Role.list()
		flash.userRoleDefault = Role.withAuthority(Role.ROLE_USER).list().first()
		
		flash.priorities = Priority.withCriteria {
			if (params.priorities) {
				order(params.sort, params.order)
			} else {
				order('id', 'asc')
			}
		}
		
		flash.themeActually = systemPreferences?.theme
		flash.themes = Theme.withCriteria {
			if (params.priorities) {
				order(params.sort, params.order)
			} else {
				order('name', 'asc')
			}
		}
		
		flash.users = User.withCriteria {
			if (params.users) {
				order(params.sort, params.order)
			} else {
				order('name', 'asc')
			}
		}

		flash.twitterRandomAppName = "skramboord-" + Math.abs((new Random(System.currentTimeMillis())).nextInt().hashCode())
	}
	
	def savePriorities = {
		def priorities = Priority.list()
		
		try {
			for (Priority prio : priorities) {
				
				prio.color = Color.decode("0x" + params["priority_${prio.id}"])
				prio.save()
			}
		} catch (NumberFormatException e) {
			flash.message = message(code:"admin.hexValues")
		}
		
		redirect(controller:'administration', action:'list')
	}
	
	def saveAppearance = {
		// save theme
		Theme theme = Theme.get(params.themes)
		
		if (theme) {
			SystemPreferences systemPreferences = getSystemPreferences()
			systemPreferences.theme = theme
			systemPreferences.save()
			session.theme = theme
		}
		
		// save logo
		SystemPreferences systemPreferences = getSystemPreferences()
		switch(params.logo) {
			case SystemPreferences.APPLICATION_NAME:
				systemPreferences.logo = null
				systemPreferences.logoUrl = "http://www.skramboord.org"
				systemPreferences.save()
				session.logo = null
				session.logoUrl = systemPreferences.logoUrl
				break
			case "newLogo":
				def logo = request.getFile('logoFile')
				
				// List of OK mime-types
				def okcontents = ['image/png', 'image/jpeg', 'image/gif']
				if (okcontents.contains(logo.getContentType())) {
					// and save
					if (!params.newLogoName) {
						params.newLogoName = logo.getOriginalFilename()
					}
					if (!systemPreferences.logo) {
						systemPreferences.logo = new Image()
					}
					systemPreferences.logo.name = params.newLogoName
					systemPreferences.logo.image = logo.getBytes()
					systemPreferences.logo.imageType = logo.getContentType()
					systemPreferences.logo.save()
					
					systemPreferences.logoUrl = params.newLogoLink
					systemPreferences.save()
					session.logo = systemPreferences.logo
					session.logoUrl = systemPreferences.logoUrl
				} else {
					flash.message = message(code:"appearance.fileType", args:[okcontents])
				}
				break
			case "logo":
				systemPreferences.logoUrl = params.logoLink
				systemPreferences.save()
				session.logoUrl = systemPreferences.logoUrl
				break
		}
		
		redirect(controller:'administration', action:'list')
	}
	
	def saveTwitterSettings = {
		def systemPreferences = getSystemPreferences()
		
		if (!systemPreferences.twitterSettings) {
			systemPreferences.twitterSettings = new TwitterAppSettings()
		}
		systemPreferences.twitterSettings.consumerKey = params.twitterConsumerKey
		systemPreferences.twitterSettings.consumerSecret = params.twitterConsumerSecret
		systemPreferences.twitterSettings.save()
		
		flash.objectToSave = systemPreferences.twitterSettings
		
		redirect(controller:'administration', action:'list')
	}
	
	def removeTwitterSettings = {
		def systemPreferences = getSystemPreferences()
		systemPreferences.twitterSettings = null
		systemPreferences.save()
		
		redirect(controller:'administration', action:'list')
	}
	
	def enableTwitterSettings = {
		def systemPreferences = getSystemPreferences()
		systemPreferences.twitterSettings.enabled = true
		systemPreferences.twitterSettings.save()
		
		redirect(controller:'administration', action:'list')
	}
	
	def disableTwitterSettings = {
		def systemPreferences = getSystemPreferences()
		systemPreferences.twitterSettings.enabled = false
		systemPreferences.twitterSettings.save()
		
		redirect(controller:'administration', action:'list')
	}
}
