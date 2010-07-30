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

class Project {
	String name
	Twitter twitter
	static hasMany = [releases:Release, sprints:Sprint, tasks:Task, team:Membership, follower:Follow]
	static belongsTo = [owner:User, master:User]

	def teamList() {
		return team.collect{it.user}
	}
	
	def followerList() {
		return follower.collect{it.user}
	}

	static mapping = {
		owner lazy:false
		master lazy:false
		twitter lazy:false
		team cascade:"all,delete-orphan"
		follower cascade:"all,delete-orphan"
	}
	
    static constraints = {
		name(nullable:false, blank:false, unique: true)
		owner(nullable:false)
		master(nullable:false)
		twitter(nullable:true)
    }
	
	static namedQueries = {
		projectsUserBelongsTo { fromUser, sortParam, orderParam, authenticateService ->
			if (!authenticateService.ifAnyGranted('ROLE_SUPERUSER')) {
				or {
					team {
						eq('user', fromUser)
					}
					follower {
						eq('user', fromUser)
					}
					eq('master', fromUser)
					eq('owner', fromUser)
				}
			}
			if (sortParam != 'sprints') {
				order(sortParam, orderParam)
			}
		}
		
		accessRight { fromProject, fromUser, authenticateService ->
			eq('id', fromProject.id)
			if (!authenticateService.ifAnyGranted('ROLE_SUPERUSER')) {
				or {
					team {
						eq('user', fromUser)
					}
					follower {
						eq('user', fromUser)
					}
					eq('master', fromUser)
					eq('owner', fromUser)
				}
			}
			projections {
				rowCount()
			}
		}
		
		changeRight { fromProject, fromUser, authenticateService ->
			eq('id', fromProject.id)
			if (!authenticateService.ifAnyGranted('ROLE_SUPERUSER')) {
				or {
					team {
						eq('user', fromUser)
					}
					eq('master', fromUser)
					eq('owner', fromUser)
				}
			}
			projections {
				rowCount()
			}
		}
	}
}
