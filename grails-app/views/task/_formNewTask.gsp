<script type="text/javascript">
	$(function() {
		$("#dialog-form").dialog({
			autoOpen: false,
			height: 400,
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
	<g:form url="[ controller: 'task', action: 'addTask', params: [ fwdTo: fwdTo, target: target ]]" name='formNewTask'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td><label><g:message code="task.name"/></label></td>
					<td><input type="text" name="taskName" id="taskName" class="text ui-widget-content ui-corner-all" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.effort"/></label></td>
					<td><input type="text" name="taskEffort" id="taskEffort" value="" class="text ui-widget-content ui-corner-all" maxlength="4" size="4" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.link"/></label></td>
					<td><input type="text" name="taskLink" id="taskLink" value="http://" class="text ui-widget-content ui-corner-all" /></td>
				</tr>
				<tr>
					<td><label><g:message code="task.priority"/></label></td>
					<td><g:select name="taskPriority" from="${flash.priorityList}" valueMessagePrefix="priorities" value="${org.skramboord.Priority.NORMAL}"/></td>
				</tr>
				<tr>
					<td style="vertical-align: top;"><label><g:message code="task.description"/></label></td>
					<td><textarea name="taskDescription" id="taskDescription" class="text ui-widget-content ui-corner-all" style="width: 356px;" rows="10"></textarea></td>
				</tr>
			</table>
		</fieldset>
	</g:form>
</div>