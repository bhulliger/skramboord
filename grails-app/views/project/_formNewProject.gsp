<script type="text/javascript">
	$(function() {
		$("#dialog-form-project").dialog({
			autoOpen: false,
			height: 250,
			width: 500,
			modal: true,
			buttons: {
				'Save': function() {
					document.getElementById("formNewProject").submit();
					$(this).dialog('close');
				},
				Cancel: function() {
					location.reload(true);
					$(this).dialog('close');
				}
			}
		});
	});
</script>

<div id="dialog-form-project" title="Create new project">
	<g:form action='addProject' name='formNewProject'>
		<fieldset>
			<label>Project</label>
			<input type="text" name="projectName" id="projectName" class="text ui-widget-content ui-corner-all"/>
			<label>Project Master</label>
			<g:select name="projectMaster" from="${flash.allUsers}" value="${session.user.id}" optionValue="userRealName" optionKey="id" />
		</fieldset>
	</g:form>
</div>
<g:submitButton name="create-project" value="Create project"/>