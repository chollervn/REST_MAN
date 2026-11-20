<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDXacNhanNhap3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    ImportIngredient3 phieu = draft(session);
    if (phieu.getImportDetail().isEmpty()) {
        throw new IllegalArgumentException("Hãy thêm ít nhất một nguyên liệu trước khi xác nhận.");
    }
    request.setAttribute("phieu", phieu);
    if ("POST".equals(request.getMethod())) {
        checkDraftToken(request, session);
        if (phieu.getId() == 0) phieu.setDate(LocalDate.now());
        try (ImportIngredientDAO3 dao = new ImportIngredientDAO3()) {
            dao.luuPhieuNhap(phieu, phieu.getWarehouseStaff(), phieu.getSupplier());
        }
        // Chỉ chuyển sang trang hóa đơn sau khi phiếu đã lưu thành công.
        request.setAttribute("phieuDaLuu", phieu);
        request.getRequestDispatcher("/GDHoaDonNhap3.jsp").forward(request, response);
        return;
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Xác nhận nhập nguyên liệu"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<h1>Xác nhận nhập nguyên liệu</h1>
<dl><dt>Nhà cung cấp</dt><dd><c:out value="${phieu.supplier.name}"/></dd><dt>Nhân viên</dt><dd><c:out value="${phieu.warehouseStaff.fullName}"/></dd><dt>Ngày nhập</dt><dd>${phieu.date.dayOfMonth}/${phieu.date.monthValue}/${phieu.date.year}</dd></dl>
<%@ include file="/WEB-INF/common/lines.jspf" %>
<p class="total">Tổng tiền <fmt:formatNumber value="${phieu.totalPrice}"/> đ</p>
<div class="actions spread"><a class="button back" href="${ctx}/GDNhapNguyenLieu3.jsp">Quay lại</a>
<form method="post" action="${ctx}/GDXacNhanNhap3.jsp"><%@ include file="/WEB-INF/common/tokens.jspf" %><button>Xác nhận nhập</button></form></div>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
