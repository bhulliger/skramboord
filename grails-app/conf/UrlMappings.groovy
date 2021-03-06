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

class UrlMappings {
    static mappings = {
	  "/$controller/$action?/$id?"{ constraints {
		  // apply constraints here
	  }}
	  "/index.gsp"(controller:"project", action:"list")
	  "/"(controller:"project", action:"list")
	  "500"(view:'/error')
		
	  name administration: "/administration/$action?/" {
		  controller = 'administration'
	  }
	  
      name project: "/project/$action?/" {
          controller = 'project'
      }
	  
	  name sprint: "/project/$project/sprint/$action?/" {
		  controller = 'sprint'
	  }
	  
	  name release: "/project/$project/release/$action?/" {
		  controller = 'release'
	  }
	  
	  name task: "/project/$project/sprint/$sprint/task/$action?/" {
		  controller = 'task'
	  }
	}
}
