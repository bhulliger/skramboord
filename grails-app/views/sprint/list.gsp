<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		
		<script type="text/javascript" src="${resource(dir:'js/jquery',file:'jquery-1.4.2.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.widget.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.mouse.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.dialog.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.position.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.resizable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.button.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.tabs.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.effects.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/cookie',file:'jquery.cookie.js')}"></script>
		
		<script type="text/javascript">
			$(function() {
				$('#create-sprint')
					.button()
					.click(function() {
						$('#dialog-form-sprint').dialog('open');
				});

				var tabId = parseInt($.cookie("sprintTab")) || 0;
				$("#tabs").tabs({
					selected: tabId,
					show:     function(junk,ui) {
						var tabName = ui.tab.toString().split("#");
						var ourl = tabName[1].split("-");
						var tabId = ourl[1];
						$.cookie("sprintTab", tabId);
					}
				});
			});
		</script>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list"">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="sprint" action="list" params="[project: session.project.id]">> ${session.project.name}</g:link></h1>
			<g:render template="projectInformation"/>

			<g:hasErrors bean="${flash.sprint}">
				<div class="errors">
					<g:renderErrors bean="${flash.sprint}" as="list"/>
				</div>
			</g:hasErrors>
			<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
			</g:if>
			
			<div id="tabs">
				<ul>
					<li><a href="#tab-0">Sprints</a></li>
					<li><a href="#tab-1">Project Team</a></li>
				</ul>
				<div id="tab-0">
					<g:if test="${flash.sprintEdit}">
						<g:render template="formEditSprint"/>
					</g:if>
					<g:elseif test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
						<g:render template="formNewSprint"/>
					</g:elseif>
					
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
									<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
										<th style="width: 50px;"></th>
										<th style="width: 70px;"></th>
									</g:if>
								</tr>
								<g:each var="sprint" in="${flash.sprintList}" status="i">
									<g:def var="sprintId" value="${sprint.id}"/>
									<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
										<td>
											<g:link controller="task" action="list" params="[sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit"/></span><span class="icon">${sprint.name}</span></g:link>
										</td>
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
				<div id="tab-1">
					<div class="list">
						<h3>Team</h3>
						<table>
							<thead>
								<tr>
									<g:sortableColumn property="username" title="Login Name" />
									<g:sortableColumn property="name" title="Name" />
									<g:sortableColumn property="prename" title="Prename" />
									<g:sortableColumn property="description" title="Description" />
									<th style="width: 90px; text-align: center;">Project Owner</th>
									<th style="width: 90px; text-align: center;">Project Master</th>
									<th style="width: 90px; text-align: center;">Developer</th>
									<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
										<th style="width: 70px;"></th>
									</g:if>
								</tr>
							</thead>
							<tbody>
								<g:each in="${flash.teamList}" status="i" var="person">
									<g:def var="userId" value="${person.id}"/>
									<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
										<td>
											<g:link controller="user" action="show" params="[id: userId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="show"/></span><span class="icon">${person.username?.encodeAsHTML()}</span></g:link>
										</td>
										<td style="vertical-align: middle;">${person.name?.encodeAsHTML()}</td>
										<td style="vertical-align: middle;">${person.prename?.encodeAsHTML()}</td>
										<td style="vertical-align: middle;">${person.description?.encodeAsHTML()}</td>
										<td style="vertical-align: middle; text-align: center;">
											<g:if test="${person.id == session.project.owner.id}">
												<span class="icon"><img src="${resource(dir:'images/icons',file:'accept.png')}" alt="show"/></span><span class="icon"></span>
											</g:if>
										</td>
										<td style="vertical-align: middle; text-align: center;">
											<g:if test="${person.id == session.project.master.id}">
												<span class="icon"><img src="${resource(dir:'images/icons',file:'accept.png')}" alt="show"/></span><span class="icon"></span>
											</g:if>
										</td>
										<g:if test="${person.id != session.project.master.id && person.id != session.project.owner.id}">
											<td style="vertical-align: middle; text-align: center;">
												<span class="icon"><img src="${resource(dir:'images/icons',file:'accept.png')}" alt="show"/></span><span class="icon"></span>
											</td>
											<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
												<td>
													<g:link controller="sprint" action="removeDeveloper" params="[user: userId]" onclick="return confirm(unescape('Are you sure to remove this user from this project? All checked out tasks from this user will be released again.'));"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="remove"/></span><span class="icon">Remove</span></g:link>
												</td>
											</g:if>
										</g:if>
										<g:else>
											<td></td>
											<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
												<td></td>
											</g:if>
										</g:else>
									</tr>
								</g:each>
							</tbody>
						</table>
					</div>
					<br/>
					<h3>Users</h3>
					<g:if test="${flash.personList.isEmpty()}">
						<div class="message">
							No more users left to support this project.
						</div>
					</g:if>
					<g:else>
						<div class="list">
							<table>
								<thead>
									<tr>
										<g:sortableColumn property="username" title="Login Name" />
										<g:sortableColumn property="name" title="Name" />
										<g:sortableColumn property="prename" title="Prename" />
										<g:sortableColumn property="description" title="Description" />
										<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
											<th style="width: 50px;"></th>
										</g:if>
									</tr>
								</thead>
								<tbody>
									<g:each in="${flash.personList}" status="i" var="person">
										<g:def var="userId" value="${person.id}"/>
										<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
											<td>
												<g:link controller="user" action="show" params="[id: userId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="show"/></span><span class="icon">${person.username?.encodeAsHTML()}</span></g:link>
											</td>
											<td style="vertical-align: middle;">${person.name?.encodeAsHTML()}</td>
											<td style="vertical-align: middle;">${person.prename?.encodeAsHTML()}</td>
											<td style="vertical-align: middle;">${person.description?.encodeAsHTML()}</td>
											<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
												<td>
													<g:link controller="sprint" action="addDeveloper" params="[user: userId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'add.png')}" alt="add"/></span><span class="icon">Add</span></g:link>
												</td>
											</g:if>
										</tr>
									</g:each>
								</tbody>
							</table>
						</div>
					</g:else>
				</div>
			</div>
		</div>
	</body>
</html>