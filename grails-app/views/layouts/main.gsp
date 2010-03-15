<html>
    <head>
        <title><g:layoutTitle default="Skramboord" /></title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'css/themes/skramboord',file:'jquery.ui.all.css')}" >
        <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
        <g:layoutHead />
    </head>
    <body>
    	<div id="content">
	        <div id="spinner" class="spinner" style="display:none;">
	            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner"/>
	        </div>
	        <div id="grailsLogo" class="logo"><a href="http://github.com/pablohess/skramboord" target="_blank">
	        	<img src="${resource(dir:'images/skramboord',file:'skramboord.logo.glossy.small.png')}" border="0" alt="Logo Skramboord"/></a>
	        </div>
	    
        	<g:layoutBody />
        </div>
    </body>
</html>