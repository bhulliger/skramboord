package ch.ping.scrumboard

import grails.test.*

class UrlTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
		mockForConstraintsTests(Url)
    }

    protected void tearDown() {
        super.tearDown()
    }
	
	/**
	 * Url can't be null
	 */
	void testNullAsUrl() {
		// given
		def correctUrl = new Url(url:null)
		
		// when
		
		// then
		assertFalse correctUrl.validate()
	}
	
    /**
     * Positive test HTTP
     */
    void testCorrectUrlHttp() {
		// given
    	def correctUrl = new Url(url:"http://www.puzzle.ch")
		
		// when
		
		// then
		assertTrue correctUrl.validate()
    }
	
	/**
	 * Negative test: Missing domain
	 */
	void testInCorrectUrlMissingDomain() {
		// given
		def incorrectUrl = new Url(url:"http://www.puzzle")
		
		// when
		
		// then
		assertFalse incorrectUrl.validate()
	}
	
	/**
	 * Positive test HTTPS
	 */
	void testCorrectUrlHttps() {
		// given
		def correctUrl = new Url(url:"https://www.puzzle.ch")
		
		// when
		
		// then
		assertTrue correctUrl.validate()
	}
	
	/**
	 * Negative test: Missing protocol
	 */
	void testInCorrectUrlMissingProtocol() {
		// given
		def incorrectUrl = new Url(url:"www.puzzle.ch")
		
		// when
		
		// then
		assertFalse incorrectUrl.validate()
	}
	
	/**
	 * Negative test: url with lot of whitespace
	 */
	void testInCorrectUrlWithWhitespace() {
		// given
		def incorrectUrl = new Url(url:"htt p:/ /ww w. puz z l e")
		
		// when
		
		// then
		assertFalse incorrectUrl.validate()
	}
}
