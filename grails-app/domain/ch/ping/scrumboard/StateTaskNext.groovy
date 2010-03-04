package ch.ping.scrumboard

class StateTaskNext extends StateTask {
	String name = "Next"
	
	def open(Task task) {
		task.state = super.getStateOpen()
	}
}
