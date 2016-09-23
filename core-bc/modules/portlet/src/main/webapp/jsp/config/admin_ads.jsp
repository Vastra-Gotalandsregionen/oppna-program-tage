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
	<p class="back-link"><a href="<portlet:renderURL/>">Tillbaka</a></p>
	<div class="content-header cf clearfix">
		<h1>Administration - administrera annonser</h1>
	</div>
	<c:if test="${fn:length(ads.list) gt 0}">
		<ul class="inventory-listing" style="list-style: none">
			<c:forEach items="${ads.list}" var="ad">
				<portlet:renderURL var="viewAdUrl">
					<portlet:param name="page" value="viewAd"/>
					<portlet:param name="advertisementId" value="${ad.id}"/>
					<portlet:param name="previousPage" value="adminAds"/>
				</portlet:renderURL>
				<portlet:actionURL var="removeAdUrl" name="removeAd">
					<portlet:param name="advertisementId" value="${ad.id}"/>
				</portlet:actionURL>
				<portlet:actionURL var="expireAdUrl" name="expireAd">
					<portlet:param name="advertisementId" value="${ad.id}"/>
				</portlet:actionURL>
				<portlet:actionURL var="republishAdUrl" name="republishAd">
					<portlet:param name="advertisementId" value="${ad.id}"/>
				</portlet:actionURL>
				<c:if test="${ad.status eq 'PUBLISHED'}">
					<c:set var="statusTitle" value="PUBLICERAD" />
				</c:if>				
				<c:if test="${ad.status eq 'EXPIRED'}">
					<c:set var="statusTitle" value="UTG�NGEN" />
				</c:if>				
				<c:if test="${ad.status eq 'BOOKED'}">
					<c:set var="statusTitle" value="BOKAD" />
				</c:if>				
				
				<c:if test="${fn:length(ad.photos) gt 0}">
					<c:forEach var="photo" items="${ad.photos}" end="0">
		     			<c:set var="imageUrl" value="${thumbnailUrl}&id=${photo.id}"/>
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(ad.photos) eq 0}">
	     			<c:set var="imageUrl" value="${thumbnailUrl}&id="/>
				</c:if>
	
				<li class="cf clearfix">
					<div class="image">
						<a href="${viewAdUrl}"><img class="thumbnail" src="${imageUrl}" alt=""></a>
					</div>
					<div class="content">
						<div class="meta"><span class="date">${ad.formattedCreatedDate}</span></div>
						<h3><a href="${viewAdUrl}">${ad.title}</a></h3>
						<div class="meta"><span class="author">Upplagd av ${ad.unit.name}</span>. Status: <strong>${statusTitle}</strong></div>
						<div class="meta"><span class="category">${ad.category.parent.title} <span class="sep">&gt;</span> ${ad.category.title}</span></div>
						<div class="meta">
							<a href="${removeAdUrl}" class="btn btn-danger">Ta bort</a>
							<c:if test="${ad.published}">
								<a href="${expireAdUrl}" class="btn btn-primary">S�tt som utg�ngen</a>
							</c:if>				
							<c:if test="${!ad.published}">
								<a href="${republishAdUrl}" class="btn btn-primary">�terpublicera</a>
							</c:if>
						</div>
					</div>
				</li>
			</c:forEach>
		</ul>
		<c:if test="${ads.numberOfPages > 1}">
			<div class="paging cf clearfix">
				<strong>G� till sida:</strong>
				<ul>
					<c:if test="${ads.hasPrevious}">
						<portlet:actionURL name="selectAdsPage" var="prevUrl"><portlet:param name="page" value="adminAds"/><portlet:param name="pageIdx" value="${ads.page-1}"/></portlet:actionURL>
						<portlet:actionURL name="selectAdsPage" var="firstUrl"><portlet:param name="page" value="adminAds"/><portlet:param name="pageIdx" value="1"/></portlet:actionURL>
						<li><a href="${firstUrl}" title="L�nk till f�rsta sidan">&lt;&lt;</a></li>
						<li><a href="${prevUrl}" title="L�nk till f�reg�ende sida">&lt;</a></li>					
					</c:if>
					<c:forEach var="pageIdx" begin="1" end="${ads.numberOfPages}">
						<c:if test="${pageIdx eq ads.page}">
							<li>${pageIdx}</li>
						</c:if>
						<c:if test="${pageIdx ne ads.page}">
							<portlet:actionURL name="selectAdsPage" var="pageUrl"><portlet:param name="page" value="adminAds"/><portlet:param name="pageIdx" value="${pageIdx}"/></portlet:actionURL>
							<li><a href="${pageUrl}">${pageIdx}</a></li>
						</c:if>
					</c:forEach>
					<c:if test="${ads.hasNext}">
						<portlet:actionURL name="selectAdsPage" var="nextUrl"><portlet:param name="page" value="adminAds"/><portlet:param name="pageIdx" value="${ads.page+1}"/></portlet:actionURL>
						<portlet:actionURL name="selectAdsPage" var="lastUrl"><portlet:param name="page" value="adminAds"/><portlet:param name="pageIdx" value="${ads.numberOfPages}"/></portlet:actionURL>
						<li><a href="${nextUrl}" title="L�nk till n�sta sida">&gt;</a></li>
						<li><a href="${lastUrl}" title="L�nk till sista sidan">&gt;&gt;</a></li>
					</c:if>
				</ul>
			</div>
		</c:if>	
	</c:if>
	<c:if test="${fn:length(ads.list) eq 0}">
		<div>Inga annonser hittades.</div>
	</c:if>
</div>
