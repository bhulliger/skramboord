<script type="text/javascript">
	$(function() {
		$("#dialog-form-release-edit").dialog({
			autoOpen: true,
			height: 300,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formEditRelease").submit();
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

<div id="dialog-form-release-edit" title="${message(code:'release.formNameEditRelease')}" class="form">
	<g:form url="[ controller: 'release', action: 'update' ]" name='formEditRelease'>
		<fieldset>
			<label><g:message code="release.release"/></label>
			<input type="text" name="releaseName" id="releaseName" value="${flash.releaseEdit.name}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="release.goal"/></label>
			<input type="text" name="releaseGoal" id="releaseGoal" value="${flash.releaseEdit.goal}" class="text ui-widget-content ui-corner-all"/>
			
			<input type="hidden" name="releaseId" value="${flash.releaseEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>