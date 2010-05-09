package org.skramboord

class DashboardPortlet implements Comparable {
	String name
	boolean enabled = true
	int portletsOrder
	static belongsTo = [owner:User]

    static constraints = {
		name(blank:false, unique: ['portletsOrder'])
    }
	
   int compareTo(obj) {
		portletsOrder.compareTo(obj.portletsOrder)
   }
}
