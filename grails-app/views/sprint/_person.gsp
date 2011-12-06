<div class="postit-yellow-right" onmouseover="changeClass('persons_${person.id}', 'iconsTaskEdit');"
	                              onmouseout="changeClass('persons_${person.id}', 'iconsTaskEditNone');">
	<div class="postit-yellow">
		<% Integer width = 45; %>
		<g:if test="${!org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER')}">
			<% width = width - 20; %>
		</g:if>
		<div id="persons_${person.id}" class="iconsTaskEditNone" style="margin-top: 15px; width: <%= width %>px;">
			<div class="buttons">
				<span class="button" style="float: right;">
					<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER')}">
						<g:def var="fwdTo" value="/project/${flash.project.id}/sprint/list"/>
						<g:link controller="user" action="edit" params="[id: person.id, fwdTo: fwdTo]">
			   				<span class="icon">
			      				<img src="${resource(dir:'images/icons',file:'person.png')}" alt="profil"/>
			      			</span>
			   			</g:link>
		   			</g:if>
		   			<g:link url="mailto:${person.email}" style="padding-right: 2px;">
		   				<span class="icon">
		      				<img src="${resource(dir:'images/icons',file:'email.png')}" alt="profil"/>
		      			</span>
		   			</g:link>
	   			</span>
	   		</div>
		</div>
	
		<div style="margin-top: 15px; margin-left: 5px;">
			${person.userRealName}
		</div>
	</div>
</div>