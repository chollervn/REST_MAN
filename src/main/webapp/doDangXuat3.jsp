<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "doDangXuat3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    if ("POST".equals(request.getMethod())) {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/GDDangNhap3.jsp");
    } else {
        response.sendRedirect(request.getContextPath() +
                (member instanceof Customer3 ? "/GDChinhKH3.jsp" : "/GDChinhNVKho3.jsp"));
    }
%>
<%@ include file="/WEB-INF/common/end-request.jspf" %>
