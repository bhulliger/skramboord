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
		</script>

	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="sprint" action="list" params="[project: session.project.id]">> ${session.project.name}</g:link> <g:link controller="task" action="list" params="[sprint: session.sprint.id]">> ${session.sprint.name}</g:link></h1>
			<g:render template="sprintInformation"/>
				
			<div id="tabs">
				<ul>
					<li><a href="#tab-0"><g:message code="task.scrumboard"/></a></li>
					<li><a href="#tab-1"><g:message code="task.burndown"/></a></li>
				</ul>
				<div id="tab-0">
					<g:render template="scrumBoard"/>
				</div>
				<div id="tab-1">
					<div id="burndown" style="width:920px;height:380px;"></div>
				</div>
			</div>
		</div>
	</body>
</html>