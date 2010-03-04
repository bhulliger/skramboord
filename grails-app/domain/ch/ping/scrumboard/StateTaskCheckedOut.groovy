package ch.ping.scrumboard

class StateTaskCheckedOut extends StateTask {
	String name = "Checked out"
	
	def open(Task task) {
		task.state = super.getStateOpen()
	}

	def done(Task task) {
		task.state = super.getStateDone()
	}
	
	def next(Task task) {
		task.state = super.getStateNext()
	}
	
	def standBy(Task task) {
		task.state = super.getStateStandBy()
	}
}
