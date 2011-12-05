<script type="text/javascript">
	$(function() {
		$("#dialog-form-project-edit").dialog({
			autoOpen: true,
			height: 200,
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
	<g:form url="${createLink(mapping: 'project', action: 'update', params: [project: flash.project ? flash.project?.id : 0, fwdTo: fwdTo])}" name='formEditProject'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td><label><g:message code="project.project"/></label></td>
					<td><input type="text" name="projectName" id="projectName" value="${flash.projectEdit.name}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" style="padding-bottom: 5px;"><b><label><g:message code="project.taskNumberingSettings"/></label></b></td>
				</tr>
				<tr>
					<td><label><g:message code="project.taskNumberingEnabled"/></label></td>
					<g:if test="${flash.projectEdit.taskNumberingEnabled}">
						<td><input type="checkbox" name="projectTaskNumberingEnabled" id="projectTaskNumberingEnabled" value="true" checked="checked" class="checkbox ui-widget-content ui-corner-all"/></td>
					</g:if>
					<g:else>
						<td><input type="checkbox" name="projectTaskNumberingEnabled" id="projectTaskNumberingEnabled" value="true" class="checkbox ui-widget-content ui-corner-all"/></td>
					</g:else>
				</tr>
				<tr>
					<td><label><g:message code="project.taskNumberingPattern"/></label></td>
					<td><input type="text" name="projectTaskNumberingPattern" id="projectTaskNumberingPattern" value="${flash.projectEdit.taskNumberingPattern}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
			</table>

			<input type="hidden" name="projectId" value="${flash.projectEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>