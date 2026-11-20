package servlet;

import dao.HoaDonDAO3;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.ImportIngredient3;
import model.ImportReceipt3;
import model.WarehouseStaff3;

/** Handles the GDHoaDonNhap3 interaction in sequence steps 74-86. */
@WebServlet("/receipt")
public class HoaDonServlet extends WebSupport {
    @Override
    protected void post(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Only the confirmation controller supplies this server-side attribute.
        Object savedImport = request.getAttribute("phieuDaLuu");
        WarehouseStaff3 staff = (WarehouseStaff3) request.getSession().getAttribute("member");
        if (!(savedImport instanceof ImportIngredient3 phieu)
                || phieu != request.getSession().getAttribute("phieu")
                || phieu.getId() <= 0
                || phieu.getWarehouseStaff().getId() != staff.getId()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hãy xác nhận lưu phiếu trước khi lập hóa đơn.");
            return;
        }

        ImportReceipt3 hoaDon = phieu.getImportReceipt();
        if (hoaDon == null) {
            hoaDon = new ImportReceipt3();
            hoaDon.setName("Hóa đơn nhập nguyên liệu");
            hoaDon.setImportIngredient(phieu);
            try (HoaDonDAO3 dao = new HoaDonDAO3()) {
                dao.luuHoaDon(hoaDon);
            }
            phieu.setImportReceipt(hoaDon);
        }
        // The GET below reads the saved invoice once and renders the invoice JSP.
        redirect(request, response, "/receipt?id=" + hoaDon.getId());
    }

    @Override
    protected void get(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try (HoaDonDAO3 dao = new HoaDonDAO3()) {
            ImportReceipt3 hoaDon = dao.getHoaDon(positive(request, "id"));
            WarehouseStaff3 staff = (WarehouseStaff3) request.getSession().getAttribute("member");
            if (hoaDon == null || hoaDon.getImportIngredient().getWarehouseStaff().getId() != staff.getId()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            request.setAttribute("hoaDon", hoaDon);
            view(request, response, "GDHoaDonNhap3");
        }
    }
}
