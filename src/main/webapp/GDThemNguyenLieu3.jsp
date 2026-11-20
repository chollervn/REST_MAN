<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDThemNguyenLieu3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    ImportIngredient3 phieu = draft(session);
    if (phieu.getId() > 0) {
        response.sendRedirect(request.getContextPath() + "/GDXacNhanNhap3.jsp");
        return;
    }
    request.setAttribute("phieu", phieu);
    if ("POST".equals(request.getMethod())) {
        checkDraftToken(request, session);
        Ingredient3 ingredient = new Ingredient3();
        ingredient.setName(required(request, "name", "Tên nguyên liệu", 150));
        ingredient.setUnit(required(request, "unit", "Đơn vị tính", 30));
        try {
            int price = Integer.parseInt(text(request, "unitCost"));
            if (price < 0) throw new NumberFormatException();
            ingredient.setUnitCost(BigDecimal.valueOf(price));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Đơn giá phải là số nguyên đồng từ 0 đến 2147483647.");
        }
        try (IngredientDAO3 dao = new IngredientDAO3()) {
            dao.themNL(ingredient, phieu.getSupplier());
        }
        response.sendRedirect(request.getContextPath() + "/GDNhapNguyenLieu3.jsp?name=" + encode(ingredient.getName()));
        return;
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Thêm nguyên liệu"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<h1>Thêm nguyên liệu</h1><p>Nhà cung cấp <strong><c:out value="${phieu.supplier.name}"/></strong></p>
<form class="stack narrow" method="post" action="${ctx}/GDThemNguyenLieu3.jsp"><%@ include file="/WEB-INF/common/tokens.jspf" %>
<label for="name">Tên nguyên liệu</label><input id="name" name="name" required maxlength="150">
<label for="unit">Đơn vị tính</label><input id="unit" name="unit" required maxlength="30">
<label for="unitCost">Đơn giá</label><input id="unitCost" name="unitCost" type="number" min="0" max="2147483647" step="1" required>
<div class="actions"><button>Lưu</button><a class="button" href="${ctx}/GDNhapNguyenLieu3.jsp">Hủy</a></div></form>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
