<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDChinhKH3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    if ("POST".equals(request.getMethod())) {
        response.sendError(405);
        return;
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Trang chủ khách hàng"/>
<%@ include file="/WEB-INF/common/header.jspf" %>
<h1>Trang chủ khách hàng</h1><div class="home-action"><a class="button" href="${ctx}/GDTimMonAn3.jsp">Tìm kiếm thông tin món ăn</a></div>
<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
