<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Đăng nhập"/>
<%@ include file="common/header.jspf" %>

<h1>Đăng nhập</h1>
<form class="stack narrow" method="post" action="${ctx}/login">
<%@ include file="common/tokens.jspf" %>
<label for="username">Tên đăng nhập</label><input id="username" name="username" maxlength="100" required autocomplete="username" value="<c:out value='${param.username}'/>">
<label for="password">Mật khẩu</label><input id="password" name="password" type="password" maxlength="100" required autocomplete="current-password">
<button>Đăng nhập</button></form>

<%@ include file="common/footer.jspf" %>
