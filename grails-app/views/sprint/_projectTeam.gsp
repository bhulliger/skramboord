<script type="text/javascript">
	$(function() {
<g:if test="${org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils.ifAnyGranted('ROLE_SUPERUSER') || session.user.equals(flash.project.owner) || session.user.equals(flash.project.master)}">
		$("#poductOwner").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'movePersonToProdctOwner') }
		}).disableSelection();
		$("#scrumMaster").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'movePersonToScrumMaster') }
		}).disableSelection();
		$("#developers").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'movePersonToDevelopers') }
		}).disableSelection();
		$("#followers").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'movePersonToFollowers') }
		}).disableSelection();
		$("#users").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'movePersonToUsers') }
		}).disableSelection();
	});

	function changeTo(event, ui, stateMethod){
		location.href="${request.contextPath}/project/${flash.project.id}/sprint/" + stateMethod + "?personId=" + $(ui.item).attr("id");
	}
</g:if>
</script>

<div class="projectTeam">
	<div class="poductOwner">
		<div class="boardheader"><g:message code="project.owner"/></div>
		<ul id="poductOwner" class="connectedSortable">
			<li id="personId_${flash.project.owner.id}" style="margin: 0; padding: 0;">
				<g:render template="person" model="['person':flash.project.owner]"/>
			</li>
		</ul>
	</div>
	<div class="clear"></div>
	
	<div class="scrumMaster">
		<div class="boardheader"><g:message code="project.master"/></div>
		<ul id="scrumMaster" class="connectedSortable">
			<li id="personId_${flash.project.master.id}" style="margin: 0; padding: 0;">
				<g:render template="person" model="['person':flash.project.master]"/>
			</li>
		</ul>
	</div>
	<div class="clear"></div>
	
	<div class="developers">
		<div class="boardheader"><g:message code="project.developers"/></div>
		<g:if test="${flash.teamList.size() > 0}">
			<ul id="developers" class="connectedSortable">
		</g:if>
		<g:else>
			<ul id="developers" class="connectedSortable" style="padding-bottom: 100px;">
		</g:else>
			<g:each in="${flash.teamList}" status="i" var="person">
				<g:if test="${(person.id != flash.project.master.id) && (person.id != flash.project.owner.id)}">
					<li id="personId_${person.id}" style="margin: 0; padding: 0;">
						<g:render template="person" model="['person':person]"/>
					</li>
				</g:if>
			</g:each>
		</ul>
	</div>
	<div class="clear"></div>
</div>

<div class="projectTeam">
	<div class="followers">
		<div class="boardheader"><g:message code="project.followers"/></div>
		<g:if test="${flash.watchList.size() > 0}">
			<ul id="followers" class="connectedSortable">
		</g:if>
		<g:else>
			<ul id="followers" class="connectedSortable" style="padding-bottom: 100px;">
		</g:else>
			<g:each in="${flash.watchList}" status="i" var="person">
				<li id="personId_${person.id}" style="margin: 0; padding: 0;">
					<g:render template="person" model="['person':person]"/>
				</li>
			</g:each>
		</ul>
	</div>
	<div class="clear"></div>
</div>

<div class="projectTeam">
	<div class="users">
		<div class="boardheader"><g:message code="admin.userList"/></div>
		<g:if test="${flash.personList.size() > 0}">
			<ul id="users" class="connectedSortable">
		</g:if>
		<g:else>
			<ul id="users" class="connectedSortable" style="padding-bottom: 100px;">
		</g:else>
			<g:each in="${flash.personList}" status="i" var="person">
				<li id="personId_${person.id}" style="margin: 0; padding: 0;">
					<g:render template="person" model="['person':person]"/>
				</li>
			</g:each>
		</ul>
	</div>
	<div class="clear"></div>
</div>

<div class="clear"></div>