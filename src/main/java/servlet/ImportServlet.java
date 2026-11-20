package servlet;

import dao.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import model.*;

@WebServlet(urlPatterns={"/imports", "/ingredients/new", "/imports/confirm"})
public class ImportServlet extends WebSupport {
    private ImportIngredient3 draft(HttpServletRequest request) {
        ImportIngredient3 phieu = (ImportIngredient3) request.getSession().getAttribute("phieu");
        if (phieu == null) throw new IllegalArgumentException("Hãy chọn nhà cung cấp trước khi nhập nguyên liệu.");
        return phieu;
    }

    @Override
    protected void get(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ImportIngredient3 phieu = draft(request);
        if (phieu.getImportReceipt() != null) {
            redirect(request, response, "/receipt?id=" + phieu.getImportReceipt().getId());
            return;
        }
        request.setAttribute("phieu", phieu);
        switch (request.getServletPath()) {
            case "/ingredients/new" -> view(request, response, "GDThemNguyenLieu3");
            case "/imports/confirm" -> {
                if (phieu.getImportDetail().isEmpty()) throw new IllegalArgumentException("Hãy thêm ít nhất một nguyên liệu trước khi xác nhận.");
                view(request, response, "GDXacNhanNhap3");
            }
            default -> {
                if (phieu.getId() > 0) {
                    redirect(request, response, "/imports/confirm");
                    return;
                }
                String name = text(request, "name");
                request.setAttribute("keyword", name);
                try (IngredientDAO3 dao = new IngredientDAO3()) {
                    if (!name.isEmpty()) request.setAttribute("dsNguyenLieu", dao.getNLTheoTen(name, phieu.getSupplier()));
                    else if (request.getParameter("name") != null) request.setAttribute("error", "Vui lòng nhập tên nguyên liệu.");
                    if (request.getParameter("selectedId") != null) {
                        Ingredient3 selected = dao.getNL(positive(request, "selectedId"), phieu.getSupplier());
                        if (selected == null) throw new IllegalArgumentException("Nguyên liệu không thuộc nhà cung cấp đã chọn.");
                        request.setAttribute("selected", selected);
                    }
                }
                view(request, response, "GDNhapNguyenLieu3");
            }
        }
    }

    @Override
    protected void post(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ImportIngredient3 phieu = draft(request);
        if (!request.getSession().getAttribute("draftToken").equals(request.getParameter("draftToken"))) {
            throw new IllegalArgumentException("Phiếu trên trang này đã thay đổi. Hãy mở lại phiếu hiện tại.");
        }
        if (request.getServletPath().equals("/imports/confirm")) {
            confirm(request, response, phieu);
            return;
        }
        if (phieu.getId() > 0) throw new IllegalArgumentException("Phiếu đã lưu. Hãy mở hóa đơn hoặc lập phiếu mới.");
        if (request.getServletPath().equals("/ingredients/new")) {
            Ingredient3 ingredient = new Ingredient3();
            ingredient.setName(required(request, "name", "Tên nguyên liệu", 150));
            ingredient.setUnit(required(request, "unit", "Đơn vị tính", 30));
            try {
                int price = Integer.parseInt(text(request, "unitCost"));
                if (price < 0) throw new NumberFormatException();
                ingredient.setUnitCost(BigDecimal.valueOf(price));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Đơn giá phải là số nguyên đồng từ 0 đến 2147483647.");
            }
            try (IngredientDAO3 dao = new IngredientDAO3()) {
                dao.themNL(ingredient, phieu.getSupplier());
            }
            redirect(request, response, "/imports?name=" + encode(ingredient.getName()));
            return;
        }
        if ("remove".equals(request.getParameter("action"))) {
            int index = positive(request, "line") - 1;
            if (index >= phieu.getImportDetail().size()) throw new IllegalArgumentException("Dòng nhập đã thay đổi.");
            phieu.getImportDetail().remove(index);
        } else if ("add".equals(request.getParameter("action"))) {
            int quantity = positive(request, "quantity");
            try (IngredientDAO3 dao = new IngredientDAO3()) {
                Ingredient3 ingredient = dao.getNL(positive(request, "ingredientId"), phieu.getSupplier());
                if (ingredient == null) throw new IllegalArgumentException("Nguyên liệu không thuộc nhà cung cấp đã chọn.");
                ImportDetail detail = new ImportDetail();
                detail.setIngredient(ingredient);
                detail.setQuantity(quantity);
                detail.setUnitCost(ingredient.getUnitCost());
                if (phieu.getTotalPrice().add(detail.getThanhTien()).compareTo(new BigDecimal("9999999999.99")) > 0) {
                    throw new IllegalArgumentException("Tổng tiền vượt giới hạn lưu của phiếu nhập.");
                }
                phieu.getImportDetail().add(detail);
            }
        } else {
            throw new IllegalArgumentException("Thao tác không hợp lệ.");
        }
        redirect(request, response, "/imports?name=" + encode(text(request, "name")));
    }

    private void confirm(HttpServletRequest request, HttpServletResponse response, ImportIngredient3 phieu) throws Exception {
        if (phieu.getId() == 0) phieu.setDate(LocalDate.now());
        try (ImportIngredientDAO3 dao = new ImportIngredientDAO3()) {
            dao.luuPhieuNhap(phieu, phieu.getWarehouseStaff(), phieu.getSupplier());
        }
        // Sequence step 73: hand the saved import to the invoice controller.
        request.setAttribute("phieuDaLuu", phieu);
        request.getRequestDispatcher("/receipt").forward(request, response);
    }
}
