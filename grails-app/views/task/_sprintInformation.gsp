<h3>Sprint informations</h3>
<table>
	<tr>
		<th>Sprint</th>
		<th>Goal</th>
		<th>Start</th>
		<th>End</th>
		<th style="text-align:center;">Number of Tasks</th>
	    <th style="text-align:center;">Total effort</th>
	    <th style="text-align:center;">Total effort done</th>
	    <th style="text-align:center; width: 20px;">Active</th>
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