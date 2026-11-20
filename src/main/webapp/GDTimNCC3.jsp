<%@ page pageEncoding="UTF-8" %>
<% String currentPage = "GDTimNCC3"; %>
<%@ include file="/WEB-INF/common/request.jspf" %>
<%
    // Hỗ trợ yêu cầu chọn nhà cung cấp gửi tới đường dẫn /suppliers cũ.
    if ("POST".equals(request.getMethod())) {
        request.getRequestDispatcher("/GDNhapNguyenLieu3.jsp").forward(request, response);
        return;
    }
    String name = text(request, "name");
    request.setAttribute("keyword", name);
    if (!name.isEmpty()) {
        try (SupplierDAO3 dao = new SupplierDAO3()) {
            request.setAttribute("dsNCC", dao.getNCCTheoTen(name));
        }
    } else if (request.getParameter("name") != null) {
        request.setAttribute("error", "Vui lòng nhập tên nhà cung cấp.");
    }
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Tìm nhà cung cấp"/>
<%@ include file="/WEB-INF/common/header.jspf" %>

<a class="button back" href="${ctx}/GDChinhNVKho3.jsp">Quay lại</a><h1>Tìm nhà cung cấp</h1>
<div class="toolbar"><form class="search" action="${ctx}/GDTimNCC3.jsp"><label for="name">Tên nhà cung cấp</label><input id="name" name="name" required value="<c:out value='${keyword}'/>"><button>Tìm kiếm</button></form><a class="button" href="${ctx}/GDThemNCC3.jsp">Thêm nhà cung cấp</a></div>
<div class="table-wrap"><table><thead><tr><th>STT</th><th>Tên nhà cung cấp</th><th>Số điện thoại</th><th>Chọn</th></tr></thead><tbody>
<c:forEach items="${dsNCC}" var="supplier" varStatus="s"><tr><td>${s.count}</td><td><c:out value="${supplier.name}"/></td><td><c:out value="${supplier.phone}"/></td>
<td><form method="post" action="${ctx}/GDNhapNguyenLieu3.jsp"><%@ include file="/WEB-INF/common/tokens.jspf" %><input type="hidden" name="supplierId" value="${supplier.id}"><button class="small">Chọn</button></form></td></tr></c:forEach>
<c:if test="${not empty keyword and empty dsNCC}"><tr><td colspan="4">Không tìm thấy nhà cung cấp phù hợp.</td></tr></c:if>
</tbody></table></div>

<%@ include file="/WEB-INF/common/footer.jspf" %>

<%@ include file="/WEB-INF/common/end-request.jspf" %>
