<script type="text/javascript">
	$(function() {
		$("#dialog-form-project").dialog({
			autoOpen: false,
			height: 250,
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
</script>

<div id="dialog-form-project" title="${message(code:'project.formNameCreateProject')}" class="form">
	<g:form action='addProject' name='formNewProject'>
		<fieldset>
			<label><g:message code="project.project"/></label>
			<input type="text" name="projectName" id="projectName" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="project.master"/></label>
			<g:select name="projectMaster" from="${flash.allUsers}" value="${session.user.id}" optionValue="userRealName" optionKey="id" />
		</fieldset>
	</g:form>
</div>