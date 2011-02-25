<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
    <head>
        <title><g:meta name="app.name"/></title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/themes/' + session.theme?.name + '/',file: session.theme?.css)}" ></link>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/themes/' + session.theme?.name + '/',file: 'theme.css')}" ></link>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css',file:'main.css')}" ></link>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/colorpicker',file:'colorpicker.css')}" ></link>
        
		<g:javascript library="jquery" plugin="jquery"/>
		<jqui:resources themeCss="css/themes/${session.theme?.name}/${session.theme?.css}"/>
		<script type="text/javascript" src="${resource(dir:'js/jquery/colorpicker',file:'colorpicker.js')}"></script>
        
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" ></link>
        
        <style type="text/css">
			body {
				background: #fff url('${request.contextPath}/images/skramboord/${session.theme?.background}') repeat-x;
				color: #333;
				font: 11px verdana, arial, helvetica, sans-serif;
				font-size: 62.5%;
				height: 100%;
				overflow-y: scroll;
			}
		</style>
        <g:layoutHead />
    </head>
    <body>
    	<div class="content">
	        <div id="spinner" class="spinner" style="display:none;">
	            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner"/>
	        </div>
	        <div id="grailsLogo" class="logo">
	        	<div style="float: left;">
	        		<g:if test="${session.logoUrl}">
	        			<a href="${session.logoUrl}" onclick="return ! window.open(this.href);">
	        				<g:if test="${session.logo}">
								<img src="${createLink(controller:'user', action:'showImage', id: session.logo.id)}" height="60"/>
							</g:if>
							<g:else>
			        			<img src="${resource(dir:'images/skramboord',file:'skramboord.logo.glossy.small.png')}" alt="Logo Skramboord" height="60"/>
			        		</g:else>
	        			</a>
	        		</g:if>
	        		<g:else>
		        		<g:link controller="project" action="list">
			        		<g:if test="${session.logo}">
								<img src="${createLink(controller:'user', action:'showImage', id: session.logo.id)}" height="60px"/>
							</g:if>
							<g:else>
			        			<img src="${resource(dir:'images/skramboord',file:'skramboord.logo.glossy.small.png')}" alt="Logo Skramboord" height="60px"/>
			        		</g:else>
		        		</g:link>
	        		</g:else>		        	
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