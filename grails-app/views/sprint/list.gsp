<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		<title>Skramboord</title>
		
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
					height: 480,
					width: 500,
					modal: true,
					buttons: {
						'Save': function() {
							document.forms["myform"].submit();
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

				$("#startDate").datepicker({onSelect: function(dateStr) {
			         	document.getElementById('startDateHidden').value=$.datepicker.parseDate('mm/dd/yy', dateStr);
					}});
				$("#endDate").datepicker({onSelect: function(dateStr) {
						document.getElementById('endDateHidden').value=$.datepicker.parseDate('mm/dd/yy', dateStr);
					}});
				
			});
		</script>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home" border="0"/> </g:link><g:link controller="sprint" action="list" params="[project: session.project.id]">> ${session.project.name}</g:link></h1>
			<h3>Sprint List</h3>
			<div id="dialog-form-sprint" title="Create new sprint">
				<g:form name="myform" action="addSprint">
					<fieldset>
						<label for="name">Sprint</label>
						<input type="text" name="sprintName" id="sprintName" class="text ui-widget-content ui-corner-all"/>
						<label for="goal">Goal</label>
						<input type="text" name="sprintGoal" id="sprintGoal" class="text ui-widget-content ui-corner-all"/>
						<table>
							<tr>
								<td><label for="startDate">Start:</label></td>
								<td><label for="endDate">End:</label></td>
							</tr>
							<tr>
								<td><div type="text" id="startDate"></div></td>
								<td><div type="text" id="endDate"></div></td>
								
							</tr>
						</table>
					</fieldset>
					<input type="hidden" id="startDateHidden" name="startDateHidden" style="border-style: none;"></input>
					<input type="hidden" id="endDateHidden" name="endDateHidden" style="border-style: none;"></input>
				</g:form>
			</div>
			<g:submitButton name="create-sprint" value="Create sprint"/>
			
			<g:hasErrors bean="${flash.sprint}">
				<div class="errors">
					<g:renderErrors bean="${flash.sprint}" as="list"/>
				</div>
			</g:hasErrors>
			<g:if test="${session.project.sprints.isEmpty()}">
				<div class="message">
					No sprints created yet.
				</div>
			</g:if>
			<g:else>
				<table>
					<tr>
						<th>Sprint</th>
						<th>Goal</th>
						<th>Start</th>
						<th>End</th>
						<th style="text-align:center;">Number of Tasks</th>
						<th style="text-align:center; width: 20px;">Active</th>
					</tr>
					<g:each var="sprint" in="${session.sprintList}" status="i">
						<g:def var="sprintId" value="${sprint.id}"/>
						<tr>
							<td>
								<g:link controller="task" action="list" params="[sprint: sprintId]"><span id="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit" border="0"/></span><span id="icon">${sprint.name}</span></g:link>
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
						</tr>
					</g:each>
				</table>
			</g:else>
		</div>
	</body>
</html>