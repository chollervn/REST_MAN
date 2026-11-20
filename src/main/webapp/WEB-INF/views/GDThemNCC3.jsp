<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Thêm nhà cung cấp"/>
<%@ include file="common/header.jspf" %>

<h1>Thêm nhà cung cấp</h1><form class="stack narrow" method="post" action="${ctx}/supplier/new"><%@ include file="common/tokens.jspf" %>
<label for="name">Tên nhà cung cấp</label><input id="name" name="name" required maxlength="150" value="<c:out value='${param.name}'/>">
<label for="phone">Số điện thoại</label><input id="phone" name="phone" type="tel" inputmode="numeric" required minlength="10" maxlength="10" pattern="[0-9]{10}" title="Nhập đúng 10 chữ số (0–9)" value="<c:out value='${param.phone}'/>">
<div class="actions"><button>Lưu</button><a class="button" href="${ctx}/suppliers">Hủy</a></div></form>

<%@ include file="common/footer.jspf" %>
