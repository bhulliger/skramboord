package org.skramboord

class TwitterAppSettings {
	boolean enabled = true
	String consumerKey
	String consumerSecret

    static constraints = {
		consumerKey blank: false
		consumerSecret blank: false
    }
}
