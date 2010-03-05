package ch.ping.scrumboard

import java.awt.Color;
import grails.test.*

class PriorityTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
		
        mockForConstraintsTests(Priority)
    }

    protected void tearDown() {
        super.tearDown()
    }

    /**
     * Correct Priority
     */
    void testCorrectPriority() {
		// given
		Priority low = new Priority(name: "low", color: Color.GREEN)
		
		// when
		
		// then
		assertTrue low.validate()
    }
	
	/**
	 * Invalid priority with missing color
	 */
	void testPriorityWithMissingColor() {
		// given
		Priority low = new Priority(name: "low")
		
		// when
		
		// then
		assertFalse low.validate()
	}
	
	/**
	 * Invalid priority with missing name
	 */
	void testPriorityWithMissingName() {
		// given
		Priority low = new Priority(color: Color.GREEN)
		
		// when
		
		// then
		assertFalse low.validate()
	}
}
