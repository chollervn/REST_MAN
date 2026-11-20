package servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;
import model.*;

@WebFilter("/*")
public class AccessFilter implements Filter {
    @Override
    public void doFilter(ServletRequest input, ServletResponse output, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) input;
        HttpServletResponse response = (HttpServletResponse) output;
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        if (path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }
        response.setHeader("Cache-Control", "no-store");
        HttpSession session = request.getSession();
        // A session owns one draft. Serialize its mutations and double submissions.
        synchronized (session) {
            if (session.getAttribute("csrf") == null) session.setAttribute("csrf", UUID.randomUUID().toString());
            if ("POST".equals(request.getMethod()) && !session.getAttribute("csrf").equals(request.getParameter("csrf"))) {
                response.sendError(403, "Phiên làm việc đã thay đổi. Vui lòng tải lại trang.");
                return;
            }
            Member3 member = (Member3) session.getAttribute("member");
            if (!path.equals("/login") && !path.isEmpty() && !path.equals("/")) {
                if (member == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                boolean customerPage = path.equals("/customer") || path.equals("/dishes") || path.equals("/dish");
                if (!path.equals("/logout") && ((customerPage && !(member instanceof Customer3))
                        || (!customerPage && !(member instanceof WarehouseStaff3)))) {
                    response.sendError(403);
                    return;
                }
            }
            chain.doFilter(request, response);
        }
    }
}
