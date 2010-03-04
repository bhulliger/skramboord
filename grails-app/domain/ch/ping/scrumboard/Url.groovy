package ch.ping.scrumboard

import org.codehaus.groovy.grails.validation.routines.UrlValidator;

class Url {
	String url
	
    static constraints = {
        url(nullable:false, url:true,blank:false)
    }
}
