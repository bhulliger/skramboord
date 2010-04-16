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

package ch.ping.scrumboard

import org.grails.plugins.springsecurity.service.AuthenticateService;

class ProjectController extends BaseControllerController {
	
	def index = { redirect(controller:'project', action:'list')
	}
	
	def list = {
		if (!params.sort) {
			params.sort = 'name'
			params.order = 'asc'
		}
		session.projectList = Project.withCriteria {
			if (params.sort != 'sprints') {
				order(params.sort, params.order)
			}
		}
		if(params.sort == 'sprints'){
			session.projectList.sort{it.sprints.size() * (params?.order == "asc"? 1 : -1)}
		}
	}
	
	/**
	 * Project delete action
	 */
	def delete = {
		if (authenticateService.ifAnyGranted('ROLE_SUPERUSER')) {
			if (params.project) {
				def project = Project.get(params.project)
				project.delete()
				
				flash.message = "Project $project.name deleted."
			}
		} else {
			flash.message = "Only Super User and admins can delete projects."
		}
		
		redirect(controller:'project', action:'list')
	}
	
	def edit = {
		if (params.project) {
			def project = Project.get(params.project)
		
			if (authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(project.owner)) {
				flash.projectEdit = project

				def criteria = User.createCriteria()
				flash.users = criteria.list {
						authorities {
				            eq('authority','ROLE_ADMIN')
				       }
				}
			} else {
				flash.message = "Only Super User and admins can edit projects."
			}
		}
		
		redirect(controller:'project', action:'list')
	}
	
	/**
	 * Project edit action
	 */
	def editProject = {
		if (params.projectId) {
			def project = Project.get(params.projectId)
			if (authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(project.owner)) {
				project.owner = User.get(params.projectOwner)
				project.name = params.projectName
				
				if (!project.save()) {
					flash.project=project
				}
			} else {
				flash.message = "Only Super User and admins can edit projects."
			}
		}

		redirect(controller:'project', action:'list')
	}
	
	/**
	 * Add new project
	 */
	def addProject = {
		def projectName = params.projectName
		
		Project project = new Project(name: projectName, owner: session.user)
		if (!project.save()) {
			flash.project=project
		}
		
		redirect(controller:'project', action:'list')
	}
}
