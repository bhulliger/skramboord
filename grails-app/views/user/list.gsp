<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
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
						<th style="width: 50px;"></th>
						<g:ifAnyGranted role="ROLE_SUPERUSER">
							<th style="width: 70px;"></th>
						</g:ifAnyGranted>
					</tr>
				</thead>
					<tbody>
						<g:each in="${personList}" status="i" var="person">
							<g:def var="userId" value="${person.id}"/>
							<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
								<td>
									<g:link controller="user" action="show" params="[id: userId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="show"/></span><span class="icon">${person.username?.encodeAsHTML()}</span></g:link>
								</td>
								<td style="vertical-align: middle;">${person.userRealName?.encodeAsHTML()}</td>
								<td style="vertical-align: middle;">${person.enabled?.encodeAsHTML()}</td>
								<td style="vertical-align: middle;">${person.description?.encodeAsHTML()}</td>
								<g:if test="${person.id == session.user.id}">
									<td>
										<g:link controller="user" action="edit" params="[id: userId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span><span class="icon">Edit</span></g:link>
									</td>
								</g:if>
								<g:else>
									<g:ifAnyGranted role="ROLE_ADMIN,ROLE_SUPERUSER">
										<td>
											<g:link controller="user" action="edit" params="[id: userId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span><span class="icon">Edit</span></g:link>
										</td>
									</g:ifAnyGranted>
									<g:ifNotGranted role="ROLE_ADMIN,ROLE_SUPERUSER">
										<td></td>
									</g:ifNotGranted>
								</g:else>
								<g:ifAnyGranted role="ROLE_SUPERUSER">
									<td>
										<g:link controller="user" action="delete" params="[id: userId]" onclick="return confirm('Are you sure?');"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="delete"/></span><span class="icon">Delete</span></g:link>
									</td>
								</g:ifAnyGranted>
							</tr>
						</g:each>
					</tbody>
				</table>
			</div>
		</div>
	</body>
</html>