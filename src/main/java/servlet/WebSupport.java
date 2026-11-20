package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

public abstract class WebSupport extends HttpServlet {
    protected abstract void get(HttpServletRequest request, HttpServletResponse response) throws Exception;
    protected void post(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.sendError(405);
    }

    @Override
    protected final void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        execute(request, response, false);
    }

    @Override
    protected final void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        execute(request, response, true);
    }

    private void execute(HttpServletRequest request, HttpServletResponse response, boolean isPost) throws ServletException, IOException {
        try {
            if (isPost) post(request, response);
            else get(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            view(request, response, "GDLoi3");
        } catch (SQLException e) {
            getServletContext().log("Lỗi CSDL tại " + request.getServletPath(), e);
            response.setStatus(503);
            request.setAttribute("error", "Không lưu hoặc đọc được dữ liệu. Phiếu đang lập vẫn được giữ. Bạn có thể quay lại và thử lại.");
            view(request, response, "GDLoi3");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void view(HttpServletRequest request, HttpServletResponse response, String name) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/" + name + ".jsp").forward(request, response);
    }

    protected void redirect(HttpServletRequest request, HttpServletResponse response, String path) throws IOException {
        response.sendRedirect(request.getContextPath() + path);
    }

    protected String text(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    protected String required(HttpServletRequest request, String name, String label, int max) {
        String value = text(request, name);
        if (value.isEmpty() || value.length() > max) throw new IllegalArgumentException(label + " phải có từ 1 đến " + max + " ký tự.");
        return value;
    }

    protected int positive(HttpServletRequest request, String name) {
        try {
            int number = Integer.parseInt(text(request, name));
            if (number > 0) return number;
        } catch (NumberFormatException ignored) {
            // Report the same validation message for missing, fractional or excessive values.
        }
        throw new IllegalArgumentException("Mã lựa chọn hoặc số lượng không hợp lệ. Số lượng phải là số nguyên dương.");
    }

    protected String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
