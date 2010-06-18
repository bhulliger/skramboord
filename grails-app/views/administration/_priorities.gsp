<div class="list">
	<g:form>
		<g:if test="${flash.message}">
			<div class="message">${flash.message}</div>
		</g:if>
	
		<table>
			<tr>
				<g:sortableColumn property="id" defaultOrder="asc" title="Id" style="width: 40px;"/>
				<g:sortableColumn property="name" defaultOrder="asc" title="Priority"/>
				<g:sortableColumn property="color" defaultOrder="asc" title="Color" style="width: 55px;"/>
			</tr>
			<g:each var="priority" in="${flash.priorities}" status="i">
				<g:def var="priorityId" value="${priority.id}"/>
				<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
					<td style="vertical-align: middle;">${priority.id}</td>
					<td style="vertical-align: middle;">${priority.name}</td>
					<td style="vertical-align: middle; background-color: #${priority.toString()}" id="td${i}">
						<input type="text" maxlength="6" size="6" name="priority_${priority.id}" id="colorpickerField${i}" value="${priority.toString()}"/>
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
								
