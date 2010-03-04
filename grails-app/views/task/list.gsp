<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		<title>ScrumBoard</title>
		
		<style type="text/css">
			#open, #checkout, #done, #next, #standBy { list-style-type: none; margin: 0; padding: 0; float: left; width: 230px;}
			#open li, #checkout li, #done li, #next li, #standBy li { margin: 1px; padding: 5px; font-size: 1.2em; width: 200px; }
			#taskInfo { font-style:italic; font-weight: normal; font-size:x-small; color: black; }
		</style>
		
		<script type="text/javascript" src="${resource(dir:'js/jquery',file:'jquery-1.4.2.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.widget.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.mouse.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.draggable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.sortable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.droppable.js')}"></script>

		
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
		});
	</script>

	</head>
	<body>
		<div class="body">	
			<h3>Informations</h3>
			<table>
				<tr>
					<th>Project</th>
					<th>Release</th>
					<th>Number of Tasks</th>
				    <th>Total effort</th>
				    <th>Total effort done</th>
				</tr>
				<tr>
					<td><b>Test</b></td>
					<td><b>1.0</b></td>
					<td>${session.numberOfTasks}</td>
					<td>${session.totalEffort}</td>
					<td>${session.totalEffortDone}</td>
				</tr>
			</table>

			<g:form method="post" >				
				<div>
					<h3>Tasks</h3>
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
											<g:link url="${task.url?.url}">${task.name}</g:link>
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
											<g:link url="${task.url?.url}">${task.name}</g:link>
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
											<g:link url="${task.url?.url}">${task.name}</g:link>
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
											<g:link url="${task.url?.url}">${task.name}</g:link>
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
											<g:link url="${task.url?.url}">${task.name}</g:link>
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
				<h3>Add Task</h3>
				<table>
					<tr>
					    <th>Name</th>
					    <th>Effort</th>
					    <th>Link</th>
					</tr>
					<tr>
						<td><input type="text" id="taskName" name="taskName" maxlength="100" size="30"/></td>
						<td><input type="text" id="taskEffort" name="taskEffort" maxlength="4" size="4"/></td>
						<td><input type="text" id="taskLink" name="taskLink" maxlength="100" size="30"/></td>
						<td>
							<div class="buttons"><span class="button"><g:actionSubmit class="add" value="add" action="addTask"/></span></div>
						</td>
					</tr>
				</table>
			</g:form>
		</div>
	</body>
</html>