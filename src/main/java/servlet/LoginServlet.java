package servlet;

import dao.MemberDAO3;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

@WebServlet(urlPatterns={"/login", "/logout"})
public class LoginServlet extends WebSupport {
    @Override
    protected void get(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Member3 member = (Member3) request.getSession().getAttribute("member");
        if (member != null) {
            redirect(request, response, member instanceof Customer3 ? "/customer" : "/warehouse");
            return;
        }
        view(request, response, "GDDangNhap3");
    }

    @Override
    protected void post(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getServletPath().equals("/logout")) {
            request.getSession().invalidate();
            redirect(request, response, "/login");
            return;
        }
        try (MemberDAO3 dao = new MemberDAO3()) {
            Member3 member = dao.dangNhap(text(request, "username"), request.getParameter("password"));
            if (member == null) {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
                view(request, response, "GDDangNhap3");
                return;
            }
            request.changeSessionId();
            request.getSession().setAttribute("member", member);
            redirect(request, response, member instanceof Customer3 ? "/customer" : "/warehouse");
        }
    }
}
