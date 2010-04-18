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

package ch.ping.skramboord

import java.awt.Color;

class AdministrationController {
	
	def index = { redirect(controller:'administration', action:'list')
	}
	
	def list = {
		if (!params.sort) {
			params.sort = 'id'
			params.order = 'asc'
		}
		flash.priorities = Priority.withCriteria {
			order(params.sort, params.order)
		}
	}
	
	def savePriorities = {
		def priorities = Priority.list()
		
		try {
			for (Priority prio : priorities) {
				
				prio.color = Color.decode("0x" + params["priority_${prio.id}"])
				prio.save()
			}
		} catch (NumberFormatException e) {
			flash.message = "Only hexadacimal values are allowed."
		}
		
		redirect(controller:'administration', action:'list')
	}
}
