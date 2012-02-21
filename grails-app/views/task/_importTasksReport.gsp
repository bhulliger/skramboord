<g:if test="${flash.importReport}">
        <div id="dialog-csv-form" title="${message(code:'task.formNameImportTasks')}" class="form">
	        <g:if test="${flash.importReport.errors}">
		        <table style="padding-bottom: 40px;">
		            <thead>
		                <th><g:message code="csv.line"/></th>
		                <th><g:message code="csv.error"/></th>
		            </thead>
				    <g:each var="error" in="${flash.importReport.errors}" status="i">
				       <tr>
				           <td>${error.key}</td>
				           <td>${error.value}</td>
				       </tr>
				    </g:each>
			    </table>
			    <g:form url="[ controller: controller, action: 'importCSV', params: ['fwdTo': fwdTo, 'target': 'sprint', project: flash.project.id, sprint: flash.sprint?.id]]" name='formImportTasks' enctype="multipart/form-data" method="post">
			        <fieldset>
			            <input type="file" name="cvsFile" id="cvsFile" />
			        </fieldset>
			    </g:form>
	        </g:if>
	        <g:elseif test="${flash.importReport.stats}">
                <table>
                    <tr>
                        <td width="20%">${message(code:'sprint.importStateNew')}:</td>
                        <td>${flash.importReport.stats.new}</td>
                    </tr>
                    <tr>
                        <td>${message(code:'sprint.importStateUpdate')}:</td>
                        <td>${flash.importReport.stats.update}</td>
                    </tr>
                    <tr>
                        <td>${message(code:'sprint.importStateIgnore')}:</td>
                        <td>${flash.importReport.stats.ignore}</td>
                    </tr>
	            </table>
	            <g:form url="[ controller: controller, action: 'importCSV', params: ['fwdTo': fwdTo, 'target': 'sprint', project: flash.project.id, sprint: flash.sprint?.id]]" name='formImportTasks' enctype="multipart/form-data" method="post">
                    <fieldset>
                        <input type="hidden" name="importtaskid" id="importtaskid" value="${flash.importtaskid}" />
                    </fieldset>
                </g:form>
	        </g:elseif>
	   </div>
    </g:if>