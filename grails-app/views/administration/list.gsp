<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />

		<link rel="stylesheet" type="text/css" href="${resource(dir:'css/colorpicker',file:'colorpicker.css')}" ></link>

		<script type="text/javascript" src="${resource(dir:'js/jquery',file:'jquery-1.4.2.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.widget.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.mouse.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.dialog.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.position.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.resizable.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.button.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.effects.core.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/ui',file:'jquery.ui.tabs.js')}"></script>
		<script type="text/javascript" src="${resource(dir:'js/jquery/colorpicker',file:'colorpicker.js')}"></script>

		<script type="text/javascript">
			$(function() {
				$('#create-project')
					.button()
					.click(function() {
						$('#dialog-form-project').dialog('open');
				});

				$("#tabs").tabs();
			});
		</script>
	</head>
	<body>
		<div class="body">
			<h1><g:link controller="project" action="list">> <img src="${resource(dir:'images/skin',file:'house.png')}" alt="Home"/> </g:link><g:link controller="administration" action="list">> System Preferences</g:link></h1>          
			
			<div id="tabs">
				<ul>
					<li><a href="#tab-priorities">Priorities</a></li>
				</ul>
				<div id="tab-priorities">
					<g:render template="priorities"/>
				</div>
			</div>
		</div>
	</body>
</html>