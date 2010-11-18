<%! import org.skramboord.Sprint %> 

<script type="text/javascript">
	$(function() {

		var selectAccordion = ${session?.tabs?.get('releases')?session.tabs.get('releases'):'0'};
		$("#accordion").accordion({
			active: selectAccordion,
			autoHeight: false
		});
	});

	function deleteRelease(releaseId, message){
		if (confirm(message)){
			location.href="/${meta(name: "app.name")}/release/delete?release=" + releaseId;
		}
	}

	function editRelease(releaseId){
		location.href="/${meta(name: "app.name")}/release/edit?release=" + releaseId;
	}
</script>

<g:if test="${flash.sprintEdit}">
	<g:render template="formEditSprint"/>
</g:if>
<g:elseif test="${flash.releaseEdit}">
	<g:render template="../release/formEditRelease"/>
</g:elseif>
<g:elseif test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
	<g:render template="formNewSprint"/>
	<g:render template="../release/formNewRelease"/>
</g:elseif>

<g:if test="${flash.releaseList.isEmpty()}">
	<div class="message">
		<g:message code="release.noReleases"/>
	</div>
	
	<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
		<table>
			<tr style="border: 1px solid #ccc;">
				<td colspan="8">
					<g:link url="#" onclick="return openFormNewRelease()"><span class="icon"><img src="${resource(dir:'images/icons',file:'add.png')}" alt="${message(code:'default.button.create.label')}" style="vertical-align: middle;"/><span class="icon" style="padding-left: 5px;"><g:message code="release.createRelease"/></span></g:link>
				</td>
			</tr>
		</table>
	</g:if>
</g:if>
<g:else>
	<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
		<table>
			<tr style="border: 1px solid #ccc;">
				<td colspan="8">
					<g:link url="#" onclick="return openFormNewRelease()"><span class="icon"><img src="${resource(dir:'images/icons',file:'add.png')}" alt="${message(code:'default.button.create.label')}" style="vertical-align: middle;"/><span class="icon" style="padding-left: 5px;"><g:message code="release.createRelease"/></span></g:link>
				</td>
			</tr>
		</table>
	</g:if>
	<div id="accordion">
		<g:each in="${flash.releaseList}" status="j" var="release">
			<h3>
				<a href="#" onclick="${remoteFunction(controller: 'administration', action:'tabChange', params:[viewName: 'releases', tabName: j])}">
					${release.name} - ${release.goal}, <g:formatDate format="dd.MM.yyyy" date="${Sprint.startDateRelease(release).list()?.first()}"/> - <g:formatDate format="dd.MM.yyyy" date="${Sprint.endDateRelease(release).list()?.first()}"/>
					<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
						<span style="float: right;"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="${message(code:'default.button.delete.label')}" onclick="return deleteRelease(${release.id}, '${message(code:'release.delete', args: [release.name])}')";/></span>
						<span style="float: right;"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="${message(code:'default.button.edit.label')}" onclick="return editRelease(${release.id})";/></span>
						<span class="clear"></span>
					</g:if>
				</a>
			</h3>
			<div>
				<g:if test="${release.sprints.isEmpty()}">
					<div class="message">
						<g:message code="sprint.noSprints"/>
					</div>
					<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
						<table>
							<tr style="border: 1px solid #ccc;">
								<td colspan="8">
									<g:link url="#" onclick="return openFormNewSprint(${release.id})"><span class="icon"><img src="${resource(dir:'images/icons',file:'add.png')}" alt="${message(code:'default.button.create.label')}" style="vertical-align: middle;"/><span class="icon" style="padding-left: 5px;"><g:message code="sprint.createSprint"/></span></g:link>
								</td>
							</tr>
						</table>
					</g:if>
				</g:if>
				<g:else>
					<div class="list">
						<table>
							<tr>
								<th><g:message code="sprint.sprint"/></th>
								<th><g:message code="sprint.goal"/></th>
								<th><g:message code="sprint.start"/></th>
								<th><g:message code="sprint.end"/></th>
								<th style="text-align:center;"><g:message code="task.tasks"/></th>
								<th style="text-align:center; width: 20px;"><g:message code="sprint.active"/></th>
								<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
									<th style="width: 20px;"></th>
									<th style="width: 20px;"></th>
								</g:if>
							</tr>
							<g:each var="sprint" in="${release.sprints}" status="i">
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
									<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
										<td>
											<g:link controller="sprint" action="edit" params="[sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="${message(code:'default.button.edit.label')}"/></span><span class="icon"></span></g:link>
										</td>
										<td>
											<g:link controller="sprint" action="delete" params="[sprint: sprintId]" onclick="return confirm('${message(code:'sprint.delete', args: [sprint.name])}');"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="${message(code:'default.button.delete.label')}"/></span><span class="icon"></span></g:link>
										</td>
									</g:if>
								</tr>
							</g:each>
								<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
									<tr style="border: 1px solid #ccc;">
										<td colspan="8">
											<g:link url="#" onclick="return openFormNewSprint(${release.id})"><span class="icon"><img src="${resource(dir:'images/icons',file:'add.png')}" alt="${message(code:'default.button.create.label')}" style="vertical-align: middle;"/><span class="icon" style="padding-left: 5px;"><g:message code="sprint.createSprint"/></span></g:link>
										</td>
									</tr>
								</g:if>
						</table>
					</div>
				</g:else>
			</div>
		</g:each>
	</div>
</g:else>