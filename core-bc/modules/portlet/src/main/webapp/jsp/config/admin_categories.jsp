<%@page import="org.springframework.validation.ObjectError"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" session="false"%><%
%><%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%><%
%><%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%><%
%><%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="aui" uri="http://liferay.com/tld/aui" %>
<%
%><portlet:actionURL name="saveCategory" var="saveCategoryUrl"/><%
%><portlet:actionURL name="removeCategory" var="removeCategoryUrl"/><%
%><portlet:renderURL var="cancelUrl"/><%
%><portlet:defineObjects/>

<% 
	org.springframework.validation.BindingResult bindingResult = 
		(org.springframework.validation.BindingResult)renderRequest.getAttribute("org.springframework.validation.BindingResult.config"); 
%>

<div id="content-primary" class="article cf" role="main">
	<p class="back-link"><a href="<portlet:renderURL/>">Tillbaka</a></p>
	<h1>Administration - administrera kategorier</h1>
	
<%
	if (bindingResult.hasErrors()) {
%>
	<div class="system-info portlet-msg-error">
		<h2>Felaktigt inmatade texter</h2>
		<p>F�ljande fel uppt�cktes i texterna, r�tta felen och f�rs�k igen.</p>
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
	
	<form:form id="change-category-form" cssClass="form-general" modelAttribute="newCategory" action="${saveCategoryUrl}" >
		<div class="row cols-2 cf">
			<c:set var="err"><form:errors path="title"/></c:set> 
			<div class="text col medium col-1 mandatory <%= bindingResult.hasFieldErrors("title") ? "error" : "" %>">
				<label for="titleInput">Kategorititel <strong><form:errors path="title"/></strong></label>
				<form:input path="title" id="titleInput"/>
			</div>
			<div class="text col medium col-2 mandatory <%= bindingResult.hasFieldErrors("parent") ? "error" : "" %>">
				<label for="parentInput">Huvudkategori <strong><form:errors path="parent"/></strong></label>
				<form:select path="parent.id">
					<option value="-1" selected="selected">Ingen (skapa toppkategori)</option>
					<form:options items="${topCategories}" itemLabel="title" itemValue="id"/>
				</form:select>
			</div>
		</div>
		<div class="row cols-1 cf">
<%--
			<div class="col medium col-1 submit-area">
				<input type="submit" value="L�gg till ny kategori">
			</div>
--%>
            <aui:button-row>
                <aui:button cssClass="rp-button button" type="submit" value="L�gg till ny kategori"/>
            </aui:button-row>
		</div>
	</form:form>

	<form:form id="change-category-form" cssClass="form-general" modelAttribute="removeCategory" action="${removeCategoryUrl}" >
		<div class="row cols-1 cf">
			<div class="col full col-1">
				<fieldset>
					<legend class="wrap"><span>V�lj kategori att ta bort</span></legend>
					<div class="fieldset-content">
						<c:forEach items="${topCategories}" var="category">
							<div class="radio" style="font-weight: bold;">
								<form:radiobutton path="id" title="${category.title}" value="${category.id}" id="category${category.id}"/>
								<label for="category${category.id}">${category.title}</label>
							</div>
							<div style="margin-left: 30px;">
								<c:forEach items="${subCategories[category.id]}" var="subcategory">
									<div class="radio">
										<form:radiobutton path="id" title="${subcategory.title}" value="${subcategory.id}" id="category${subcategory.id}"/>
										<label for="category${subcategory.id}">${subcategory.title}</label>
									</div>
								</c:forEach>								
							</div>	
						</c:forEach>	
					</div>
				</fieldset>
			</div>			
		</div>
		<div class="row cols-1 cf">
<%--
			<div class="col medium col-1 submit-area">
				<input type="submit" value="Ta bort vald enhet">
			</div>
--%>
            <aui:button-row>
                <aui:button cssClass="rp-button button" type="submit" value="Ta bort vald kategori" />
            </aui:button-row>
		</div>		
	</form:form>
</div>