/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package AuthenController;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
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
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";

        String url;
        switch (action) {
            case "login":
                url = "login.jsp";
                break;
            case "logout":
                url = logout(request, response);
                break;
            case "signup":
                url = "signup.jsp";
                break;
            case "editprofile":
                url = "editprofile.jsp";
                break;
            case "changepassword":
                url = "changepassword.jsp";
                break;
            case "resetpassword":
                url = "resetpassword.jsp";
                break;
            case "verify":
                url = verifyEmail(request, response);
                break;
            default:
                url = "Home.jsp";
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";

        String url;
        switch (action) {
            case "login":
                url = login(request, response);
                break;
            case "register":
                url = register(request, response);
                break;
            case "update":
                url = updateProfile(request, response);
                break;
            case "changepassword":
                url = changePassword(request, response);
                break;
            case "resetpassword":
                url = resetPassword(request, response);
                break;
            default:
                url = "Home.jsp";
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    private String login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userDAO.login(email, password);

            if (user == null) {
                request.setAttribute("notification", "Sai email hoặc mật khẩu");
                return "login.jsp";
            }

            if (!user.isStatus()) {
                request.setAttribute("notification", "Tài khoản chưa được kích hoạt");
                return "login.jsp";
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            switch (user.getRoleId()) {
                case 3: // Admin
                    return "admin-dashboard.jsp";
                case 2: // Staff
                    return "staff-dashboard.jsp";
                default: // User
                    return "Home.jsp";
            }
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            return "login.jsp";
        }
    }

    private String logout(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().removeAttribute("user");
        return "Home.jsp";
    }

    private String register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String url;
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String confirmPassword = request.getParameter("confirm_password");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("notification", "Nhập lại mật khẩu không giống nhau");
            url = "signup.jsp";
        } else {
            try {
                if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                    request.setAttribute("notification", "Địa chỉ email không hợp lệ");
                    url = "signup.jsp";
                } else if (!phone.matches("^(032|033|034|035|036|037|038|039|096|097|098|086|083|084|085|081|082|088|091|094|070|079|077|076|078|090|093|089|056|058|092|059|099)[0-9]{7}$")) {
                    request.setAttribute("notification", "Số điện thoại không hợp lệ");
                    url = "signup.jsp";
                } else if (password.length() <= 8 || password.length() > 32) {
                    request.setAttribute("notification", "Mật khẩu phải từ 8 đến 32 ký tự");
                    url = "signup.jsp";
                } else if (userDAO.checkEmailExists(email.toLowerCase())) {
                    request.setAttribute("notification", "Email đã tồn tại");
                    url = "signup.jsp";
                } else {
                    String token = UUID.randomUUID().toString();

                    // Tạo user mới không dùng Builder
                    User newUser = new User();
                    newUser.setEmail(email);
                    newUser.setPassword(password);
                    newUser.setFullname(fullname);
                    newUser.setPhone(phone);
                    newUser.setAddress(address);
                    newUser.setRoleId(1); // Mặc định role user
                    newUser.setStatus(false); // Chưa kích hoạt
                    newUser.setVerificationToken(token);

                    if (userDAO.register(newUser)) {
                        String verificationLink = request.getScheme() + "://"
                                + request.getServerName() + ":"
                                + request.getServerPort()
                                + request.getContextPath()
                                + "/authen?action=verify&token=" + token;

                        String emailBody = "Xin chào " + fullname + ",<br><br>"
                                + "<span style='color: green;'>Vui lòng xác minh địa chỉ email của bạn để hoàn tất đăng ký tài khoản PetTech.</span><br><br>"
                                + "Nhấp vào liên kết sau để xác minh: <a href='" + verificationLink + "'>" + verificationLink + "</a><br><br>"
                                + "<span style='color: blue;'>Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!</span>";

                        try {
                            SendMailOK.send(
                                    "smtp.gmail.com",
                                    email,
                                    "vdc120403@gmail.com",
                                    "ednn nwbo zbyq gahs",
                                    "Xác minh email PetTech",
                                    emailBody
                            );
                            request.setAttribute("notification", "Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.");
                            url = "login.jsp";
                        } catch (Exception e) {
                            e.printStackTrace();
                            request.setAttribute("notification", "Đăng ký thành công nhưng gửi email xác nhận thất bại. Vui lòng liên hệ quản trị viên.");
                            url = "login.jsp";
                        }
                    } else {
                        request.setAttribute("notification", "Đăng ký thất bại. Vui lòng thử lại.");
                        url = "signup.jsp";
                    }
                }
            } catch (SQLException ex) {
                request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
                url = "signup.jsp";
            }
        }
        return url;
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
            return "editprofile.jsp";
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
            return "editprofile.jsp";
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            return "editprofile.jsp";
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
            return "changepassword.jsp";
        }

        try {
            // Verify old password
            User user = userDAO.login(currentUser.getEmail(), oldPassword);
            if (user == null) {
                request.setAttribute("notification", "Mật khẩu cũ không đúng");
                return "changepassword.jsp";
            }

            if (userDAO.changePassword(currentUser.getId(), newPassword)) {
                request.setAttribute("notification", "Đổi mật khẩu thành công");
                // Update session with new password
                currentUser.setPassword(newPassword);
                session.setAttribute("user", currentUser);
            } else {
                request.setAttribute("notification", "Đổi mật khẩu thất bại");
            }

            return "changepassword.jsp";
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            return "changepassword.jsp";
        }
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

    private String verifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        try {
            if (userDAO.verifyUser(token)) {
                request.setAttribute("notification", "Xác thực email thành công. Bạn có thể đăng nhập ngay bây giờ.");
            } else {
                request.setAttribute("notification", "Liên kết xác thực không hợp lệ hoặc đã được sử dụng.");
            }

            return "login.jsp";
        } catch (SQLException ex) {
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            return "login.jsp";
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
