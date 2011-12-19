<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />

		<script type="text/javascript" src="${resource(dir:'js/jquery/flot',file:'jquery.flot.js')}"></script>
		
		<script type="text/javascript">
			var showBurndown = false;
			$(function() {
				var selectTab = ${session?.tabs?.get('tasks')?session.tabs.get('tasks'):'0'};
				$("#tabs").tabs({
					selected: selectTab,
					show:     function(junk,ui) {
						if (showBurndown || (selectTab == '1')) { // Only render burn down if tab #1 is selected.
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
				    							min: ${(flash.sprint.startDate).getTime()},
				    							max: ${(flash.sprint.endDate).getTime() + 10000000}
										},
						    			grid: { markings: markings }
						    	    });
						    showBurndown = false;
						}
					}
				});
			});

			function rerenderBurndown(){
				showBurndown = true;
			}
		</script>

	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list"> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="sprint" action="list" params="[project: flash.project.id]">> ${flash.project.name}</g:link> <g:link controller="task" action="list" params="[sprint: flash.sprint.id]">> ${flash.sprint.name}</g:link></h1>
			<g:hasErrors bean="${flash.objectToSave}">
				<div class="errors">
					<g:renderErrors bean="${flash.objectToSave}" as="list"/>
				</div>
			</g:hasErrors>
			<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
			</g:if>

			<div id="tabs">
				<ul>
					<li><a href="#tab-0" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'tasks', tabName: '0'])}"><g:message code="task.scrumboard"/></a></li>
					<li><a href="#tab-1" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'tasks', tabName: '1'])}"><g:message code="sprint.informations"/></a></li>
					<li><a href="#tab-2" onclick="rerenderBurndown(); ${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'tasks', tabName: '2'])}"><g:message code="task.burndown"/></a></li>
				</ul>
				<div id="tab-0">
					<g:render template="scrumBoard"/>
				</div>
				<div id="tab-1">
					<g:render template="sprintInformation"/>
				</div>
				<div id="tab-2">
					<div id="burndown" style="width:1100px;height:380px;"></div>
				</div>
			</div>
		</div>
	</body>
</html>