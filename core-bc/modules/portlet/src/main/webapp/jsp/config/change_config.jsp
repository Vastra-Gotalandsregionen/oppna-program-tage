<%@page import="org.springframework.validation.ObjectError"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" session="false"%><%
%><%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%><%
%><%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%><%
%><%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="aui" uri="http://liferay.com/tld/aui" %>
<%
%><portlet:actionURL name="saveConfig" var="saveConfigUrl"/><%
%><portlet:renderURL var="cancelUrl"/><%
%><portlet:defineObjects/>

<% 
	org.springframework.validation.BindingResult bindingResult = 
		(org.springframework.validation.BindingResult)renderRequest.getAttribute("org.springframework.validation.BindingResult.config"); 
%>

<div id="content-primary" class="article cf" role="main">
	<p class="back-link"><a href="<portlet:renderURL/>">Tillbaka</a></p>
	<h1>Administration - �ndra konfigurationsdata</h1>
	<p>Ange de konfigurationsv�rden som applikationen skall anv�nda</p>
	
<%
	if (bindingResult.hasErrors()) {
%>
	<div class="system-info portlet-msg-error">
		<h2>Felaktigt inmatade annonsuppgifter</h2>
		<p>F�ljande fel uppt�cktes i konfigurationen, r�tta felen och f�rs�k igen.</p>
		<ul>
<%
		for(ObjectError error: bindingResult.getAllErrors()) {
%>			
			<li><spring:message code="<%= error.getCode() %>"/></li>
<%
		}
%>
		</ul>
	</div>
<%
	}
%>	
	
	<form:form id="change-config-form" cssClass="form-general" modelAttribute="config" action="${saveConfigUrl}" >
		<p>Antal poster att visa p� varje resultatsida</p>
		<div class="row cols-1 cf">
			<c:set var="err"><form:errors path="pageSize"/></c:set> 
			<div class="text col small col-1 mandatory <%= bindingResult.hasFieldErrors("pageSize") ? "error" : "" %>">
				<label for="pageSizeInput">Sidstorlek<strong><form:errors path="pageSize"/></strong></label>
				<form:input path="pageSize" id="pageSizeInput"/>
			</div>
		</div>
		<div class="row cols-1 cf">
			<div class="col hr col-1">
				<hr>
			</div>
		</div>
		<p>Dimensioner som uppladdade bilder skall skalas till</p>
		<div class="row cols-2 cf">
			<c:set var="err"><form:errors path="imageWidth"/></c:set> 
			<div class="text col small col-1 mandatory <%= bindingResult.hasFieldErrors("imageWidth") ? "error" : "" %>">
				<label for="imageWidthInput">Foto bredd <strong><form:errors path="imageWidth"/></strong></label>
				<form:input path="imageWidth" id="imageWidthInput"/>
			</div>
			<c:set var="err"><form:errors path="imageHeight"/></c:set> 
			<div class="text col small col-1 mandatory <%= bindingResult.hasFieldErrors("imageHeight") ? "error" : "" %>">
				<label for="imageHeightInput">Foto h�jd <strong><form:errors path="imageHeight"/></strong></label>
				<form:input path="imageHeight" id="imageHeightInput"/>
			</div>
		</div>
		<div class="row cols-2 cf">
			<c:set var="err"><form:errors path="thumbWidth"/></c:set> 
			<div class="text col small col-1 mandatory <%= bindingResult.hasFieldErrors("thumbWidth") ? "error" : "" %>">
				<label for="thumbWidthInput">Tumnagel bredd <strong><form:errors path="thumbWidth"/></strong></label>
				<form:input path="thumbWidth" id="thumbWidthInput"/>
			</div>
			<c:set var="err"><form:errors path="thumbHeight"/></c:set> 
			<div class="text col small col-1 mandatory <%= bindingResult.hasFieldErrors("thumbHeight") ? "error" : "" %>">
				<label for="imageHeightInput">Tumnagel h�jd <strong><form:errors path="thumbHeight"/></strong></label>
				<form:input path="thumbHeight" id="thumbHeightInput"/>
			</div>
		</div>
		<div class="row cols-1 cf">
			<div class="col hr col-1">
				<hr>
			</div>
		</div>
		<p>Direktl�nkning till portlet</p>
		<div class="row cols-1 cf">
			<c:set var="err"><form:errors path="pocURIBase"/></c:set> 
			<div class="text col large col-1 mandatory <%= bindingResult.hasFieldErrors("pocURIBase") ? "error" : "" %>">
				<label for="pocURIBaseInput">POC-URI-basl�nk <strong><form:errors path="pocURIBase"/></strong></label>
				<form:input path="pocURIBase" id="pocURIBaseInput"/>
			</div>
		</div>
		<div class="row cols-1 cf">
			<div class="col hr col-1">
				<hr>
			</div>
		</div>
		<p>Giltighetstider</p>
		<div class="row cols-2 cf">
			<c:set var="err"><form:errors path="adExpireTime"/></c:set> 
			<div class="text col small col-1 mandatory <%= bindingResult.hasFieldErrors("adExpireTime") ? "error" : "" %>">
				<label for="adExpireTimeInput">Annonser <strong><form:errors path="adExpireTime"/></strong></label>
				<form:input path="adExpireTime" id="adExpireTimeInput"/>
			</div>
			<c:set var="err"><form:errors path="requestExpireTime"/></c:set> 
			<div class="text col small col-1 mandatory <%= bindingResult.hasFieldErrors("requestExpireTime") ? "error" : "" %>">
				<label for="requestExpireTimeInput">Efterlysningar <strong><form:errors path="requestExpireTime"/></strong></label>
				<form:input path="requestExpireTime" id="requestExpireTimeInput"/>
			</div>
		</div>
		<div class="row cols-1 cf">
			<div class="col hr col-1">
				<hr>
			</div>
		</div>
		<p>L�nk till regelsida</p>
		<div class="row cols-1 cf">
			<c:set var="err"><form:errors path="rulesUrl"/></c:set> 
			<div class="text col large col-1 mandatory <%= bindingResult.hasFieldErrors("rulesUrl") ? "error" : "" %>">
				<label for="rulesUrlInput">L�nk <strong><form:errors path="rulesUrl"/></strong></label>
				<form:input path="rulesUrl" id="rulesUrlInput"/>
			</div>
		</div>				
		<div class="row cols-1 cf">
			<div class="col hr col-1">
				<hr>
			</div>
		</div>
		<div class="row cols-1 cf">
			<%--<div class="col medium col-1 submit-area">--%>
            <aui:button-row>
				<aui:button cssClass="rp-button button" type="submit" value="Uppdatera konfigurationen" name="submit-5086c4a3b380d"/>
				<a class="rp-link-button" href="${cancelUrl}">Avbryt</a>
            </aui:button-row>
			<%--</div>--%>
		</div>
	</form:form>	
</div>
