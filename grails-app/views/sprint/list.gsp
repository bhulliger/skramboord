<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		
		<style type="text/css">
			label, input { display:block; }
			input.text { margin-bottom:12px; width:95%; padding: .4em; }
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
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.datepicker.js')}"></script>
		
		<script type="text/javascript">
			$(function() {
				$("#dialog-form-sprint").dialog({
					autoOpen: false,
					height: 500,
					width: 500,
					modal: true,
					buttons: {
						'Save': function() {
							document.getElementById("formNewSprint").submit();
							$(this).dialog('close');
						},
						Cancel: function() {
							location.reload(true);
							$(this).dialog('close');
						}
					}
				});

				$("#dialog-form-sprint-edit").dialog({
					autoOpen: true,
					height: 500,
					width: 500,
					modal: true,
					buttons: {
						'Save': function() {
							document.getElementById("formEditSprint").submit();
							$(this).dialog('close');
						},
						Cancel: function() {
							location.reload(true);
							$(this).dialog('close');
						}
					}
				});
			
				$('#create-sprint')
					.button()
					.click(function() {
						$('#dialog-form-sprint').dialog('open');
				});

				$("#startDate").datepicker({dateFormat: 'yy-mm-dd', onSelect: function(dateStr) {
			    	document.getElementById('startDateHidden').value=$.datepicker.parseDate('yy-mm-dd', dateStr);
				}});
				$("#endDate").datepicker({dateFormat: 'yy-mm-dd', onSelect: function(dateStr) {
					document.getElementById('endDateHidden').value=$.datepicker.parseDate('yy-mm-dd', dateStr);
				}});
			});
		</script>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="sprint" action="list" params="[project: session.project.id]">> ${session.project.name}</g:link></h1>
			<h3>Sprint List</h3>
			
			<g:if test="${flash.sprintEdit}">
				<g:render template="formEditSprint"/>
			</g:if>
			<g:elseif test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
				<g:render template="formNewSprint"/>
			</g:elseif>

			<g:hasErrors bean="${flash.sprint}">
				<div class="errors">
					<g:renderErrors bean="${flash.sprint}" as="list"/>
				</div>
			</g:hasErrors>
			<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
			</g:if>
			<g:if test="${session.project.sprints.isEmpty()}">
				<div class="message">
					No sprints created yet.
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
							<th style="text-align:center;">Tasks</th>
							<th style="text-align:center; width: 20px;">Active</th>
							<g:ifAnyGranted role="ROLE_SUPERUSER,ROLE_ADMIN">
								<th style="width: 50px;"></th>
								<th style="width: 70px;"></th>
							</g:ifAnyGranted>
						</tr>
						<g:each var="sprint" in="${session.sprintList}" status="i">
							<g:def var="sprintId" value="${sprint.id}"/>
							<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
								<td>
									<g:link controller="task" action="list" params="[sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit"/></span><span class="icon">${sprint.name}</span></g:link>
								</td>
								<td>${sprint.goal}</td>
								<td><g:formatDate format="dd.MM.yyyy" date="${sprint.startDate}"/></td>
								<td><g:formatDate format="dd.MM.yyyy" date="${sprint.endDate}"/></td>
								<td style="text-align:center;">${sprint.tasks.size()}</td>
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
								<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
									<td>
										<g:link controller="sprint" action="edit" params="[sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span><span class="icon">Edit</span></g:link>
									</td>
									<td>
										<g:link controller="sprint" action="delete" params="[sprint: sprintId]" onclick="return confirm(unescape('Are you sure to delete sprint %22${sprint.name}%22?'));"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="delete"/></span><span class="icon">Delete</span></g:link>
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