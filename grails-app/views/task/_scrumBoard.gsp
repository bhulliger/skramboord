<script type="text/javascript">
	$(function() {
		// Task tooltip
		xOffset = 5;
		yOffset = -15;
		$("li.tooltip").hover(
				function(e){	
					this.t = this.title;
					this.title = "";									  
					$("body").append("<p id='tooltip' style='width:260pt;'>"+ this.t +"</p>");
					$("#tooltip").css("top",(e.pageY - yOffset) + "px")
	                             .css("left",(e.pageX + xOffset) + "px")
	                             .fadeIn("fast");
		    	},
				function(){
					this.title = this.t;
					$("#tooltip").remove();
				}
			);	
		$("li.tooltip").mousemove(function(e){
			$("#tooltip")
				.css("top",(e.pageY - yOffset) + "px")
				.css("left",(e.pageX + xOffset) + "px");
		});

		backgroundMarked = "#aaa";
		backgroundNormal = "transparent";
		
<g:if test="${flash.scrumMaster}">
		$("#backlog").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'copyTaskToBacklog') },
			start: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundMarked;
						$("#tooltip").remove();
					},
			stop: function(event, ui) { document.getElementById('open').style.backgroundColor = backgroundNormal },
			over: function(event, ui) { this.style.paddingBottom = "0px" },
			out: function(event, ui) { this.style.paddingBottom = "62px" }
		}).disableSelection();	
</g:if>
<g:if test="${flash.teammate}">
		$("#open").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToOpen') },
			start: function(event, ui) {
						document.getElementById('checkout').style.backgroundColor = backgroundMarked;
						document.getElementById('next').style.backgroundColor = backgroundMarked;
						document.getElementById('standBy').style.backgroundColor = backgroundMarked;
						document.getElementById('backlog').style.backgroundColor = backgroundMarked;
						$("#tooltip").remove();
					},
			stop: function(event, ui) {
						document.getElementById('checkout').style.backgroundColor = backgroundNormal;
						document.getElementById('next').style.backgroundColor = backgroundNormal;
						document.getElementById('standBy').style.backgroundColor = backgroundNormal;
						document.getElementById('backlog').style.backgroundColor = backgroundNormal;
					},
			over: function(event, ui) { this.style.paddingBottom = "0px" },
			out: function(event, ui) { this.style.paddingBottom = "62px" }
		}).disableSelection();
		$("#checkout").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToCheckOut') },
			start: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundMarked;
						document.getElementById('codereview').style.backgroundColor = backgroundMarked;
						document.getElementById('next').style.backgroundColor = backgroundMarked;
						document.getElementById('standBy').style.backgroundColor = backgroundMarked;
						document.getElementById('backlog').style.backgroundColor = backgroundMarked;
						$("#tooltip").remove();
					},
			stop: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundNormal;
						document.getElementById('codereview').style.backgroundColor = backgroundNormal;
						document.getElementById('next').style.backgroundColor = backgroundNormal;
						document.getElementById('standBy').style.backgroundColor = backgroundNormal;
						document.getElementById('backlog').style.backgroundColor = backgroundNormal;
					},
			over: function(event, ui) { this.style.paddingBottom = "0px" },
			out: function(event, ui) { this.style.paddingBottom = "62px" }
		}).disableSelection();
		$("#codereview").sortable({
            connectWith: '.connectedSortable',
            dropOnEmpty: true,
            receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToCodereview') },
			start: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundMarked;
						document.getElementById('done').style.backgroundColor = backgroundMarked;
						document.getElementById('next').style.backgroundColor = backgroundMarked;
						document.getElementById('standBy').style.backgroundColor = backgroundMarked;
						document.getElementById('backlog').style.backgroundColor = backgroundMarked;
						$("#tooltip").remove();
					},
			stop: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundNormal;
						document.getElementById('done').style.backgroundColor = backgroundNormal;
						document.getElementById('next').style.backgroundColor = backgroundNormal;
						document.getElementById('standBy').style.backgroundColor = backgroundNormal;
						document.getElementById('backlog').style.backgroundColor = backgroundNormal;
					},
			over: function(event, ui) { this.style.paddingBottom = "0px" },
			out: function(event, ui) { this.style.paddingBottom = "62px" }
        }).disableSelection();
		$("#done").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToDone') },
			start: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundMarked;
						document.getElementById('checkout').style.backgroundColor = backgroundMarked;
						document.getElementById('backlog').style.backgroundColor = backgroundMarked;
						$("#tooltip").remove();
					},
			stop: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundNormal;
						document.getElementById('checkout').style.backgroundColor = backgroundNormal;
						document.getElementById('backlog').style.backgroundColor = backgroundNormal;
					},
			over: function(event, ui) { this.style.paddingBottom = "0px" },
			out: function(event, ui) { this.style.paddingBottom = "62px" }
		}).disableSelection();
		$("#next").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToNext') },
			start: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundMarked;
						document.getElementById('backlog').style.backgroundColor = backgroundMarked;
						$("#tooltip").remove();
					},
			stop: function(event, ui) {
						document.getElementById('open').style.backgroundColor = backgroundNormal;
						document.getElementById('backlog').style.backgroundColor = backgroundNormal;
					},
			over: function(event, ui) { this.style.paddingBottom = "0px" },
			out: function(event, ui) { this.style.paddingBottom = "62px" }
		}).disableSelection();
		$("#standBy").sortable({
			connectWith: '.connectedSortable',
			dropOnEmpty: true,
			receive: function(event, ui) { changeTo(event, ui, 'changeTaskStateToStandBy') },
			start: function(event, ui) {
						document.getElementById('checkout').style.backgroundColor = backgroundMarked;
						document.getElementById('next').style.backgroundColor = backgroundMarked;
						document.getElementById('open').style.backgroundColor = backgroundMarked;
						document.getElementById('backlog').style.backgroundColor = backgroundMarked;
						$("#tooltip").remove();
					},
			stop: function(event, ui) {
						document.getElementById('checkout').style.backgroundColor = backgroundNormal;
						document.getElementById('next').style.backgroundColor = backgroundNormal;
						document.getElementById('open').style.backgroundColor = backgroundNormal;
						document.getElementById('backlog').style.backgroundColor = backgroundNormal;
					},
			over: function(event, ui) { this.style.paddingBottom = "0px" },
			out: function(event, ui) { this.style.paddingBottom = "62px" }
		}).disableSelection();
