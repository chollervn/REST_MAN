<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Hóa đơn nhập nguyên liệu"/>
<%@ include file="common/header.jspf" %>

<h1>Hóa đơn nhập nguyên liệu</h1><c:set var="phieu" value="${hoaDon.importIngredient}"/>
<dl><dt>Mã hóa đơn</dt><dd><strong><c:out value="${hoaDon.code}"/></strong></dd>
<dt>Nhà cung cấp</dt><dd><c:out value="${phieu.supplier.name}"/></dd>
<dt>Nhân viên nhập</dt><dd><c:out value="${phieu.warehouseStaff.fullName}"/></dd>
<dt>Ngày nhập</dt><dd>${phieu.date.dayOfMonth}/${phieu.date.monthValue}/${phieu.date.year}</dd>
<dt>Tổng thanh toán</dt><dd><strong><fmt:formatNumber value="${hoaDon.totalPrice}"/> đ</strong></dd></dl>
<div class="print-only"><%@ include file="common/lines.jspf" %></div>
<div class="actions no-print"><button type="button" onclick="window.print()">Xuất hóa đơn</button><a class="button back" href="${ctx}/warehouse">Trang chủ</a></div>

<%@ include file="common/footer.jspf" %>
