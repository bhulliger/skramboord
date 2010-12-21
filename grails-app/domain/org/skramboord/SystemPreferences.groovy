package org.skramboord

class SystemPreferences {
	static String APPLICATION_NAME = "skramboord"
	String name
	TwitterAppSettings twitterSettings

	static constraints = {
		name blank: false, unique: true
		twitterSettings nullable: true
	}
	
	static namedQueries = {
		getPreferences { appName ->
			eq('name', appName)
		}
	}
}
