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
		
		<script type="text/javascript">
			// set the list selector
			var setSelector = ".column";

			function getOrder() {
		        location.href="${request.contextPath}/project/saveDashboardOrder?dashboard=" + $(setSelector).sortable("toArray");
			}

			function restoreOrder() {
		        var list = $(setSelector);
		        if (list == null) return

		        var dashboard = document.getElementById("dashboard").value;
		        if (!dashboard) return;

		        // make array from saved order
		        var IDs = dashboard.split(",");
		       
		        // fetch current order
		        var items = list.sortable("toArray");
		        // make array from current order
		        var rebuild = new Array();
		        for ( var v=0, len=items.length; v<len; v++ ){
	                rebuild[items[v]] = items[v];
		        }
		       
		        for (var i = 0, n = IDs.length; i < n; i++) {
	                // item id from saved order
	                var itemID = IDs[i];
	               
	                if (itemID in rebuild) {
                        // select item id from current order
                        var item = rebuild[itemID];
                       
                        // select the item according to current order
                        var child = $("div.ui-sortable").children("#" + item);
                       
                        // select the item according to the saved order
                        var savedOrd = $("div.ui-sortable").children("#" + itemID);
                       
                        // remove all the items
                        child.remove();
                       
                        // add the items in turn according to saved order we need to filter here since the "ui-sortable"
                        // class is applied to all ul elements and we only want the very first!
                        $("div.ui-sortable").filter(":first").append(savedOrd);
	                }
		        } 
			}

			function restorePortletState() {
				var dashboard = document.getElementById("dashboard").value;
		        if (!dashboard) return;

		        var portletStates = document.getElementById("portletStates").value;
		        if (!portletStates) return;

		        var IDs = dashboard.split(",");
		        var states = portletStates.split(",");

		        for (var i = 0, n = IDs.length; i < n; i++) {
		        	var itemID = IDs[i];
		        	var itemState = states[i];

			        if (itemState == "false") {
			        	$("#" + itemID).addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        		.find(".portlet-header")
			        			.addClass("ui-widget-header ui-corner-all")
								.prepend('<span class="ui-icon ui-icon-minusthick"><\/span>')
								.end()
							.find(".portlet-content").toggle();
		        	} else {
			        	$("#" + itemID).addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
		        		.find(".portlet-header")
		        			.addClass("ui-widget-header ui-corner-all")
							.prepend('<span class="ui-icon ui-icon-plusthick"><\/span>')
							.end()
						.find(".portlet-content");
		        	}
		        }
			}
		
			$(function() {
				$(".column").sortable({
					connectWith: '.column',
					stop: function() {getOrder();}
				});
				restoreOrder();
				restorePortletState();
	
				$(".portlet-header .ui-icon").click(function() {
					$(this).toggleClass("ui-icon-minusthick");
					$(this).parents(".portlet:first").find(".portlet-content").toggle();
					
					location.href="${request.contextPath}/project/savePortletState?portlet=" + this.parentNode.parentNode.id;
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
		<div class="body">
			<h1><g:link controller="project" action="list">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/></g:link></h1>
			<g:if test="${flash.projectEdit}">
				<g:render template="formEditProject" model="['fwdTo':'project']"/>
			</g:if>
			
			<g:hasErrors bean="${flash.objectToSave}">
				<div class="errors">
					<g:renderErrors bean="${flash.objectToSave}" as="list"/>
				</div>
			</g:hasErrors>
			<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
			</g:if>
			
			<input type="hidden" id="dashboard" name="dashboard" style="border-style: none;" value="${session.user.userDashboard}"/>
			<input type="hidden" id="portletStates" name="dashboard" style="border-style: none;" value="${session.user.portletStates}"/>
			
			<div style="padding-top: 10px;">
				<div class="column">
					<div class="portlet" id="${org.skramboord.DashboardPortlet.PORTLET_TASKS}">
						<div class="portlet-header"><g:message code="dashboard.myTasks"/></div>
						<div class="portlet-content">
							<g:if test="${flash.myTasks.isEmpty()}">
								<div class="message">
									<g:message code="dashboard.noMyTasks"/>
								</div>
							</g:if>
							<g:else>
								<div class="list">
									<table>
										<tr>
											<th><g:message code="task.task"/></th>
											<th><g:message code="project.project"/></th>
											<th><g:message code="release.release"/></th>
											<th><g:message code="sprint.sprint"/></th>
											<th style="text-align:center; width: 50px;"><g:message code="task.effort"/></th>
											<th><g:message code="task.priority"/></th>
										</tr>
										<g:each var="task" in="${flash.myTasks}" status="i">
											<g:def var="sprintId" value="${task.sprint?.id}"/>
											<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
												<td style="vertical-align: middle;">
													<g:link controller="task" action="list" params="[sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit"/></span><span class="icon">${task.name}</span></g:link>
												</td>
												<td style="vertical-align: middle;">${task.sprint?.release?.project?.name}</td>
												<td style="vertical-align: middle;">${task.sprint?.release?.name}</td>
												<td style="vertical-align: middle;">${task.sprint?.name}</td>
												<td style="vertical-align: middle;text-align:center;">${task.effort}</td>
												<td style="vertical-align: middle; font-weight: bold; color: #${task.priority.colorAsString()};"><g:message code="priorities.${task.priority.name}"/></td>
											</tr>
										</g:each>
									</table>
								</div>
							</g:else>
						</div>
					</div>
					
					<div class="portlet" id="${org.skramboord.DashboardPortlet.PORTLET_SPRINTS}">
						<div class="portlet-header"><g:message code="dashboard.activeSprints"/></div>
						<div class="portlet-content">
							<g:if test="${flash.runningSprintsList.isEmpty()}">
								<div class="message">
									<g:message code="dashboard.noActiveSprints"/>
								</div>
							</g:if>
							<g:else>
								<div class="list">
									<table>
										<tr>
											<th><g:message code="sprint.sprint"/></th>
											<th><g:message code="release.release"/></th>
											<th><g:message code="sprint.goal"/></th>
											<th><g:message code="sprint.start"/></th>
											<th><g:message code="sprint.end"/></th>
											<th style="text-align:center; width: 20px;"><g:message code="task.tasks"/></th>
											<th style="text-align:center; width: 20px;"><g:message code="sprint.active"/></th>
										</tr>
										<g:each var="sprint" in="${flash.runningSprintsList}" status="i">
											<g:def var="sprintId" value="${sprint.id}"/>
											<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
												<td>
													<g:link controller="task" action="list" params="[sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit"/></span><span class="icon">${sprint.name}</span></g:link>
												</td>
												<td style="vertical-align: middle;">${sprint.release?.name}</td>
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
					
					<div class="portlet" id="${org.skramboord.DashboardPortlet.PORTLET_PROJECTS}">
						<div class="portlet-header"><g:message code="project.projects"/></div>
						<div class="portlet-content">
							<g:if test="${flash.projectList.isEmpty()}">
								<div class="message">
									<g:message code="project.noProjects"/>
								</div>
								<sec:ifAnyGranted roles="ROLE_SUPERUSER,ROLE_ADMIN">
									<table>
										<tr style="border: 1px solid #ccc;">
											<td colspan="6">
												<g:render template="formNewProject"/>
												<g:link url="#" onclick="return openFormNewProject();"><span class="icon"><img src="${resource(dir:'images/icons',file:'add.png')}" alt="${message(code:'default.button.create.label')}" style="vertical-align: middle;"/><span class="icon" style="padding-left: 5px;"><g:message code="project.createProject"/></span></g:link>
											</td>
										</tr>
									</table>
								</sec:ifAnyGranted>
							</g:if>
							<g:else>
								<div class="list">
									<table>
										<tr>
											<g:sortableColumn property="name" defaultOrder="asc" title="${message(code:'project.project')}"/>
											<g:sortableColumn property="owner" defaultOrder="asc" title="${message(code:'project.owner')}"/>
											<g:sortableColumn property="master" defaultOrder="asc" title="${message(code:'project.master')}"/>
											<g:sortableColumn property="sprints" defaultOrder="desc" title="${message(code:'sprint.sprints')}" style="text-align:center; width: 50px;"/>
											<sec:ifAnyGranted roles="ROLE_SUPERUSER">
												<th style="width: 40px;"></th>
											</sec:ifAnyGranted>
											<g:if test="${!org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') && flash.ownerOfAProject}">
												<th style="width: 20px;"></th>
											</g:if>
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
												
												<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || flash.ownerOfAProject}">
													<td>
														<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(project.owner)}">
															<g:link controller="project" action="edit" params="[project: projectId, fwdTo: 'project']"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="${message(code:'default.button.edit.label')}"/></span><span class="icon"></span></g:link>
														</g:if>
														<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER')}">
															<g:link controller="project" action="delete" params="[project: projectId]" onclick="return confirm('${message(code:'project.delete', args: [project.name])}');"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="${message(code:'default.button.delete.label')}"/></span><span class="icon"></span></g:link>
														</g:if>
													</td>
												</g:if>
											</tr>
										</g:each>
									</table>
									<sec:ifAnyGranted roles="ROLE_SUPERUSER,ROLE_ADMIN">
										<div class="buttons">
											<g:render template="formNewProject"/>
											<span class="button"><g:actionSubmit class="add" onclick="return openFormNewProject();" value="${message(code:'project.createProject')}" /></span>
										</div>
									</sec:ifAnyGranted>
								</div>
							</g:else>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
