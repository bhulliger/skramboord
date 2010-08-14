<head>
	<meta name="layout" content="main" />
	<title><g:message code="admin.newUser"/></title>
</head>

<body>



	<div class="body">
		<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="user" action="list">> <g:message code="admin.userList"/></g:link> <g:link controller="user" action="create">> <g:message code="admin.newUser"/></g:link></h1>
	
		<h3><g:message code="admin.newUser"/></h3>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>
		<g:hasErrors bean="${person}">
		<div class="errors">
			<g:renderErrors bean="${person}" as="list" />
		</div>
		</g:hasErrors>
		<g:form action="save">
			<div class="dialog">
				<table>
				<tbody>

					<tr class="prop">
						<td valign="top" class="name"><label for="username"><g:message code="user.loginName"/>: *</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'username','errors')}">
							<input type="text" id="username" name="username" value="${person.username?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="prename"><g:message code="user.prename"/>: *</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'prename','errors')}">
							<input type="text" id="prename" name="prename" value="${person.prename?.encodeAsHTML()}"/>
						</td>
					</tr>
					
					<tr class="prop">
						<td valign="top" class="name"><label for="name"><g:message code="user.name"/>: *</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'name','errors')}">
							<input type="text" id="name" name="name" value="${person.name?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="password"><g:message code="user.password"/>: *</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'password','errors')}">
							<input type="password" id="password" name="password" value="${person.password?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="enabled"><g:message code="user.enabled"/>:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'enabled','errors')}">
							<g:checkBox name="enabled" value="true" ></g:checkBox>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="description"><g:message code="user.description"/>:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'description','errors')}">
							<input type="text" id="description" name="description" value="${person.description?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="email"><g:message code="user.email"/>: *</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'email','errors')}">
							<input type="text" id="email" name="email" value="${person.email?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="emailShow"><g:message code="user.showEmail"/>:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'emailShow','errors')}">
							<g:checkBox name="emailShow" value="true"/>
						</td>
					</tr>

					<g:ifAllGranted role="ROLE_SUPERUSER">
						<tr class="prop">
							<td valign="top" class="name" align="left"><g:message code="admin.roles"/>:</td>
						</tr>
					
						<g:each in="${authorityList}">
							<tr>
								<td valign="top" class="name" align="left">${it.authority.encodeAsHTML()}</td>
								<td align="left"><g:checkBox name="${it.authority}"/></td>
							</tr>
						</g:each>
					</g:ifAllGranted>
					
					<tr class="prop">
						<td class="name">* <g:message code="user.mandatory"/></td>
					</tr>
				</tbody>
				</table>
			</div>

			<div class="buttons">
				<span class="button"><input class="save" type="submit" value="${message(code:'default.button.create.label')}" /></span>
			</div>

		</g:form>

	</div>
</body>
