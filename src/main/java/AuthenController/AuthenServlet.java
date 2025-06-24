/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package AuthenController;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.UUID;
import model.SendMailOK;
import model.User;

/**
 *
 * @author FPT
 */
public class AuthenServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourseDetailAdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseDetailAdminServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";

        try {
            switch (action) {
                case "login":
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    break;
                case "logout":
                try {
                    logout(request, response);
                } catch (IOException ex) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
                break;
                case "editprofile":
                    request.getRequestDispatcher("editProfile.jsp").forward(request, response); // ✅ Chỉ hiển thị form
                    break;
                case "changepassword":
                    request.getRequestDispatcher("changePassword.jsp").forward(request, response); // ✅ Sửa tại đây
                    break;
                case "resetpassword":
                    request.getRequestDispatcher("resetPassword.jsp").forward(request, response); // ✅ Sửa tại đây
                    break;
                case "verify":
                    verifyEmail(request, response);
                    break;

                default:
                    response.sendRedirect("home");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action") != null ? request.getParameter("action") : "";

        try {
            switch (action) {
                case "login":
                    login(request, response);
                    break;
                case "editprofile":
                    updateProfile(request, response);
                    break;
                case "changepassword":
                    changePassword(request, response);
                    break;
                case "resetpassword":
                    String nextPage = resetPassword(request, response);
                    if (nextPage != null) {
                        request.getRequestDispatcher(nextPage).forward(request, response);
                    }
                    break;

                default:
                    response.sendRedirect("home");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember_me");

        try {
            User user = userDAO.login(email, password);

            if (user == null) {
                request.getSession().setAttribute("notification", "❌ Sai email hoặc mật khẩu. Vui lòng thử lại.");
                response.sendRedirect("login.jsp");
                return;
            }

            if (!user.isStatus()) {
                request.getSession().setAttribute("notification", "⚠️ Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email.");
                response.sendRedirect("login.jsp");
                return;
            }

            if (!user.isIsActive()) {
                request.getSession().setAttribute("notification", "⚠️ Gói dịch vụ của bạn chưa được kích hoạt. Vui lòng chọn gói hoặc chờ xác nhận.");
                response.sendRedirect("login.jsp");
                return;
            }

            // Lưu user vào session
            // Lưu user và userId vào session
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // giữ nguyên
            session.setAttribute("userId", user.getId()); // 🔥 thêm dòng này

            // Xử lý remember me
            if (rememberMe != null) {
                Cookie cEmail = new Cookie("cEmail", email);
                Cookie cPassword = new Cookie("cPassword", password);

                // Set thời hạn 6 tháng
                int expiry = 60 * 60 * 24 * 30 * 6;
                cEmail.setMaxAge(expiry);
                cPassword.setMaxAge(expiry);

                // Quan trọng: set path để cookie hoạt động toàn hệ thống
                cEmail.setPath("/");
                cPassword.setPath("/");

                response.addCookie(cEmail);
                response.addCookie(cPassword);
            }

            System.out.println("✅ Đăng nhập thành công: " + user.getFullname() + " | Vai trò: " + user.getRoleId());

            // Điều hướng sau đăng nhập
            String redirectUrl = request.getParameter("redirect");
            if (redirectUrl == null || redirectUrl.isEmpty()) {
                redirectUrl = (user.getRoleId() == 2 || user.getRoleId() == 3) ? "admin" : "home";
            }

            response.sendRedirect(redirectUrl);

        } catch (SQLException ex) {
            ex.printStackTrace(); // Log server
            request.getSession().setAttribute("notification", "🚨 Lỗi hệ thống: " + ex.getMessage());
            response.sendRedirect("login.jsp");
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect("home");
    }

    private String updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            return "login.jsp";
        }

        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Kiểm tra các tham số có null không
        if (fullname == null || phone == null || address == null) {
            request.setAttribute("notification", "Thiếu thông tin cần thiết");
            return "editProfile.jsp"; // <- tên file nên viết thường
        }

        // Kiểm tra số điện thoại hợp lệ
        if (!phone.matches("^(032|033|034|035|036|037|038|039|096|097|098|086|083|084|085|081|082|088|091|094|070|079|077|076|078|090|093|089|056|058|092|059|099)[0-9]{7}$")) {
            request.setAttribute("notification", "Số điện thoại không hợp lệ");
            return "editProfile.jsp";
        }

        // Cập nhật đối tượng người dùng
        User updatedUser = new User();
        updatedUser.setId(currentUser.getId());
        updatedUser.setEmail(currentUser.getEmail());
        updatedUser.setPassword(currentUser.getPassword());
        updatedUser.setFullname(fullname);
        updatedUser.setPhone(phone);
        updatedUser.setAddress(address);
        updatedUser.setRoleId(currentUser.getRoleId());
        updatedUser.setStatus(currentUser.isStatus());

        UserDAO userDAO = new UserDAO(); // ✅ Đảm bảo được khởi tạo

        try {
            if (userDAO.updateProfile(updatedUser)) {
                session.setAttribute("user", updatedUser);
                request.setAttribute("notification", "Cập nhật thông tin thành công");
            } else {
                request.setAttribute("notification", "Cập nhật thông tin thất bại");
            }
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
        }

        return "editProfile.jsp"; // ✅ Viết đúng tên file JSP
    }

    private String changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            return "login.jsp";
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate inputs
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("notification", "Mật khẩu mới không khớp");
            return "changePassword.jsp";
        }

        try {
            // Verify old password
            User user = userDAO.login(currentUser.getEmail(), oldPassword);
            if (user == null) {
                request.setAttribute("notification", "Mật khẩu cũ không đúng");
                return "changePassword.jsp";
            }
// Validate inputs
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("notification", "Mật khẩu mới không khớp");
                return "changePassword.jsp";
            }

            if (newPassword.equals(oldPassword)) {
                request.setAttribute("notification", "Mật khẩu mới không được trùng với mật khẩu cũ");
                return "changePassword.jsp";
            }

            if (!isValidPassword(newPassword)) {
                request.setAttribute("notification", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số");
                return "changePassword.jsp";
            }

            if (userDAO.changePassword(currentUser.getId(), newPassword)) {
                currentUser.setPassword(newPassword);
                session.setAttribute("user", currentUser);
                session.invalidate(); // bắt buộc đăng nhập lại

                // Chuyển hướng đến changepassword.jsp và gắn cờ thành công
                request.setAttribute("success", true);
                request.setAttribute("notification", "Đổi mật khẩu thành công. Vui lòng đăng nhập lại sau vài giây...");
                return "changePassword.jsp";

            } else {
                request.setAttribute("notification", "Đổi mật khẩu thất bại");
            }

            return "changePassword.jsp";
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            return "changePassword.jsp";
        }
    }

    private boolean isValidPassword(String password) {
        // Ví dụ: ít nhất 8 ký tự, 1 chữ hoa, 1 chữ thường, 1 số
        String regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$";
        return password != null && password.matches(regex);
    }

    private String resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(); // <-- phải khai báo session ở đây

        String email = request.getParameter("email");

        try {
            if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                request.setAttribute("error", "⚠️ Email không hợp lệ");
                return "resetPassword.jsp";
            }
            User user = userDAO.getUserByEmail(email);
            if (user == null) {
                request.setAttribute("error", "❌ Email không tồn tại trong hệ thống");
                return "resetPassword.jsp";
            }

            // Tạo token reset password (hết hạn sau 24h)
            String token = UUID.randomUUID().toString();
            userDAO.saveResetToken(email, token); // Bạn cần có method này

            String resetLink = request.getScheme() + "://"
                    + request.getServerName()
                    + (request.getServerPort() != 80 && request.getServerPort() != 443
                    ? ":" + request.getServerPort() : "")
                    + request.getContextPath()
                    + "/authen?action=changepassword&token=" + token;

            String emailBody = "<!DOCTYPE html>"
                    + "<html lang='vi'>"
                    + "<head>"
                    + "<meta charset='UTF-8'>"
                    + "<style>"
                    + "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #fffaf4; color: #333; padding: 20px; }"
                    + ".container { max-width: 600px; margin: auto; background-color: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 20px; }"
                    + "h2 { color: #ff6600; }"
                    + ".button { display: inline-block; background-color: #ff9966; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: bold; }"
                    + ".footer { font-size: 13px; color: #888; margin-top: 30px; line-height: 1.6; }"
                    + ".footer strong { color: #555; }"
                    + "</style>"
                    + "</head>"
                    + "<body>"
                    + "<div class='container'>"
                    + "<h2>🔐 Yêu cầu đặt lại mật khẩu</h2>"
                    + "<p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản PetTech của bạn.</p>"
                    + "<p>Vui lòng nhấn vào nút dưới đây để tạo mật khẩu mới:</p>"
                    + "<p><a class='button' href='" + resetLink + "'>Đặt lại mật khẩu</a></p>"
                    + "<p>Nếu bạn không yêu cầu, hãy bỏ qua email này.</p>"
                    + "<div class='footer'>"
                    + "<strong>❤️ PetTech Team</strong><br>"
                    + "Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi nhé! 🧡<br>"
                    + "📞 Hỗ trợ: <a href='tel:0352138596'>0352 138 596</a><br>"
                    + "Địa chỉ: Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội"
                    + "</div>"
                    + "</div>"
                    + "</body>"
                    + "</html>";

            SendMailOK.send(
                    "smtp.gmail.com",
                    email,
                    "vdc120403@gmail.com",
                    "ednn nwbo zbyq gahs",
                    "Đặt lại mật khẩu PetTech",
                    emailBody
            );

            // Thêm thông báo thành công vào session
            session.setAttribute("success", "✅ Yêu cầu đặt lại mật khẩu đã được gửi. Vui lòng kiểm tra email của bạn.");
            response.sendRedirect("login.jsp"); // Chuyển hướng về trang login
            return null;

        } catch (SQLException ex) {
            request.setAttribute("error", "🚨 Lỗi hệ thống: " + ex.getMessage());
            return "resetPassword.jsp";
        } catch (Exception e) {
            request.setAttribute("error", "🚨 Gửi email đặt lại mật khẩu thất bại. Vui lòng thử lại.");
            return "resetPassword.jsp";
        }
    }

    private void verifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String token = request.getParameter("token");
        HttpSession session = request.getSession();

        try {
            if (userDAO.verifyUser(token)) {
                session.setAttribute("notification", "Xác thực email thành công. Bạn có thể đăng nhập ngay bây giờ.");
            } else {
                session.setAttribute("notification", "Liên kết xác thực không hợp lệ hoặc đã được sử dụng.");
            }

            response.sendRedirect("login.jsp");
        } catch (SQLException ex) {
            session.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            response.sendRedirect("login.jsp");
        }
    }

    private String generateRandomPassword(int length) {

        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * chars.length());
            sb.append(chars.charAt(index));
        }

        return sb.toString();
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
