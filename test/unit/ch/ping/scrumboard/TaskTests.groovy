package ch.ping.scrumboard
import java.awt.Color;
import grails.test.*

class TaskTests extends GrailsUnitTestCase {
	Url urlPuzzle
	Priority immediate
	Priority normal
	StateTaskOpen taskStateOpen
	StateTaskCheckedOut taskStateChecked
	
    protected void setUp() {
        super.setUp()

        mockForConstraintsTests(Task)

        urlPuzzle = new Url(url:"http://www.puzzle.ch")
		immediate = new Priority(name: "immediate", color: Color.RED)
		normal = new Priority(name: "normal", color: Color.GREEN)
		taskStateOpen = new StateTaskOpen()
		taskStateChecked = new StateTaskCheckedOut()
    }

    protected void tearDown() {
        super.tearDown()
    }

    /**
     * Test with a correct task
     */
    void testCorrectTask() {
		// given
		Task task = new Task(name:"Mantis 2001", effort: 2.0, url: urlPuzzle, state: taskStateOpen, priority: normal)
		
		// when
		
		// then
		assertTrue task.validate()
    }
	
	/**
	 * Another test with a correct task
	 */
	void testAnotherCorrectTask() {
		// given
		Task task = new Task(name:"Mantis 3050", effort: 100.0, url: urlPuzzle, state: taskStateChecked, priority: immediate)
		
		// when
		
		// then
		assertTrue task.validate()
	}
	
	/**
	 * Task without url is still valid
	 */
	void testTaskWithoutUrl() {
		// given
		Task task = new Task(name:"Mantis 3050", effort: 1.0, state: taskStateChecked, priority: normal)
		
		// when
		
		// then
		assertTrue task.validate()
	}
	
	/**
	 * Each task needs his effort time
	 */
	void testTaskWithMissingEffort() {
		// given
		Task task = new Task(name:"Mantis 2001", url: urlPuzzle, state: taskStateChecked, priority: normal)
		
		// when
		
		// then
		assertFalse task.validate()
	}
	
	/**
	 * Task without name is invalid
	 */
	void testTaskWithMissingName() {
		// given
		Task task = new Task(effort: 2.0, url: urlPuzzle, state: taskStateChecked, priority: normal)
		
		// when
		
		// then
		assertFalse task.validate()
	}
	
	/**
	 * Task without priority
	 */
	void testTaskWithMissingPriority() {
		// given
		Task task = new Task(name:"Mantis 3050", effort: 100.0, url: urlPuzzle, state: taskStateChecked)
		
		// when
		
		// then
		assertFalse task.validate()
	}
	
	/**
	 * Test without task state
	 */
	void testTaskWithMissingState() {
		// given
		Task task = new Task(name:"Mantis 3050", effort: 100.0, url: urlPuzzle, priority: normal)
		
		// when
		
		// then
		assertFalse task.validate()
	}
}
