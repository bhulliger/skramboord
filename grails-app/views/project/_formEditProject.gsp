<div id="dialog-form-project-edit" title="Edit project">
	<g:form action='editProject' name='formEditProject'>
		<fieldset>
			<label>Project</label>
			<input type="text" name="projectName" id="projectName" value="${flash.projectEdit.name}" class="text ui-widget-content ui-corner-all"/>
			<label>Project Owner</label>
			<g:select name="projectOwner" from="${flash.users}" value="${flash.projectEdit.owner.id}" optionValue="userRealName" optionKey="id" />
			<label>Project Master</label>
			<g:select name="projectMaster" from="${flash.allUsers}" value="${flash.projectEdit.master.id}" optionValue="userRealName" optionKey="id" />
			<input type="hidden" name="projectId" value="${flash.projectEdit.id}" style="border-style: none;"/>
		</fieldset>
	</g:form>
</div>
<g:submitButton name="create-project" value="Create project"/>