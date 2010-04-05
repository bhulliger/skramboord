<head>
	<meta name="layout" content="main" />
	<title>User List</title>
</head>

<body>
	<div class="body">
		<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home" border="0"/> </g:link><g:link controller="user" action="list">> User List</g:link></h1>
		
		<g:ifAnyGranted role="ROLE_ADMIN,ROLE_SUPERUSER">
			<div class="nav">
				<span class="menuButton"><g:link class="create" action="create">New User</g:link></span>
			</div>
		</g:ifAnyGranted>
		<h3>User List</h3>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>
		<div class="list">
			<table>
			<thead>
				<tr>
					<g:sortableColumn property="username" title="Login Name" />
					<g:sortableColumn property="userRealName" title="Full Name" />
					<g:sortableColumn property="enabled" title="Enabled" />
					<g:sortableColumn property="description" title="Description" />
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
			<g:each in="${personList}" status="i" var="person">
				<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
					<td>${person.username?.encodeAsHTML()}</td>
					<td>${person.userRealName?.encodeAsHTML()}</td>
					<td>${person.enabled?.encodeAsHTML()}</td>
					<td>${person.description?.encodeAsHTML()}</td>
					<td class="actionButtons">
						<span class="actionButton">
							<g:link action="show" id="${person.id}">Show</g:link>
						</span>
					</td>
				</tr>
			</g:each>
			</tbody>
			</table>
		</div>
	</div>
</body>
