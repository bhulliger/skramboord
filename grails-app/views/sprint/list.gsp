<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		<title>Skramboord</title>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="sprint" action="list" params="[project: session.project.id]">> ${session.project.name}</g:link></h1>
			<h3>Sprint List</h3>
			<table>
				<tr>
					<th>Sprint</th>
					<th>Goal</th>
					<th>Start</th>
					<th>End</th>
					<th>Number of Tasks</th>
				</tr>
				<g:each var="sprint" in="${session.sprintList}" status="i">
					<g:def var="sprintId" value="${sprint.id}"/>
					<tr>
						<td>
							<g:link controller="task" action="list" params="[sprint: sprintId]">${sprint.name}</g:link>
						</td>
						<td>${sprint.goal}</td>
						<td><g:formatDate format="dd.MM.yyyy" date="${sprint.startDate}"/></td>
						<td><g:formatDate format="dd.MM.yyyy" date="${sprint.endDate}"/></td>
						<td>${sprint.tasks.size()}</td>
					</tr>
				</g:each>
			</table>
		</div>
	</body>
</html>