<div class="list">
	<g:form>
		<table>
			<tr>
				<th style="width: 20px;"></th>
				<g:sortableColumn params="[priorities:true]" property="name" defaultOrder="asc" title="${message(code:'theme.name')}"/>
			</tr>
			<g:each var="theme" in="${flash.themes}" status="i">
				<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
					<g:if test="${flash.themeActually.id.equals(theme.id)}">
						<td style="vertical-align: middle;"><g:radio name="themes" value="${theme.id}" checked="true"/></td>
					</g:if>
					<g:else>
						<td style="vertical-align: middle;"><g:radio name="themes" value="${theme.id}"/></td>
					</g:else>
					<td style="vertical-align: middle;"><g:message code="${theme.name}"/></td>
				</tr>
			</g:each>
		</table>
		<div class="buttons">
			<span class="button"><g:actionSubmit class="cancel" action="list" value="${message(code:'default.button.cancel.label')}" /></span>
			<span class="button"><g:actionSubmit class="save" action="saveThemes" value="${message(code:'default.button.save.label')}" /></span>
		</div>
	</g:form>
</div>
								
