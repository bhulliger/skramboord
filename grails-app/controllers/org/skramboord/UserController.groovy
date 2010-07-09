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
		if (authenticateService.ifAllGranted('ROLE_SUPERUSER')) {
			def person = User.get(params.id)
			if (person) {
				def authPrincipal = authenticateService.principal()
				//avoid self-delete if the logged-in user is an admin
				if (!(authPrincipal instanceof String) && authPrincipal.username == person.username) {
					flash.message = message(code:"user.selfDestruction")
				}
				else {
					// first, delete this person from People_Authorities table.
					Role.findAll().each { it.removeFromPeople(person)
					}
					// second, remove all tasks from person
					person.tasks.each {it.user = null}
					person.tasks.clear()
					
					// Now delete this person...
					person.delete()
					flash.message = message(code:"user.deleted", args:[params.id])
				}
			}
			else {
				flash.message = message(code:"user.notFound", args:[params.id])
			}
		} else {
			flash.message = message(code:"error.insufficientAccessRights")
		}
		
		redirect action: list
	}
	
	def edit = {
		def person = User.get(params.id)
		if (!person) {
			flash.message = message(code:"user.notFound", args:[params.id])
			redirect action: list
			return
		}
		if (authenticateService.ifNotGranted('ROLE_SUPERUSER') && person.id != session.user.id) {
			flash.message = message(code:"error.insufficientAccessRights")
			redirect action: list
			return
		}
		
		return buildPersonModel(person)
	}
	
	/**
	 * Person update action.
	 */
	def update = {
		
		def person = User.get(params.id)
		if (!person) {
			flash.message = message(code:"user.notFound", args:[params.id])
			redirect action: edit, id: params.id
			return
		}
		
		long version = params.version.toLong()
		if (person.version > version) {
			person.errors.rejectValue 'version', "person.optimistic.locking.failure",
			"Another user has updated this User while you were editing."
			render view: 'edit', model: buildPersonModel(person)
			return
		}
		
		def oldPassword = person.passwd
		person.properties = params
		if (!params.passwd.equals(oldPassword)) {
			person.passwd = authenticateService.encodePassword(params.passwd)
		}
		person.color = Color.decode("0x" + params["taskColor"])
		
		if (person.save() && authenticateService.ifAllGranted('ROLE_SUPERUSER')) {
			Role.findAll().each { it.removeFromPeople(person)
			}
			addRoles(person)
			redirect action: show, id: person.id
		}
		else {
			render view: 'edit', model: buildPersonModel(person)
		}
	}
	
	def create = {
		[person: new User(params), authorityList: Role.list()]
	}
	
	/**
	 * Person save action.
	 */
	def save = {
		
		def person = new User()
		person.properties = params
		person.passwd = authenticateService.encodePassword(params.passwd)
		if (person.save()) {
			addRoles(person)
			redirect action: show, id: person.id
		}
		else {
			render view: 'create', model: [authorityList: Role.list(), person: person]
		}
	}
	
	private void addRoles(person) {
		for (String key in params.keySet()) {
			if (key.contains('ROLE') && 'on' == params.get(key)) {
				if (authenticateService.ifAllGranted('ROLE_SUPERUSER')) {
					// Only Super user can add all roles
					Role.findByAuthority(key).addToPeople(person)
				}
			}
		}
		// Every user (USER, ADMIN and SUPERUSER) has the role ROLE_USER
		Role.findByAuthority('ROLE_USER').addToPeople(person)
	}
	
	private Map buildPersonModel(person) {
		
		List roles = Role.list()
		roles.sort { r1, r2 ->
			r1.authority <=> r2.authority
		}
		Set userRoleNames = []
		for (role in person.authorities) {
			userRoleNames << role.authority
		}
		LinkedHashMap<Role, Boolean> roleMap = [:]
		for (role in roles) {
			roleMap[(role)] = userRoleNames.contains(role.authority)
		}
		
		return [person: person, roleMap: roleMap]
	}
}
