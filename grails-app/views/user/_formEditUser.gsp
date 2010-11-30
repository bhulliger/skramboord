<script type="text/javascript">
	$(function() {
		$("#dialog-form-user-edit").dialog({
			autoOpen: true,
<sec:ifNotGranted roles="ROLE_SUPERUSER">
			height: 440,
</sec:ifNotGranted>
<sec:ifAnyGranted roles="ROLE_SUPERUSER">
			height: 500,
</sec:ifAnyGranted>
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formEditUser").submit();
					$(this).dialog('close');
				},
				'<g:message code="default.button.cancel.label"/>': function() {
					location.reload(true);
					$(this).dialog('close');
				}
			}
		});
	});
</script>

<div id="dialog-form-user-edit" title="${message(code:'user.editProfile')} - ${flash.userEdit.username}" class="form">
	<g:form url="[ controller: 'user', action: 'update', params: [ fwdTo: fwdTo ]]" name='formEditUser'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td align="right"><label><g:message code="user.name"/></label></td>
					<td><input type="text" name="userName" id="userName" value="${flash.userEdit.name}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.prename"/></label></td>
					<td><input type="text" name="userPrename" id="userPrename" value="${flash.userEdit.prename}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.password"/></label></td>
					<td><input type="password" type="text" name="userPassword" id="userPassword" value="${flash.userEdit.password}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.password2"/></label></td>
					<td><input type="password" type="text" name="userPassword2" id="userPassword2" value="${flash.userEdit.password}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.description"/></label></td>
					<td><input type="text" name="userDescription" id="userDescription" value="${flash.userEdit.description}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.email"/></label></td>
					<td><input type="text" name="userEmail" id="userEmail" value="${flash.userEdit.email}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<sec:ifAnyGranted roles="ROLE_SUPERUSER">
					<tr>
						<td><label><g:message code="admin.role"/></label></td>
						<td><g:select name="userRole" from="${flash.userRoles}" value="${flash.userRole.id}" optionValue="description" optionKey="id" /></td>
					</tr>
				</sec:ifAnyGranted>
			</table>

			<br>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td style="vertical-align: top; width: 100%;"><label><g:message code="task.taskColor"/></label></td>
					<td>
						<p id="colorpickerHolder"></p>
						<script type="text/javascript">
							$(function() {
								$('#colorpickerHolder').ColorPicker({
									flat: true,
									color: "${flash.userEdit.taskColor}",
									onSubmit: function(hsb, hex, rgb, el) {
										document.getElementById("taskColor").value = hex;
									},
									onChange: function (hsb, hex, rgb) {
										$('#colorSelector div').css('backgroundColor', '#' + hex);
									},
									onBeforeShow: function () {
										$(this).ColorPickerSetColor(this.value);
									}
								});
							});
						</script>
					</td>
				</tr>
			</table>

			
			<input type="hidden" maxlength="6" size="6" name="taskColor" id="taskColor" value="${flash.userEdit.taskColor}"/>
			<input type="hidden" name="userId" value="${flash.userEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>