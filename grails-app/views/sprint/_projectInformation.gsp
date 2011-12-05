<g:if test="${flash.projectEdit}">
	<g:render template="../project/formEditProject" model="['fwdTo':'sprint']"/>
</g:if>
<table>
	<tr>
		<th><g:message code="project.project"/></th>
		<th><g:message code="project.owner"/></th>
		<th><g:message code="project.master"/></th>
		<th style="text-align:center;width: 50px;"><g:message code="sprint.sprints"/></th>
		<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner)}">
			<th style="width: 20px;"></th>
		</g:if>
	</tr>
	<tr>
		<td style="vertical-align: middle;"><b>${flash.project.name}</b></td>
		<td style="vertical-align: middle;">${flash.project.owner.userRealName}</td>
		<td style="vertical-align: middle;">${flash.project.master.userRealName}</td>
		<td style="vertical-align: middle;text-align:center;">${flash.project.sprints.size()}</td>
		<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner)}">
			<td>
				<g:link mapping="project" action="edit" params="[project: flash.project.id, fwdTo: 'sprint']"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="${message(code:'default.button.edit.label')}"/></span></g:link>
			</td>
		</g:if>
	</tr>
</table>