<g:form controller="project">
	<g:if test="${flash.twitterAccessUrl}">
		<ol>
			<li class="twitter">
				<g:message code="twitter.visiteUrl"/>
				<a href="${flash.twitterAccessUrl}" onclick="return ! window.open(this.href);"><g:message code="twitter.clickHere"/></a>
			</li>
			<li class="twitter"><g:message code="twitter.loginOnTwitter"/></li>
			<li class="twitter">
				<g:message code="twitter.pastePin"/>
				<input type="text" name="twitterAccessPin" id="twitterAccessPin" class="text ui-widget-content ui-corner-all"/>
			</li>
			<li class="twitter"><g:message code="twitter.save"/></li>
		</ol>
		
		<div class="buttons">
			<span class="button"><g:actionSubmit class="save" action="createTwitterAccount" value="${message(code:'default.button.save.label')}" /></span>
		</div>
	</g:if>
	<g:else>
		<g:if test="${session.project.twitter}">
			<g:if test="${session.project.twitter.enabled}">
				<span class="icon"><img src="${resource(dir:'images/icons',file:'accept.png')}"/></span><span class="icon"><g:message code="twitter.enabled"/></span>
			</g:if>
			<g:else>
				<span class="icon"><img src="${resource(dir:'images/icons',file:'error.png')}"/></span><span class="icon"><g:message code="twitter.disabled"/></span>
			</g:else>
			<div class="buttons">
				<g:if test="${session.project.twitter.enabled}">
					<span class="button"><g:actionSubmit class="disconnect" action="disableTwitter" value="${message(code:'default.button.twitter.disable.label')}" /></span>
				</g:if>
				<g:else>
					<span class="button"><g:actionSubmit class="connect" action="enableTwitter" value="${message(code:'default.button.twitter.enable.label')}" /></span>
				</g:else>
				<span class="button"><g:actionSubmit class="delete" action="removeTwitter" value="${message(code:'default.button.twitter.delete.label')}" /></span>
			</div>
		</g:if>
		<g:else>
			<g:message code="twitter.noAccount"/>
			
			<div class="buttons">
				<span class="button"><g:actionSubmit class="add" action="addTwitter" value="${message(code:'default.button.twitter.add.label')}" /></span>
			</div>
		</g:else>
	</g:else>
	
	<input type="hidden" name="projectId" value="${session.project.id}" style="border-style: none;"/>
</g:form>