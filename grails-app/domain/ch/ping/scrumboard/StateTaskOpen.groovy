package ch.ping.scrumboard

class StateTaskOpen extends StateTask {
	String name = "Open"
		
    def checkOut(Task task) {
		task.state = super.getStateCheckedOut()
	}
	
	def next(Task task) {
		task.state = super.getStateNext()
	}
	
	def standBy(Task task) {
		task.state = super.getStateStandBy()
	}
}
