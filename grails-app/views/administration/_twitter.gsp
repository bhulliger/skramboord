<g:form controller="administration">
	<g:if test="${flash.twitterAppSettings}">
		<g:if test="${flash.twitterAppSettings.enabled}">
			<span class="icon"><img src="${resource(dir:'images/icons',file:'accept.png')}"/></span><span class="icon"><g:message code="twitter.appEnabled"/></span>
		</g:if>
		<g:else>
			<span class="icon"><img src="${resource(dir:'images/icons',file:'error.png')}"/></span><span class="icon"><g:message code="twitter.appDisabled"/></span>
		</g:else>
		<div class="buttons">
			<g:if test="${flash.twitterAppSettings.enabled}">
				<span class="button"><g:actionSubmit class="disconnect" action="disableTwitterSettings" value="${message(code:'default.button.twitter.disable.label')}" /></span>
			</g:if>
			<g:else>
				<span class="button"><g:actionSubmit class="connect" action="enableTwitterSettings" value="${message(code:'default.button.twitter.enable.label')}" /></span>
			</g:else>
			<span class="button"><g:actionSubmit class="delete" action="removeTwitterSettings" value="${message(code:'default.button.twitter.deleteApp.label')}" /></span>
		</div>
	</g:if>
	<g:else>
		<ol>
			<li class="twitter">
				<g:message code="twitter.visiteUrl"/>
				<a href="${message(code:'twitter.registerNewApp')}" onclick="return ! window.open(this.href);"><g:message code="twitter.clickHere"/></a>
			</li>
			<li class="twitter"><g:message code="twitter.entryRandomAppName"/> <b>${flash.twitterRandomAppName}</b></li>
			<li class="twitter"><g:message code="twitter.changeApplicationType"/></li>
			<li class="twitter"><g:message code="twitter.defaultAccessType"/></li>
			<li class="twitter"><g:message code="twitter.finishApplicationRegistration"/></li>
			<li class="twitter">
				<g:message code="twitter.copyConsumerKey"/>
				<input type="text" name="twitterConsumerKey" id="twitterConsumerKey" class="text ui-widget-content ui-corner-all" value="${flash?.twitterAppSettings?.consumerKey}"/>
			</li>
			<li class="twitter">
				<g:message code="twitter.copyConsumerSecret"/>
				<input type="text" name="twitterConsumerSecret" id="twitterConsumerSecret" class="text ui-widget-content ui-corner-all" value="${flash?.twitterAppSettings?.consumerSecret}"/>
			</li>
		</ol>
		<div class="buttons">
			<span class="button"><g:actionSubmit class="add" action="saveTwitterSettings" value="${message(code:'default.button.twitter.add.label')}" /></span>
		</div>
	</g:else>
</g:form>