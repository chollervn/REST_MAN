<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Thông báo"/>
<%@ include file="common/header.jspf" %>

<h1>Thông báo</h1><div class="actions">
<c:choose><c:when test="${not empty sessionScope.phieu}"><a class="button" href="${ctx}/imports">Quay lại phiếu nhập</a></c:when>
<c:otherwise><a class="button" href="${ctx}/login">Trang chủ</a></c:otherwise></c:choose>
<button type="button" onclick="history.back()">Quay lại</button></div>

<%@ include file="common/footer.jspf" %>
