<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />

		<script type="text/javascript">
			$(function() {
				$('#create-project')
					.button()
					.click(function() {
						$('#dialog-form-project').dialog('open');
				});

				var selectTab = ${session?.tabs?.get('administration')?session.tabs.get('administration'):'0'};
				$("#tabs").tabs({
					selected: selectTab
				});
			});
		</script>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="administration" action="list">> <g:message code="admin.systemPreferences"/></g:link></h1>          
			<g:hasErrors bean="${flash.objectToSave}">
				<div class="errors">
					<g:renderErrors bean="${flash.objectToSave}" as="list"/>
				</div>
			</g:hasErrors>
			<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
			</g:if>
			
			<div id="tabs">
				<ul>
					<li><a href="#tab-0" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'administration', tabName: '0'])}"><g:message code="admin.userList"/></a></li>
					<li><a href="#tab-1" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'administration', tabName: '1'])}"><g:message code="admin.appearance"/></a></li>
					<li><a href="#tab-2" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'administration', tabName: '2'])}"><g:message code="admin.priorities"/></a></li>
					<li><a href="#tab-3" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'administration', tabName: '3'])}"><g:message code="admin.taskTypes"/></a></li>
					<li><a href="#tab-4" onclick="${remoteFunction(controller: 'user', action:'tabChange', params:[viewName: 'administration', tabName: '4'])}"><g:message code="twitter"/></a></li>
				</ul>
				<div id="tab-0">
					<g:render template="users"/>
				</div>
				<div id="tab-1">
					<g:render template="appearance"/>
				</div>
				<div id="tab-2">
					<g:render template="priorities"/>
				</div>
				<div id="tab-3">
					<g:render template="taskTypes"/>
				</div>
				<div id="tab-4">
					<g:render template="twitter"/>
				</div>
			</div>
		</div>
	</body>
</html>