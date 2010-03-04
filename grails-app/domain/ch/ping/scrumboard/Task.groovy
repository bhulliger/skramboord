package ch.ping.scrumboard

class Task {
	
	String name
	Double effort
	Url url
	StateTask state
	
	static constraints = {
		name(nullable:false)
		effort(nullable:false)
		url(nullable:true)
		state(nullable:false)
    }
}
