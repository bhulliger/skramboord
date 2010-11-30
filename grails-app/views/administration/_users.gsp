<div class="list">
	<table>
		<thead>
			<tr>
				<g:sortableColumn params="[users:true]" property="username" title="${message(code:'user.loginName')}"/>
				<g:sortableColumn params="[users:true]" property="name" title="${message(code:'user.name')}" />
				<g:sortableColumn params="[users:true]" property="prename" title="${message(code:'user.prename')}" />
				<g:sortableColumn params="[users:true]" property="email" title="${message(code:'user.email')}" />
				<g:sortableColumn params="[users:true]" property="description" title="${message(code:'user.description')}" />
				<th style="width: 20px;"></th>
			</tr>
		</thead>
		<tbody>
			<g:each in="${flash.users}" status="i" var="person">
				<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
					<td>
						<g:link controller="user" action="edit" params="[id: person.id, fwdTo: '/administration/list']"><span class="icon"><img src="${resource(dir:'images/icons',file:'edit.png')}" alt="show"/></span><span class="icon">${person.username?.encodeAsHTML()}</span></g:link>
					</td>
					<td style="vertical-align: middle;">${person.name?.encodeAsHTML()}</td>
					<td style="vertical-align: middle;">${person.prename?.encodeAsHTML()}</td>
					<td style="vertical-align: middle;">${person.email?.encodeAsHTML()}</td>
					<td style="vertical-align: middle;">${person.description?.encodeAsHTML()}</td>
					<td>
						<g:link controller="user" action="delete" params="[id: person.id, fwdTo: '/administration/list']" onclick="return confirm('${message(code:'default.button.delete.confirm.message')}');"><span class="icon"><img src="${resource(dir:'images/icons',file:'delete.png')}" alt="delete"/></span><span class="icon"></span></g:link>
					</td>
				</tr>
			</g:each>
		</tbody>
	</table>
	<div class="buttons">
		<g:render template="../user/formNewUser" model="['fwdTo': '/administration/list']"/>
		<span class="button"><g:actionSubmit class="add" onclick="return openFormNewUser();" value="${message(code:'user.createUser')}" /></span>
	</div>
</div>