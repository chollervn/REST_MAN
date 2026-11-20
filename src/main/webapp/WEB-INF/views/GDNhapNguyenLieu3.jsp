<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="title" value="Nhập nguyên liệu"/>
<%@ include file="common/header.jspf" %>

<h1>Nhập nguyên liệu</h1><p>Nhà cung cấp <strong><c:out value="${phieu.supplier.name}"/></strong></p>
<div class="toolbar"><form class="search" action="${ctx}/imports"><label for="name">Tên nguyên liệu</label><input id="name" name="name" required value="<c:out value='${keyword}'/>"><button>Tìm kiếm</button></form><a class="button" href="${ctx}/ingredients/new">Thêm nguyên liệu</a></div>
<div class="table-wrap"><table><thead><tr><th>STT</th><th>Tên nguyên liệu</th><th>Đơn vị</th><th>Đơn giá (đồng/đơn vị)</th><th>Chọn</th></tr></thead><tbody>
<c:forEach items="${dsNguyenLieu}" var="nl" varStatus="s"><tr><td>${s.count}</td><td><c:out value="${nl.name}"/></td><td><c:out value="${nl.unit}"/></td><td class="money"><fmt:formatNumber value="${nl.unitCost}"/></td><td>
<c:url var="selectUrl" value="/imports"><c:param name="name" value="${keyword}"/><c:param name="selectedId" value="${nl.id}"/></c:url><a class="button small" href="<c:out value='${selectUrl}'/>">Chọn</a>
</td></tr></c:forEach>
<c:if test="${not empty keyword and empty dsNguyenLieu}"><tr><td colspan="5">Không tìm thấy nguyên liệu của nhà cung cấp này.</td></tr></c:if>
</tbody></table></div>
<c:if test="${not empty selected}">
<form class="selection" method="post" action="${ctx}/imports"><%@ include file="common/tokens.jspf" %>
<input type="hidden" name="action" value="add"><input type="hidden" name="ingredientId" value="${selected.id}"><input type="hidden" name="name" value="<c:out value='${keyword}'/>">
<p>Nguyên liệu <strong><c:out value="${selected.name}"/></strong></p><div class="search"><label for="quantity">Số lượng</label><input id="quantity" name="quantity" type="number" min="1" max="2147483647" step="1" required><button>Thêm vào danh sách</button></div></form>
</c:if>
<h2>DANH SÁCH NGUYÊN LIỆU NHẬP</h2>
<div class="table-wrap"><table><thead><tr><th>STT</th><th>Nguyên liệu</th><th>Số lượng</th><th>Đơn vị</th><th>Đơn giá (đồng/đơn vị)</th><th>Thành tiền (VNĐ)</th><th>Xóa</th></tr></thead><tbody>
<c:forEach items="${phieu.importDetail}" var="line" varStatus="s"><tr><td>${s.count}</td><td><c:out value="${line.ingredient.name}"/></td><td>${line.quantity}</td><td><c:out value="${line.ingredient.unit}"/></td><td class="money"><fmt:formatNumber value="${line.unitCost}"/></td><td class="money"><fmt:formatNumber value="${line.thanhTien}"/></td>
<td><form method="post" action="${ctx}/imports"><%@ include file="common/tokens.jspf" %><input type="hidden" name="action" value="remove"><input type="hidden" name="line" value="${s.count}"><input type="hidden" name="name" value="<c:out value='${keyword}'/>"><button class="small">Xóa</button></form></td></tr></c:forEach>
<c:if test="${empty phieu.importDetail}"><tr><td colspan="7">Chưa có nguyên liệu trong phiếu.</td></tr></c:if>
</tbody></table></div><p class="total">Tổng tiền <fmt:formatNumber value="${phieu.totalPrice}"/> đ</p>
<div class="actions spread"><a class="button back" href="${ctx}/suppliers">Quay lại</a><a class="button" href="${ctx}/imports/confirm">Xác nhận</a></div>

<%@ include file="common/footer.jspf" %>
