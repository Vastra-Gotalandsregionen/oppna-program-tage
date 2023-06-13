<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%><%
%><%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%><%
%><%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%><%
%><%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="aui" uri="http://liferay.com/tld/aui" %>
<%
%><portlet:defineObjects/><%
%><portlet:renderURL var="cancelUrl"/><%
%>
<portlet:renderURL var="createAdUrl">
	<portlet:param name="page" value="createAd"/>
</portlet:renderURL><%
%>

<c:if test="${config.useInternalResources}">
	<script src="<%= renderResponse.encodeURL(renderRequest.getContextPath() + "/external/jquery/jquery-1.8.2.js") %>" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="<%= renderResponse.encodeURL(renderRequest.getContextPath() + "/external/css/retursidan.css?r=3")%>"/>
</c:if>

<div id="content-primary" class="article cf clearfix" role="main">
<h1>Skapa ny annons</h1>
<form id="new-ad-start-form" class="form-general" method="get" action="#">
	<p>${texts.confirmCreateAdText}</p>
	<div class="row cols-1 cf clearfix">
		<div class="col col-1">
			<div class="checkbox alt">
				<input type="checkbox" value="ett" name="checkboxgroup1" id="checkbox1-5097936784a63">
				<label for="checkbox1-5097936784a63">Jag förstår hur bortskänkning och bokning fungerar</label>
			</div>
		</div>
	</div>
	<div class="row cols-1 cf clearfix">
		<%--<div class="col medium col-1 submit-area">--%>
            <aui:button-row>
				<button type="submit" href="#" id="submit-5097936784ac4" class="btn btn-primary" useNamespace="false" >Fortsätt</button>
                <a class="btn btn-default" href="${cancelUrl}">Avbryt</a>
            </aui:button-row>
		<%--</div>--%>
	</div>
</form>
</div>

<script type="text/javascript">
	$("#submit-5097936784ac4").click(function(e) {
        e.preventDefault();
		if ($("#checkbox1-5097936784a63").is(":checked")) {
			window.location.href="${createAdUrl}";
		} else {
			alert("Du måste klicka i rutan som bekräftar att du förstått reglerna för bortskänkning för att kunna gå vidare.")
		}
	});
</script>
