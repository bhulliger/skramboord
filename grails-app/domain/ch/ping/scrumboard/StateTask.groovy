package ch.ping.scrumboard

class StateTask {
	String name = "Abstract state"
	
	protected StateTask() {}
	
	def checkOut(Task task) {
		// do nothing
	}
	
	def open(Task task) {
		// do nothing
	}
	
	def done(Task task) {
		// do nothing
	}
	
	def next(Task task) {
		// do nothing
	}
	
	def standBy(Task task) {
		// do nothing
	}
	
	static StateTaskOpen getStateOpen() {
		return StateTaskOpen.withCriteria(uniqueResult:true) {
		}
	}
	
	static StateTaskCheckedOut getStateCheckedOut() {
		return StateTaskCheckedOut.withCriteria(uniqueResult:true) {
		}
	}
	
	static StateTaskDone getStateDone() {
		return StateTaskDone.withCriteria(uniqueResult:true) {
		}
	}
	
	static StateTaskNext getStateNext() {
		return StateTaskNext.withCriteria(uniqueResult:true) {
		}
	}
	
	static StateTaskStandBy getStateStandBy() {
		return StateTaskStandBy.withCriteria(uniqueResult:true) {
		}
	}
}
