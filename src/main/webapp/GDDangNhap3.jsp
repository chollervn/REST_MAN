<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDDangNhap3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    if (member != null) {
        response.sendRedirect(request.getContextPath() +
                (member instanceof Customer3 ? "/GDChinhKH3.jsp" : "/GDChinhNVKho3.jsp"));
        return;
    }
    if ("POST".equals(request.getMethod())) {
        try (MemberDAO3 dao = new MemberDAO3()) {
            Member3 authenticated = dao.dangNhap(text(request, "username"), request.getParameter("password"));
            if (authenticated == null) {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
            } else {
                request.changeSessionId();
                session.setAttribute("member", authenticated);
                response.sendRedirect(request.getContextPath() +
                        (authenticated instanceof Customer3 ? "/GDChinhKH3.jsp" : "/GDChinhNVKho3.jsp"));
                return;
            }
        }
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Đăng nhập"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<h1>Đăng nhập</h1>
<form class="stack narrow" method="post" action="${ctx}/GDDangNhap3.jsp">
<%@ include file="/WEB-INF/common/tokens.jspf" %>
<label for="username">Tên đăng nhập</label><input id="username" name="username" maxlength="100" required autocomplete="username" value="<c:out value='${param.username}'/>">
<label for="password">Mật khẩu</label><input id="password" name="password" type="password" maxlength="100" required autocomplete="current-password">
<button>Đăng nhập</button></form>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
