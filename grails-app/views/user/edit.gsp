<head>
	<meta name="layout" content="main" />
	<title>Edit User</title>
</head>

<body>
	<div class="body">
		<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="user" action="list">> User List</g:link> <g:link controller="user" action="edit" params="[id: person.id]">> ${person.username?.encodeAsHTML()}</g:link></h1>
		
		<g:ifAnyGranted role="ROLE_ADMIN,ROLE_SUPERUSER">
			<div class="nav">
				<span class="menuButton"><g:link class="create" action="create">New User</g:link></span>
			</div>
		</g:ifAnyGranted>
		<h3>Edit User</h3>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>
		<g:hasErrors bean="${person}">
		<div class="errors">
			<g:renderErrors bean="${person}" as="list" />
		</div>
		</g:hasErrors>
		<g:form>
			<fieldset style="border: none;">
				<input type="hidden" name="id" value="${person.id}" />
				<input type="hidden" name="version" value="${person.version}" />
				<div class="dialog">
					<table>
					<tbody>
	
						<tr class="prop">
							<td class="name"><label for="username">Login Name: *</label></td>
							<td class="value" ${hasErrors(bean:person,field:'username','errors')}">
								<input type="text" id="username" name="username" value="${person.username?.encodeAsHTML()}"/>
							</td>
						</tr>
	
						<tr class="prop">
							<td valign="top" class="name"><label for="prename">Frist Name: *</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'prename','errors')}">
								<input type="text" id="prename" name="prename" value="${person.prename?.encodeAsHTML()}"/>
							</td>
						</tr>
						
						<tr class="prop">
							<td valign="top" class="name"><label for="name">Name: *</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'name','errors')}">
								<input type="text" id="name" name="name" value="${person.name?.encodeAsHTML()}"/>
							</td>
						</tr>
	
						<tr class="prop">
							<td valign="top" class="name"><label for="passwd">Password: *</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'passwd','errors')}">
								<input type="password" id="passwd" name="passwd" value="${person.passwd?.encodeAsHTML()}"/>
							</td>
						</tr>
	
						<tr class="prop">
							<td valign="top" class="name"><label for="enabled">Enabled:</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'enabled','errors')}">
								<g:checkBox name="enabled" value="${person.enabled}"/>
							</td>
						</tr>
	
						<tr class="prop">
							<td valign="top" class="name"><label for="description">Description:</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'description','errors')}">
								<input type="text" id="description" name="description" value="${person.description?.encodeAsHTML()}"/>
							</td>
						</tr>
	
						<tr class="prop">
							<td valign="top" class="name"><label for="email">Email: *</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'email','errors')}">
								<input type="text" id="email" name="email" value="${person?.email?.encodeAsHTML()}"/>
							</td>
						</tr>
	
						<tr class="prop">
							<td valign="top" class="name"><label for="emailShow">Show Email:</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'emailShow','errors')}">
								<g:checkBox name="emailShow" value="${person.emailShow}"/>
							</td>
						</tr>
	
						<tr class="prop">
							<td valign="top" class="name"><label for="authorities">Roles:</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'authorities','errors')}">
								<ul>
								<g:each var="entry" in="${roleMap}">
									<li>${entry.key.authority.encodeAsHTML()}
										<g:ifAllGranted role="ROLE_SUPERUSER">
											<g:checkBox name="${entry.key.authority}" value="${entry.value}"/>
										</g:ifAllGranted>
										<g:ifNotGranted role="ROLE_SUPERUSER">
											<g:checkBox name="${entry.key.authority}" value="${entry.value}" disabled="true"/>
										</g:ifNotGranted>
									</li>
								</g:each>
								</ul>
							</td>
						</tr>
						
						<tr class="prop">
							<td class="name">* mandatory</td>
						</tr>
	
					</tbody>
					</table>
				</div>
	
				<div class="buttons">
					<span class="button"><g:actionSubmit class="save" value="Update" /></span>
					<g:ifAllGranted role="ROLE_SUPERUSER">
						<span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
					</g:ifAllGranted>
				</div>
			</fieldset>
		</g:form>

	</div>
</body>
