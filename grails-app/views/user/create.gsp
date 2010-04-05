<head>
	<meta name="layout" content="main" />
	<title>Create User</title>
</head>

<body>



	<div class="body">
		<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home" border="0"/> </g:link><g:link controller="user" action="list">> User List</g:link> <g:link controller="user" action="create">> Create User</g:link></h1>
	
		<g:ifAnyGranted role="ROLE_ADMIN,ROLE_SUPERUSER">
			<div class="nav">
				<span class="menuButton"><g:link class="create" action="create">New User</g:link></span>
			</div>
		</g:ifAnyGranted>
		<h3>Create User</h3>
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
						<td valign="top" class="name"><label for="username">Login Name:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'username','errors')}">
							<input type="text" id="username" name="username" value="${person.username?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="userRealName">Full Name:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'userRealName','errors')}">
							<input type="text" id="userRealName" name="userRealName" value="${person.userRealName?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="passwd">Password:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'passwd','errors')}">
							<input type="password" id="passwd" name="passwd" value="${person.passwd?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="enabled">Enabled:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'enabled','errors')}">
							<g:checkBox name="enabled" value="true" ></g:checkBox>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="description">Description:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'description','errors')}">
							<input type="text" id="description" name="description" value="${person.description?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="email">Email:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'email','errors')}">
							<input type="text" id="email" name="email" value="${person.email?.encodeAsHTML()}"/>
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><label for="emailShow">Show Email:</label></td>
						<td valign="top" class="value ${hasErrors(bean:person,field:'emailShow','errors')}">
							<g:checkBox name="emailShow" value="true"/>
						</td>
					</tr>

					<g:ifAllGranted role="ROLE_SUPERUSER">
						<tr class="prop">
							<td valign="top" class="name" align="left">Assign Roles:</td>
						</tr>
					
						<g:each in="${authorityList}">
							<tr>
								<td valign="top" class="name" align="left">${it.authority.encodeAsHTML()}</td>
								<td align="left"><g:checkBox name="${it.authority}"/></td>
							</tr>
						</g:each>
					</g:ifAllGranted>

				</tbody>
				</table>
			</div>

			<div class="buttons">
				<span class="button"><input class="save" type="submit" value="Create" /></span>
			</div>

		</g:form>

	</div>
</body>
