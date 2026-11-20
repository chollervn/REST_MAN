<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDChinhNVKho3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    if ("POST".equals(request.getMethod())) {
        response.sendError(405);
        return;
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Trang chủ nhân viên kho"/>
<%@ include file="/WEB-INF/common/header.jspf" %>
<h1>Trang chủ nhân viên kho</h1><div class="home-action"><a class="button" href="${ctx}/GDTimNCC3.jsp">Nhập nguyên liệu</a></div>
<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
