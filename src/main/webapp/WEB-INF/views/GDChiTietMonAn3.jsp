<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Thông tin chi tiết món ăn"/>
<%@ include file="common/header.jspf" %>

<c:url var="backUrl" value="/dishes"><c:param name="name" value="${keyword}"/></c:url>
<a class="button back" href="<c:out value='${backUrl}'/>">Quay lại</a>
<h1>Thông tin chi tiết món ăn <c:out value="${dish.name}"/></h1>
<dl><dt>Tên món ăn</dt><dd><c:out value="${dish.name}"/></dd><dt>Giá</dt><dd><fmt:formatNumber value="${dish.price}"/> đ</dd><dt>Mô tả</dt><dd class="description"><c:out value="${dish.description}"/></dd></dl>

<%@ include file="common/footer.jspf" %>
