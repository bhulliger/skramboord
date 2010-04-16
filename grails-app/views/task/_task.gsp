<g:if test="${session.user.equals(task.user)}">
	<li id="taskId_${task.id}" class="ui-state-default" style=" border: 2px solid #009700;">
</g:if>
<g:else>
	<li id="taskId_${task.id}" class="ui-state-default">
</g:else>
	<g:link url="${task.url}" onclick="return ! window.open(this.href);" style="color: #${task.priority.toString()};">${task.name}</g:link>
	<div class="taskInfo">
		Effort: ${task.effort}<br/>
		<g:if test="${task.user}">
			Person: ${task.user.userRealName}
		</g:if>
	</div>
</li>