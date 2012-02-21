<script type="text/javascript">
	$(function() {
		$("#dialog-import-form").dialog({
			autoOpen: false,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.import.label"/>': function() {
					document.getElementById("formImportTasks").submit();
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

<div id="dialog-import-form" title="${message(code:'task.formNameImportTasks')}" class="form">
	<g:form url="[ controller: controller, action: 'importCSV', params: [ fwdTo: fwdTo, target: target, project: flash.project.id, sprint: flash.sprint?.id ]]" name='formImportTasks' enctype="multipart/form-data" method="post">
		<fieldset>
			<input type="file" name="cvsFile" id="cvsFile" />
		</fieldset>
	</g:form>
</div>