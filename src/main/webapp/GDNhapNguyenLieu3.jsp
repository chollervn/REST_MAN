<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDNhapNguyenLieu3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    if ("POST".equals(request.getMethod()) && request.getParameter("supplierId") != null) {
        try (SupplierDAO3 dao = new SupplierDAO3()) {
            Supplier3 supplier = dao.getNCC(positive(request, "supplierId"));
            if (supplier == null) throw new IllegalArgumentException("Nhà cung cấp không tồn tại.");
            ImportIngredient3 current = (ImportIngredient3) session.getAttribute("phieu");
            if (current == null || current.getId() > 0 || current.getSupplier().getId() != supplier.getId()) {
                current = new ImportIngredient3();
                current.setSupplier(supplier);
                current.setWarehouseStaff((WarehouseStaff3) member);
                session.setAttribute("phieu", current);
                session.setAttribute("draftToken", UUID.randomUUID().toString());
            }
        }
        response.sendRedirect(request.getContextPath() + "/GDNhapNguyenLieu3.jsp");
        return;
    }
    ImportIngredient3 phieu = draft(session);
    if (phieu.getImportReceipt() != null) {
        response.sendRedirect(request.getContextPath() + "/GDHoaDonNhap3.jsp?id=" + phieu.getImportReceipt().getId());
        return;
    }
    if (phieu.getId() > 0) {
        response.sendRedirect(request.getContextPath() + "/GDXacNhanNhap3.jsp");
        return;
    }
    String name = text(request, "name");
    if ("POST".equals(request.getMethod())) {
        checkDraftToken(request, session);
        if ("remove".equals(request.getParameter("action"))) {
            int index = positive(request, "line") - 1;
            if (index >= phieu.getImportDetail().size()) throw new IllegalArgumentException("Dòng nhập đã thay đổi.");
            phieu.getImportDetail().remove(index);
        } else if ("add".equals(request.getParameter("action"))) {
            int quantity = positive(request, "quantity");
            try (IngredientDAO3 dao = new IngredientDAO3()) {
                Ingredient3 ingredient = dao.getNL(positive(request, "ingredientId"), phieu.getSupplier());
                if (ingredient == null) throw new IllegalArgumentException("Nguyên liệu không thuộc nhà cung cấp đã chọn.");
                ImportDetail detail = new ImportDetail();
                detail.setIngredient(ingredient);
                detail.setQuantity(quantity);
                detail.setUnitCost(ingredient.getUnitCost());
                if (phieu.getTotalPrice().add(detail.getThanhTien()).compareTo(new BigDecimal("9999999999.99")) > 0) {
                    throw new IllegalArgumentException("Tổng tiền vượt giới hạn lưu của phiếu nhập.");
                }
                phieu.getImportDetail().add(detail);
            }
        } else {
            throw new IllegalArgumentException("Thao tác không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/GDNhapNguyenLieu3.jsp?name=" + encode(name));
        return;
    }
    request.setAttribute("phieu", phieu);
    request.setAttribute("keyword", name);
    if (!name.isEmpty() || request.getParameter("selectedId") != null) {
        try (IngredientDAO3 dao = new IngredientDAO3()) {
            if (!name.isEmpty()) request.setAttribute("dsNguyenLieu", dao.getNLTheoTen(name, phieu.getSupplier()));
            if (request.getParameter("selectedId") != null) {
                Ingredient3 selected = dao.getNL(positive(request, "selectedId"), phieu.getSupplier());
                if (selected == null) throw new IllegalArgumentException("Nguyên liệu không thuộc nhà cung cấp đã chọn.");
                request.setAttribute("selected", selected);
            }
        }
    }
    if (name.isEmpty() && request.getParameter("name") != null) {
        request.setAttribute("error", "Vui lòng nhập tên nguyên liệu.");
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Nhập nguyên liệu"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<h1>Nhập nguyên liệu</h1><p>Nhà cung cấp <strong><c:out value="${phieu.supplier.name}"/></strong></p>
<div class="toolbar"><form class="search" action="${ctx}/GDNhapNguyenLieu3.jsp"><label for="name">Tên nguyên liệu</label><input id="name" name="name" required value="<c:out value='${keyword}'/>"><button>Tìm kiếm</button></form><a class="button" href="${ctx}/GDThemNguyenLieu3.jsp">Thêm nguyên liệu</a></div>
<div class="table-wrap"><table><thead><tr><th>STT</th><th>Tên nguyên liệu</th><th>Đơn vị</th><th>Đơn giá (đồng/đơn vị)</th><th>Chọn</th></tr></thead><tbody>
<c:forEach items="${dsNguyenLieu}" var="nl" varStatus="s"><tr><td>${s.count}</td><td><c:out value="${nl.name}"/></td><td><c:out value="${nl.unit}"/></td><td class="money"><fmt:formatNumber value="${nl.unitCost}"/></td><td>
<c:url var="selectUrl" value="/GDNhapNguyenLieu3.jsp"><c:param name="name" value="${keyword}"/><c:param name="selectedId" value="${nl.id}"/></c:url><a class="button small" href="<c:out value='${selectUrl}'/>">Chọn</a>
</td></tr></c:forEach>
<c:if test="${not empty keyword and empty dsNguyenLieu}"><tr><td colspan="5">Không tìm thấy nguyên liệu của nhà cung cấp này.</td></tr></c:if>
</tbody></table></div>
<c:if test="${not empty selected}">
<form class="selection" method="post" action="${ctx}/GDNhapNguyenLieu3.jsp"><%@ include file="/WEB-INF/common/tokens.jspf" %>
<input type="hidden" name="action" value="add"><input type="hidden" name="ingredientId" value="${selected.id}"><input type="hidden" name="name" value="<c:out value='${keyword}'/>">
<p>Nguyên liệu <strong><c:out value="${selected.name}"/></strong></p><div class="search"><label for="quantity">Số lượng</label><input id="quantity" name="quantity" type="number" min="1" max="2147483647" step="1" required><button>Thêm vào danh sách</button></div></form>
</c:if>
<h2>DANH SÁCH NGUYÊN LIỆU NHẬP</h2>
<div class="table-wrap"><table><thead><tr><th>STT</th><th>Nguyên liệu</th><th>Số lượng</th><th>Đơn vị</th><th>Đơn giá (đồng/đơn vị)</th><th>Thành tiền (VNĐ)</th><th>Xóa</th></tr></thead><tbody>
<c:forEach items="${phieu.importDetail}" var="line" varStatus="s"><tr><td>${s.count}</td><td><c:out value="${line.ingredient.name}"/></td><td>${line.quantity}</td><td><c:out value="${line.ingredient.unit}"/></td><td class="money"><fmt:formatNumber value="${line.unitCost}"/></td><td class="money"><fmt:formatNumber value="${line.thanhTien}"/></td>
<td><form method="post" action="${ctx}/GDNhapNguyenLieu3.jsp"><%@ include file="/WEB-INF/common/tokens.jspf" %><input type="hidden" name="action" value="remove"><input type="hidden" name="line" value="${s.count}"><input type="hidden" name="name" value="<c:out value='${keyword}'/>"><button class="small">Xóa</button></form></td></tr></c:forEach>
<c:if test="${empty phieu.importDetail}"><tr><td colspan="7">Chưa có nguyên liệu trong phiếu.</td></tr></c:if>
</tbody></table></div><p class="total">Tổng tiền <fmt:formatNumber value="${phieu.totalPrice}"/> đ</p>
<div class="actions spread"><a class="button back" href="${ctx}/GDTimNCC3.jsp">Quay lại</a><a class="button" href="${ctx}/GDXacNhanNhap3.jsp">Xác nhận</a></div>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
