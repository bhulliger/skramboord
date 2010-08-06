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

import org.hibernate.criterion.Distinct;

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

		// get all project the user belongs to
		flash.projectList = Project.projectsUserBelongsTo(session.user, params.sort, params.order, authenticateService).listDistinct()
		
		// get all running sprints the user belongs to
		flash.runningSprintsList = Sprint.createCriteria().listDistinct {
			le('startDate', today)
			ge('endDate', today)
			if (!authenticateService.ifAnyGranted('ROLE_SUPERUSER')) {
				release {
					project {
						or {
							team {
								eq('user', session.user)
							}
							follower {
								eq('user', session.user)
							}
							eq('master', session.user)
							eq('owner', session.user)
						}
					}
				}
			}
		}
		
		flash.myTasks = Task.fromUser(session.user).list()
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
				
				flash.message = message(code:"project.deleted", args:[project.name])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(controller:'project', action:'list')
	}
	
	def edit = {
		if (params.project) {
			def project = Project.get(params.project)
		
			if (projectEditPermission(session.user, project)) {
				flash.projectEdit = project
				def criteria = User.createCriteria()
				flash.users = criteria.list {
						authorities {
				            eq('authority','ROLE_ADMIN')
				       }
				}
			} else {
				flash.message = message(code:"error.insufficientAccessRights")
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
			if (projectEditPermission(session.user, project)) {
				project.name = params.projectName
				
				// Twitter
				if (!params.twitterAccount.isEmpty() && !params.twitterPassword.isEmpty()) {
					project.twitter = new Twitter(account: params.twitterAccount, password: params.twitterPassword).save()
				} else {
					project.twitter = null
				}
				
				if (!project.save()) {
					flash.project=project
				}
			} else {
				flash.message = message(code:"error.insufficientAccessRights")
			}
		}

		redirect(controller:params.fwdTo, action:'list')
	}
	
	/**
	 * Add new project
	 */
	def addProject = {
		if (projectNewPermission()) {
			def projectName = params.projectName
			
			Project project = new Project(name: projectName, owner: session.user, master: User.get(params.projectMaster))
			if (!project.save()) {
				flash.project=project
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
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
	
	private boolean projectNewPermission() {
		return authenticateService.ifAnyGranted('ROLE_SUPERUSER') || authenticateService.ifAnyGranted('ROLE_ADMIN')
	}
	
	private boolean projectEditPermission(User user, Project project) {
		return authenticateService.ifAnyGranted('ROLE_SUPERUSER') || user.equals(project.owner)
	}
}
