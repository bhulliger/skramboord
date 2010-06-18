<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		
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
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.effects.slide.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.effects.blind.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/flot',file:'jquery.flot.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/cookie',file:'jquery.cookie.js')}"></script>
		
		<script type="text/javascript">
			$(function() {
				var showProductBacklog = $.cookie('showProductBacklog'); 
				if (showProductBacklog != 'show') {
					$("#productBacklog").hide();
					document.getElementById("scrumboard").style.width = "900px";
				} else {
					document.getElementById("scrumboard").style.width = "660px";
				}
				
				$('#toggleProductBacklog')
					.button()
					.click(function() {
				    	if ($("#productBacklog").is(":hidden")) {
				    		$.cookie('showProductBacklog', 'show')
				    		document.getElementById("scrumboard").style.width = "660px";
				    		$("#productBacklog").toggle(500);
				    	} else {
				    		$.cookie('showProductBacklog', 'hide')
				    		document.getElementById("scrumboard").style.width = "900px";
				    		$("#productBacklog").toggle();
				    	}
				});
				
<g:if test="${flash.teammate}">
				$('#create-task')
					.button()
					.click(function() {
						$('#dialog-form').dialog('open');
				});

				$("#backlog").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: function(event, ui) { changeTo(event, ui, 'copyTaskToBacklog') }
				}).disableSelection();
				$("#open").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToOpen') }
				}).disableSelection();
				$("#checkout").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToCheckOut') }
				}).disableSelection();
				$("#done").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToDone') }
				}).disableSelection();
				$("#next").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToNext') }
				}).disableSelection();
				$("#standBy").sortable({
					connectWith: '.connectedSortable',
					dropOnEmpty: true,
					receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToStandBy') }
				}).disableSelection();
</g:if>

				var tabId = parseInt($.cookie("taskTab")) || 0;
				$("#tabs").tabs({
					selected: tabId,
					show:     function(junk,ui) {
						var tabName = ui.tab.toString().split("#");
						var ourl = tabName[1].split("-");
						var tabId = ourl[1];
						$.cookie("taskTab", tabId);

						if (tabId == 1) { // Only render burn down if tab #1 is selected.
							var target = [];
							var today = ${flash.today}
							var dates = ${flash.burndownTargetX};
							var gradient = ${flash.totalEffort}/${flash.burndownTargetXSize};
						    var markings = [{ color: '#ff0000', lineWidth: 1, xaxis: { from: today, to: today} }];
						    
						    for (var i = 0; i <= ${flash.burndownTargetXSize}; i += 1) {
						        target.push([dates[i], ${flash.totalEffort} - gradient*i]);
						    }
						    
						    $.plot($("#burndown"), [ target, ${flash.burndownReal} ],
						    	    {
					    	    		xaxis: {
				    							mode: 'time',
				    							min: ${(session.sprint.startDate).getTime()},
				    							max: ${(session.sprint.endDate).getTime() + 10000000}
										},
						    			grid: { markings: markings }
						    	    });
						}
					}
				});
			});

<g:if test="${flash.teammate}">
			function changeTo(event, ui, stateMethod){
				location.href="/${meta(name: "app.name")}/task/" + stateMethod + "?taskId=" + $(ui.item).attr("id");
			}
