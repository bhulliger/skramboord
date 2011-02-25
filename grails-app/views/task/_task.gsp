<g:if test="${task.description?.size() > 0}">
	<li id="taskId_${task.id}" style="margin: 0; padding: 0;" title="<b>${message(code:'task.description')}:</b><br/>${task.description}" class="tooltip">
</g:if>
<g:else>
	<li id="taskId_${task.id}" style="margin: 0; padding: 0;">
</g:else>
	<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.id.equals(session.project.owner.id) || session.user.id.equals(session.project.master.id)}">
		<div class="postit-right-${task.type.color}" onmouseover="document.getElementById('icons_${task.id}').setAttribute('class', 'iconsTaskEdit')"
	                              onmouseout="document.getElementById('icons_${task.id}').setAttribute('class', 'iconsTaskEditNone')">
    </g:if>
    <g:else>
		<div class="postit-right-${task.type.color} readonly" onmouseover="document.getElementById('icons_${task.id}').setAttribute('class', 'iconsTaskEdit')"
	                              onmouseout="document.getElementById('icons_${task.id}').setAttribute('class', 'iconsTaskEditNone')">
    </g:else>
		<div class="postit-${task.type.color}">
			<g:if test="${task.name.size() < 40}">
				<g:link url="${task.url}" onclick="return ! window.open(this.href);" style="color: #${task.priority.colorAsString()}; font-size: 1em;">${task.name}</g:link>
			</g:if>
			<g:elseif test="${task.name.size() < 50}">
				<g:link url="${task.url}" onclick="return ! window.open(this.href);" style="color: #${task.priority.colorAsString()}; font-size: 0.8em;">${task.name}</g:link>
			</g:elseif>
			<g:else>
				<g:link url="${task.url}" onclick="return ! window.open(this.href);" style="color: #${task.priority.colorAsString()}; font-size: 0.8em;">${task.name[0..47]}...</g:link>
			</g:else>
			<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.id.equals(session.project.owner.id) || session.user.id.equals(session.project.master.id)}">
				<div id="icons_${task.id}" class="iconsTaskEditNone" style="float: right;">
					<g:link controller="task" action="edit" params="[task: task.id, fwdTo: fwdTo]">
						<span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="edit"/></span>
					</g:link>
					<g:link controller="task" action="delete" params="[task: task.id, fwdTo: fwdTo]" onclick="return confirm('${message(code:'task.delete', args: [task.name])}');">
						<span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="delete"/></span>
					</g:link>
				</div>
			</g:if>
			
			<div class="taskInfo">
				<g:message code="task.effort"/>: ${task.effort},
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