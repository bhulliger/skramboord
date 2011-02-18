<script type="text/javascript">
	$(function() {
		$("#dialog-form-edit").dialog({
			autoOpen: true,
			height: 440,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formEditTask").submit();
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

<div id="dialog-form-edit" title="${message(code:'task.formNameEditTask')}" class="form">
	<g:form url="[ controller: 'task', action: 'update', params: [ fwdTo: fwdTo ]]" name='formEditTask'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td><label><g:message code="task.name"/></label></td>
					<td><input type="text" name="taskName" id="taskName" value="${flash.taskEdit.name}" class="text ui-widget-content ui-corner-all" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.effort"/></label></td>
					<td><input type="text" name="taskEffort" id="taskEffort" value="${flash.taskEdit.effort}" class="text ui-widget-content ui-corner-all" maxlength="4" size="4" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.link"/></label></td>
					<td><input type="text" name="taskLink" id="taskLink" value="${flash.taskEdit.url}" class="text ui-widget-content ui-corner-all" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.priority"/></label></td>
					<td><g:select name="taskPriority" from="${flash.priorityList}" value="${flash.taskEdit.priority.name}" valueMessagePrefix="priorities"/></td>
				</tr>
				<tr>
					<td><label><g:message code="task.type"/></label></td>
					<td><g:select name="taskType" from="${flash.taskTypes}" value="${flash.taskEdit.type.name}" valueMessagePrefix="taskTypes"/></td>
				</tr>
				<tr>
					<td style="vertical-align: top;"><label><g:message code="task.description"/></label></td>
					<td><textarea name="taskDescription" id="taskDescription" class="text ui-widget-content ui-corner-all" style="width: 356px;" rows="10">${flash.taskEdit.description}</textarea></td>
				</tr>
			</table>

			<input type="hidden" name="taskId" value="${flash.taskEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>