</g:if>

// Product Backlog
<g:if test="${session.enableBacklog}">
		document.getElementById("scrumboard").style.width = "840px";
</g:if>
<g:else>
$("#productBacklog").hide();
		document.getElementById("scrumboard").style.width = "1060px";
</g:else>
	});

	function toggleProductBacklog(){
		if ($("#productBacklog").is(":hidden")) {
			document.getElementById("scrumboard").style.width = "840px";
    		$("#productBacklog").toggle(500);
			${remoteFunction(controller: 'task', action:'enableBacklog', params:[enableBacklog: 'true'])}
    	} else {
    		document.getElementById("scrumboard").style.width = "1060px";
    		$("#productBacklog").toggle();
    		${remoteFunction(controller: 'task', action:'enableBacklog', params:[enableBacklog: 'false'])}
    	}
	}

    function changeClass(id, clazz) {
    	document.getElementById(id).setAttribute('class', clazz);
    }
	
<g:if test="${flash.teammate}">
	function changeTo(event, ui, stateMethod){
		location.href="${request.contextPath}/project/${flash.project.id}/sprint/${flash.sprint.id}/task/" + stateMethod + "?taskId=" + $(ui.item).attr("id");
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
    <g:render template="importTasksReport" model="['controller':'task', 'fwdTo' : 'task']"/>
    
	<g:if test="${flash.taskEdit}">
		<g:render template="formEditTask" model="['fwdTo': 'task']"/>
	</g:if>
	<g:elseif test="${flash.sprint.isSprintActive()}">
		<g:render template="formNewTask" model="['fwdTo': 'task', 'target': 'sprint']"/>
		<g:render template="formImportTasks" model="['controller':'task','fwdTo': 'sprint', 'target': 'backlog']"/>
	</g:elseif>

	
	<div class="buttons">
		<span class="button">
			<g:if test="${flash.sprint.isSprintActive()}">
				<g:if test="${flash.teammate}">
					<g:actionSubmit class="add" onclick="openNewTaskForm();" value="${message(code:'task.createTask')}"/>
					<g:actionSubmit class="import" onclick="openImportTasksForm();" value="${message(code:'task.importTasks')}"/>
				</g:if>
			</g:if>
			<g:actionSubmit class="table" onclick="toggleProductBacklog();" value="${message(code:'project.backlog.button', args: [flash.projectBacklog.size()])}" />
			
		</span>
	</div>
	
	<div class="clear"></div>
	
	<div class="backlog" id="productBacklog">
		<div class="boardheader" style="padding-top: 2px;"><g:message code="project.backlog"/></div>
		<div style="height: 500px; overflow: auto;">
			<g:if test="${flash.projectBacklog.size() > 0}">
				<ul id="backlog" class="connectedSortable">
			</g:if>
			<g:else>
				<ul id="backlog" class="connectedSortable" style="padding-bottom: 62px;">
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
				<ul id="open" class="connectedSortable" style="padding-bottom: 62px;">
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
				<ul id="checkout" class="connectedSortable" style="padding-bottom: 62px;">
			</g:else>
				<g:each var="task" in="${flash.taskListCheckout}" status="i">
					<g:render template="task" model="['task':task, 'fwdTo': 'task']"/>
				</g:each>
			</ul>
		</div>
		
		<div class="codereview">
            <div class="boardheader"><g:message code="task.codereview"/></div>
            <g:if test="${flash.taskListCodereview.size() > 0}">
                <ul id="codereview" class="connectedSortable">
            </g:if>
            <g:else>
                <ul id="codereview" class="connectedSortable" style="padding-bottom: 62px;">
            </g:else>
                <g:each var="task" in="${flash.taskListCodereview}" status="i">
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
				<ul id="done" class="connectedSortable" style="padding-bottom: 62px;">
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
					<ul id="next" class="connectedSortable" style="padding-bottom: 62px;">
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
					<ul id="standBy" class="connectedSortable" style="padding-bottom: 62px;">
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