<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER')}">
	<div class="postit-right" onmouseover="document.getElementById('persons_${person.id}').setAttribute('class', 'iconsTaskEdit')"
                              onmouseout="document.getElementById('persons_${person.id}').setAttribute('class', 'iconsTaskEditNone')">
</g:if>
<g:else>
	<div class="postit-right readonly">
</g:else>
	<div class="postit">
		<div id="persons_${person.id}" class="iconsTaskEditNone" style="margin-top: 15px; float: right;">
			<g:link controller="user" action="edit" params="[id: person.id, fwdTo: '/sprint/list']" style="padding-right: 10px;">
   				<span class="icon">
      				<img src="${resource(dir:'images/icons',file:'person.png')}" alt="profil"/>
      			</span>
   			</g:link>
		</div>
	
		<div style="margin-top: 15px; margin-left: 5px;">
			${person.userRealName}
		</div>
	</div>
</div>