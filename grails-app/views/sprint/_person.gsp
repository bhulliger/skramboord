<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER')}">
	<div class="postit-yellow-right" onmouseover="changeClass('persons_${person.id}', 'iconsTaskEdit');"
	                              	onmouseout="changeClass('persons_${person.id}', 'iconsTaskEditNone');">
</g:if>
<g:else>
	<div class="postit-yellow-right readonly">
</g:else>
	<div class="postit-yellow">
		<div id="persons_${person.id}" class="iconsTaskEditNone" style="margin-top: 15px; float: right; width: 20px;">
			<div class="buttons">
				<span class="button" style="float: right;">
				<g:def var="fwdTo" value="/project/${flash.project.id}/sprint/list"/>
				<g:link controller="user" action="edit" params="[id: person.id, fwdTo: fwdTo]" style="padding-right: 10px;">
	   				<span class="icon">
	      				<img src="${resource(dir:'images/icons',file:'person.png')}" alt="profil"/>
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