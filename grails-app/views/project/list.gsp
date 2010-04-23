<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		
		<script type="text/javascript" src="${resource(dir:'js/jquery',file:'jquery-1.4.2.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.widget.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.mouse.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.dialog.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.position.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.resizable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.button.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.tabs.js')}"></script>

		<script type="text/javascript">
			$(function() {
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
			<g:if test="${flash.projectEdit}">
				<g:render template="formEditProject" model="['fwdTo':'project']"/>
				<g:submitButton name="create-project" value="Create project"/>
			</g:if>
			<g:else>
				<g:ifAnyGranted role="ROLE_SUPERUSER,ROLE_ADMIN">
					<g:render template="formNewProject"/>
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
										<g:link controller="project" action="edit" params="[project: projectId, fwdTo: 'project']"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span><span class="icon">Edit</span></g:link>
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
			</g:else>
		</div>
	</body>
</html>
