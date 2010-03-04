package ch.ping.scrumboard

import grails.test.*

class EmailTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
        mockForConstraintsTests(Email)
    }

    protected void tearDown() {
        super.tearDown()
    }
	
	/**
	 * Test null as email address
	 */
	void testNullAsEmail() {
		def correctEmail = new Email(email:null)
		assertFalse correctEmail.validate()
	}
	
    /**
     * Test correct email address
     */
    void testCorrectEmail() {
		def correctEmail = new Email(email:"info@puzzle.ch")
		assertTrue correctEmail.validate()
    }
	
	/**
	 * Test incorrect email address: missing @
	 */
	void testIncorrectEmailMissingAt() {
		def correctEmail = new Email(email:"infopuzzle.ch")
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: missing domain
	 */
	void testIncorrectEmailMissingDomain() {
		def correctEmail = new Email(email:"info@puzzle")
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: missing name
	 */
	void testIncorrectEmailMissingName() {
		def correctEmail = new Email(email:"@puzzle")
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: address with whitespace
	 */
	void testIncorrectEmailWithWhitespace() {
		def correctEmail = new Email(email:"in fo@p u zzle")
		assertFalse correctEmail.validate()
	}
}
