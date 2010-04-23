<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		
		<style type="text/css">
			#open, #checkout, #done, #next, #standBy { list-style-type: none; margin: 0; padding: 0; float: left; width: 230px;}
			#open li, #checkout li, #done li, #next li, #standBy li { margin: 1px; padding: 5px; font-size: 1.2em; width: 200px; }
			.taskInfo { font-style:italic; font-weight: normal; font-size:x-small; color: black; }
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
			<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="sprint" action="list" params="[project: session.project.id]">> ${session.project.name}</g:link> <g:link controller="task" action="list" params="[sprint: session.sprint.id]">> ${session.sprint.name}</g:link></h1>
			<g:render template="sprintInformation"/>
				
			<div id="tabs">
				<ul>
					<li><a href="#tab-task">Tasks</a></li>
					<li><a href="burndown.gsp">Burn Down</a></li>
				</ul>
				<div id="tab-task">
					<div>
						<h3>Tasks</h3>
						<g:if test="${session.sprint.isSprintActive()}">
							<g:render template="formNewTask"/>
						</g:if>
						
						<g:hasErrors bean="${flash.task}">
							<div class="errors">
								<g:renderErrors bean="${flash.task}" as="list"/>
							</div>
						</g:hasErrors>
						<g:if test="${flash.message}">
							<div class="message">${flash.message}</div>
						</g:if>
		
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
											<g:render template="task" model="['task':task]"/>
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
											<g:render template="task" model="['task':task]"/>
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
											<g:render template="task" model="['task':task]"/>
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
											<g:render template="task" model="['task':task]"/>
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
											<g:render template="task" model="['task':task]"/>
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