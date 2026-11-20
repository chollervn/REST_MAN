<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Tìm món ăn"/>
<%@ include file="common/header.jspf" %>

<a class="button back" href="${ctx}/customer">Quay lại</a><h1>Tìm món ăn</h1>
<form class="search" action="${ctx}/dishes"><label class="sr-only" for="name">Tên món ăn</label><input id="name" name="name" required value="<c:out value='${keyword}'/>"><button>Tìm kiếm</button></form>
<h2>DANH SÁCH MÓN ĂN</h2>
<div class="table-wrap"><table><thead><tr><th>TT</th><th>Tên</th><th>Giá</th><th>Xem chi tiết</th></tr></thead><tbody>
<c:forEach items="${dsMonAn}" var="dish" varStatus="s"><tr><td>${s.count}</td><td><c:out value="${dish.name}"/></td><td class="money"><fmt:formatNumber value="${dish.price}"/> đ</td>
<td><c:url var="detailUrl" value="/dish"><c:param name="id" value="${dish.id}"/><c:param name="name" value="${keyword}"/></c:url><a href="<c:out value='${detailUrl}'/>">Xem chi tiết</a></td></tr></c:forEach>
<c:if test="${not empty keyword and empty dsMonAn}"><tr><td colspan="4">Không tìm thấy món ăn phù hợp.</td></tr></c:if>
</tbody></table></div>

<%@ include file="common/footer.jspf" %>
