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

class ProjectController extends BaseController {
	
	def index = { redirect(controller:'project', action:'list')
	}
	
	def list = {
		flash.allUsers = User.list()
			
		if (!params.sort) {
			params.sort = 'name'
			params.order = 'asc'
		}
		Date today = Today.getInstance()
		flash.runningSprintsList = Sprint.withCriteria {
			le('startDate', today)
			ge('endDate', today)
		}
		flash.projectList = Project.withCriteria {
			if (params.sort != 'sprints') {
				order(params.sort, params.order)
			}
		}
		flash.myTasks = Task.withCriteria {
			eq('user', session.user)
			eq('state', StateTask.getStateCheckedOut())
			order('priority',"desc")
			order('project',"asc")
			order('name',"asc")
		}
		if(params.sort == 'sprints'){
			flash.projectList.sort{it.sprints.size() * (params?.order == "asc"? 1 : -1)}
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
				flash.allUsers = User.list()
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
		
		redirect(controller:params.fwdTo, action:'list')
	}
	
	/**
	 * Project edit action
	 */
	def editProject = {
		if (params.projectId) {
			def project = Project.get(params.projectId)
			if (authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(project.owner)) {
				project.owner = User.get(params.projectOwner)
				project.master = User.get(params.projectMaster)
				project.name = params.projectName
				
				if (!project.save()) {
					flash.project=project
				}
			} else {
				flash.message = "Only Super User and admins can edit projects."
			}
		}

		redirect(controller:params.fwdTo, action:'list')
	}
	
	/**
	 * Add new project
	 */
	def addProject = {
		def projectName = params.projectName
		
		Project project = new Project(name: projectName, owner: session.user, master: User.get(params.projectMaster))
		if (!project.save()) {
			flash.project=project
		}
		
		redirect(controller:'project', action:'list')
	}
	
	/**
	 * Saving dashboard elements order
	 */
	def saveDashboardOrder = {
		int index = 0
		session.user.refresh()
		for (String portletName : params.dashboard.split(",")) {
			DashboardPortlet portlet = DashboardPortlet.withCriteria(uniqueResult:true) {
				eq('name', portletName)
				eq('owner', session.user)
			}
			if (portlet) {
				// edit portlet
				portlet.portletsOrder = index
				portlet.save()
			} else {
				// create new portlet
				new DashboardPortlet(name: portletName, portletsOrder: index, owner: session.user).save()
			}
			++index
		}
		
		redirect(controller:'project', action:'list')
	}
	
	/**
	 * Save portlet state (enabled/disabled)
	 */
	def savePortletState = {
		DashboardPortlet portlet = DashboardPortlet.withCriteria(uniqueResult:true) {
			eq('name', params.portlet)
			eq('owner', session.user)
		}
		
		portlet.enabled = !portlet.enabled
		portlet.save()

		redirect(controller:'project', action:'list')
	}
}
