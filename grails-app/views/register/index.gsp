<head>
	<meta name="layout" content="main" />
	<title>User Registration</title>
</head>

<body>

	<div class="nav">
		<span class="menuButton"><a class='home' href="${createLinkTo(dir:'')}">Home</a></span>
	</div>

	<div class="body">
		<h1>User Registration</h1>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>
		<g:hasErrors bean="${person}">
		<div class="errors">
			<g:renderErrors bean="${person}" as="list" />
		</div>
		</g:hasErrors>

		<g:form action="save">
		<div class="dialog">
		<table>
		<tbody>

			<tr class='prop'>
				<td valign='top' class='name'><label for='username'>Login Name:</label></td>
				<td valign='top' class='value ${hasErrors(bean:person,field:'username','errors')}'>
					<input type="text" name='username' value="${person?.username?.encodeAsHTML()}"/>
				</td>
			</tr>

			<tr class='prop'>
				<td valign='top' class='name'><label for='prename'>First Name:</label></td>
				<td valign='top' class='value ${hasErrors(bean:person,field:'prename','errors')}'>
					<input type="text" name='prename' value="${person?.prename?.encodeAsHTML()}"/>
				</td>
			</tr>
			
			<tr class='prop'>
				<td valign='top' class='name'><label for='name'>Name:</label></td>
				<td valign='top' class='value ${hasErrors(bean:person,field:'name','errors')}'>
					<input type="text" name='name' value="${person?.name?.encodeAsHTML()}"/>
				</td>
			</tr>

			<tr class='prop'>
				<td valign='top' class='name'><label for='password'>Password:</label></td>
				<td valign='top' class='value ${hasErrors(bean:person,field:'password','errors')}'>
					<input type="password" name='password' value="${person?.password?.encodeAsHTML()}"/>
				</td>
			</tr>

			<tr class='prop'>
				<td valign='top' class='name'><label for='enabled'>Confirm Password:</label></td>
				<td valign='top' class='value ${hasErrors(bean:person,field:'password','errors')}'>
					<input type="password" name='repassword' value="${person?.password?.encodeAsHTML()}"/>
				</td>
			</tr>

			<tr class='prop'>
				<td valign='top' class='name'><label for='email'>Email:</label></td>
				<td valign='top' class='value ${hasErrors(bean:person,field:'email','errors')}'>
					<input type="text" name='email' value="${person?.email?.encodeAsHTML()}"/>
				</td>
			</tr>

			<tr class='prop'>
				<td valign='bottom' class='name'><label for='code'>Enter Code: </label></td>
				<td valign='top' class='name'>
					<input type="text" name="captcha" size="8"/>
					<img src="${createLink(controller:'captcha', action:'index')}" align="absmiddle"/>
				</td>
			</tr>

		</tbody>
		</table>
		</div>

		<div class="buttons">
			<span class="formButton">
				<input class='save' type="submit" value="Create"></input>
			</span>
		</div>

		</g:form>
	</div>
</body>
