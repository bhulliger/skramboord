<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
    <head>
        <title><g:meta name="app.name"/></title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/themes/skramboord',file:'jquery.ui.all.css')}" ></link>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css',file:'main.css')}" ></link>
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" ></link>
        <g:layoutHead />
    </head>
    <body>
    	<div id="content">
	        <div id="spinner" class="spinner" style="display:none;">
	            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner"/>
	        </div>
	        <div id="grailsLogo" class="logo">
	        	<div style="float: left;">
		        	<a href="http://github.com/pablohess/skramboord" onclick="return ! window.open(this.href);">
		        		<img src="${resource(dir:'images/skramboord',file:'skramboord.logo.glossy.small.png')}" alt="Logo Skramboord"/>
		        	</a>
	        	</div>
	        	<div style="float: right;">
	        		<g:isLoggedIn>
	        			<g:link controller="user" action="show" params="[id: session.user.id]" style="padding-right: 10px;">
	        				<span class="icon">
		        				<img src="${resource(dir:'images/icons',file:'person.png')}" alt="profil"/>
		        			</span>
		        			<span class="icon">Welcome, ${session.user.userRealName}</span>
	        			</g:link>
		        		<g:link controller="logout" action="index">
		        			<span class="icon">
		        				<img src="${resource(dir:'images/icons',file:'application_go.png')}" alt="logout"/>
		        			</span>
		        			<span class="icon">Logout</span>
		        		</g:link>
	        		</g:isLoggedIn>
	        	</div>
	        	<div style="clear: both;"/>
	        </div>
        	<g:layoutBody />
        </div>
        <div style="margin-top: 10px; text-align: center;">
       		<a href="http://github.com/pablohess/skramboord" onclick="return ! window.open(this.href);">
        		<g:meta name="app.name"/>, Version <g:meta name="app.version"/>, built with Grails <g:meta name="app.grails.version"/>
        	</a>
	    </div>
    </body>
</html>