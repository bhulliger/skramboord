<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
	</head>
	
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home" border="0"/> </g:link><g:link controller="user" action="list">> <g:message code="admin.userList"/></g:link></h1>
			
			<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_SUPERUSER">
				<div class="nav">
					<span class="menuButton"><g:link class="create" action="create"><g:message code="admin.newUser"/></g:link></span>
				</div>
			</sec:ifAnyGranted>
			<h3><g:message code="admin.userList"/></h3>
			<g:if test="${flash.message}">
			<div class="message">${flash.message}</div>
			</g:if>
			<div class="list">
				<table>
					<thead>
						<tr>
							<g:sortableColumn property="username" title="${message(code:'user.loginName')}"/>
							<g:sortableColumn property="userRealName" title="${message(code:'user.fullName')}" />
							<g:sortableColumn property="enabled" title="${message(code:'user.enabled')}" />
							<g:sortableColumn property="description" title="${message(code:'user.description')}" />
							<th style="width: 20px;"></th>
							<sec:ifAnyGranted roles="ROLE_SUPERUSER">
								<th style="width: 20px;"></th>
							</sec:ifAnyGranted>
						</tr>
					</thead>
					<tbody>
						<g:each in="${flash.personList}" status="i" var="person">
							<g:def var="userId" value="${person.id}"/>
							<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
								<td>
									<g:link controller="user" action="show" params="[id: userId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="show"/></span><span class="icon">${person.username?.encodeAsHTML()}</span></g:link>
								</td>
								<td style="vertical-align: middle;">${person.userRealName?.encodeAsHTML()}</td>
								<td style="vertical-align: middle;">${person.enabled?.encodeAsHTML()}</td>
								<td style="vertical-align: middle;">${person.description?.encodeAsHTML()}</td>
								<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || person.id == session.user.id}">
									<td>
										<g:link controller="user" action="edit" params="[id: userId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span><span class="icon"></span></g:link>
									</td>
								</g:if>
								<g:else>
									<td></td>
								</g:else>
								<sec:ifAnyGranted roles="ROLE_SUPERUSER">
									<td>
										<g:link controller="user" action="delete" params="[id: userId]" onclick="return confirm('${message(code:'default.button.delete.confirm.message')}');"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="delete"/></span><span class="icon"></span></g:link>
									</td>
								</sec:ifAnyGranted>
							</tr>
						</g:each>
					</tbody>
				</table>
			</div>
		</div>
	</body>
</html>