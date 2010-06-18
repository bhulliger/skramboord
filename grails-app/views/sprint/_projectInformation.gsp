<h3><g:message code="project.informations"/></h3>
<g:if test="${flash.projectEdit}">
	<g:render template="../project/formEditProject" model="['fwdTo':'sprint']"/>
</g:if>
<table>
	<tr>
		<th><g:message code="project.project"/></th>
		<th><g:message code="project.owner"/></th>
		<th><g:message code="project.master"/></th>
		<th style="text-align:center;width: 50px;"><g:message code="sprint.sprints"/></th>
		<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner)}">
			<th style="width: 20px;"></th>
		</g:if>
	</tr>
	<tr>
		<td style="vertical-align: middle;"><b>${session.project.name}</b></td>
		<td style="vertical-align: middle;">${session.project.owner.userRealName}</td>
		<td style="vertical-align: middle;">${session.project.master.userRealName}</td>
		<td style="vertical-align: middle;text-align:center;">${session.project.sprints.size()}</td>
		<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner)}">
			<td>
				<g:link controller="project" action="edit" params="[project: session.project.id, fwdTo: 'sprint']"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="${message(code:'default.button.edit.label')}"/></span><span class="icon"></span></g:link>
			</td>
		</g:if>
	</tr>
</table>