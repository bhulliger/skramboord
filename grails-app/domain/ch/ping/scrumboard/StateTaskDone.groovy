package ch.ping.scrumboard

class StateTaskDone extends StateTask {
	String name = "Done"
	
	def checkOut(Task task) {
		task.state = super.getStateCheckedOut()
	}
	
	def open(Task task) {
		task.state = super.getStateOpen()
	}
}
