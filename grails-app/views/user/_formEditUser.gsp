<script type="text/javascript">
	$(function() {
		$("#dialog-form-user-edit").dialog({
			autoOpen: true,
			height: 670,
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
			<label><g:message code="user.name"/></label>
			<input type="text" name="userName" id="userName" value="${flash.userEdit.name}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="user.prename"/></label>
			<input type="text" name="userPrename" id="userPrename" value="${flash.userEdit.prename}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="user.password"/></label>
			<input type="password" type="text" name="userPassword" id="userPassword" value="${flash.userEdit.password}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="user.password2"/></label>
			<input type="password" type="text" name="userPassword2" id="userPassword2" value="${flash.userEdit.password}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="user.description"/></label>
			<input type="text" name="userDescription" id="userDescription" value="${flash.userEdit.description}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="user.email"/></label>
			<input type="text" name="userEmail" id="userEmail" value="${flash.userEdit.email}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="task.taskColor"/></label>

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
			
			<input type="hidden" maxlength="6" size="6" name="taskColor" id="taskColor" value="${flash.userEdit.taskColor}"/>
			<input type="hidden" name="userId" value="${flash.userEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>