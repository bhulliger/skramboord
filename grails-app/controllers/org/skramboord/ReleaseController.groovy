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

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;

class ReleaseController extends BaseController {
	
	def index = { redirect(controller:'sprint', action:'list')
	}
	
	/**
	 * Release delete action
	 */
	def delete = {
		if (releaseWritePermission(session.user, session.project)) {
			if (params.release) {
				def release = Release.get(params.release)
				release.delete()
				
				flash.message = message(code:"release.deleted", args:[release.name])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(controller:'sprint', action:'list')
	}
	
	/**
	 * Add new release
	 */
	def addRelease = {
		if (releaseWritePermission(session.user, session.project)) {
			def releaseName = params.releaseName
			def releaseGoal = params.releaseGoal
			
			Release release = new Release(name: releaseName, goal: releaseGoal, project: session.project)
			if (!release.save()) {
				flash.objectToSave=release
			}
			
			// select new created release
			session.project.refresh()
			if(!session.tabs) {
				session.tabs = new HashMap<String,String>()
			}
			session.tabs.put('releases', session.project.releases.size()-1)
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(controller:'sprint', action:'list')
	}
	
	def edit = {
		if (releaseWritePermission(session.user, session.project)) {
			if (params.release) {
				flash.releaseEdit = Release.get(params.release)
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(controller:'sprint', action:'list')
	}
	
	/**
	 * Release edit action
	 */
	def update = {
		if (releaseWritePermission(session.user, session.project)) {
			if (params.releaseId) {
				def release = Release.get(params.releaseId)
				release.name = params.releaseName
				release.goal = params.releaseGoal
				
				if (!release.save()) {
					flash.objectToSave=release
				}
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(controller:'sprint', action:'list')
	}
	
	private boolean releaseViewPermission(User user, Project project) {
		return Project.accessRight(project, user, springSecurityService).list().first() == 0
	}
	
	private boolean releaseWritePermission(User user, Project project) {
		return SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER) || user.equals(project.owner) || user.equals(project.master)
	}
}
