<script type="text/javascript">
	$(function() {
		$("#dialog-form-project").dialog({
			autoOpen: false,
			height: 160,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formNewProject").submit();
					$(this).dialog('close');
				},
				'<g:message code="default.button.cancel.label"/>': function() {
					location.reload(true);
					$(this).dialog('close');
				}
			}
		});
	});

	function openFormNewProject(){
		$('#dialog-form-project').dialog('open');
		return true;
	}
</script>

<div id="dialog-form-project" title="${message(code:'project.formNameCreateProject')}" class="form">
	<g:form action='addProject' name='formNewProject'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td><label><g:message code="project.project"/></label></td>
					<td><input type="text" name="projectName" id="projectName" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="project.master"/></label></td>
					<td><g:select name="projectMaster" from="${flash.allUsers}" value="${session.user.id}" optionValue="userRealName" optionKey="id" /></td>
				</tr>
			</table>
		</fieldset>
	</g:form>
</div>