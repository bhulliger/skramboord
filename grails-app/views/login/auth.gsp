<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta name='layout' content='main' />
	
	<style type='text/css' media='screen'>
		#login {
			margin:15px 0px; padding:0px;
			text-align:center;
		}
		#login .inner {
			width:300px;
			margin:0px auto;
			text-align:left;
			background-color:#ffffff;
		}
		#login .inner .fheader {
			padding-left: 15px;
			padding-bottom: 10px;
			margin:3px 0px 3px 0;
			color:#2e3741;
			font-size:14px;
			font-weight:bold;
		}
		#login .inner .cssform p {
			clear: left;
			padding-left: 135px;
			height: 1%;
		}
		#login .inner .cssform input[type='text'] {
			width: 120px;
		}
		#login .inner .cssform label {
			font-weight: bold;
			float: left;
			margin-left: -120px;
			width: 140px;
		}
		#login .inner .login_message {color:red;}
		#login .inner .text_ {width:120px;}
		#login .inner .chk {height:12px; border: none;}
	</style>
</head>

<body>
	<div class="body">
	<div id='login'>
		<div class='inner'>
			<g:if test='${flash.message}'>
			<div class='login_message'>${flash.message}</div>
			</g:if>
			<div class='fheader'><g:message code="admin.pleaseLogin"/></div>
			<form action='${postUrl}' method="post" id='loginForm' class='cssform'>
				<p>
					<label for='j_username'><g:message code="user.loginName"/></label>
					<input type='text' class='text_' name='j_username' id='j_username' value='${request.remoteUser}' />
				</p>
				<p>
					<label for='j_password'><g:message code="user.password"/></label>
					<input type='password' class='text_' name='j_password' id='j_password' />
				</p>
				<p>
					<label for='remember_me'><g:message code="admin.rememberMe"/></label>
					<input type='checkbox' class='chk' name='_spring_security_remember_me' id='remember_me' <g:if test='${hasCookie}'>checked='checked'</g:if> />
				</p>
				<p>
					<input type='submit' value="${message(code:'default.button.login.label')}"/>
				</p>
			</form>
		</div>
	</div>
	</div>
<script type='text/javascript'>
<!--
(function(){
	document.forms['loginForm'].elements['j_username'].focus();
})();
// -->
</script>
</body>
