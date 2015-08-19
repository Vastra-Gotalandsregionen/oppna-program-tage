<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" session="false"%><%
%><%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%><%
%><%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%><%
%><%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %><%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<portlet:resourceURL id="thumbnail" cacheability="cacheLevelFull" var="thumbnailUrl"/><%
%><portlet:resourceURL id="subCategories" var="subCatUrl"/><%
%><portlet:renderURL var="createAdUrl"><portlet:param name="page" value="createAdConfirm"/></portlet:renderURL><%
%><portlet:renderURL var="listMyAdsUrl"><portlet:param name="page" value="listMyAds"/></portlet:renderURL><%
%><portlet:actionURL name="filterAds" var="filterUrl"/><%
%><portlet:defineObjects/>

<c:if test="${config.useInternalResources}">
	<script src="<%= renderResponse.encodeURL(renderRequest.getContextPath() + "/external/jquery/jquery-1.8.2.js") %>" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="<%= renderResponse.encodeURL(renderRequest.getContextPath() + "/external/css/retursidan.css")%>"/>
</c:if>

<div id="content-primary" class="cf" role="main">
	<div class="content-header cf clearfix">
		<h1>Tage</h1>
        <a href="${createAdUrl}" class="rp-link-button">L�gg in annons</a>
        <a href="${listMyAdsUrl}" class="rp-link-button">Mina annonser</a>
	</div>
	<p>H�r kan du annonsera ut �verblivna m�bler och utrustning som du vill sk�nka f�r �teranv�ndning till andra verksamheter inom VGR. Du kan �ven efterlysa m�bler och utrustning din verksamhet har behov av. Det kostar inget att annonsera p� Tage.</p>
	<p>Vi g�r det h�r f�r att �ka �terv�ndningen och minska resursf�rbrukningen.</p>
	<form:form id="search-inventory-form" cssClass="form-general" modelAttribute="searchFilter" action="${filterUrl}" >
		<div class="row cols-3 cf clearfix">
			<div class="select medium col col-1">
				<label for="508e6b767babe">Kategori</label>
				<form:select id="508e6b767babe" path="topCategory.id">
					<form:option value="-1" selected="selected">Alla</form:option>
					<form:options items="${topCategories}" itemLabel="title" itemValue="id"/>
				</form:select>
			</div>
			<div class="select medium col col-2">
				<label for="508e6b767bc24">Underkategori</label>
				<form:select id="508e6b767bc24" path="subCategory.id">
					<option value="-1" selected="selected">Alla</option>
					<c:if test="${!empty subCategories}">
						<form:options items="${subCategories}" itemLabel="title" itemValue="id"/>
					</c:if>
				</form:select>
			</div>
			<div class="select medium col col-3">
				<label for="508e6b767bd2c">F�rvaltning</label>
				<form:select id="508e6b767bd2c" path="unit.id">
					<option value="-1" selected="selected">Alla</option>
					<form:options items="${units}" itemLabel="name" itemValue="id"/>
				</form:select>
			</div>
            <div class="row cols-1 cf">
                <%--<div class="col small col-1">--%>
                <aui:button-row>
                    <aui:button cssClass="rp-button" type="submit" value="Visa" name="submit-508e6b767c18f"/>
                </aui:button-row>
                <%--</div>--%>
            </div>
        </div>
	</form:form>
	<h2><span id="headerTitle">Alla annonser</span></h2>
	<c:if test="${fn:length(ads.list) gt 0}">
		<ul class="inventory-listing">
			<c:forEach items="${ads.list}" var="ad">
				<portlet:renderURL var="viewAdUrl">
					<portlet:param name="page" value="viewAd"/>
					<portlet:param name="advertisementId" value="${ad.id}"/>
				</portlet:renderURL>
				
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
						<a href="${viewAdUrl}"><img src="${imageUrl}" alt=""></a>
					</div>
					<div class="content">
						<div class="meta"><span class="date">${ad.formattedCreatedDate}</span></div>
						<h3><a href="${viewAdUrl}">${ad.title}</a></h3>
						<div class="meta"><span class="author">Upplagd av ${ad.unit.name}</span></div>
						<div class="meta"><span class="category">${ad.category.parent.title} <span class="sep">&gt;</span> ${ad.category.title}</span></div>
					</div>
				</li>
			</c:forEach>
		</ul>
		<c:if test="${ads.numberOfPages > 1}">
			<div class="paging cf clearfix">
				<strong>G� till sida:</strong>
				<ul>
					<c:if test="${ads.hasPrevious}">
						<portlet:actionURL name="filterAds" var="prevUrl"><portlet:param name="pageIdx" value="${ads.page-1}"/></portlet:actionURL>
						<portlet:actionURL name="filterAds" var="firstUrl"><portlet:param name="pageIdx" value="1"/></portlet:actionURL>
						<li><a href="${firstUrl}" title="L�nk till f�rsta sidan">&lt;&lt;</a></li>
						<li><a href="${prevUrl}" title="L�nk till f�reg�ende sida">&lt;</a></li>					
					</c:if>
					<c:forEach var="pageIdx" begin="1" end="${ads.numberOfPages}">
						<c:if test="${pageIdx eq ads.page}">
							<li>${pageIdx}</li>
						</c:if>
						<c:if test="${pageIdx ne ads.page}">
							<portlet:actionURL name="filterAds" var="pageUrl"><portlet:param name="pageIdx" value="${pageIdx}"/></portlet:actionURL>
							<li><a href="${pageUrl}">${pageIdx}</a></li>
						</c:if>
					</c:forEach>
					<c:if test="${ads.hasNext}">
						<portlet:actionURL name="filterAds" var="nextUrl"><portlet:param name="pageIdx" value="${ads.page+1}"/></portlet:actionURL>
						<portlet:actionURL name="filterAds" var="lastUrl"><portlet:param name="pageIdx" value="${ads.numberOfPages}"/></portlet:actionURL>
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

<script type="text/javascript">
	// construct the header based on filter selections
	$(document).ready(function() {
		if ($("#508e6b767babe").val() != -1) {
			$("#headerTitle").append(" i kategori " + $("#508e6b767babe option:selected").text());
		}
		if ($("#508e6b767bc24").val() != -1) {
			$("#headerTitle").append(" > " + $("#508e6b767bc24 option:selected").text());
		}
		if ($("#508e6b767bd2c").val() != -1) {
			$("#headerTitle").append(" fr�n f�rvaltning " + $("#508e6b767bd2c option:selected").text());
		}
	});

	$("#508e6b767babe").change(function() {
		$.ajax({
			type: "POST",
			url: "${subCatUrl}", 
			dataType: "html",
			data: { parent: $(this).find(":selected").val() },
			success: function(result) {
				$("#508e6b767bc24").html("<option value=\"-1\" selected=\"selected\">Alla</option>" + result);
				$("#508e6b767bc24").trigger("change");
			},
			error: function(result) {
				alert("Ett fel uppstod p� servern n�r underkategorier h�mtades: " + result.responseText);
			}
		});
	});
</script>