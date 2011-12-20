<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />

		<script type="text/javascript">
			$(function() {
				xOffset = 5;
				yOffset = -15;
				$("li.tooltip").hover(function(e){	
						this.t = this.title;
						this.title = "";									  
						$("body").append("<p id='tooltip' style='width:260pt;'>"+ this.t +"</p>");
						$("#tooltip").css("top",(e.pageY - yOffset) + "px")
                                     .css("left",(e.pageX + xOffset) + "px")
                                     .fadeIn("fast");
			    	},
					function(){
						this.title = this.t;		
						$("#tooltip").remove();});	
				$("li.tooltip").mousemove(function(e){
					$("#tooltip")
						.css("top",(e.pageY - yOffset) + "px")
						.css("left",(e.pageX + xOffset) + "px");
				});
				
				var selectTab = ${session?.tabs?.get('sprint')?session.tabs.get('sprint'):'0'};
				$("#tabs").tabs({
					selected: selectTab
				});
			});
		</script>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list"><img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="sprint" action="list" params="[project: flash.project.id]">> ${flash.project.name}</g:link></h1>

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
					<li><a href="#tab-0" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'sprint', tabName: '0'])}"><g:message code="release.releases"/></a></li>
					<li><a href="#tab-1" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'sprint', tabName: '1'])}"><g:message code="project.informations"/></a></li>
					<li><a href="#tab-2" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'sprint', tabName: '2'])}"><g:message code="project.backlog"/></a></li>
					<li><a href="#tab-3" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'sprint', tabName: '3'])}"><g:message code="sprint.projectTeam"/></a></li>
					<g:if test="${flash.twitterAppSettings && flash.twitterAppSettings.enabled}">
						<li><a href="#tab-4" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'sprint', tabName: '4'])}"><g:message code="twitter"/></a></li>
					</g:if>
				</ul>
				<div id="tab-0">
					<g:render template="projectReleases"/>
				</div>
				<div id="tab-1">
					<g:render template="projectInformation"/>
				</div>
				<div id="tab-2">
					<g:render template="productBacklog"/>
				</div>
				<div id="tab-3">
					<g:render template="projectTeam"/>
				</div>
				<g:if test="${flash.twitterAppSettings && flash.twitterAppSettings.enabled}">
					<div id="tab-4">
						<g:render template="twitter"/>
					</div>
				</g:if>
			</div>
		</div>
	</body>
</html>