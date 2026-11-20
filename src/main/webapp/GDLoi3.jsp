<%@ page pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%
    Throwable cause = exception;
    while (cause != null && cause.getCause() != null && cause.getCause() != cause) cause = cause.getCause();
    if (cause instanceof IllegalArgumentException) {
        response.setStatus(400);
        request.setAttribute("error", cause.getMessage());
    } else if (cause instanceof java.sql.SQLException) {
        application.log("Lỗi CSDL khi xử lý JSP", exception);
        response.setStatus(503);
        request.setAttribute("error", "Không lưu hoặc đọc được dữ liệu. Phiếu đang lập vẫn được giữ. Bạn có thể quay lại và thử lại.");
    } else if (exception != null) {
        application.log("Lỗi xử lý JSP", exception);
        response.setStatus(500);
        request.setAttribute("error", "Không xử lý được yêu cầu. Vui lòng quay lại và thử lại.");
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Thông báo"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<h1>Thông báo</h1><div class="actions">
<c:choose><c:when test="${not empty sessionScope.phieu}"><a class="button" href="${ctx}/GDNhapNguyenLieu3.jsp">Quay lại phiếu nhập</a></c:when>
<c:otherwise><a class="button" href="${ctx}/GDDangNhap3.jsp">Trang chủ</a></c:otherwise></c:choose>
<button type="button" onclick="history.back()">Quay lại</button></div>

<%@ include file="/WEB-INF/common/footer.jspf" %>
