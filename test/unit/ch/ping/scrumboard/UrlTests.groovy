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
		def correctUrl = new Url(url:null)
		assertFalse correctUrl.validate()
	}
	
    /**
     * Positive test HTTP
     */
    void testCorrectUrlHttp() {
    	def correctUrl = new Url(url:"http://www.puzzle.ch")
		assertTrue correctUrl.validate()
    }
	
	/**
	 * Negative test: Missing domain
	 */
	void testInCorrectUrlMissingDomain() {
		def incorrectUrl = new Url(url:"http://www.puzzle")
		assertFalse incorrectUrl.validate()
	}
	
	/**
	 * Positive test HTTPS
	 */
	void testCorrectUrlHttps() {
		def correctUrl = new Url(url:"https://www.puzzle.ch")
		assertTrue correctUrl.validate()
	}
	
	/**
	 * Negative test: Missing protocol
	 */
	void testInCorrectUrlMissingProtocol() {
		def incorrectUrl = new Url(url:"www.puzzle.ch")
		assertFalse incorrectUrl.validate()
	}
	
	/**
	 * Negative test: url with lot of whitespace
	 */
	void testInCorrectUrlWithWhitespace() {
		def incorrectUrl = new Url(url:"htt p:/ /ww w. puz z l e")
		assertFalse incorrectUrl.validate()
	}
}
