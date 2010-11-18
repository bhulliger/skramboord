<script type="text/javascript">
	$(function() {
		$("#dialog-form-edit").dialog({
			autoOpen: true,
			height: 550,
			width: 400,
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
	<g:form action="update" name="formEditTask">
		<fieldset>
			<label><g:message code="task.name"/></label>
			<input type="text" name="taskName" id="taskName" value="${flash.taskEdit.name}" class="text ui-widget-content ui-corner-all" />
			<label><g:message code="task.description"/></label>
			<textarea name="taskDescription" id="taskDescription" class="text ui-widget-content ui-corner-all" style="width: 356px;" rows="10">${flash.taskEdit.description}</textarea>
			<label><g:message code="task.effort"/></label>
			<input type="text" name="taskEffort" id="taskEffort" value="${flash.taskEdit.effort}" class="text ui-widget-content ui-corner-all" maxlength="4" size="4" />
			<label><g:message code="task.link"/></label>
			<input type="text" name="taskLink" id="taskLink" value="${flash.taskEdit.url}" class="text ui-widget-content ui-corner-all" />
			<label><g:message code="task.priority"/></label>
			<g:select name="taskPriority" from="${flash.priorityList}" value="${flash.taskEdit.priority.id}" valueMessagePrefix="priorities"/>
			<input type="hidden" name="taskId" value="${flash.taskEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>