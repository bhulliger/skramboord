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
		// given
		def correctEmail = new Email(email:null)
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
	
    /**
     * Test correct email address
     */
    void testCorrectEmail() {
		// given
		def correctEmail = new Email(email:"info@puzzle.ch")
		
		// when
		
		// then
		assertTrue correctEmail.validate()
    }
	
	/**
	 * Test incorrect email address: missing @
	 */
	void testIncorrectEmailMissingAt() {
		// given
		def correctEmail = new Email(email:"infopuzzle.ch")
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: missing domain
	 */
	void testIncorrectEmailMissingDomain() {
		// given
		def correctEmail = new Email(email:"info@puzzle")
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: missing name
	 */
	void testIncorrectEmailMissingName() {
		// given
		def correctEmail = new Email(email:"@puzzle")
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
	
	/**
	 * Test incorrect email address: address with whitespace
	 */
	void testIncorrectEmailWithWhitespace() {
		// given
		def correctEmail = new Email(email:"in fo@p u zzle")
		
		// when
		
		// then
		assertFalse correctEmail.validate()
	}
}
