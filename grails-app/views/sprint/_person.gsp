<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
	<div class="postit-right">
</g:if>
<g:else>
	<div class="postit-right readonly">
</g:else>
	<div class="postit">
		<div style="margin-top: 15px; margin-left: 5px;">${person.userRealName}</div>
	</div>
</div>