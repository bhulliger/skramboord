package ch.ping.scrumboard

import org.apache.commons.validator.EmailValidator;

class Email {
	String email
	
    static constraints = {
        email(nullable:false, email:true, blank:false)
    }
}
