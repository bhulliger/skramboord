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
		flash.project = getProject()
		if (releaseWritePermission(session.user, flash.project)) {
			if (params.release) {
				def release = Release.get(params.release)
				release.delete()
				
				flash.message = message(code:"release.deleted", args:[release.name])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
	}
	
	/**
	 * Add new release
	 */
	def addRelease = {
		flash.project = getProject()
		if (releaseWritePermission(session.user, flash.project)) {
			def releaseName = params.releaseName
			def releaseGoal = params.releaseGoal
			
			Release release = new Release(name: releaseName, goal: releaseGoal, project: flash.project)
			if (!release.save()) {
				flash.releaseIncomplete=release
				flash.objectToSave=release
			}
			
			// select new created release
			flash.project.refresh()
			if(!session.tabs) {
				session.tabs = new HashMap<String,String>()
			}
			session.tabs.put('releases', flash.project.releases.size()-1)
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
	}
	
	def edit = {
		flash.project = getProject()
		if (releaseWritePermission(session.user, flash.project)) {
			if (params.release) {
				flash.releaseEdit = Release.get(params.release)
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
	}
	
	/**
	 * Release edit action
	 */
	def update = {
		flash.project = getProject()
		if (releaseWritePermission(session.user, flash.project)) {
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
		
		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
	}
	
	private boolean releaseViewPermission(User user, Project project) {
		return Project.accessRight(project, user, springSecurityService).list().first() == 0
	}
	
	private boolean releaseWritePermission(User user, Project project) {
		return SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER) || user.id.equals(project.owner.id) || user.id.equals(project.master.id)
	}
}
