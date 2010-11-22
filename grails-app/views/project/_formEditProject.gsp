<script type="text/javascript">
	$(function() {
		$("#dialog-form-project-edit").dialog({
			autoOpen: true,
			height: 180,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formEditProject").submit();
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

<div id="dialog-form-project-edit" title="${message(code:'project.formNameEditProject')}" class="form">
	<g:form url="[ controller: 'project', action: 'update', params: [ fwdTo: fwdTo ]]" name='formEditProject'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td><label><g:message code="project.project"/></label></td>
					<td><input type="text" name="projectName" id="projectName" value="${flash.projectEdit.name}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="project.twitter.account"/></label></td>
					<td><input type="text" name="twitterAccount" id="twitterAccount" value="${flash.projectEdit.twitter?.account}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="project.twitter.password"/></label></td>
					<td><input type="password" name="twitterPassword" id="twitterPassword" value="${flash.projectEdit.twitter?.password}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
			</table>

			<input type="hidden" name="projectId" value="${flash.projectEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>