package ch.ping.scrumboard

class StateTaskStandBy extends StateTask {
	String name = "Stand By"
	
	def checkOut(Task task) {
		task.state = super.getStateCheckedOut()
	}
	
	def open(Task task) {
		task.state = super.getStateOpen()
	}
	
	def next(Task task) {
		task.state = super.getStateNext()
	}
}
