<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Thêm nguyên liệu"/>
<%@ include file="common/header.jspf" %>

<h1>Thêm nguyên liệu</h1><p>Nhà cung cấp <strong><c:out value="${phieu.supplier.name}"/></strong></p>
<form class="stack narrow" method="post" action="${ctx}/ingredients/new"><%@ include file="common/tokens.jspf" %>
<label for="name">Tên nguyên liệu</label><input id="name" name="name" required maxlength="150">
<label for="unit">Đơn vị tính</label><input id="unit" name="unit" required maxlength="30">
<label for="unitCost">Đơn giá</label><input id="unitCost" name="unitCost" type="number" min="0" max="2147483647" step="1" required>
<div class="actions"><button>Lưu</button><a class="button" href="${ctx}/imports">Hủy</a></div></form>

<%@ include file="common/footer.jspf" %>
