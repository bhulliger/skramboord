<script type="text/javascript">
	$(function() {
		$("#dialog-form").dialog({
			autoOpen: false,
			height: 360,
			width: 300,
			modal: true,
			buttons: {
				'Save': function() {
					document.getElementById("formNewTask").submit();
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

<div id="dialog-form" title="Create new task" class="form">
	<g:form action="addTask" name="formNewTask">
		<fieldset>
			<label>Name</label>
			<input type="text" name="taskName" id="taskName" class="text ui-widget-content ui-corner-all" />
			<label>Effort</label>
			<input type="text" name="taskEffort" id="taskEffort" value="" class="text ui-widget-content ui-corner-all" maxlength="4" size="4" />
			<label>Link</label>
			<input type="text" name="taskLink" id="taskLink" value="" class="text ui-widget-content ui-corner-all" />
			<label>Priority</label>
			<g:select name="taskPriority" from="${flash.priorityList}" optionValue="name" optionKey="id"/>
		</fieldset>
	</g:form>
</div>
<g:submitButton name="create-task" value="Create task"/>