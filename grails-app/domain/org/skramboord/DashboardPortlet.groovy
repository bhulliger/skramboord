package org.skramboord

class DashboardPortlet implements Comparable {
	static String PORTLET_TASKS = "tasks"
	static String PORTLET_SPRINTS = "sprints"
	static String PORTLET_PROJECTS = "projects"
	
	String name
	boolean enabled = true
	int portletsOrder
	static belongsTo = [owner:User]

    static constraints = {
		name(blank:false, unique: ['portletsOrder','owner'])
    }
	
   int compareTo(obj) {
		portletsOrder.compareTo(obj.portletsOrder)
   }
}
