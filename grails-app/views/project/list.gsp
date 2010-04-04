<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		<title>Skramboord</title>
		
		<style type="text/css">
			label, input { display:block; }
			input.text { margin-bottom:12px; width:95%; padding: .4em; }
			fieldset { padding:0; border:0; margin-top:25px; }
			div#users-contain { width: 350px; margin: 20px 0; }
			div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
			div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
			.ui-dialog .ui-state-error { padding: .3em; }
			.validateTips { border: 1px solid transparent; padding: 0.3em; }
		</style>
		
		<script type="text/javascript" src="${resource(dir:'js/jquery',file:'jquery-1.4.2.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.widget.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.mouse.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.draggable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.sortable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.droppable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.dialog.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.position.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.resizable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.button.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.effects.core.js')}"></script>
		
		<script type="text/javascript">
			$(function() {
				$("#dialog-form-project").dialog({
					autoOpen: false,
					height: 200,
					width: 500,
					modal: true,
					buttons: {
						'Save': function() {
							document.forms["myform"].submit();
							$(this).dialog('close');
						},
						Cancel: function() {
							location.reload(true);
							$(this).dialog('close');
						}
					}
				});
			
				$('#create-project')
					.button()
					.click(function() {
						$('#dialog-form-project').dialog('open');
				});				
			});
		</script>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home" border="0"/></g:link></h1>
			<h3>Project List</h3>
			<div id="dialog-form-project" title="Create new project">
				<g:form name="myform" action="addProject">
					<fieldset>
						<label for="name">Project</label>
						<input type="text" name="projectName" id="projectName" class="text ui-widget-content ui-corner-all"/>
				</g:form>
			</div>
			<g:submitButton name="create-project" value="Create project"/>
			
			<g:hasErrors bean="${flash.project}">
				<div class="errors">
					<g:renderErrors bean="${flash.project}" as="list"/>
				</div>
			</g:hasErrors>
			<div class="list">
				<table>
					<tr>
						<g:sortableColumn property="name" defaultOrder="asc" title="Project"/>
						<g:sortableColumn property="sprints" defaultOrder="desc" title="Sprints"/>
					</tr>
					<g:each var="project" in="${session.projectList}" status="i">
						<g:def var="projectId" value="${project.id}"/>
						<tr>
							<td>
								<g:link controller="sprint" action="list" params="[project: projectId]"><span id="icon"><img src="${resource(dir:'images/icons',file:'magnifier.png')}" alt="edit" border="0"/></span><span id="icon">${project.name}</span></g:link>
							</td>
							<td style="text-align:center;">${project.sprints.size()}</td>
						</tr>
					</g:each>
				</table>
			</div>
		</div>
	</body>
</html>