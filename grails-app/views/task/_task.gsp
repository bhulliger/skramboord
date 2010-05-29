<li id="taskId_${task.id}" style="margin: 0; padding: 0;">
	<div class="postit-right">
		<div class="postit">
			<g:link url="${task.url}" onclick="return ! window.open(this.href);" style="color: #${task.priority.toString()};">${task.name}</g:link>
			<g:if test="${authenticateService.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(session.project.owner) || session.user.equals(session.project.master)}">
				<div style="float: right;">
					<g:link controller="task" action="edit" params="[task: task.id]">
						<span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span><span class="icon"></span>
					</g:link>
					<g:link controller="task" action="delete" params="[task: task.id]" onclick="return confirm(unescape('Are you sure to delete task %22${task.name}%22?'));">
						<span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="delete"/></span><span class="icon"></span>
					</g:link>
				</div>
			</g:if>
			
			<div class="taskInfo">
				Effort: ${task.effort}<br/>
				<g:if test="${task.user}">
					<g:if test="${session.user.equals(task.user)}">
						Person: <span style="color: #${task.user.taskColor}; font-weight:bold">${task.user.userRealName}</span>
					</g:if>
					<g:else>
						Person: ${task.user.userRealName}
					</g:else>
				</g:if>
			</div>
		</div>
	</div>
</li>