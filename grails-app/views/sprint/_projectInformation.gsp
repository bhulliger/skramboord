<h3>Project informations</h3>
<table>
	<tr>
		<th>Project</th>
		<th>Project Owner</th>
		<th>Project Master</th>
		<th style="text-align:center;width: 50px;">Sprints</th>
	</tr>
	<tr>
		<td><b>${session.project.name}</b></td>
		<td>${session.project.owner.userRealName}</td>
		<td>${session.project.master.userRealName}</td>
		<td style="text-align:center;">${session.project.sprints.size()}</td>
	</tr>
</table>