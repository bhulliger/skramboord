<table>
	<tr>
		<th><g:message code="sprint.sprint"/></th>
		<th><g:message code="sprint.goal"/></th>
		<th><g:message code="sprint.start"/></th>
		<th><g:message code="sprint.end"/></th>
		<th style="text-align:center;"><g:message code="task.Tasks"/></th>
	    <th style="text-align:center;"><g:message code="sprint.totalEffort"/></th>
	    <th style="text-align:center;"><g:message code="sprint.totalEffortDone"/></th>
	    <th style="text-align:center; width: 20px;"><g:message code="sprint.active"/></th>
	</tr>
	<tr>
		<td><b>${session.sprint.name}</b></td>
		<td>${session.sprint.goal}</td>
		<td><g:formatDate format="dd.MM.yyyy" date="${session.sprint.startDate}"/></td>
		<td><g:formatDate format="dd.MM.yyyy" date="${session.sprint.endDate}"/></td>
		<td style="text-align:center;">${flash.numberOfTasks}</td>
		<td style="text-align:center;">${flash.totalEffort}</td>
		<td style="text-align:center;">${flash.totalEffortDone}</td>
		<td style="text-align:center;">
			<g:if test="${session.sprint.isSprintRunning()}">
				<img src="${resource(dir:'images/icons',file:'flag_green.png')}" alt="Sprint is running"/>
			</g:if>
			<g:elseif test="${!session.sprint.isSprintRunning() && session.sprint.isSprintActive()}">
				<img src="${resource(dir:'images/icons',file:'flag_blue.png')}" alt="Sprint not started yet"/>
			</g:elseif>
			<g:else>
				<img src="${resource(dir:'images/icons',file:'flag_red.png')}" alt="Sprint is finished"/>
			</g:else>
		</td>
	</tr>
</table>