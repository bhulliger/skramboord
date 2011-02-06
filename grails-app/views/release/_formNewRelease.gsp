<script type="text/javascript">
	$(function() {
		$("#dialog-form-release").dialog({
			autoOpen: false,
			height: 160,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formNewRelease").submit();
					$(this).dialog('close');
				},
				'<g:message code="default.button.cancel.label"/>': function() {
					location.reload(true);
					$(this).dialog('close');
				}
			}
		});
	});

	function openFormNewRelease(){
		$('#dialog-form-release').dialog('open');
		return true;
	}
</script>

<div id="dialog-form-release" title="${message(code:'release.formNameCreateRelease')}" class="form">
	<g:form action='addRelease' controller='release' name='formNewRelease'>
		<fieldset>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td><label><g:message code="release.release"/></label></td>
					<td><input type="text" name="releaseName" id="releaseName" value="${flash.releaseIncomplete?.name}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
				<tr>
					<td><label><g:message code="release.goal"/></label></td>
					<td><input type="text" name="releaseGoal" id="releaseGoal" value="${flash.releaseIncomplete?.goal}" class="text ui-widget-content ui-corner-all"/></td>
				</tr>
			</table>
		</fieldset>
	</g:form>
</div>