<script type="text/javascript">
	$(function() {
<g:if test="${flash.teammate}">
		$("#backlog").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'copyTaskToBacklog') }
		}).disableSelection();
		$("#open").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToOpen') }
		}).disableSelection();
		$("#checkout").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToCheckOut') }
		}).disableSelection();
		$("#done").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToDone') }
		}).disableSelection();
		$("#next").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToNext') }
		}).disableSelection();
		$("#standBy").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToStandBy') }
		}).disableSelection();
</g:if>
	});

	function toggleProductBacklog(){
		if ($("#productBacklog").is(":hidden")) {
    		$.cookie('showProductBacklog', 'show')
    		document.getElementById("scrumboard").style.width = "660px";
    		$("#productBacklog").toggle(500);
    	} else {
    		$.cookie('showProductBacklog', 'hide')
    		document.getElementById("scrumboard").style.width = "900px";
    		$("#productBacklog").toggle();
    	}
	}
	
<g:if test="${flash.teammate}">
	function changeTo(event, ui, stateMethod){
		location.href="/${meta(name: "app.name")}/task/" + stateMethod + "?taskId=" + $(ui.item).attr("id");
	}

	function openNewTaskForm(){
		$('#dialog-form').dialog('open');
	}
</g:if>
</script>

<div>
	<g:if test="${flash.taskEdit}">
		<g:render template="formEditTask"/>
	</g:if>
	<g:elseif test="${session.sprint.isSprintActive()}">
		<g:render template="formNewTask"/>
	</g:elseif>

	<div class="buttons">
		<span class="button">
			<g:if test="${flash.teammate}">
				<g:actionSubmit class="add" onclick="openNewTaskForm();" value="${message(code:'task.createTask')}"/>
			</g:if>
			<g:actionSubmit class="table" onclick="toggleProductBacklog();" value="${message(code:'project.backlog.button', args: [flash.projectBacklog.size()])}" />
		</span>
	</div>
	
	<div class="clear"></div>
	
	<div class="backlog" id="productBacklog">
		<div class="boardheader"><g:message code="project.backlog"/></div>
		<div style="height: 500px; overflow: auto;">
			<g:if test="${flash.projectBacklog.size() > 0}">
				<ul id="backlog" class="connectedSortable">
			</g:if>
			<g:else>
				<ul id="backlog" class="connectedSortable" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.projectBacklog}" status="i">
					<g:render template="task" model="['task':task]"/>
				</g:each>
			</ul>
		</div>
	</div>
	
	<div class="scrumboard" id="scrumboard">
		<div class="open">
			<div class="boardheader"><g:message code="task.open"/></div>
			<g:if test="${flash.taskListOpen.size() > 0}">
				<ul id="open" class="connectedSortable">
			</g:if>
			<g:else>
				<ul id="open" class="connectedSortable" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.taskListOpen}" status="i">
					<g:render template="task" model="['task':task]"/>
				</g:each>
			</ul>
		</div>
		
		<div class="checkout">
			<div class="boardheader"><g:message code="task.checkout"/></div>
			<g:if test="${flash.taskListCheckout.size() > 0}">
				<ul id="checkout" class="connectedSortable">
			</g:if>
			<g:else>
				<ul id="checkout" class="connectedSortable" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.taskListCheckout}" status="i">
					<g:render template="task" model="['task':task]"/>
				</g:each>
			</ul>
		</div>
		
		<div class="done">
			<div class="boardheader"><g:message code="task.done"/></div>
			<g:if test="${flash.taskListDone.size() > 0}">
				<ul id="done" class="connectedSortable">
			</g:if>
			<g:else>
				<ul id="done" class="connectedSortable" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.taskListDone}" status="i">
					<g:render template="task" model="['task':task]"/>
				</g:each>
			</ul>
		</div>
		
		<div class="nextStandBy">
			<div class="next">
				<div class="boardheader"><g:message code="task.next"/></div>
				<g:if test="${flash.taskListNext.size() > 0}">
					<ul id="next" class="connectedSortable">
				</g:if>
				<g:else>
					<ul id="next" class="connectedSortable" style="padding-bottom: 100px;">
				</g:else>
					<g:each var="task" in="${flash.taskListNext}" status="i">
						<g:render template="task" model="['task':task]"/>
					</g:each>
				</ul>
			</div>
			
			<div class="standBy">
				<div class="boardheader"><g:message code="task.standby"/></div>
				<g:if test="${flash.taskListStandBy.size() > 0}">
					<ul id="standBy" class="connectedSortable">
				</g:if>
				<g:else>
					<ul id="standBy" class="connectedSortable" style="padding-bottom: 100px;">
				</g:else>
					<g:each var="task" in="${flash.taskListStandBy}" status="i">
						<g:render template="task" model="['task':task]"/>
					</g:each>
				</ul>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>