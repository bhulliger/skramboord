<script type="text/javascript">
	$(function() {
		$("#dialog-form-release").dialog({
			autoOpen: false,
			height: 250,
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
			<label><g:message code="release.release"/></label>
			<input type="text" name="releaseName" id="releaseName" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="release.goal"/></label>
			<input type="text" name="releaseGoal" id="releaseGoal" class="text ui-widget-content ui-corner-all"/>
		</fieldset>
	</g:form>
</div>