<head>
	<meta name="layout" content="main" />
	<title>Show User</title>
</head>

<body>
	<div class="body">
		<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="user" action="list">> <g:message code="admin.userList"/></g:link> <g:link controller="user" action="show" params="[id: flash.person.id]">> ${flash.person.username?.encodeAsHTML()}</g:link></h1>
		
		<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_SUPERUSER">
			<div class="nav">
				<span class="menuButton"><g:link class="create" action="create"><g:message code="admin.newUser"/></g:link></span>
			</div>
		</sec:ifAnyGranted>
		<h3><g:message code="user.profile"/></h3>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>
		<div class="dialog">
			<table>
			<tbody>
				<tr class="prop">
					<td valign="top" class="name"><g:message code="user.loginName"/>:</td>
					<td valign="top" class="value">${flash.person.username?.encodeAsHTML()}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name"><g:message code="user.prename"/>:</td>
					<td valign="top" class="value">${flash.person.prename?.encodeAsHTML()}</td>
				</tr>
				
				<tr class="prop">
					<td valign="top" class="name"><g:message code="user.name"/>:</td>
					<td valign="top" class="value">${flash.person.name?.encodeAsHTML()}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name"><g:message code="user.enabled"/>:</td>
					<td valign="top" class="value"><g:checkBox name="userEnabled" value="${flash.person.enabled}" disabled="true"/></td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name"><g:message code="user.description"/>:</td>
					<td valign="top" class="value">${flash.person.description?.encodeAsHTML()}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name"><g:message code="user.email"/>:</td>
					<td valign="top" class="value">${flash.person.email?.encodeAsHTML()}</td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name"><g:message code="user.showEmail"/>:</td>
					<td valign="top" class="value"><g:checkBox name="emailShow" value="${flash.person.emailShow}" disabled="true"/></td>
				</tr>
				
				<tr class="prop">
					<td valign="top" class="name"><g:message code="task.taskColor"/>:</td>
					<td valign="top" class="value"><span style="padding: 2px; border: 4px solid #${flash.person.taskColor};">${flash.person.taskColor}</span></td>
				</tr>

				<tr class="prop">
					<td valign="top" class="name"><g:message code="admin.roles"/>:</td>
					<td valign="top" class="value">
						<ul>
						<g:each in="${flash.roleNames}" var='name'>
							<li>${name}</li>
						</g:each>
						</ul>
					</td>
				</tr>

			</tbody>
			</table>
		</div>
		<g:form>
			<g:if test="${springSecurityService.ifAnyGranted('ROLE_SUPERUSER') || flash.person.id == session.user.id}">
				<div class="buttons">
					<input type="hidden" name="id" value="${flash.person.id}"/>
					<span class="button"><g:actionSubmit class="edit" value="${message(code:'default.button.edit.label')}" action="Edit"/></span>
					<sec:ifAnyGranted roles="ROLE_SUPERUSER">
						<span class="button"><g:actionSubmit class="delete" onclick="return confirm('${message(code:'default.button.delete.confirm.message')}');" value="${message(code:'default.button.delete.label')}" /></span>
					</sec:ifAnyGranted>
				</div>
			</g:if>
		</g:form>
	</div>
</body>
