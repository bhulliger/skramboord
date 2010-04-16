<script type="text/javascript">
	$(function() {
		$('#startDate').datepicker("setDate", "${flash.sprintEdit.startDate}");
		$('#endDate').datepicker("setDate", "${flash.sprintEdit.endDate}");
	});
</script>
<div id="dialog-form-sprint-edit" title="Edit sprint">
	<g:form action="editSprint" name="formEditSprint">
		<fieldset>
			<label>Sprint</label>
			<input type="text" name="sprintName" id="sprintName" value="${flash.sprintEdit.name}" class="text ui-widget-content ui-corner-all"/>
			<label>Goal</label>
			<input type="text" name="sprintGoal" id="sprintGoal" value="${flash.sprintEdit.goal}" class="text ui-widget-content ui-corner-all"/>
			<table>
				<tr>
					<td><label>Start:</label></td>
					<td><label>End:</label></td>
				</tr>
				<tr>
					<td><div id="startDate"></div></td>
					<td><div id="endDate"></div></td>
				</tr>
			</table>
			<input type="hidden" id="startDateHidden" name="startDateHidden" style="border-style: none;"/>
			<input type="hidden" id="endDateHidden" name="endDateHidden" style="border-style: none;"/>
			<input type="hidden" name="sprintId" value="${flash.sprintEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>

<g:submitButton name="create-sprint" value="Create sprint"/>