<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="a" uri="/WEB-INF/app.tld"%>
<%@ taglib prefix="w" uri="http://www.unidal.org/web/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="res" uri="http://www.unidal.org/webres"%>
<jsp:useBean id="ctx"	type="com.dianping.cat.report.page.event.Context"	scope="request" />
<jsp:useBean id="payload"	type="com.dianping.cat.report.page.event.Payload"	scope="request" />
<jsp:useBean id="model"	type="com.dianping.cat.report.page.event.Model" scope="request" />

<a:historyReport title="History Report" navUrlPrefix="type=${payload.type}&group=${payload.group}">
	<jsp:attribute name="subtitle">${w:format(payload.historyStartDate,'yyyy-MM-dd HH:mm')} to ${w:format(payload.historyDisplayEndDate,'yyyy-MM-dd HH:mm')}</jsp:attribute>
	<jsp:body>
	<res:useJs value="${res.js.local['baseGraph.js']}" target="head-js"/>
<table class="machines">
	<tr style="text-align: left">
		<th> <c:forEach var="ip" items="${model.ips}">&nbsp;[&nbsp; 
						<a href="?op=history&domain=${model.domain}&ip=${ip}&date=${model.date}&reportType=${model.reportType}${model.customDate}"
									>${ip}</a>
   	 		&nbsp;]&nbsp;
			 </c:forEach>
		</th>
	</tr>
</table>

<table class="groups">
	<tr class="left">
		<th>
   	 		<c:forEach var="group" items="${model.groups}">
				<c:choose><c:when test="${payload.group eq group}">
		   	  		&nbsp;[&nbsp;
		   	  			<a class="current" href="?op=historyGroupReport&domain=${model.domain}&group=${group}&date=${model.date}">${group}</a>
		   	 		&nbsp;]&nbsp;
	   	 		</c:when>
	   	 		<c:otherwise>
		   	  		&nbsp;[&nbsp;
		   	  			<a href="?op=historyGroupReport&domain=${model.domain}&group=${group}&date=${model.date}">${group}</a>
		   	 		&nbsp;]&nbsp;
	   	 		</c:otherwise></c:choose>
			 </c:forEach>
		</th>
	</tr>
</table>
<script type="text/javascript" src="/cat/js/appendHostname.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	appendHostname(${model.ipToHostnameStr});
	
	$.each($('table.machines a'),function(index,item){
		var id=$(item).text();
		<c:forEach var="ip" items="${model.groupIps}">
			group = '${ip}';
			if(id.indexOf(group)!=-1){
				$(item).addClass('current');
			}
		</c:forEach>
	});
	
});
</script>

<table class='table table-hover table-striped table-condensed '>
	<c:choose>
		<c:when test="${empty payload.type}">
			<tr>
			<th  style="text-align: left;"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&sort=type${model.customDate}"> Type</a></th>
			<th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&sort=total${model.customDate}">Total</a></th>
			<th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&sort=failure${model.customDate}">Failure</a></th>
			<th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&sort=failurePercent${model.customDate}">Failure%</a></th>
			<th class="right">Sample Link</th><th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&sort=total${model.customDate}">QPS</a></th>
			</tr>
			<c:forEach var="item" items="${model.displayTypeReport.results}"
						varStatus="status">
				<c:set var="e" value="${item.detail}" />
				<c:set var="lastIndex" value="${status.index}" />
				<tr class=" right">
					<td style="text-align: left">
					<a href="?op=historyGroupGraph&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${item.type}${model.customDate}" class="history_graph_link" data-status="${status.index}">[:: show ::]</a>
					&nbsp;&nbsp;&nbsp;<a href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${item.type}${model.customDate}">${item.type}</a></td>
					<td>${w:format(e.totalCount,'#,###,###,###,##0')}</td>
					<td>${e.failCount}</td>
					<td>${w:format(e.failPercent/100,'0.0000%')}</td>
					<td><a href="${model.logViewBaseUri}/${empty e.failMessageUrl ? e.successMessageUrl : e.failMessageUrl}?domain=${model.domain}">Log View</a></td>
					<td>${w:format(e.tps,'0.0')}</td>
				</tr>
				<tr class="graphs"><td colspan="7" style="display:none"><div id="${status.index}" style="display:none"></div></td></tr>
				<tr></tr>
			</c:forEach>
		</c:when>
		<c:otherwise>
		<tr>
			<th  style="text-align: left;"><a	href="?op=historyGroupGraph&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${payload.type}&sort=type${model.customDate}"> Name</a></th>
			<th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${payload.type}&sort=total${model.customDate}">Total</a></th>
			<th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${payload.type}&sort=failure${model.customDate}">Failure</a></th>
			<th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${payload.type}&sort=failurePercent${model.customDate}">Failure%</a></th>
			<th class="right">Sample Link</th><th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${payload.type}&sort=type${model.customDate}">QPS</a></th>
			<th class="right"><a	href="?op=historyGroupReport&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${payload.type}&sort=type${model.customDate}">Percent%</a></th>
					</tr>
			<c:forEach var="item" items="${model.displayNameReport.results}"
						varStatus="status">
				<c:set var="e" value="${item.detail}" />
				<c:set var="lastIndex" value="${status.index}" />
				<tr class=" right">
					<td style="text-align: left">
					<c:choose>
					<c:when test="${status.index > 0}">
						<a href="?op=historyGroupGraph&domain=${model.domain}&date=${model.date}&group=${payload.group}&reportType=${model.reportType}&type=${payload.type}&name=${item.name}${model.customDate}" class="history_graph_link" data-status="${status.index}">[:: show ::]</a>
						&nbsp;&nbsp;&nbsp;${e.id}</td>
						</c:when>
						<c:otherwise>
							${e.id}
						</c:otherwise>
					</c:choose>
					<td>${w:format(e.totalCount,'#,###,###,###,##0')}</td>
					<td>${e.failCount}</td>
					<td>${w:format(e.failPercent/100,'0.0000%')}</td>
					<td><a	href="${model.logViewBaseUri}/${empty e.failMessageUrl ? e.successMessageUrl : e.failMessageUrl}?domain=${model.domain}">Log View</a></td>
					<td>${w:format(e.tps,'0.0')}</td>
					<td>${w:format(e.totalPercent,'0.0000%')}</td>
				</tr>
				<tr class="graphs"><td colspan="7" style="display:none"><div id="${status.index}" style="display:none"></div></td></tr>
				<tr></tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</table>

<font color="white">${lastIndex+1}</font>
</br>
<res:useJs value="${res.js.local.event_js}" target="bottom-js" />
<c:choose>
	<c:when test="${not empty payload.type}">
		<table>
			<tr>
				<td><div id="eventGraph" class="pieChart" ></div>
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			var data = ${model.pieChart};
			graphPieChart(document.getElementById('eventGraph'), data );
		</script>
	</c:when>
</c:choose>
</jsp:body>
</a:historyReport>