<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Xác nhận nhập nguyên liệu"/>
<%@ include file="common/header.jspf" %>

<h1>Xác nhận nhập nguyên liệu</h1>
<dl><dt>Nhà cung cấp</dt><dd><c:out value="${phieu.supplier.name}"/></dd><dt>Nhân viên</dt><dd><c:out value="${phieu.warehouseStaff.fullName}"/></dd><dt>Ngày nhập</dt><dd>${phieu.date.dayOfMonth}/${phieu.date.monthValue}/${phieu.date.year}</dd></dl>
<%@ include file="common/lines.jspf" %>
<p class="total">Tổng tiền <fmt:formatNumber value="${phieu.totalPrice}"/> đ</p>
<div class="actions spread"><a class="button back" href="${ctx}/imports">Quay lại</a>
<form method="post" action="${ctx}/imports/confirm"><%@ include file="common/tokens.jspf" %><button>Xác nhận nhập</button></form></div>

<%@ include file="common/footer.jspf" %>
