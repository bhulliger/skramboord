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
			location.href="${request.contextPath}/project/${flash.project.id}/release/delete?release=" + releaseId;
		}
	}

	function editRelease(releaseId){
		location.href="${request.contextPath}/project/${flash.project.id}/release/edit?release=" + releaseId;
	}
</script>

<g:if test="${flash.sprintEdit}">
	<g:render template="formEditSprint"/>
</g:if>
<g:elseif test="${flash.releaseEdit}">
	<g:render template="../release/formEditRelease"/>
</g:elseif>
<g:elseif test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
	<g:render template="formNewSprint"/>
	<g:render template="../release/formNewRelease"/>
</g:elseif>

<g:if test="${flash.releaseList.isEmpty()}">
	<div class="message">
		<g:message code="release.noReleases"/>
	</div>
	
	<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
		<div class="buttons">
			<span class="button"><g:actionSubmit class="add" onclick="return openFormNewRelease();" value="${message(code:'release.createRelease')}" /></span>
		</div>
	</g:if>
</g:if>
<g:else>
	<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
		<div class="buttons">
			<span class="button"><g:actionSubmit class="add" onclick="return openFormNewRelease();" value="${message(code:'release.createRelease')}" /></span>
		</div>
	</g:if>
	<div id="accordion">
		<g:each in="${flash.releaseList}" status="j" var="release">
			<h3>
				<a href="#" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'releases', tabName: j])}">
					${release.name} - ${release.goal}, <g:formatDate format="dd.MM.yyyy" date="${Sprint.startDateRelease(release).list()?.first()}"/> - <g:formatDate format="dd.MM.yyyy" date="${Sprint.endDateRelease(release).list()?.first()}"/>
					<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
						<span style="float: right;"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="${message(code:'default.button.delete.label')}" onclick="return deleteRelease(${release.id}, '${message(code:'release.delete', args: [release.name])}');"/></span>
						<span style="float: right;"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="${message(code:'default.button.edit.label')}" onclick="return editRelease(${release.id});"/></span>
						<span class="clear">&nbsp;</span>
					</g:if>
				</a>
			</h3>
			<div>
				<g:if test="${release.sprints.isEmpty()}">
					<div class="message">
						<g:message code="sprint.noSprints"/>
					</div>
					<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
						<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
							<div class="buttons">
								<span class="button"><g:actionSubmit class="add" onclick="return openFormNewSprint(${release.id});" value="${message(code:'sprint.createSprint')}" /></span>
							</div>
						</g:if>
					</g:if>
				</g:if>
				<g:else>
					<div class="list">
						<table>
							<tr>
								<th><g:message code="sprint.sprint"/></th>
								<th><g:message code="sprint.goal"/></th>
								<th style="text-align:center; width: 90px;"><g:message code="sprint.personDays"/></th>
								<th style="width: 70px;"><g:message code="sprint.start"/></th>
								<th style="width: 70px;"><g:message code="sprint.end"/></th>
								<th style="text-align:center;"><g:message code="task.tasks"/></th>
								<th style="text-align:center; width: 20px;"><g:message code="sprint.active"/></th>
								<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
									<th style="width: 40px;"></th>
								</g:if>
							</tr>
							<g:each var="sprint" in="${release.sprints}" status="i">
								<g:def var="sprintId" value="${sprint.id}"/>
								<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
									<td>
										<g:link mapping="task" action="list" params="[project: flash.project.id, sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit"/></span><span class="icon">${sprint.name}</span></g:link>
									</td>
									<td style="vertical-align: middle;">${sprint.goal}</td>
									<td style="vertical-align: middle;text-align:center;">${sprint.personDays}</td>
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
									<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
										<td>
											<g:link mapping="sprint" action="edit" params="[project: flash.project.id, sprint: sprintId]"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="${message(code:'default.button.edit.label')}"/></span></g:link>
											<g:link mapping="sprint" action="delete" params="[project: flash.project.id, sprint: sprintId]" onclick="return confirm('${message(code:'sprint.delete', args: [sprint.name])}');"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="${message(code:'default.button.delete.label')}"/></span></g:link>
										</td>
									</g:if>
								</tr>
							</g:each>
						</table>
						<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
							<div class="buttons">
								<span class="button"><g:actionSubmit class="add" onclick="return openFormNewSprint(${release.id});" value="${message(code:'sprint.createSprint')}" /></span>
							</div>
						</g:if>
					</div>
				</g:else>
			</div>
		</g:each>
	</div>
</g:else>