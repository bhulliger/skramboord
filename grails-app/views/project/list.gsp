<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		
		<style type="text/css">
			label, input { display:block; }
			input.text { margin-bottom:12px; width:95%; padding: .4em; }
			select { margin-bottom:12px; width:97%; padding: .3em; }
			fieldset { padding:0; border:0; margin-top:25px; }
			div#users-contain { width: 350px; margin: 20px 0; }
			div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
			div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
			.ui-dialog .ui-state-error { padding: .3em; }
			.validateTips { border: 1px solid transparent; padding: 0.3em; }
		</style>
		
		<script type="text/javascript" src="${resource(dir:'js/jquery',file:'jquery-1.4.2.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.widget.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.mouse.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.draggable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.sortable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.droppable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.dialog.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.position.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.resizable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.button.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.effects.core.js')}"></script>
		
		<script type="text/javascript">
			$(function() {
				$("#dialog-form-project").dialog({
					autoOpen: false,
					height: 250,
					width: 500,
					modal: true,
					buttons: {
						'Save': function() {
							document.getElementById("formNewProject").submit();
							$(this).dialog('close');
						},
						Cancel: function() {
							location.reload(true);
							$(this).dialog('close');
						}
					}
				});

				$("#dialog-form-project-edit").dialog({
					autoOpen: true,
					height: 320,
					width: 500,
					modal: true,
					buttons: {
						'Save': function() {
							document.getElementById("formEditProject").submit();
							$(this).dialog('close');
						},
						Cancel: function() {
							location.reload(true);
							$(this).dialog('close');
						}
					}
				});


				$('#create-project')
					.button()
					.click(function() {
						$('#dialog-form-project').dialog('open');
				});
			});
		</script>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/></g:link></h1>          
			<h3>Project List</h3>
			<g:if test="${flash.projectEdit}">
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
			</g:if>
			<g:else>
				<g:ifAnyGranted role="ROLE_SUPERUSER,ROLE_ADMIN">
					<div id="dialog-form-project" title="Create new project">
					<g:form action='addProject' name='formNewProject'>
						<fieldset>
							<label>Project</label>
							<input type="text" name="projectName" id="projectName" class="text ui-widget-content ui-corner-all"/>
							<label>Project Master</label>
							<g:select name="projectMaster" from="${flash.allUsers}" value="${session.user.id}" optionValue="userRealName" optionKey="id" />
						</fieldset>
					</g:form>
					</div>
					<g:submitButton name="create-project" value="Create project"/>
				</g:ifAnyGranted>
			</g:else>
			
			<g:hasErrors bean="${flash.project}">
				<div class="errors">
					<g:renderErrors bean="${flash.project}" as="list"/>
				</div>
			</g:hasErrors>
			<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
			</g:if>
			<g:if test="${session.projectList.isEmpty()}">
				<div class="message">
					No projects created yet.
				</div>
			</g:if>
			<g:else>
				<div class="list">
					<table>
						<tr>
							<g:sortableColumn property="name" defaultOrder="asc" title="Project"/>
							<g:sortableColumn property="owner" defaultOrder="asc" title="Project Owner"/>
							<g:sortableColumn property="master" defaultOrder="asc" title="Project Master"/>
							<g:sortableColumn property="sprints" defaultOrder="desc" title="Sprints" style="text-align:center; width: 50px;"/>
							<g:ifAnyGranted role="ROLE_SUPERUSER,ROLE_ADMIN">
								<th style="width: 50px;"></th>
							</g:ifAnyGranted>
							<g:ifAllGranted role="ROLE_SUPERUSER">
								<th style="width: 70px;"></th>
							</g:ifAllGranted>
						</tr>
						<g:each var="project" in="${session.projectList}" status="i">
							<g:def var="projectId" value="${project.id}"/>
							<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
								<td>
									<g:link controller="sprint" action="list" params="[project: projectId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="view"/></span><span class="icon">${project.name}</span></g:link>
								</td>
								<td style="vertical-align: middle;">${project.owner.userRealName}</td>
								<td style="vertical-align: middle;">${project.master.userRealName}</td>
								<td style="vertical-align: middle; text-align:center;">${project.sprints.size()}</td>

								<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(project.owner)}">
									<td>
										<g:link controller="project" action="edit" params="[project: projectId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span><span class="icon">Edit</span></g:link>
									</td>
								</g:if>
								<g:elseif test="${authenticateService.ifAnyGranted('ROLE_ADMIN')}">
									<td style="vertical-align: middle; text-align:center;">-</td>
								</g:elseif>
								<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER')}">
									<td>
										<g:link controller="project" action="delete" params="[project: projectId]" onclick="return confirm(unescape('Are you sure to delete project %22${project.name}%22?'));"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="delete"/></span><span class="icon">Delete</span></g:link>
									</td>
								</g:if>
							</tr>
						</g:each>
					</table>
				</div>
			</div>
		</g:else>
	</body>
</html>