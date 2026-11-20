<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Tìm nhà cung cấp"/>
<%@ include file="common/header.jspf" %>

<a class="button back" href="${ctx}/warehouse">Quay lại</a><h1>Tìm nhà cung cấp</h1>
<div class="toolbar"><form class="search" action="${ctx}/suppliers"><label for="name">Tên nhà cung cấp</label><input id="name" name="name" required value="<c:out value='${keyword}'/>"><button>Tìm kiếm</button></form><a class="button" href="${ctx}/supplier/new">Thêm nhà cung cấp</a></div>
<div class="table-wrap"><table><thead><tr><th>STT</th><th>Tên nhà cung cấp</th><th>Số điện thoại</th><th>Chọn</th></tr></thead><tbody>
<c:forEach items="${dsNCC}" var="supplier" varStatus="s"><tr><td>${s.count}</td><td><c:out value="${supplier.name}"/></td><td><c:out value="${supplier.phone}"/></td>
<td><form method="post" action="${ctx}/suppliers"><%@ include file="common/tokens.jspf" %><input type="hidden" name="supplierId" value="${supplier.id}"><button class="small">Chọn</button></form></td></tr></c:forEach>
<c:if test="${not empty keyword and empty dsNCC}"><tr><td colspan="4">Không tìm thấy nhà cung cấp phù hợp.</td></tr></c:if>
</tbody></table></div>

<%@ include file="common/footer.jspf" %>
