<script type="text/javascript">
	$(function() {
		$("#dialog-form-sprint-edit").dialog({
			autoOpen: true,
			height: 400,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formEditSprint").submit();
					$(this).dialog('close');
				},
				'<g:message code="default.button.cancel.label"/>': function() {
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
		
		$('#startDate').datepicker("setDate", "${flash.sprintEdit.startDate}");
		$('#endDate').datepicker("setDate", "${flash.sprintEdit.endDate}");
	});
</script>
<div id="dialog-form-sprint-edit" title="${message(code:'sprint.formNameEditSprint')}" class="form">
	<g:form url="${createLink(mapping: 'sprint', action: 'update', params: [project: flash.project.id])}" name='formEditSprint'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td><label><g:message code="sprint.sprint"/></label></td>
					<td><input type="text" name="sprintName" id="sprintName" value="${flash.sprintEdit.name}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="sprint.goal"/></label></td>
					<td><input type="text" name="sprintGoal" id="sprintGoal" value="${flash.sprintEdit?.goal}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="sprint.personDays"/></label></td>
					<td><input type="text" name="sprintPersonDays" id="sprintPersonDays" value="${flash.sprintEdit?.personDays}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
			</table>
			<br/>
			<table>
				<tr>
					<td><label><g:message code="sprint.start"/>:</label></td>
					<td><label><g:message code="sprint.end"/>:</label></td>
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