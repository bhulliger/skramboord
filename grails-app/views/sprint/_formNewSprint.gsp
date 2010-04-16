<script type="text/javascript">
	$(function() {
		$("#dialog-form-sprint").dialog({
			autoOpen: false,
			height: 500,
			width: 500,
			modal: true,
			buttons: {
				'Save': function() {
					document.getElementById("formNewSprint").submit();
					$(this).dialog('close');
				},
				Cancel: function() {
					location.reload(true);
					$(this).dialog('close');
				}
			}
		});

		$("#startDate").datepicker({dateFormat: 'yy-mm-dd', onSelect: function(dateStr) {
	    	document.getElementById('startDateHidden').value=$.datepicker.parseDate('yy-mm-dd', dateStr);
		}});
		$("#endDate").datepicker({dateFormat: 'yy-mm-dd', onSelect: function(dateStr) {
			document.getElementById('endDateHidden').value=$.datepicker.parseDate('yy-mm-dd', dateStr);
		}});
	});
</script>

<div id="dialog-form-sprint" title="Create new sprint">
	<g:form action="addSprint" name="formNewSprint">
		<fieldset>
			<label>Sprint</label>
			<input type="text" name="sprintName" id="sprintName" class="text ui-widget-content ui-corner-all"/>
			<label>Goal</label>
			<input type="text" name="sprintGoal" id="sprintGoal" class="text ui-widget-content ui-corner-all"/>
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
		</fieldset>
	</g:form>
</div>
<g:submitButton name="create-sprint" value="Create sprint"/>