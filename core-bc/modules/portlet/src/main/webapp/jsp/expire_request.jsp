<%@page import="org.springframework.validation.ObjectError"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%><%
%><%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%><%
%><%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%><%
%><%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%
%><portlet:renderURL var="cancelUrl"/><%
%><portlet:actionURL name="performExpire" var="expireUrl"><portlet:param name="requestId" value="${request.id}"/></portlet:actionURL><%
%><portlet:defineObjects/>

<c:if test="${config.useInternalResources}">
	<script src="<%= renderResponse.encodeURL(renderRequest.getContextPath() + "/external/jquery/jquery-1.8.2.js") %>" type="text/javascript"></script>
</c:if>

<div id="content-primary" class="article cf clearfix" role="main">
	<h1>Ta bort ${request.title}</h1>

	<form id="republish-ad-start-form" class="form-general" method="get" action="#">
		<p>${texts.confirmRemoveRequestText}</p>
		<div class="row cols-1 cf clearfix">
			<div class="col col-1">
				<div class="checkbox alt">
					<input type="checkbox" value="ett" name="checkboxgroup1" id="checkbox1-5097936784a63">
					<label for="checkbox1-5097936784a63">Jag vill ta bort min efterlysning</label>
				</div>
			</div>
		</div>
		<div class="row cols-1 cf clearfix">
			<div class="col medium col-1 submit-area">
				<a href="#" id="submit-5097936784ac4" class="btn btn-danger">Fortsätt</a>
				<a href="${cancelUrl}" class="btn btn-default">Avbryt</a>
			</div>
		</div>
	</form>
</div>

<script type="text/javascript">
	$("#submit-5097936784ac4").click(function() {
		if ($("#checkbox1-5097936784a63").is(":checked")) {
			window.location.href="${expireUrl}";
		} else {
			alert("Du måste klicka i rutan som bekräftar att du vill sätta efterlysningen som utgången för att kunna gå vidare.")
		}
	});
</script>
