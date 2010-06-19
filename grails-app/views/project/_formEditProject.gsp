<script type="text/javascript">
	$(function() {
		$("#dialog-form-project-edit").dialog({
			autoOpen: true,
			height: 420,
			width: 500,
			modal: true,
			buttons: {
				'<g:message code="default.button.save.label"/>': function() {
					document.getElementById("formEditProject").submit();
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

<div id="dialog-form-project-edit" title="${message(code:'project.formNameEditProject')}" class="form">
	<g:form url="[ controller: 'project', action: 'editProject', params: [ fwdTo: fwdTo ]]" name='formEditProject'>
		<fieldset>
			<label><g:message code="project.project"/></label>
			<input type="text" name="projectName" id="projectName" value="${flash.projectEdit.name}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="project.owner"/></label>
			<g:select name="projectOwner" from="${flash.users}" value="${flash.projectEdit.owner.id}" optionValue="userRealName" optionKey="id" />
			<label><g:message code="project.master"/></label>
			<g:select name="projectMaster" from="${flash.allUsers}" value="${flash.projectEdit.master.id}" optionValue="userRealName" optionKey="id" />
			<label><g:message code="project.twitter.account"/></label>
			<input type="text" name="twitterAccount" id="twitterAccount" value="${flash.projectEdit.twitter?.account}" class="text ui-widget-content ui-corner-all"/>
			<label><g:message code="project.twitter.password"/></label>
			<input type="password" name="twitterPassword" id="twitterPassword" value="${flash.projectEdit.twitter?.password}" class="text ui-widget-content ui-corner-all"/>
			
			<input type="hidden" name="projectId" value="${flash.projectEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>