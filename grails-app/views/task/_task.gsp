<g:if test="${task.title?.size() > 0 || task.description?.size() > 0}">
	<% String tooltip = ""; %>
	<g:if test="${task.title?.size() > 0}">
		<% tooltip += "<b>${task.title}</b><br/>"; %>
	</g:if>
	<g:if test="${task.description?.size() > 0}">
		<% tooltip += "<br/>${task.description}"; %>
	</g:if>
	<li id="taskId_${task.id}" style="margin: 0; padding: 0;" class="tooltip" title="<%= tooltip %>">
</g:if>
<g:else>
	<li id="taskId_${task.id}" style="margin: 0; padding: 0;">
</g:else>

	<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.id.equals(session.project.owner.id) || session.user.id.equals(session.project.master.id)}">
		<div class="postit-right-${task.type.color}" onmouseover="changeClass('icons_${task.id}', 'iconsTaskEdit'); changeClass('taskNumber_${task.id}', 'taskNumberShort');"
	                              onmouseout="changeClass('icons_${task.id}', 'iconsTaskEditNone'); changeClass('taskNumber_${task.id}', 'taskNumber');">
    </g:if>
    <g:else>
		<div class="postit-right-${task.type.color} readonly">
    </g:else>
		<div class="postit-${task.type.color}">
			<div id="taskNumber_${task.id}" class="taskNumber">
				<g:link url="${task.url}" onclick="return ! window.open(this.href);" style="position:relative; z-index: 1; color: #${task.priority.colorAsString()}; font-size: 0.8em;">${task.number}</g:link>
			</div>
			
			<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.id.equals(session.project.owner.id) || session.user.id.equals(session.project.master.id)}">
				<div id="icons_${task.id}" class="iconsTaskEditNone" style="float: right; position:relative; z-index: 2; top: -15px; padding-right: 5px;">
					<g:link controller="task" action="edit" params="[task: task.id, fwdTo: fwdTo]">
						<span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span>
					</g:link>
					<g:link controller="task" action="delete" params="[task: task.id, fwdTo: fwdTo]" onclick="return confirm('${message(code:'task.delete', args: [task.number])}');">
						<span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="delete"/></span>
					</g:link>
				</div>
			</g:if>
			
			<div class="taskInfo">
				<g:message code="task.effort"/>: ${task.effort},<br>
				<g:if test="${task.user}">
					<g:if test="${session.user.equals(task.user)}">
						<g:message code="task.person"/>: <span style="color: #${task.user.taskColor}; font-weight:bold">${task.user.prename} ${task.user.name[0]}.</span>
					</g:if>
					<g:else>
						<g:message code="task.person"/>: ${task.user.prename} ${task.user.name[0]}.
					</g:else>
				</g:if>
			</div>
		</div>
	</div>
</li>