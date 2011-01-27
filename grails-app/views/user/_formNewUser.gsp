<script type="text/javascript">
	$(function() {
		$("#dialog-form-user").dialog({
			autoOpen: false,
<sec:ifNotGranted roles="ROLE_SUPERUSER">
			height: 440,
</sec:ifNotGranted>
<sec:ifAnyGranted roles="ROLE_SUPERUSER">
			height: 520,
</sec:ifAnyGranted>
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formNewUser").submit();
					$(this).dialog('close');
				},
				'<g:message code="default.button.cancel.label"/>': function() {
					location.reload(true);
					$(this).dialog('close');
				}
			}
		});
	});

	function openFormNewUser(){
		$('#dialog-form-user').dialog('open');
		return true;
	}
</script>

<div id="dialog-form-user" title="${message(code:'user.createUser')}" class="form">
	<g:form url="[ controller: 'user', action: 'save', params: [ fwdTo: fwdTo ]]" name='formNewUser'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td align="right"><label><g:message code="user.loginName"/></label></td>
					<td><input type="text" name="userLoginName" id="userLoginName" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td align="right"><label><g:message code="user.name"/></label></td>
					<td><input type="text" name="userName" id="userName" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.prename"/></label></td>
					<td><input type="text" name="userPrename" id="userPrename" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.password"/></label></td>
					<td><input type="password" type="text" name="userPassword" id="userPassword" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.password2"/></label></td>
					<td><input type="password" type="text" name="userPassword2" id="userPassword2" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.description"/></label></td>
					<td><input type="text" name="userDescription" id="userDescription" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="user.email"/></label></td>
					<td><input type="text" name="userEmail" id="userEmail" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<sec:ifAnyGranted roles="ROLE_SUPERUSER">
					<tr>
						<td><label><g:message code="admin.role"/></label></td>
						<td><g:select name="userRole" from="${flash.userRoles}" value="${flash.userRoleDefault.id}" optionValue="description" optionKey="id" /></td>
					</tr>
				</sec:ifAnyGranted>
			</table>

			<br>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td style="vertical-align: top; width: 100%;"><label><g:message code="task.taskColor"/></label></td>
					<td>
						<p id="colorpickerHolderNewUser"></p>
						<script type="text/javascript">
							$(function() {
								$('#colorpickerHolderNewUser').ColorPicker({
									flat: true,
									color: "009700",
									onSubmit: function(hsb, hex, rgb, el) {
										document.getElementById("taskColorNewUser").value = hex;
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
			
			<input type="hidden" maxlength="6" size="6" name="taskColorNewUser" id="taskColorNewUser" value="009700"/>
		</fieldset>
	</g:form>
</div>