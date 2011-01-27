<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
    <head>
        <title><g:meta name="app.name"/></title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/themes/skramboord',file:'jquery.ui.all.css')}" ></link>
         
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css',file:'main.css')}" ></link>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/colorpicker',file:'colorpicker.css')}" ></link>
        
		<g:javascript library="jquery" plugin="jquery"/>
		<jqui:resources themeCss="css/themes/skramboord/jquery.ui.all.css"/>
		<script type="text/javascript" src="${resource(dir:'js/jquery/colorpicker',file:'colorpicker.js')}"></script>
        
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" ></link>
        <g:layoutHead />
    </head>
    <body>
    	<div class="content">
	        <div id="spinner" class="spinner" style="display:none;">
	            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner"/>
	        </div>
	        <div id="grailsLogo" class="logo">
	        	<div style="float: left;">
		        	<a href="http://www.skramboord.org" onclick="return ! window.open(this.href);">
		        		<img src="${resource(dir:'images/skramboord',file:'skramboord.logo.glossy.small.png')}" alt="Logo Skramboord"/>
		        	</a>
	        	</div>
	        	<div style="float: right;">
	        		<sec:ifLoggedIn>
	        			<sec:ifAnyGranted roles="ROLE_SUPERUSER">
							<g:link controller="administration" action="list" style="padding-right: 10px;">
		        				<span class="icon">
			        				<img src="${resource(dir:'images/icons',file:'bullet_wrench.png')}" alt="profil"/>
			        			</span>
			        			<span class="icon"><g:message code="admin.systemPreferences"/></span>
		        			</g:link>
						</sec:ifAnyGranted>
	        			<g:link controller="user" action="edit" params="[id: session.user.id, fwdTo: request.getServletPath()]" style="padding-right: 10px;">
	        				<span class="icon">
		        				<img src="${resource(dir:'images/icons',file:'person.png')}" alt="profil"/>
		        			</span>
		        			<span class="icon"><g:message code="main.welcome"/>, ${session.user.userRealName}</span>
	        			</g:link>
	        		</sec:ifLoggedIn>
	        		
	        			<g:link controller="${params.controller}" action="${params.action}" params="[lang:'en']">
	        				<span class="icon">
		        				<img src="${resource(dir:'images/icons',file:'english.png')}" alt="english"/>
		        			</span>
	        			</g:link>
						<g:link controller="${params.controller}" action="${params.action}" params="[lang:'de']" style="padding-right: 10px;">
							<span class="icon">
		        				<img src="${resource(dir:'images/icons',file:'german.png')}" alt="german"/>
		        			</span>
						</g:link>
						
	        		<sec:ifLoggedIn>
		        		<g:link controller="logout" action="index">
		        			<span class="icon">
		        				<img src="${resource(dir:'images/icons',file:'application_go.png')}" alt="logout"/>
		        			</span>
		        			<span class="icon"><g:message code="main.logout"/></span>
		        		</g:link>
	        		</sec:ifLoggedIn>
	        	</div>
	        	<div style="clear: both;"/>
	        </div>
        </div>
       	<g:layoutBody />
		<g:if test="${flash.userEdit}">
			<g:render template="../user/formEditUser" model="['fwdTo': request.getServletPath()]"/>
		</g:if>
        <div style="margin-top: 10px; text-align: center;">
       		<a href="http://github.com/pablohess/skramboord" onclick="return ! window.open(this.href);">
        		<g:meta name="app.name"/>, Version <g:meta name="app.version"/>, built with Grails <g:meta name="app.grails.version"/>
        	</a>
	    </div>
    </body>
</html>