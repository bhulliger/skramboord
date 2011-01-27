package org.skramboord

class SystemPreferences {
	static String APPLICATION_NAME = "skramboord"
	String name
	TwitterAppSettings twitterSettings
	Theme theme

	static constraints = {
		name blank: false, unique: true
		twitterSettings nullable: true
		theme nullable: false
	}
	
	static namedQueries = {
		getPreferences { appName ->
			eq('name', appName)
		}
	}
}
