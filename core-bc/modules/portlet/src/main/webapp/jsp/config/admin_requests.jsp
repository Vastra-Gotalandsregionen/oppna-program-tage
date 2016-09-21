<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" session="false"%><%
%><%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%><%
%><%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%><%
%><%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%
%><portlet:resourceURL id="thumbnail" cacheability="cacheLevelFull" var="thumbnailUrl"/><%
%><portlet:defineObjects/>

<link rel="stylesheet" type="text/css" href="<%= renderResponse.encodeURL(renderRequest.getContextPath() + "/external/css/retursidan.css")%>"/>

<style type="text/css">
    ul.inventory-listing li.cf {
        border: 1px grey solid;
        box-shadow: 1px 1px 7px;
        list-style: none;
        margin: 16px 0;
        padding: 6px;
    }
</style>

<div id="content-primary" class="cf" role="main">
	<p class="back-link"><a class="btn btn-default" href="<portlet:renderURL/>">Tillbaka</a></p>
	<div class="content-header cf clearfix">
		<h1>Administration - administrera efterlysningar</h1>
	</div>
	<c:if test="${fn:length(requests.list) gt 0}">
		<ul class="inventory-listing">
			<c:forEach items="${requests.list}" var="request">
				<portlet:renderURL var="viewRequestUrl">
					<portlet:param name="page" value="viewRequest"/>
					<portlet:param name="requestId" value="${request.id}"/>
					<portlet:param name="previousPage" value="adminRequests"/>
				</portlet:renderURL>
				<portlet:actionURL var="removeRequestUrl" name="removeRequest">
					<portlet:param name="requestId" value="${request.id}"/>
				</portlet:actionURL>
				<portlet:actionURL var="expireRequestUrl" name="expireRequest">
					<portlet:param name="requestId" value="${request.id}"/>
				</portlet:actionURL>
				<portlet:actionURL var="republishRequestUrl" name="republishRequest">
					<portlet:param name="requestId" value="${request.id}"/>
				</portlet:actionURL>
				<c:if test="${request.status eq 'PUBLISHED'}">
					<c:set var="statusTitle" value="PUBLICERAD" />
				</c:if>				
				<c:if test="${request.status eq 'EXPIRED'}">
					<c:set var="statusTitle" value="UTG�NGEN" />
				</c:if>					
				
				<li class="cf clearfix">
					<div class="content">
						<div class="meta"><span class="date">${request.formattedCreatedDate}</span></div>
						<h3><a href="${viewRequestUrl}">${request.title}</a></h3>
						<div class="meta"><span class="category">${request.category.parent.title} <span class="sep">&gt;</span> ${request.category.title}</span></div>
						<div class="meta">Status: <strong>${statusTitle}</strong></div>
						<div class="meta">
							<a href="${removeRequestUrl}" class="btn btn-danger">Ta bort</a>
							<c:if test="${request.published}">
								<a href="${expireRequestUrl}" class="btn btn-primary">S�tt som utg�ngen</a>
							</c:if>				
							<c:if test="${!request.published}">
								<a href="${republishRequestUrl}" class="btn btn-primary">�terpublicera</a>
							</c:if>
						</div>
					</div>
				</li>
			</c:forEach>
		</ul>
		<c:if test="${requests.numberOfPages > 1}">
			<div class="paging cf clearfix">
				<strong>G� till sida:</strong>
				<ul>
					<c:if test="${requests.hasPrevious}">
						<portlet:actionURL name="selectRequestsPage" var="prevUrl"><portlet:param name="page" value="adminRequests"/><portlet:param name="pageIdx" value="${requests.page-1}"/></portlet:actionURL>
						<portlet:actionURL name="selectRequestsPage" var="firstUrl"><portlet:param name="page" value="adminRequests"/><portlet:param name="pageIdx" value="1"/></portlet:actionURL>
						<li><a href="${firstUrl}" title="L�nk till f�rsta sidan">&lt;&lt;</a></li>
						<li><a href="${prevUrl}" title="L�nk till f�reg�ende sida">&lt;</a></li>					
					</c:if>
					<c:forEach var="pageIdx" begin="1" end="${requests.numberOfPages}">
						<c:if test="${pageIdx eq requests.page}">
							<li>${pageIdx}</li>
						</c:if>
						<c:if test="${pageIdx ne requests.page}">
							<portlet:actionURL name="selectRequestsPage" var="pageUrl"><portlet:param name="page" value="adminRequests"/><portlet:param name="pageIdx" value="${pageIdx}"/></portlet:actionURL>
							<li><a href="${pageUrl}">${pageIdx}</a></li>
						</c:if>
					</c:forEach>
					<c:if test="${requests.hasNext}">
						<portlet:actionURL name="selectRequestsPage" var="nextUrl"><portlet:param name="page" value="adminRequests"/><portlet:param name="pageIdx" value="${requests.page+1}"/></portlet:actionURL>
						<portlet:actionURL name="selectRequestsPage" var="lastUrl"><portlet:param name="page" value="adminRequests"/><portlet:param name="pageIdx" value="${requests.numberOfPages}"/></portlet:actionURL>
						<li><a href="${nextUrl}" title="L�nk till n�sta sida">&gt;</a></li>
						<li><a href="${lastUrl}" title="L�nk till sista sidan">&gt;&gt;</a></li>
					</c:if>
				</ul>
			</div>
		</c:if>	
	</c:if>
	<c:if test="${fn:length(requests.list) eq 0}">
		<div>Inga efterlysningar hittades.</div>
	</c:if>
</div>
