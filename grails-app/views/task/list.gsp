<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		<title>Skramboord</title>
		
		<style type="text/css">
			#open, #checkout, #done, #next, #standBy { list-style-type: none; margin: 0; padding: 0; float: left; width: 230px;}
			#open li, #checkout li, #done li, #next li, #standBy li { margin: 1px; padding: 5px; font-size: 1.2em; width: 200px; }
			#taskInfo { font-style:italic; font-weight: normal; font-size:x-small; color: black; }
			
			body { font-size: 62.5%; }
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
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.tabs.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.effects.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/flot',file:'jquery.flot.js')}"></script>
		
		<script type="text/javascript">
			function changeToOpen(event, ui){
				location.href="${resource(dir:'task',file:'changeTaskStateToOpen')}" + "?taskId=" + $(ui.item).attr("id");
			}
			function changeToCheckout(event, ui){
				location.href="${resource(dir:'task',file:'changeTaskStateToCheckOut')}" + "?taskId=" + $(ui.item).attr("id");
			}
			function changeToDone(event, ui){
				location.href="${resource(dir:'task',file:'changeTaskStateToDone')}" + "?taskId=" + $(ui.item).attr("id");
			}
			function changeToNext(event, ui){
				location.href="${resource(dir:'task',file:'changeTaskStateToNext')}" + "?taskId=" + $(ui.item).attr("id");
			}
			function changeToStandBy(event, ui){
				location.href="${resource(dir:'task',file:'changeTaskStateToStandBy')}" + "?taskId=" + $(ui.item).attr("id");
			}
		
			$(function() {
				$("#dialog-form").dialog({
					autoOpen: false,
					height: 340,
					width: 300,
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
	
				$('#create-task')
					.button()
					.click(function() {
						$('#dialog-form').dialog('open');
				});

				$("#open").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: changeToOpen
				}).disableSelection();
				$("#checkout").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: changeToCheckout
				}).disableSelection();
				$("#done").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: changeToDone
				}).disableSelection();
				$("#next").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: changeToNext
				}).disableSelection();
				$("#standBy").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: changeToStandBy
				}).disableSelection();

				$("#tabs").tabs({
					ajaxOptions: {
						error: function(xhr, status, index, anchor) {
							$(anchor.hash).html("Couldn't load this tab. We'll try to fix this as soon as possible.");
						}
					}
				});
			});							
		</script>

	</head>
	<body>
		<div class="body">
			<h1><g:link controller="sprint" action="list" params="[project: session.project.id]">> ${session.project.name}</g:link> <g:link controller="task" action="list" params="[sprint: session.sprint.id]">> ${session.sprint.name}</g:link></h1>
			<h3>Project informations</h3>
			<table>
				<tr>
					<th>Sprint</th>
					<th>Goal</th>
					<th>Start</th>
					<th>End</th>
					<th style="text-align:center;">Number of Tasks</th>
				    <th style="text-align:center;">Total effort</th>
				    <th style="text-align:center;">Total effort done</th>
				    <th style="text-align:center; width: 20px;">Active</th>
				</tr>
				<tr>
					<td><b>${session.sprint.name}</b></td>
					<td>${session.sprint.goal}</td>
					<td><g:formatDate format="dd.MM.yyyy" date="${session.sprint.startDate}"/></td>
					<td><g:formatDate format="dd.MM.yyyy" date="${session.sprint.endDate}"/></td>
					<td style="text-align:center;">${session.numberOfTasks}</td>
					<td style="text-align:center;">${session.totalEffort}</td>
					<td style="text-align:center;">${session.totalEffortDone}</td>
					<td style="text-align:center;">
						<g:if test="${session.sprint.isSprintRunning()}">
							<img src="${resource(dir:'images/icons',file:'flag_green.png')}" alt="Sprint is running"/>
						</g:if>
						<g:elseif test="${!session.sprint.isSprintRunning() && session.sprint.isSprintActive()}">
							<img src="${resource(dir:'images/icons',file:'flag_blue.png')}" alt="Sprint not started yet"/>
						</g:elseif>
						<g:else>
							<img src="${resource(dir:'images/icons',file:'flag_red.png')}" alt="Sprint is finished"/>
						</g:else>
					</td>
				</tr>
			</table>
				
			<div id="tabs">
				<ul>
					<li><a href="#tabs-1">Tasks</a></li>
					<li><a href="burndown.gsp">Burn Down</a></li>
				</ul>
				<div id="tabs-1">
					<div>
						<h3>Tasks</h3>
						<div id="dialog-form" title="Create new task">
							<g:form name="myform" action="addTask">
								<fieldset>
									<label for="name">Name</label>
									<input type="text" name="taskName" id="taskName" class="text ui-widget-content ui-corner-all" />
									<label for="effort">Effort</label>
									<input type="text" name="taskEffort" id="taskEffort" value="" class="text ui-widget-content ui-corner-all" maxlength="4" size="4" />
									<label for="link">Link</label>
									<input type="text" name="taskLink" id="taskLink" value="" class="text ui-widget-content ui-corner-all" />
									<label for="link">Priority</label>
									<g:select name="taskPriority" from="${session.priorityList}" optionValue="name" optionKey="name"/>
								</fieldset>
							</g:form>
						</div>
						<g:if test="${session.sprint.isSprintActive()}">
							<g:submitButton name="create-task" value="Create task"/>
						</g:if>
						<g:hasErrors bean="${flash.task}">
							<div class="errors">
								<g:renderErrors bean="${flash.task}" as="list"/>
							</div>
						</g:hasErrors>
		
						<table>
							<tr>
							    <th>Open</th>
							    <th>Checkout</th>
							    <th>Done</th>
							</tr>
							<tr>
								<td>
									<g:if test="${session.taskListOpen.size() > 0}">
										<ul id="open" class="connectedSortable">
									</g:if>
									<g:else>
										<ul id="open" class="connectedSortable" style="padding-bottom: 100px;">
									</g:else>
										<g:each var="task" in="${session.taskListOpen}" status="i">
											<li id="taskId_${task.id}" class="ui-state-default">
												<g:link url="${task.url}" target="_blank" style="color: #${task.priority.toString()};">${task.name}</g:link>
												<div id="taskInfo">
													Effort: ${task.effort}<br/>
													Person: unknown
												</div>
											</li>
										</g:each>
									</ul>
								</td>
								<td>
									<g:if test="${session.taskListCheckout.size() > 0}">
										<ul id="checkout" class="connectedSortable">
									</g:if>
									<g:else>
										<ul id="checkout" class="connectedSortable" style="padding-bottom: 100px;">
									</g:else>
										<g:each var="task" in="${session.taskListCheckout}" status="i">
											<li id="taskId_${task.id}" class="ui-state-default">
												<g:link url="${task.url}" target="_blank" style="color: #${task.priority.toString()};">${task.name}</g:link>
												<div id="taskInfo">
													Effort: ${task.effort}<br/>
													Person: unknown
												</div>
											</li>
										</g:each>
									</ul>
								</td>
								<td>
									<g:if test="${session.taskListDone.size() > 0}">
										<ul id="done" class="connectedSortable">
									</g:if>
									<g:else>
										<ul id="done" class="connectedSortable" style="padding-bottom: 100px;">
									</g:else>
										<g:each var="task" in="${session.taskListDone}" status="i">
											<li id="taskId_${task.id}" class="ui-state-default">
												<g:link url="${task.url}" target="_blank" style="color: #${task.priority.toString()};">${task.name}</g:link>
												<div id="taskInfo">
													Effort: ${task.effort}<br/>
													Person: unknown
												</div>
											</li>
										</g:each>
									</ul>
								</td>
							</tr>
							<tr>
								<th colspan="2">Stand by</th>
								<th>Next</th>
							</tr>
							<tr>
								<td colspan="2">
									<g:if test="${session.taskListStandBy.size() > 0}">
										<ul id="standBy" class="connectedSortable">
									</g:if>
									<g:else>
										<ul id="standBy" class="connectedSortable" style="padding-bottom: 100px;">
									</g:else>
										<g:each var="task" in="${session.taskListStandBy}" status="i">
											<li id="taskId_${task.id}" class="ui-state-default">
												<g:link url="${task.url}" target="_blank" style="color: #${task.priority.toString()};">${task.name}</g:link>
												<div id="taskInfo">
													Effort: ${task.effort}<br/>
													Person: unknown
												</div>
											</li>
										</g:each>
									</ul>
								</td>
								<td>
									<g:if test="${session.taskListNext.size() > 0}">
										<ul id="next" class="connectedSortable">
									</g:if>
									<g:else>
										<ul id="next" class="connectedSortable" style="padding-bottom: 100px;">
									</g:else>
										<g:each var="task" in="${session.taskListNext}" status="i">
											<li id="taskId_${task.id}" class="ui-state-default">
												<g:link url="${task.url}" target="_blank" style="color: #${task.priority.toString()};">${task.name}</g:link>
												<div id="taskInfo">
													Effort: ${task.effort}<br/>
													Person: unknown
												</div>
											</li>
										</g:each>
									</ul>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>