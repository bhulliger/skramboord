<script type="text/javascript">
	$(function() {		
		$("#dialog-form-sprint").dialog({
			autoOpen: false,
			height: 350,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formNewSprint").submit();
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
	});

	function openFormNewSprint(id){
		document.getElementById('releaseId').value=id;
		$('#dialog-form-sprint').dialog('open');
		return true;
	}
</script>

<div id="dialog-form-sprint" title="${message(code:'sprint.formNameCreateSprint')}" class="form">
	<g:form action="addSprint" name="formNewSprint">
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td><label><g:message code="sprint.sprint"/></label></td>
					<td><input type="text" name="sprintName" id="sprintName" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="sprint.goal"/></label></td>
					<td><input type="text" name="sprintGoal" id="sprintGoal" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
			</table>
			<br>
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
			<input type="hidden" id="releaseId" name="releaseId" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>