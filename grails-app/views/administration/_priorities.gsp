<div class="list">
	<g:form>
		<table>
			<tr>
				<g:sortableColumn property="id" defaultOrder="asc" title="Id" style="width: 40px;"/>
				<g:sortableColumn property="name" defaultOrder="asc" title="${message(code:'task.priority')}"/>
				<g:sortableColumn property="color" defaultOrder="asc" title="${message(code:'task.color')}" style="width: 55px;"/>
			</tr>
			<g:each var="priority" in="${flash.priorities}" status="i">
				<g:def var="priorityId" value="${priority.id}"/>
				<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
					<td style="vertical-align: middle;">${priority.id}</td>
					<td style="vertical-align: middle;"><g:message code="priorities.${priority.name}"/></td>
					<td style="vertical-align: middle; background-color: #${priority.colorAsString()}" id="td${i}">
						<input type="text" maxlength="6" size="6" name="priority_${priority.id}" id="colorpickerField${i}" value="${priority.colorAsString()}"/>
						<script type="text/javascript">
							$(function() {
								$('#colorpickerField'+${i}).ColorPicker({
									onSubmit: function(hsb, hex, rgb, el) {
										$(el).val(hex);
										$(el).ColorPickerHide();
										document.getElementById("td${i}").style.backgroundColor = '#' + hex;
									},
									onBeforeShow: function () {
										$(this).ColorPickerSetColor(this.value);
									}
								})
								.bind('keyup', function(){
									$(this).ColorPickerSetColor(this.value);
								});
							});
						</script>
					</td>
				</tr>
			</g:each>
		</table>
		<div class="buttons">
			<span class="button"><g:actionSubmit class="cancel" action="list" value="${message(code:'default.button.cancel.label')}" /></span>
			<span class="button"><g:actionSubmit class="save" action="savePriorities" value="${message(code:'default.button.save.label')}" /></span>
		</div>
	</g:form>
</div>
								
