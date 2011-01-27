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
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;

/**
 * User controller.
 */
class UserController extends BaseController {

	def index = {
		redirect action: list, params: params
	}
	
	def list = {
		if (!params.max) {
			params.max = 10
		}
		flash.personList = User.list(params)
	}
		
	def show = {
		def person = User.get(params.id)
		if (!person) {
			flash.message = message(code:"user.notFound", args:[params.id])
			redirect action: list
			return
		}
		List roleNames = []
		for (role in person.authorities) {
			roleNames << role.authority
		}
		roleNames.sort { n1, n2 ->
			n1 <=> n2
		}
		flash.roleNames = roleNames
		flash.person = person
	}
	
	/**
	 * Person delete action. Before removing an existing person,
	 * he should be removed from those authorities which he is involved.
	 */
	def delete = {
		def person = User.get(params.id)
		if (userDeletePermission(session.user, person)) {
			if (person) {
				//avoid self-delete if the logged-in user is an admin
				if (!session.user.equals(person)) {
					if (!istheUserTheLastSuperuser(person)) {
						// first, delete this person from People_Authorities table.
						UserRole.removeAll(person)
						// second, remove all tasks from person
						person.tasks.each {it.user = null}
						person.tasks.clear()
						
						// Now delete this person...
						person.delete()
						flash.message = message(code:"user.deleted", args:[person.getUserRealName()])
					} else {
						flash.message = message(code:"error.deleteLastSuperUser")
					}
				}
				else {
					flash.message = message(code:"user.selfDestruction")
				}
			}
			else {
				flash.message = message(code:"user.notFound", args:[params.id])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect(uri:params.fwdTo)
	}
	
	def edit = {
		def person = User.get(params.id)
		if (userWritePermission(session.user, person)) {
			if (params.id) {
				flash.userEdit = User.get(params.id)
				flash.userRoles = Role.list()
				flash.userRole = (flash.userEdit.getAuthorities().toArray())[0]
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		redirect(uri:params.fwdTo)
	}
	
	/**
	 * Person update action.
	 */
	def update = {
		def person = User.get(params.userId)
		if (userWritePermission(session.user, person)) {
			if (params.userPassword == params.userPassword2) {
				if (!params.userPassword.equals(person.password)) {
					person.password = springSecurityService.encodePassword(params.userPassword)
				}
			} else {
				flash.message = message(code:"error.passwordNotEqual")			
			}
			
			person.name = params.userName
			person.prename = params.userPrename
			person.description = params.userDescription
			person.email = params.userEmail
			person.color = Color.decode("0x" + params.taskColor)
			
			if (person.save()) {
				if (SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER)) {
					Role existingRole = (person.getAuthorities().toArray())[0]
                    Role newRole = Role.get(params.userRole)
                    if (!newRole.equals(existingRole)) {
                    	// If superuser is the last superuser then he can not change his role
                    	if (!istheUserTheLastSuperuser(person)) {
                    		UserRole.removeAll(person)
                    		UserRole.create(person, newRole)					
                    	} else {
                    		flash.message = message(code:"error.lastSuperUser")
                    	}
                    }
				}
			} else {
				flash.objectToSave=person			
			}
			
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		redirect(uri:params.fwdTo)
	}
	
	def create = {
		[person: new User(params), authorityList: Role.list()]
	}
	
	/**
	 * Person save action.
	 */
	def save = {
		def person = new User()
		if (params.userPassword == params.userPassword2) {
			if (!params.userPassword.equals(person.password)) {
				person.password = springSecurityService.encodePassword(params.userPassword)
			}
		} else {
			flash.message = message(code:"error.passwordNotEqual")
		}
		
		person.username = params.userLoginName
		person.name = params.userName
		person.prename = params.userPrename
		person.description = params.userDescription
		person.email = params.userEmail
		person.color = Color.decode("0x" + params.taskColorNewUser)
		person.addToPortlets(new DashboardPortlet(name: DashboardPortlet.PORTLET_TASKS, portletsOrder: 0, owner: person))
		person.addToPortlets(new DashboardPortlet(name: DashboardPortlet.PORTLET_SPRINTS, portletsOrder: 1, owner: person))
		person.addToPortlets(new DashboardPortlet(name: DashboardPortlet.PORTLET_PROJECTS, portletsOrder: 2, owner: person))
		
		if (person.save()) {
			// Only Superuser can set a different role than just ROLE_USER.
			if (SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER)) {
				UserRole.create(person, Role.get(params.userRole))
			} else {
				UserRole.create(person, Role.withAuthority(Role.ROLE_USER).list().first())
			}
		} else {
			flash.objectToSave=person
		}
		
		redirect(uri:params.fwdTo)
	}
	
	def tabChange = {
		if (params.viewName && params.tabName) {
			if(!session.tabs) {
				session.tabs = new HashMap<String,String>()
			}
			session.tabs.put(params.viewName, params.tabName)
		}
	}
	
	private boolean userWritePermission(User user, User userToChange) {
		return SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER) || user.id.equals(user.id)
	}
	
	private boolean userDeletePermission(User user, User userToDelete) {
		return SpringSecurityUtils.ifAnyGranted(Role.ROLE_SUPERUSER)
	}
	
	private boolean istheUserTheLastSuperuser(User user) {
		Role superuserRole = Role.withAuthority(Role.ROLE_SUPERUSER).list().first()
		return UserRole.get(user.id, superuserRole.id) && UserRole.withRole(superuserRole).list().size() <= 1
	}
}
