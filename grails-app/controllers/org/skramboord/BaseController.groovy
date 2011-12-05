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

import javax.servlet.http.HttpServletResponse

abstract class BaseController {
	def springSecurityService
	
	def beforeInterceptor = [action:this.&doBefore]
	
	def doBefore() {
		if (session) {
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
		}
		
		if (springSecurityService) {
			session.user = springSecurityService.currentUser
		}
	}
	
	protected SystemPreferences getSystemPreferences() {
		return SystemPreferences.getPreferences(SystemPreferences.APPLICATION_NAME).list().first()
	}
	
	protected Project getProject() {
		def project = Project.get(params.project)
		
		if (project == null){
			response.sendError(HttpServletResponse.SC_NOT_FOUND)
			return null
		}
		return project
	}
	
	protected Sprint getSprint() {
		def sprint = Sprint.get(params.sprint)
		
		if (project == null){
			response.sendError(HttpServletResponse.SC_NOT_FOUND)
			return null
		}
		return sprint
	}
	
	protected def createRedirect(String fwdTo, Project project, Sprint sprint) {
		def paramList = []
		if (project?.id != null && sprint?.id != null) {
			return redirect(url: createLink(mapping: fwdTo, action: 'list', params: [project: project.id, sprint: sprint.id]))
		} else if (project?.id != null) {
			return redirect(url: createLink(mapping: fwdTo, action: 'list', params: [project: project.id]))
		} else {
			return redirect(url: createLink(mapping: fwdTo, action: 'list'))
		}
	}
	
	/**
	* Returns true if this user is allowed to change the state of the tasks.
	*
	* @param user
	* @param project
	* @return
	*/
   protected boolean taskWorkPermission(User user, Project project) {
	   return Project.changeRight(project, user, springSecurityService).list().first() != 0
   }
}