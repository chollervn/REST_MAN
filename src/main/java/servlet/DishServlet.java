package servlet;

import dao.DishDAO3;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dish3;

@WebServlet(urlPatterns={"/customer", "/dishes", "/dish"})
public class DishServlet extends WebSupport {
    @Override
    protected void get(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getServletPath().equals("/customer")) {
            view(request, response, "GDChinhKH3");
            return;
        }
        String name = text(request, "name");
        request.setAttribute("keyword", name);
        try (DishDAO3 dao = new DishDAO3()) {
            if (request.getServletPath().equals("/dish")) {
                Dish3 dish = dao.getMonAn(positive(request, "id"));
                if (dish == null) throw new IllegalArgumentException("Món ăn không còn tồn tại. Hãy quay lại danh sách để chọn món khác.");
                request.setAttribute("dish", dish);
                view(request, response, "GDChiTietMonAn3");
            } else {
                if (request.getParameter("name") != null && name.isEmpty()) request.setAttribute("error", "Vui lòng nhập tên món ăn.");
                if (!name.isEmpty()) request.setAttribute("dsMonAn", dao.getDsMonAnTheoTen(name));
                view(request, response, "GDTimMonAn3");
            }
        }
    }
}
