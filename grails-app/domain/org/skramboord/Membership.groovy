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

class Membership {
	Project project
	User user
	
	static Membership link(project, user) {
		def m = Membership.findByProjectAndUser(project, user)
		if (!m) {
			m = new Membership()
			project?.addToTeam(m)
			user?.addToProjects(m)
			m.save()
		} 
		return m
	}

	static void unlink(project, user) {
		def m = Membership.findByProjectAndUser(project, user)
		if (m) {
			project?.removeFromTeam(m)
			user?.removeFromProjects(m)
			m.delete()
		}
	}
}
