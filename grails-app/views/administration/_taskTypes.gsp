<div class="list">
	<g:form>
		<table>
			<tr>
				<g:sortableColumn params="[priorities:true]" property="name" defaultOrder="asc" title="${message(code:'task.type')}"/>
				<g:sortableColumn params="[priorities:true]" property="color" defaultOrder="asc" title="${message(code:'task.color')}" style="width: 160px;"/>
			</tr>
			<g:each var="taskType" in="${flash.taskTypes}" status="i">
				<g:def var="taskTypeId" value="${taskType.id}"/>
				<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
					<td style="vertical-align: middle;"><g:message code="taskTypes.${taskType.name}"/></td>
					<td>
						<div class="postit-right-${taskType.color} readonly">
							<div class="postit-${taskType.color}">
								<g:select name="taskType_${taskType.id}" from="${flash.taskTypeColors}" value="${taskType.color}" valueMessagePrefix="taskTypeColors"/>
							</div>
						</div>
					</td>
				</tr>
			</g:each>
		</table>
		<div class="buttons">
			<span class="button"><g:actionSubmit class="cancel" action="list" value="${message(code:'default.button.cancel.label')}" /></span>
			<span class="button"><g:actionSubmit class="save" action="saveTaskTypes" value="${message(code:'default.button.save.label')}" /></span>
		</div>
	</g:form>
</div>