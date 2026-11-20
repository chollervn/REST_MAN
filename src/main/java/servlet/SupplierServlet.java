package servlet;

import dao.SupplierDAO3;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.UUID;
import model.*;

@WebServlet(urlPatterns={"/warehouse", "/suppliers", "/supplier/new"})
public class SupplierServlet extends WebSupport {
    @Override
    protected void get(HttpServletRequest request, HttpServletResponse response) throws Exception {
        switch (request.getServletPath()) {
            case "/warehouse" -> view(request, response, "GDChinhNVKho3");
            case "/supplier/new" -> view(request, response, "GDThemNCC3");
            default -> {
                String name = text(request, "name");
                request.setAttribute("keyword", name);
                if (request.getParameter("name") != null) {
                    if (name.isEmpty()) request.setAttribute("error", "Vui lòng nhập tên nhà cung cấp.");
                    else try (SupplierDAO3 dao = new SupplierDAO3()) {
                        request.setAttribute("dsNCC", dao.getNCCTheoTen(name));
                    }
                }
                view(request, response, "GDTimNCC3");
            }
        }
    }

    @Override
    protected void post(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try (SupplierDAO3 dao = new SupplierDAO3()) {
            if (request.getServletPath().equals("/supplier/new")) {
                Supplier3 supplier = new Supplier3();
                supplier.setName(required(request, "name", "Tên nhà cung cấp", 150));
                String phone = request.getParameter("phone");
                if (phone == null || !phone.matches("[0-9]{10}")) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    request.setAttribute("error", "Số điện thoại phải gồm đúng 10 chữ số (0–9).");
                    view(request, response, "GDThemNCC3");
                    return;
                }
                supplier.setPhone(phone);
                dao.themNCC(supplier);
                redirect(request, response, "/suppliers?name=" + encode(supplier.getName()));
            } else {
                Supplier3 supplier = dao.getNCC(positive(request, "supplierId"));
                if (supplier == null) throw new IllegalArgumentException("Nhà cung cấp không tồn tại.");
                HttpSession session = request.getSession();
                ImportIngredient3 phieu = (ImportIngredient3) session.getAttribute("phieu");
                if (phieu == null || phieu.getId() > 0 || phieu.getSupplier().getId() != supplier.getId()) {
                    phieu = new ImportIngredient3();
                    phieu.setSupplier(supplier);
                    phieu.setWarehouseStaff((WarehouseStaff3) session.getAttribute("member"));
                    session.setAttribute("phieu", phieu);
                    session.setAttribute("draftToken", UUID.randomUUID().toString());
                }
                redirect(request, response, "/imports");
            }
        }
    }
}
