<div id="dialog-form" title="Create new task">
	<g:form action="addTask" name="formNewTask">
		<fieldset>
			<label>Name</label>
			<input type="text" name="taskName" id="taskName" class="text ui-widget-content ui-corner-all" />
			<label>Effort</label>
			<input type="text" name="taskEffort" id="taskEffort" value="" class="text ui-widget-content ui-corner-all" maxlength="4" size="4" />
			<label>Link</label>
			<input type="text" name="taskLink" id="taskLink" value="" class="text ui-widget-content ui-corner-all" />
			<label>Priority</label>
			<g:select name="taskPriority" from="${session.priorityList}" optionValue="name" optionKey="name"/>
		</fieldset>
	</g:form>
</div>
<g:submitButton name="create-task" value="Create task"/>