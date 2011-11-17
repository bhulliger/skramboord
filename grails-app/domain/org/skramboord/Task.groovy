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

import java.util.Date;

class Task {	
	String name
	String description
	Double effort
	String url
	StateTask state
	Priority priority
	TaskType type
	Date finishedDate
	static belongsTo = [sprint:Sprint, project:Project, user:User]
	
	public void setUrl(String url) {
		this.url = url.replaceAll(" ", "")
	}
	
	static mapping = {
		priority lazy:false
		type lazy:false
		sprint lazy:false
	}
	                    
	static constraints = {
		name(nullable:false, blank:false)
		description(nullable:true)
		effort(nullable:false)
		url(url:true)
		state(nullable:false)
		priority(nullable:false)
		type(nullable:false)
		finishedDate(nullable:true)
		user(nullable:true)
		sprint(nullable:true)
		project(nullable:true)
    }
	
	static namedQueries = {
		fromSprint { fromSprint, taskState ->
			eq('state', taskState)
			eq('sprint', fromSprint)
			order('priority',"desc")
		}
		projectBacklog { fromProject ->
			eq('project', fromProject)
			order('priority',"desc")
		}
		projectBacklogWithPriority { fromProject, withPriority ->
			eq('project', fromProject)
			eq('priority', withPriority)
			order('name',"asc")
		}
		fromUser { fromUser ->
			eq('user', fromUser)
			eq('state', StateTask.getStateCheckedOut())
			order('priority',"desc")
			order('project',"asc")
			order('name',"asc")
		}
		effortTasksDone { fromSprint ->
			eq('state', StateTask.getStateDone())
			eq('sprint', fromSprint)
			projections {
				sum("effort")
			}
		}
		effortTasksTotal { fromSprint ->
			'in'('state', [StateTask.getStateOpen(), StateTask.getStateCheckedOut(), StateTask.getStateCodereview(), StateTask.getStateDone(), StateTask.getStateStandBy()])
			eq('sprint', fromSprint)
			projections {
				sum("effort")
			}
		}
		checkedOutTasksFromUserInProject { fromUser, fromProject ->
			eq('user', fromUser)
			eq('state', StateTask.getStateCheckedOut())
			sprint {
				release {
					eq('project', fromProject)
				}
			}
		}
	}
}