</g:if>
		</script>

	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="sprint" action="list" params="[project: session.project.id]">> ${session.project.name}</g:link> <g:link controller="task" action="list" params="[sprint: session.sprint.id]">> ${session.sprint.name}</g:link></h1>
			<g:render template="sprintInformation"/>
				
			<div id="tabs">
				<ul>
					<li><a href="#tab-0">Scrum Board</a></li>
					<li><a href="#tab-1">Burn Down</a></li>
				</ul>
				<div id="tab-0">
					<div>
						<h3>Tasks</h3>
						<g:if test="${flash.taskEdit}">
							<g:render template="formEditTask"/>
						</g:if>
						<g:elseif test="${session.sprint.isSprintActive()}">
							<g:render template="formNewTask"/>
						</g:elseif>
						<g:submitButton name="toggleProductBacklog" value="Product Backlog (${flash.projectBacklog.size()} tasks)"/>
						
						<g:hasErrors bean="${flash.task}">
							<div class="errors">
								<g:renderErrors bean="${flash.task}" as="list"/>
							</div>
						</g:hasErrors>
						<g:if test="${flash.message}">
							<div class="message">${flash.message}</div>
						</g:if>
						
						<div class="clear"></div>
						
						<div class="backlog" id="productBacklog">
							<div class="boardheader">Backlog</div>
							<div style="height: 500px; overflow: auto;">
								<g:if test="${flash.projectBacklog.size() > 0}">
									<ul id="backlog" class="connectedSortable">
								</g:if>
								<g:else>
									<ul id="backlog" class="connectedSortable" style="padding-bottom: 100px;">
								</g:else>
									<g:each var="task" in="${flash.projectBacklog}" status="i">
										<g:render template="task" model="['task':task]"/>
									</g:each>
								</ul>
							</div>
						</div>
						
						<div class="scrumboard" id="scrumboard">
							<div class="open">
								<div class="boardheader">Open</div>
								<g:if test="${flash.taskListOpen.size() > 0}">
									<ul id="open" class="connectedSortable">
								</g:if>
								<g:else>
									<ul id="open" class="connectedSortable" style="padding-bottom: 100px;">
								</g:else>
									<g:each var="task" in="${flash.taskListOpen}" status="i">
										<g:render template="task" model="['task':task]"/>
									</g:each>
								</ul>
							</div>
							
							<div class="checkout">
								<div class="boardheader">Checkout</div>
								<g:if test="${flash.taskListCheckout.size() > 0}">
									<ul id="checkout" class="connectedSortable">
								</g:if>
								<g:else>
									<ul id="checkout" class="connectedSortable" style="padding-bottom: 100px;">
								</g:else>
									<g:each var="task" in="${flash.taskListCheckout}" status="i">
										<g:render template="task" model="['task':task]"/>
									</g:each>
								</ul>
							</div>
							
							<div class="done">
								<div class="boardheader">Done</div>
								<g:if test="${flash.taskListDone.size() > 0}">
									<ul id="done" class="connectedSortable">
								</g:if>
								<g:else>
									<ul id="done" class="connectedSortable" style="padding-bottom: 100px;">
								</g:else>
									<g:each var="task" in="${flash.taskListDone}" status="i">
										<g:render template="task" model="['task':task]"/>
									</g:each>
								</ul>
							</div>
							
							<div class="nextStandBy">
								<div class="next">
									<div class="boardheader">Next</div>
									<g:if test="${flash.taskListNext.size() > 0}">
										<ul id="next" class="connectedSortable">
									</g:if>
									<g:else>
										<ul id="next" class="connectedSortable" style="padding-bottom: 100px;">
									</g:else>
										<g:each var="task" in="${flash.taskListNext}" status="i">
											<g:render template="task" model="['task':task]"/>
										</g:each>
									</ul>
								</div>
								
								<div class="standBy">
									<div class="boardheader">Stand by</div>
									<g:if test="${flash.taskListStandBy.size() > 0}">
										<ul id="standBy" class="connectedSortable">
									</g:if>
									<g:else>
										<ul id="standBy" class="connectedSortable" style="padding-bottom: 100px;">
									</g:else>
										<g:each var="task" in="${flash.taskListStandBy}" status="i">
											<g:render template="task" model="['task':task]"/>
										</g:each>
									</ul>
								</div>
							</div>
						</div>
						<div class="clear"></div>
					</div>
				</div>
				<div id="tab-1">
					<div id="burndown" style="width:920px;height:380px;"></div>
				</div>
			</div>
		</div>
	</body>
</html>