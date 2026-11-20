<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDThemNCC3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    if ("POST".equals(request.getMethod())) {
        Supplier3 supplier = new Supplier3();
        supplier.setName(required(request, "name", "Tên nhà cung cấp", 150));
        String phone = request.getParameter("phone");
        if (phone == null || !phone.matches("[0-9]{10}")) {
            response.setStatus(400);
            request.setAttribute("error", "Số điện thoại phải gồm đúng 10 chữ số (0–9).");
        } else {
            supplier.setPhone(phone);
            try (SupplierDAO3 dao = new SupplierDAO3()) {
                dao.themNCC(supplier);
            }
            response.sendRedirect(request.getContextPath() + "/GDTimNCC3.jsp?name=" + encode(supplier.getName()));
            return;
        }
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Thêm nhà cung cấp"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<h1>Thêm nhà cung cấp</h1><form class="stack narrow" method="post" action="${ctx}/GDThemNCC3.jsp"><%@ include file="/WEB-INF/common/tokens.jspf" %>
<label for="name">Tên nhà cung cấp</label><input id="name" name="name" required maxlength="150" value="<c:out value='${param.name}'/>">
<label for="phone">Số điện thoại</label><input id="phone" name="phone" type="tel" inputmode="numeric" required minlength="10" maxlength="10" pattern="[0-9]{10}" title="Nhập đúng 10 chữ số (0–9)" value="<c:out value='${param.phone}'/>">
<div class="actions"><button>Lưu</button><a class="button" href="${ctx}/GDTimNCC3.jsp">Hủy</a></div></form>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
