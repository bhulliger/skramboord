<head>
	<meta name="layout" content="main" />
	<title>Show User</title>
</head>

<body>
	<div class="body">
		<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="user" action="list">> User List</g:link> <g:link controller="user" action="show" params="[id: person.id]">> ${person.username?.encodeAsHTML()}</g:link></h1>
		
		<g:ifAnyGranted role="ROLE_ADMIN,ROLE_SUPERUSER">
			<div class="nav">
				<span class="menuButton"><g:link class="create" action="create">New User</g:link></span>
			</div>
		</g:ifAnyGranted>
		<h3>Show User</h3>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>
		<div class="dialog">
			<table>
			<tbody>
				<tr class="prop">
					<td valign="top" class="name">Login Name:</td>
					<td valign="top" class="value">${person.username?.encodeAsHTML()}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name">Full Name:</td>
					<td valign="top" class="value">${person.userRealName?.encodeAsHTML()}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name">Enabled:</td>
					<td valign="top" class="value">${person.enabled}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name">Description:</td>
					<td valign="top" class="value">${person.description?.encodeAsHTML()}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name">Email:</td>
					<td valign="top" class="value">${person.email?.encodeAsHTML()}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name">Show Email:</td>
					<td valign="top" class="value">${person.emailShow}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name">Roles:</td>
					<td valign="top" class="value">
						<ul>
						<g:each in="${roleNames}" var='name'>
							<li>${name}</li>
						</g:each>
						</ul>
					</td>
				</tr>

			</tbody>
			</table>
		</div>
		
		<g:form>
			<g:ifAnyGranted role="ROLE_ADMIN,ROLE_SUPERUSER">
				<input type="hidden" name="id" value="${person.id}"/>
				<div class="buttons">
					<span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
					<g:ifAnyGranted role="ROLE_SUPERUSER">
						<span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
					</g:ifAnyGranted>
				</div>
			</g:ifAnyGranted>
			<g:ifNotGranted role="ROLE_ADMIN,ROLE_SUPERUSER">
				<g:if test="${person.id == session.user.id}">
					<div class="buttons">
						<input type="hidden" name="id" value="${person.id}" />
						<span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
					</div>
				</g:if>
			</g:ifNotGranted>
		</g:form>
	</div>
</body>
