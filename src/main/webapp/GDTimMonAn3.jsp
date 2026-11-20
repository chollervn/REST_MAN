<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDTimMonAn3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    if ("POST".equals(request.getMethod())) {
        response.sendError(405);
        return;
    }

    String name = text(request, "name");
    request.setAttribute("keyword", name);
    if (!name.isEmpty()) {
        try (DishDAO3 dao = new DishDAO3()) {
            request.setAttribute("dsMonAn", dao.getDsMonAnTheoTen(name));
        }
    } else if (request.getParameter("name") != null) {
        request.setAttribute("error", "Vui lòng nhập tên món ăn.");
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Tìm món ăn"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<a class="button back" href="${ctx}/GDChinhKH3.jsp">Quay lại</a><h1>Tìm món ăn</h1>
<form class="search" action="${ctx}/GDTimMonAn3.jsp"><label class="sr-only" for="name">Tên món ăn</label><input id="name" name="name" required value="<c:out value='${keyword}'/>"><button>Tìm kiếm</button></form>
<h2>DANH SÁCH MÓN ĂN</h2>
<div class="table-wrap"><table><thead><tr><th>TT</th><th>Tên</th><th>Giá</th><th>Xem chi tiết</th></tr></thead><tbody>
<c:forEach items="${dsMonAn}" var="dish" varStatus="s"><tr><td>${s.count}</td><td><c:out value="${dish.name}"/></td><td class="money"><fmt:formatNumber value="${dish.price}"/> đ</td>
<td><c:url var="detailUrl" value="/GDChiTietMonAn3.jsp"><c:param name="id" value="${dish.id}"/><c:param name="name" value="${keyword}"/></c:url><a href="<c:out value='${detailUrl}'/>">Xem chi tiết</a></td></tr></c:forEach>
<c:if test="${not empty keyword and empty dsMonAn}"><tr><td colspan="4">Không tìm thấy món ăn phù hợp.</td></tr></c:if>
</tbody></table></div>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
