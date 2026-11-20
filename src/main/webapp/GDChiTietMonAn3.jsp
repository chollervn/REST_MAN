<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDChiTietMonAn3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    if ("POST".equals(request.getMethod())) {
        response.sendError(405);
        return;
    }

    request.setAttribute("keyword", text(request, "name"));
    try (DishDAO3 dao = new DishDAO3()) {
        Dish3 dish = dao.getMonAn(positive(request, "id"));
        if (dish == null) {
            throw new IllegalArgumentException("Món ăn không còn tồn tại. Hãy quay lại danh sách để chọn món khác.");
        }
        request.setAttribute("dish", dish);
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Thông tin chi tiết món ăn"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<c:url var="backUrl" value="/GDTimMonAn3.jsp"><c:param name="name" value="${keyword}"/></c:url>
<a class="button back" href="<c:out value='${backUrl}'/>">Quay lại</a>
<h1>Thông tin chi tiết món ăn <c:out value="${dish.name}"/></h1>
<dl><dt>Tên món ăn</dt><dd><c:out value="${dish.name}"/></dd><dt>Giá</dt><dd><fmt:formatNumber value="${dish.price}"/> đ</dd><dt>Mô tả</dt><dd class="description"><c:out value="${dish.description}"/></dd></dl>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
