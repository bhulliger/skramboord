import ch.ping.scrumboard.StateTaskCheckedOut;
import ch.ping.scrumboard.StateTaskDone;
import ch.ping.scrumboard.StateTaskNext;
import ch.ping.scrumboard.StateTaskOpen;
import ch.ping.scrumboard.StateTaskStandBy;
import ch.ping.scrumboard.Task;
import ch.ping.scrumboard.Url;

class BootStrap {

     def init = { servletContext ->
		// Create some test data
		Url urlPuzzle = new Url(url:"http://www.puzzle.ch")
		urlPuzzle.save()

		StateTaskOpen taskStateOpen = new StateTaskOpen()
		taskStateOpen.save()
		StateTaskCheckedOut taskStateChecked = new StateTaskCheckedOut()
		taskStateChecked.save()
		StateTaskDone taskStateDone = new StateTaskDone()
		taskStateDone.save()
		StateTaskNext taskStateNext = new StateTaskNext()
		taskStateNext.save()
		StateTaskStandBy taskStateStandBy = new StateTaskStandBy()
		taskStateStandBy.save()

		new Task(name:"Mantis 2001", effort: 2, url: urlPuzzle, state: taskStateOpen).save()
		new Task(name:"Mantis 2015", effort: 3.5, url: urlPuzzle, state: taskStateOpen).save()
		new Task(name:"Mantis 1999", effort: 1.0, url: urlPuzzle, state: taskStateChecked).save()
     }
     def destroy = {
     }
} 