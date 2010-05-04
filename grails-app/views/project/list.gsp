<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		
		<style type="text/css">
			.column { width: 100%; float: left; padding-bottom: 100px; }
			.portlet { margin: 0 1em 1em 0; border: none;}
			.portlet-header { margin: 0.3em; padding: 4px; }
			.portlet-header .ui-icon { float: right; }
			.portlet-content { padding: 0.4em; padding-top: 0px;}
			.ui-sortable-placeholder { border: 1px dotted black; visibility: visible !important; height: 50px !important; }
			.ui-sortable-placeholder * { visibility: hidden; }
		</style>
		
		<script type="text/javascript" src="${resource(dir:'js/jquery',file:'jquery-1.4.2.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.widget.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.mouse.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.dialog.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.position.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.resizable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.button.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.tabs.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.sortable.js')}"></script>

		<script type="text/javascript">
			$(function() {
				$(".column").sortable({
					connectWith: '.column'
				});
	
				$(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
					.find(".portlet-header")
						.addClass("ui-widget-header ui-corner-all")
						.prepend('<span class="ui-icon ui-icon-plusthick"><\/span>')
						.end()
					.find(".portlet-content");
	
				$(".portlet-header .ui-icon").click(function() {
					$(this).toggleClass("ui-icon-minusthick");
					$(this).parents(".portlet:first").find(".portlet-content").toggle();
				});
	
				$(".column").disableSelection();

				
				$('#create-project')
					.button()
					.click(function() {
						$('#dialog-form-project').dialog('open');
				});
			});
		</script>
	</head>
	<body>		
			<h1><g:link controller="project" action="list">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/></g:link></h1>
			<g:if test="${flash.projectEdit}">
				<g:render template="formEditProject" model="['fwdTo':'project']"/>
			</g:if>
			
			<g:hasErrors bean="${flash.project}">
				<div class="errors">
					<g:renderErrors bean="${flash.project}" as="list"/>
				</div>
			</g:hasErrors>
			<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
			</g:if>
			
			<div style="padding-top: 10px;">
			<div class="column">
				<div class="portlet">
					<div class="portlet-header">My Tasks</div>
					<div class="portlet-content">
						<g:if test="${flash.myTasks.isEmpty()}">
							<div class="message">
								No tasks checked out. What are you paid for?
							</div>
						</g:if>
						<g:else>
							<div class="list">
								<table>
									<tr>
										<th>Task</th>
										<th>Project</th>
										<th>Sprint</th>
										<th style="text-align:center; width: 50px;">Effort</th>
										<th>Priority</th>
									</tr>
									<g:each var="task" in="${flash.myTasks}" status="i">
										<g:def var="sprintId" value="${task.sprint.id}"/>
										<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
											<td style="vertical-align: middle;">
												<g:link controller="task" action="list" params="[sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit"/></span><span class="icon">${task.name}</span></g:link>
											</td>
											<td style="vertical-align: middle;">${task.sprint.project.name}</td>
											<td style="vertical-align: middle;">${task.sprint.name}</td>
											<td style="vertical-align: middle;text-align:center;">${task.effort}</td>
											<td style="vertical-align: middle; font-weight: bold; color: #${task.priority};">${task.priority.name}</td>
										</tr>
									</g:each>
								</table>
							</div>
						</g:else>
					</div>
				</div>
				
				<div class="portlet">
					<div class="portlet-header">Active Spints</div>
					<div class="portlet-content">
						<g:if test="${flash.runningSprintsList.isEmpty()}">
							<div class="message">
								No active sprints found.
							</div>
						</g:if>
						<g:else>
							<div class="list">
								<table>
									<tr>
										<th>Sprint</th>
										<th>Goal</th>
										<th>Start</th>
										<th>End</th>
										<th style="text-align:center; width: 20px;">Tasks</th>
										<th style="text-align:center; width: 20px;">Active</th>
									</tr>
									<g:each var="sprint" in="${flash.runningSprintsList}" status="i">
										<g:def var="sprintId" value="${sprint.id}"/>
										<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
											<td>
												<g:link controller="task" action="list" params="[sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit"/></span><span class="icon">${sprint.name}</span></g:link>
											</td>
											<td style="vertical-align: middle;">${sprint.goal}</td>
											<td style="vertical-align: middle;"><g:formatDate format="dd.MM.yyyy" date="${sprint.startDate}"/></td>
											<td style="vertical-align: middle;"><g:formatDate format="dd.MM.yyyy" date="${sprint.endDate}"/></td>
											<td style="vertical-align: middle;text-align:center;">${sprint.tasks.size()}</td>
											<td style="text-align:center;">
												<g:if test="${sprint.isSprintRunning()}">
													<img src="${resource(dir:'images/icons',file:'flag_green.png')}" alt="Sprint is running"/>
												</g:if>
												<g:elseif test="${!sprint.isSprintRunning() && sprint.isSprintActive()}">
													<img src="${resource(dir:'images/icons',file:'flag_blue.png')}" alt="Sprint not started yet"/>
												</g:elseif>
												<g:else>
													<img src="${resource(dir:'images/icons',file:'flag_red.png')}" alt="Sprint is finished"/>
												</g:else>
											</td>
										</tr>
									</g:each>
								</table>
							</div>
						</g:else>
					</div>
				</div>
				
				<div class="portlet">
					<div class="portlet-header">Projects</div>
					<div class="portlet-content">
						<g:if test="${flash.projectList.isEmpty()}">
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
									<g:each var="project" in="${flash.projectList}" status="i">
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
									<g:ifAnyGranted role="ROLE_SUPERUSER,ROLE_ADMIN">
										<tr>
										<td>
										<g:render template="formNewProject"/>
										<g:submitButton name="create-project" value="Create project"/>
										</td>
										</tr>
									</g:ifAnyGranted>
								</table>
							</div>
						</g:else>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
