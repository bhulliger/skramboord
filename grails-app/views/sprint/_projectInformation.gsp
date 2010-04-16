<h3>Project informations</h3>
<g:if test="${flash.projectEdit}">
	<g:render template="../project/formEditProject" model="['fwdTo':'sprint']"/>
</g:if>
<table>
	<tr>
		<th>Project</th>
		<th>Project Owner</th>
		<th>Project Master</th>
		<th style="text-align:center;width: 50px;">Sprints</th>
		<th style="width: 50px;"></th>
	</tr>
	<tr>
		<td style="vertical-align: middle;"><b>${session.project.name}</b></td>
		<td style="vertical-align: middle;">${session.project.owner.userRealName}</td>
		<td style="vertical-align: middle;">${session.project.master.userRealName}</td>
		<td style="vertical-align: middle;text-align:center;">${session.project.sprints.size()}</td>
		<td>
			<g:link controller="project" action="edit" params="[project: session.project.id, fwdTo: 'sprint']"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span><span class="icon">Edit</span></g:link>
		</td>
	</tr>
</table>