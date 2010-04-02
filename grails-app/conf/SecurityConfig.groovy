security {

	// see DefaultSecurityConfig.groovy for all settable/overridable properties

	active = true

	loginUserDomainClass = "User"
	authorityDomainClass = "Role"
	
	useRequestMapDomainClass = false

	requestMapString = '''
	        CONVERT_URL_TO_LOWERCASE_BEFORE_COMPARISON
	        PATTERN_TYPE_APACHE_ANT
			/=IS_AUTHENTICATED_FULLY
			/login/auth=IS_AUTHENTICATED_ANONYMOUSLY
			/js/**=IS_AUTHENTICATED_ANONYMOUSLY
			/css/**=IS_AUTHENTICATED_ANONYMOUSLY
			/images/**=IS_AUTHENTICATED_ANONYMOUSLY
			/plugins/**=IS_AUTHENTICATED_ANONYMOUSLY
			/captcha/**=IS_AUTHENTICATED_ANONYMOUSLY
			/register/**=IS_AUTHENTICATED_ANONYMOUSLY
			/**=IS_AUTHENTICATED_FULLY
		  	'''
}
