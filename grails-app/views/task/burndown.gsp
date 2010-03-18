<script id="source" language="javascript" type="text/javascript">
	$(function () {
		var target = [];
		var today = ${session.today}
		var dates = ${session.burndownTargetX};
		var gradient = ${session.totalEffort}/${session.burndownTargetXSize};
	    var markings = [{ color: '#ff0000', lineWidth: 1, xaxis: { from: today, to: today} }];
	    
	    for (var i = 0; i <= ${session.burndownTargetXSize}; i += 1) {
	        target.push([dates[i], ${session.totalEffort} - gradient*i]);
	    }
	    
	    $.plot($("#placeholder"), [ target, ${session.burndownReal} ],
	    	    {
    	    		xaxis: {
    							mode: 'time',
    							min: ${(session.sprint.startDate).getTime()},
    							max: ${(session.sprint.endDate).getTime() + 10000000}
					},
	    			grid: { markings: markings }
					
	    	    });
	});
</script>
<div id="placeholder" style="width:920px;height:400px;"></div>