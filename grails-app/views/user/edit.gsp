<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta name="layout" content="main" />
</head>

<body>
	<div class="body">
		<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="user" action="list">> <g:message code="admin.userList"/></g:link> <g:link controller="user" action="edit" params="[id: person.id]">> ${person.username?.encodeAsHTML()}</g:link></h1>
		
		<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_SUPERUSER">
			<div class="nav">
				<span class="menuButton"><g:link class="create" action="create"><g:message code="admin.newUser"/></g:link></span>
			</div>
		</sec:ifAnyGranted>
		<h3><g:message code="user.editProfile"/></h3>
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
							<td class="name"><label for="username"><g:message code="user.loginName"/>: *</label></td>
							<td class="value ${hasErrors(bean:person,field:'username','errors')}">
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
								<g:checkBox name="enabled" value="${person.enabled}"/>
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
								<input type="text" id="email" name="email" value="${person?.email?.encodeAsHTML()}"/>
							</td>
						</tr>
	
						<tr class="prop">
							<td valign="top" class="name"><label for="emailShow"><g:message code="user.showEmail"/>:</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'emailShow','errors')}">
								<g:checkBox name="emailShow" value="${person.emailShow}"/>
							</td>
						</tr>
						
						<tr class="prop">
							<td valign="top" class="name"><label for="emailShow"><g:message code="task.taskColor"/>:</label></td>
							<td valign="top" class="value ${hasErrors(bean:person,field:'color','errors')}">
								<span id="spanTaskColor" style="padding: 6px; background: #${person.taskColor};">
									<input type="text" maxlength="6" size="6" name="taskColor" id="colorpickerTaskColor" value="${person.taskColor}"/>
								</span>
								<script type="text/javascript">
									$(function() {
										$('#colorpickerTaskColor').ColorPicker({
											onSubmit: function(hsb, hex, rgb, el) {
												$(el).val(hex);
												$(el).ColorPickerHide();
												document.getElementById("spanTaskColor").style.backgroundColor = '#' + hex;
											},
											onBeforeShow: function () {
												$(this).ColorPickerSetColor(this.value);
											}
										})
										.bind('keyup', function(){
											$(this).ColorPickerSetColor(this.value);
										});
									});
								</script>
							</td>
							<td valign="top" class="value"></td>
						</tr>
						
						<tr class="prop">
							<td valign="top" class="name"><g:message code="admin.roles"/>:</td>
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
							<td class="name">* <g:message code="user.mandatory"/></td>
						</tr>
	
					</tbody>
					</table>
				</div>
	
				<div class="buttons">
					<span class="button"><g:actionSubmit class="save" value="${message(code:'default.button.save.label')}" /></span>
					<g:ifAllGranted role="ROLE_SUPERUSER">
						<span class="button"><g:actionSubmit class="delete" onclick="return confirm('${message(code:'default.button.delete.confirm.message')}');" value="${message(code:'default.button.delete.label')}" /></span>
					</g:ifAllGranted>
				</div>
			</fieldset>
		</g:form>

	</div>
</body>
