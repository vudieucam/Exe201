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
import java.sql.SQLException;
import java.util.UUID;
import model.SendMailOK;
import model.User;

/**
 *
 * @author FPT
 */
public class AuthenServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                    updateProfile(request, response);
                    break;
                case "changepassword":
                    changePassword(request, response);
                    break;
                case "resetpassword":
                    resetPassword(request, response);
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
                    resetPassword(request, response);
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

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember_me");

        try {
            User user = userDAO.login(email, password);

            if (user == null) {
                request.setAttribute("notification", "❌ Sai email hoặc mật khẩu. Vui lòng thử lại.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if (!user.isStatus()) {
                request.setAttribute("notification", "⚠️ Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if (!user.isIsActive()) {
                request.setAttribute("notification", "⚠️ Gói dịch vụ của bạn chưa được kích hoạt. Vui lòng chọn gói hoặc chờ xác nhận.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Lưu user vào session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Xử lý remember me
            if (rememberMe != null) {
                Cookie cEmail = new Cookie("cEmail", email);
                Cookie cPassword = new Cookie("cPassword", password);
                cEmail.setMaxAge(60 * 60 * 24 * 30 * 6);
                cPassword.setMaxAge(60 * 60 * 24 * 30 * 6);
                response.addCookie(cEmail);
                response.addCookie(cPassword);
            }

            System.out.println("Đăng nhập thành công: " + user.getFullname() + " | Vai trò: " + user.getRoleId());

            // Xác định URL chuyển hướng
            String redirectUrl;

            // Ưu tiên tham số redirect trong URL
            String redirectParam = request.getParameter("redirect");
            if (redirectParam != null && !redirectParam.isEmpty()) {
                redirectUrl = redirectParam;
            } // Nếu không có tham số redirect, kiểm tra role
            else {
                switch (user.getRoleId()) {
                    case 2: // admin
                    case 3: // staff
                        redirectUrl = "admin";
                        break;
                    default: // user
                        redirectUrl = "home";
                }
            }

            // Thực hiện chuyển hướng
            response.sendRedirect(redirectUrl);

        } catch (SQLException ex) {
            request.setAttribute("error", "🚨 Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
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

        try {
            if (userDAO.updateProfile(updatedUser)) {
                session.setAttribute("user", updatedUser);
                request.setAttribute("notification", "Cập nhật thông tin thành công");
            } else {
                request.setAttribute("notification", "Cập nhật thông tin thất bại");
            }
            return "editProfile.jsp";
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            return "editProfile.jsp";
        }
    }

    private String changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        String email = request.getParameter("email");

        try {
            User user = userDAO.getUserByEmail(email);
            if (user == null) {
                request.setAttribute("notification", "Email không tồn tại");
                return "resetpassword.jsp";
            }

            // Tạo token reset password (hết hạn sau 24h)
            String resetToken = UUID.randomUUID().toString();
            userDAO.saveResetToken(email, resetToken);

            // Tạo link reset password
            String resetLink = request.getRequestURL().toString()
                    .replace(request.getServletPath(), "")
                    + "/authen?action=changepassword&token=" + resetToken;

            try {
                String emailBody = "Xin chào " + user.getFullname() + ",<br><br>"
                        + "<span style='color: green;'>Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản PetTech.</span><br><br>"
                        + "Vui lòng nhấp vào liên kết sau để đặt lại mật khẩu: <a href='" + resetLink + "'>" + resetLink + "</a><br><br>"
                        + "Liên kết này sẽ hết hạn sau 24 giờ.<br><br>"
                        + "<span style='color: blue;'>Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!</span>";

                SendMailOK.send(
                        "smtp.gmail.com",
                        email,
                        "vdc120403@gmail.com", // Thay bằng email của bạn
                        "ednn nwbo zbyq gahs", // Thay bằng mật khẩu ứng dụng
                        "Đặt lại mật khẩu PetTech",
                        emailBody
                );

                request.setAttribute("notification", "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("notification", "Gửi email đặt lại mật khẩu thất bại. Vui lòng thử lại hoặc liên hệ quản trị viên.");
            }

            return "resetpassword.jsp";
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            return "resetpassword.jsp";
        }
    }

    private void verifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
