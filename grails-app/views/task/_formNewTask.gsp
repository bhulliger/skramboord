<script type="text/javascript">
	$(function() {
		$("#dialog-form").dialog({
			autoOpen: false,
			height: 440,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formNewTask").submit();
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

<div id="dialog-form" title="${message(code:'task.formNameCreateTask')}" class="form">
	<g:form url="${flash.sprint?.id != null ?
					createLink(mapping: 'task', action: 'addTask', params: [project: flash.project.id, sprint: flash.sprint?.id, fwdTo: fwdTo, target: target])
					: createLink(mapping: 'task', action: 'addTask', params: [project: flash.project.id, sprint: 0, fwdTo: fwdTo, target: target])}" name="formNewTask">
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<g:if test="${!flash.taskNumberingEnabled}">
					<tr>
						<td><label><g:message code="task.number"/></label></td>
						<td><input type="text" name="taskNumber" id="taskNumber" value="${flash.taskIncomplete?.number}" class="text ui-widget-content ui-corner-all" /></td>
					</tr>
				</g:if>
				<tr>
					<td><label><g:message code="task.title"/></label></td>
					<td><input type="text" name="taskTitle" id="taskTitle" value="${flash.taskIncomplete?.title}" class="text ui-widget-content ui-corner-all" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.effort"/></label></td>
					<td><input type="text" name="taskEffort" id="taskEffort" value="${flash.taskIncomplete?.effort}" class="text ui-widget-content ui-corner-all" maxlength="4" size="4" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.link"/></label></td>
					<td><input type="text" name="taskLink" id="taskLink" value="${flash.taskIncomplete?.url ? flash.taskIncomplete?.url : 'http://'}" class="text ui-widget-content ui-corner-all" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.priority"/></label></td>
					<td><g:select name="taskPriority" from="${flash.priorityList}" valueMessagePrefix="priorities" value="${flash.taskIncomplete?.priority ? flash.taskIncomplete?.priority : org.skramboord.Priority.NORMAL}"/></td>
				</tr>
				<tr>
					<td><label><g:message code="task.type"/></label></td>
					<td><g:select name="taskType" from="${flash.taskTypes}" valueMessagePrefix="taskTypes" value="${flash.taskIncomplete?.type ? flash.taskIncomplete?.type : org.skramboord.TaskType.FEATURE}"/></td>
				</tr>
				<tr>
					<td style="vertical-align: top; padding-top: 5px;"><label><g:message code="task.description"/></label></td>
					<td><textarea name="taskDescription" id="taskDescription" class="text ui-widget-content ui-corner-all" style="width: 356px;" rows="10">${flash.taskIncomplete?.description}</textarea></td>
				</tr>
			</table>
		</fieldset>
	</g:form>
</div>