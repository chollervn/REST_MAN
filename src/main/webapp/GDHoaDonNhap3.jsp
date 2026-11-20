<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDHoaDonNhap3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    WarehouseStaff3 staff = (WarehouseStaff3) member;
    if ("POST".equals(request.getMethod())) {
        Object savedImport = request.getAttribute("phieuDaLuu");
        ImportIngredient3 phieu = savedImport instanceof ImportIngredient3
                ? (ImportIngredient3) savedImport : null;
        if (phieu == null || phieu != session.getAttribute("phieu") || phieu.getId() <= 0
                || phieu.getWarehouseStaff().getId() != staff.getId()) {
            response.sendError(400, "Hãy xác nhận lưu phiếu trước khi lập hóa đơn.");
            return;
        }
        ImportReceipt3 hoaDon = phieu.getImportReceipt();
        if (hoaDon == null) {
            hoaDon = new ImportReceipt3();
            hoaDon.setName("Hóa đơn nhập nguyên liệu");
            hoaDon.setImportIngredient(phieu);
            try (HoaDonDAO3 dao = new HoaDonDAO3()) {
                dao.luuHoaDon(hoaDon);
            }
            phieu.setImportReceipt(hoaDon);
        }
        response.sendRedirect(request.getContextPath() + "/GDHoaDonNhap3.jsp?id=" + hoaDon.getId());
        return;
    }
    try (HoaDonDAO3 dao = new HoaDonDAO3()) {
        ImportReceipt3 hoaDon = dao.getHoaDon(positive(request, "id"));
        if (hoaDon == null || hoaDon.getImportIngredient().getWarehouseStaff().getId() != staff.getId()) {
            response.sendError(404);
            return;
        }
        request.setAttribute("hoaDon", hoaDon);
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Hóa đơn nhập nguyên liệu"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<h1>Hóa đơn nhập nguyên liệu</h1><c:set var="phieu" value="${hoaDon.importIngredient}"/>
<dl><dt>Mã hóa đơn</dt><dd><strong><c:out value="${hoaDon.code}"/></strong></dd>
<dt>Nhà cung cấp</dt><dd><c:out value="${phieu.supplier.name}"/></dd>
<dt>Nhân viên nhập</dt><dd><c:out value="${phieu.warehouseStaff.fullName}"/></dd>
<dt>Ngày nhập</dt><dd>${phieu.date.dayOfMonth}/${phieu.date.monthValue}/${phieu.date.year}</dd>
<dt>Tổng thanh toán</dt><dd><strong><fmt:formatNumber value="${hoaDon.totalPrice}"/> đ</strong></dd></dl>
<div class="print-only"><%@ include file="/WEB-INF/common/lines.jspf" %></div>
<div class="actions no-print"><button type="button" onclick="window.print()">Xuất hóa đơn</button><a class="button back" href="${ctx}/GDChinhNVKho3.jsp">Trang chủ</a></div>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
