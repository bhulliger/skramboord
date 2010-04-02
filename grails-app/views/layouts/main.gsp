<html>
    <head>
        <title><g:layoutTitle default="Skramboord" /></title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/themes/skramboord',file:'jquery.ui.all.css')}" >
        <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
        <g:layoutHead />
    </head>
    <body>
    	<div id="content">
	        <div id="spinner" class="spinner" style="display:none;">
	            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner"/>
	        </div>
	        <div id="grailsLogo" class="logo">
	        	<div style="float: left;">
		        	<a href="http://github.com/pablohess/skramboord" target="_blank">
		        		<img src="${resource(dir:'images/skramboord',file:'skramboord.logo.glossy.small.png')}" border="0" alt="Logo Skramboord"/>
		        	</a>
	        	</div>
	        	<div style="float: right;">
	        		<g:if test="${!(flash.loggedIn==false)}">
		        		<g:link controller="logout" action="index">
		        			<span id="icon">
		        				<img src="${resource(dir:'images/icons',file:'application_go.png')}" alt="logout" border="0"/>
		        			</span>
		        			<span id="icon">Logout</span>
		        		</g:link>
	        		</g:if>
	        	</div>
	        	<div style="clear: both;"/>
	        </div>
        	<g:layoutBody />
        </div>
        <div style="margin-top: 10px; text-align: center;">
       		<a href="http://github.com/pablohess/skramboord" target="_blank">
        		<g:meta name="app.name"/>, Version <g:meta name="app.version"/>, built with Grails <g:meta name="app.grails.version"/>
        	</a>
	    </div>
    </body>
</html>