<script type="text/javascript">
	$(function() {
		// Task tooltip
		xOffset = 15;
		yOffset = 15;
		$("li.tooltip").hover(function(e){	
				this.t = this.title;
				this.title = "";									  
				$("body").append("<p id='tooltip' style='width:260pt;'>"+ this.t +"</p>");
				$("#tooltip").css("top",(e.pageY - xOffset) + "px")
                             .css("left",(e.pageX + yOffset) + "px")
                             .fadeIn("fast");
	    	},
			function(){
				this.title = this.t;
				$("#tooltip").remove();});	
		$("li.tooltip").mousemove(function(e){
			$("#tooltip")
				.css("top",(e.pageY - xOffset) + "px")
				.css("left",(e.pageX + yOffset) + "px");
		});
		
<g:if test="${flash.scrumMaster}">
		$("#backlog").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'copyTaskToBacklog') }
		}).disableSelection();	
</g:if>
<g:if test="${flash.teammate}">
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

// Product Backlog
<g:if test="${session.enableBacklog}">
		document.getElementById("scrumboard").style.width = "660px";
</g:if>
<g:else>
$("#productBacklog").hide();
		document.getElementById("scrumboard").style.width = "900px";
</g:else>
	});

	function toggleProductBacklog(){
		if ($("#productBacklog").is(":hidden")) {
			document.getElementById("scrumboard").style.width = "660px";
    		$("#productBacklog").toggle(500);
			${remoteFunction(controller: 'task', action:'enableBacklog', params:[enableBacklog: 'true'])}
    	} else {
    		document.getElementById("scrumboard").style.width = "900px";
    		$("#productBacklog").toggle();
    		${remoteFunction(controller: 'task', action:'enableBacklog', params:[enableBacklog: 'false'])}
    	}
	}
	
<g:if test="${flash.teammate}">
	function changeTo(event, ui, stateMethod){
		location.href="${request.contextPath}/task/" + stateMethod + "?taskId=" + $(ui.item).attr("id");
	}

	function openNewTaskForm(){
		$('#dialog-form').dialog('open');
	}
</g:if>
</script>

<div>
	<g:if test="${flash.taskEdit}">
		<g:render template="formEditTask" model="['fwdTo': 'task']"/>
	</g:if>
	<g:elseif test="${session.sprint.isSprintActive()}">
		<g:render template="formNewTask" model="['fwdTo': 'task', 'target': 'sprint']"/>
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
					<g:render template="task" model="['task':task, 'fwdTo': 'task']"/>
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
					<g:render template="task" model="['task':task, 'fwdTo': 'task']"/>
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
					<g:render template="task" model="['task':task, 'fwdTo': 'task']"/>
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
					<g:render template="task" model="['task':task, 'fwdTo': 'task']"/>
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
						<g:render template="task" model="['task':task, 'fwdTo': 'task']"/>
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
						<g:render template="task" model="['task':task, 'fwdTo': 'task']"/>
					</g:each>
				</ul>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>