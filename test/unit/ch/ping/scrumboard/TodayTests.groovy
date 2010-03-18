package ch.ping.scrumboard

import grails.test.*

class TodayTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    /**
     * Tests if getInstance() returns the correct date.
     */
    void testTodayInstance() {
    	// given
		Calendar calendar = Calendar.getInstance()
		Date today = Date.parse("dd.MM.yyyy", "${calendar.get(Calendar.DATE)}.${calendar.get(Calendar.MONTH)}.${calendar.get(Calendar.YEAR)}")

		// when
		
		// then
		assertEquals today, Today.getInstance()
    }
}
