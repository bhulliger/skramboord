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
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;
import twitter4j.TwitterFactory;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.conf.*;
import twitter4j.http.AccessToken;
import twitter4j.http.RequestToken;
import grails.plugins.springsecurity.Secured;

class ProjectController extends BaseController {

	def index = {
		redirect(url: createLink(mapping: 'project', action: 'list'))
	}

	def list = {
		flash.allUsers = User.list()

		if (!params.sort) {
			params.sort = 'name'
			params.order = 'asc'
		}
		Date today = Today.getInstance()

		// get all project the user belongs to
		flash.projectList = Project.projectsUserBelongsTo(session.user, params.sort, params.order, springSecurityService).listDistinct()

		flash.ownerOfAProject = false
		for (project in flash.projectList) {
			if (session.user.equals(project.owner)) {
				flash.ownerOfAProject = true
				break
			}
		}

		// get all running sprints the user belongs to
		flash.runningSprintsList = Sprint.createCriteria().listDistinct {
			le('startDate', today)
			ge('endDate', today)
			if (!SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER)) {
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
	@Secured(["ROLE_SUPERUSER"])
	def delete = {
		if (params.project) {
			def project = Project.get(params.project)
			project.delete()

			flash.message = message(code:"project.deleted", args:[project.name])
		}

		redirect(url: createLink(mapping: 'project', action: 'list'))
	}

	def edit = {
		if (params.project) {
			def project = Project.get(params.project)

			if (projectEditPermission(session.user, project)) {
				flash.projectEdit = project
			} else {
				flash.message = message(code:"error.insufficientAccessRights")
			}
		}

		createRedirect(params.fwdTo, getProject(), getSprint())
	}

	/**
	 * Project edit action
	 */
	def update = {
		flash.project = getProject()
		if (flash.project) {
			def project = Project.get(flash.project.id)
			if (projectEditPermission(session.user, project)) {
				project.name = params.projectName
				project.taskNumberingEnabled = params.projectTaskNumberingEnabled != null ? Boolean.valueOf(params.projectTaskNumberingEnabled) : false
				project.taskNumberingPattern = params.projectTaskNumberingPattern

				if (!project.save()) {
					flash.objectToSave=project
				}
			} else {
				flash.message = message(code:"error.insufficientAccessRights")
			}
		}
		
		createRedirect(params.fwdTo, flash.project, getSprint())
	}

	/**
	 * Add new project
	 */
	def addProject = {
		if (projectNewPermission()) {
			def projectName = params.projectName

			Project project = new Project(name: projectName, owner: session.user, master: User.get(params.projectMaster))
			if (!project.save()) {
				flash.objectToSave=project
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(url: createLink(mapping: 'project', action: 'list'))
	}

	/**
	 * Disable Twitter account
	 */
	def disableTwitter = {
		flash.project = getProject()
		if (projectEditPermission(session.user, project)) {
			project.twitter.enabled = false

			if (!flash.project.twitter.save()) {
				flash.objectToSave = flash.project.twitter
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
	}

	/**
	 * Enable Twitter account
	 */
	def enableTwitter = {
		flash.project = getProject()
		if (projectEditPermission(session.user, flash.project)) {
			flash.project.twitter.enabled = true

			if (!flash.project.twitter.save()) {
				flash.objectToSave = flash.project.twitter
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
	}

	/**
	 * Remove Twitter account
	 */
	def removeTwitter = {
		flash.project = getProject()
		if (projectEditPermission(session.user, flash.project)) {
			TwitterAccount account = flash.project.twitter
			flash.project.twitter = null
			if (!account.delete()) {
				flash.objectToSave = account
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
	}

	/**
	 * Add Twitter account
	 */
	def addTwitter = {
		flash.project = getProject()
		if (projectEditPermission(session.user, flash.project)) {
			def twitterAppSettings = getSystemPreferences().twitterSettings
			try {
				session.twitter = new TwitterFactory().getInstance()
				session.twitter.setOAuthConsumer(twitterAppSettings.consumerKey, twitterAppSettings.consumerSecret)
				session.requestToken = session.twitter.getOAuthRequestToken()
				flash.twitterAccessUrl = session.requestToken.getAuthorizationURL()
			} catch (TwitterException e) {
				flash.message = message(code:"error.twitterProblems")
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}

		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
	}

	/**
	 * Create Twitter account with pin
	 */
	def createTwitterAccount = {
		if (params.twitterAccessPin && params.twitterAccessPin.length() > 0) {
			flash.project = getProject()
			if (projectEditPermission(session.user, flash.project)) {
				try {
					AccessToken accessToken = session.twitter.getOAuthAccessToken(session.requestToken, params.twitterAccessPin)
					flash.project.twitter = new TwitterAccount(token: accessToken.getToken(), tokenSecret: accessToken.getTokenSecret()).save()
					flash.project.save()
				} catch (TwitterException e) {
					flash.message = message(code:"error.twitterProblems")
				}
			} else {
				flash.message = message(code:"error.insufficientAccessRights")
			}
		} else {
			flash.message = message(code:"error.twitter.noPin")
		}

		redirect(url: createLink(mapping: 'sprint', action: 'list', params:[project: flash.project.id]))
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

		redirect(url: createLink(mapping: 'project', action: 'list'))
	}

	/**
	 * Save portlet state (enabled/disabled)
	 */
	def savePortletState = {
		session.user.refresh()
		DashboardPortlet portlet = DashboardPortlet.withCriteria(uniqueResult:true) {
			eq('name', params.portlet)
			eq('owner', session.user)
		}
		
		if (portlet) {
			portlet.enabled = !portlet.enabled
			portlet.save()
		}

		redirect(url: createLink(mapping: 'project', action: 'list'))
	}

	private boolean projectNewPermission() {
		return SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER) || SpringSecurityUtils.ifAnyGranted(Role.ROLE_ADMIN)
	}

	private boolean projectEditPermission(User user, Project project) {
		return SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER) || user.id.equals(project.owner.id)
	}
}
