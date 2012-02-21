<script type="text/javascript">
	$(function() {
<g:if test="${flash.teammate}">
		$("#immediate").sortable({
			connectWith: '.connectedSortableProductBacklog',
			dropOnEmpty: true,
			receive: function(event, ui) { changePrioTo(event, ui, 'changeTaskPrio', "${org.skramboord.Priority.IMMEDIATE}") }
		}).disableSelection();
		$("#urgent").sortable({
			connectWith: '.connectedSortableProductBacklog',
			dropOnEmpty: true,
			receive: function(event, ui) { changePrioTo(event, ui, 'changeTaskPrio', "${org.skramboord.Priority.URGENT}") }
		}).disableSelection();
		$("#high").sortable({
			connectWith: '.connectedSortableProductBacklog',
			dropOnEmpty: true,
			receive: function(event, ui) { changePrioTo(event, ui, 'changeTaskPrio', "${org.skramboord.Priority.HIGH}") }
		}).disableSelection();
		$("#normal").sortable({
			connectWith: '.connectedSortableProductBacklog',
			dropOnEmpty: true,
			receive: function(event, ui) { changePrioTo(event, ui, 'changeTaskPrio', "${org.skramboord.Priority.NORMAL}") }
		}).disableSelection();
		$("#low").sortable({
			connectWith: '.connectedSortableProductBacklog',
			dropOnEmpty: true,
			receive: function(event, ui) { changePrioTo(event, ui, 'changeTaskPrio', "${org.skramboord.Priority.LOW}") }
		}).disableSelection();
</g:if>
	});

    function changeClass(id, clazz) {
    	document.getElementById(id).setAttribute('class', clazz);
    }
	
<g:if test="${flash.teammate}">
	function changePrioTo(event, ui, stateMethod, priority){
		location.href="${request.contextPath}/project/${flash.project.id}/sprint/0/task/" + stateMethod + "?taskId=" + $(ui.item).attr("id") + "&taskPrio=" + priority;
	}

	function openNewTaskForm(){
		$('#dialog-form').dialog('open');
	}
	function openImportTasksForm(){
		$('#dialog-import-form').dialog('open');
	}

</g:if>
<g:if test="${flash.importReport}">
	$(function() {
	    $("#dialog-csv-form").dialog({
	        width: 500,
	        modal: true,
	        buttons: {
	            '<g:message code="default.button.import.label"/>': function() {
	                document.getElementById("formImportTasks").submit();
	                $(this).dialog('close');
	            },
	            '<g:message code="default.button.cancel.label"/>': function() {
	                location.reload(true);
	                $(this).dialog('close');
	            }
	        }
	    });
	});
</g:if>
</script>

<div>
	<g:render template="../task/importTasksReport" model="['controller':'sprint', 'fwdTo' : 'sprint']"/>
	<g:if test="${flash.taskEdit}">
		<g:render template="../task/formEditTask" model="['fwdTo': 'sprint']"/>
	</g:if>
	<g:render template="../task/formNewTask" model="['fwdTo': 'sprint', 'target': 'backlog']"/>
	<g:render template="../task/formImportTasks" model="['controller':'sprint','fwdTo': 'sprint', 'target': 'backlog']"/>

	<div class="buttons">
		<span class="button">
			<g:if test="${flash.teammate}">
				<g:actionSubmit class="add" onclick="openNewTaskForm();" value="${message(code:'task.createTask')}"/>
				<g:actionSubmit class="import" onclick="openImportTasksForm();" value="${message(code:'task.importTasks')}"/>
			</g:if>
		</span>
	</div>
	
	
	<div class="clear"></div>
	
	<div class="productBacklog" id="productBacklog">
		<div class="immediate">
			<div class="boardheader"><g:message code="priorities.immediate"/></div>
			<g:if test="${flash.backlogImmediate.size() > 0}">
				<ul id="immediate" class="connectedSortableProductBacklog">
			</g:if>
			<g:else>
				<ul id="immediate" class="connectedSortableProductBacklog" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.backlogImmediate}" status="i">
					<g:render template="../task/task" model="['task':task, 'fwdTo': 'sprint']"/>
				</g:each>
			</ul>
		</div>
		<div class="urgent">
			<div class="boardheader"><g:message code="priorities.urgent"/></div>
			<g:if test="${flash.backlogUrgent.size() > 0}">
				<ul id="urgent" class="connectedSortableProductBacklog">
			</g:if>
			<g:else>
				<ul id="urgent" class="connectedSortableProductBacklog" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.backlogUrgent}" status="i">
					<g:render template="../task/task" model="['task':task, 'fwdTo': 'sprint']"/>
				</g:each>
			</ul>
		</div>
		<div class="high">
			<div class="boardheader"><g:message code="priorities.high"/></div>
			<g:if test="${flash.backlogHigh.size() > 0}">
				<ul id="high" class="connectedSortableProductBacklog">
			</g:if>
			<g:else>
				<ul id="high" class="connectedSortableProductBacklog" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.backlogHigh}" status="i">
					<g:render template="../task/task" model="['task':task, 'fwdTo': 'sprint']"/>
				</g:each>
			</ul>
		</div>
		<div class="normal">
			<div class="boardheader"><g:message code="priorities.normal"/></div>
			<g:if test="${flash.backlogNormal.size() > 0}">
				<ul id="normal" class="connectedSortableProductBacklog">
			</g:if>
			<g:else>
				<ul id="normal" class="connectedSortableProductBacklog" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.backlogNormal}" status="i">
					<g:render template="../task/task" model="['task':task, 'fwdTo': 'sprint']"/>
				</g:each>
			</ul>
		</div>
		<div class="low">
			<div class="boardheader"><g:message code="priorities.low"/></div>
			<g:if test="${flash.backlogLow.size() > 0}">
				<ul id="low" class="connectedSortableProductBacklog">
			</g:if>
			<g:else>
				<ul id="low" class="connectedSortableProductBacklog" style="padding-bottom: 100px;">
			</g:else>
				<g:each var="task" in="${flash.backlogLow}" status="i">
					<g:render template="../task/task" model="['task':task, 'fwdTo': 'sprint']"/>
				</g:each>
			</ul>
		</div>
	</div>
	<div class="clear"></div>
</div>