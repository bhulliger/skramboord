<div class="list">
    <script language="javascript" type="text/javascript">
        function checkRadioButton()
        {
            document.getElementById("newLogo").checked = true;
            document.getElementById("logo").checked = false;
            document.getElementById("${org.skramboord.SystemPreferences.APPLICATION_NAME}").checked = false;
        }
    </script>


	<g:form enctype="multipart/form-data" >
		<h3><g:message code="appearance.theme"/></h3>
		<table>
			<tr>
				<th style="width: 20px;"></th>
				<g:sortableColumn params="[priorities:true]" property="name" defaultOrder="asc" title="${message(code:'appearance.name')}"/>
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
		
		<h3><g:message code="appearance.logo"/></h3>
		<table>
			<tr>
				<th style="width: 20px;"></th>
				<g:sortableColumn params="[priorities:true]" property="name" defaultOrder="asc" title="${message(code:'appearance.name')}"/>
				<th></th>
				<th></th>
			</tr>
			<tr>
				<td style="vertical-align: middle;">
					<g:if test="${!session.logo}">
						<g:radio id="${org.skramboord.SystemPreferences.APPLICATION_NAME}" name="logo" value="${org.skramboord.SystemPreferences.APPLICATION_NAME}" checked="true"/>
					</g:if>
					<g:else>
						<g:radio id="${org.skramboord.SystemPreferences.APPLICATION_NAME}" name="logo" value="${org.skramboord.SystemPreferences.APPLICATION_NAME}"/>
					</g:else>
				</td>
				<td style="vertical-align: middle;">${org.skramboord.SystemPreferences.APPLICATION_NAME}</td>
				<td style="vertical-align: middle;"><img src="${resource(dir:'images/skramboord',file:'skramboord.logo.glossy.small.png')}" alt="Logo Skramboord" height="40px"/></td>
				<td></td>
			</tr>
			<g:if test="${session.logo}">
				<tr>
					<td style="vertical-align: middle;"><g:radio id="logo" name="logo" value="logo" checked="true"/></td>
					<td style="vertical-align: middle;">${session.logo.name}</td>
					<td style="vertical-align: middle;"><img src="${createLink(controller:'user', action:'showImage', id: session.logo.id)}" height="40px"/></td>
					<td></td>
				</tr>
			</g:if>
			<tr>
				<td style="vertical-align: middle;"><g:radio id="newLogo" name="logo" value="newLogo"/></td>
				<td style="vertical-align: middle;">
					<input type="text" name="logoName" id="logoName" onClick="checkRadioButton()" class="text ui-widget-content ui-corner-all"/>
				</td>
				<td style="vertical-align: middle;">
					<input type="file" name="logoFile" id="logoFile" onClick="checkRadioButton()"/>
				</td>
				<td style="vertical-align: middle;">
					<div style="font-size:0.8em;">
						<g:message code="appearance.fileGuidelines"/>
				    </div>
				</td>
			</tr>
		</table>
		
		<div class="buttons">
			<span class="button"><g:actionSubmit class="cancel" action="list" value="${message(code:'default.button.cancel.label')}" /></span>
			<span class="button"><g:actionSubmit class="save" action="saveAppearance" value="${message(code:'default.button.save.label')}" /></span>
		</div>
	</g:form>
</div>
								
