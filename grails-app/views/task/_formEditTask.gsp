<script type="text/javascript">
	$(function() {
		$("#dialog-form-edit").dialog({
			autoOpen: true,
			height: 360,
			width: 300,
			modal: true,
			buttons: {
				'Save': function() {
					document.getElementById("formEditTask").submit();
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

<div id="dialog-form-edit" title="${message(code:'task.formNameEditTask')}" class="form">
	<g:form action="editTask" name="formEditTask">
		<fieldset>
			<label><g:message code="task.name"/></label>
			<input type="text" name="taskName" id="taskName" value="${flash.taskEdit.name}" class="text ui-widget-content ui-corner-all" />
			<label><g:message code="task.effort"/></label>
			<input type="text" name="taskEffort" id="taskEffort" value="${flash.taskEdit.effort}" class="text ui-widget-content ui-corner-all" maxlength="4" size="4" />
			<label><g:message code="task.link"/></label>
			<input type="text" name="taskLink" id="taskLink" value="${flash.taskEdit.url}" class="text ui-widget-content ui-corner-all" />
			<label><g:message code="task.priority"/></label>
			<g:select name="taskPriority" from="${flash.priorityList}" value="${flash.taskEdit.priority.id}" optionValue="name" optionKey="id"/>
			<input type="hidden" name="taskId" value="${flash.taskEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>
<g:if test="${flash.teammate}">
	<g:submitButton name="create-task" value="${message(code:'task.createTask')}"/>
</g:if>