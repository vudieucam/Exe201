package customer.ServicePackage;

import dal.PackageDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import model.SendMailOK;
import model.ServicePackage;
import model.User;

public class PackageServlet extends HttpServlet {

    private PackageDAO PackageDAO = new PackageDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action != null && action.equals("select")) {
                int packageId = Integer.parseInt(request.getParameter("packageId"));
                response.sendRedirect("signup.jsp?packageId=" + packageId);
                return;
            }

            if (action != null && action.equals("upgrade")) {
                int packageId = Integer.parseInt(request.getParameter("packageId"));
                ServicePackage pkg = PackageDAO.getPackageById(packageId);

                if (pkg != null) {
                    request.setAttribute("pkg", pkg);
                    HttpSession session = request.getSession();
                    User pendingUser = (User) session.getAttribute("pendingUser");
                    request.setAttribute("fromRegistration", pendingUser != null);
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                    return;
                }
            }

            List<ServicePackage> packages = PackageDAO.getAllPackages();
            request.setAttribute("packages", packages);

        } catch (SQLException | NumberFormatException e) {
            request.setAttribute("error", "Không thể tải danh sách gói: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("pricing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("pricing.jsp");
            return;
        }

        switch (action) {
            case "register":
                registerPackage(request, response);
                break;
            case "upgrade":
                upgradePackage(request, response);
                break;
            case "payAndRegister":
                payAndRegister(request, response);
                break;
            default:
                response.sendRedirect("pricing.jsp");
        }
    }

    private void registerPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            response.sendRedirect("signup.jsp?packageId=" + packageId);
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));

            if (user.getServicePackageId() != null && user.getServicePackageId() == packageId) {
                session.setAttribute("notification", "Bạn đã đăng ký gói này rồi!");
                reloadPackages(request, response);
                return;
            }

            if (user.getServicePackageId() != null && user.getServicePackageId() > packageId) {
                session.setAttribute("notification", "Bạn không thể chuyển xuống gói thấp hơn!");
                reloadPackages(request, response);
                return;
            }

            boolean success = PackageDAO.registerPackage(user.getId(), packageId);

            if (success) {
                user.setServicePackageId(packageId);
                session.setAttribute("user", user);
                session.setAttribute("notification", "Đăng ký gói dịch vụ thành công!");
            } else {
                session.setAttribute("notification", "Đăng ký gói dịch vụ thất bại. Vui lòng thử lại!");
            }

            reloadPackages(request, response);

        } catch (NumberFormatException | SQLException e) {
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            reloadPackages(request, response);
        }
    }

    private void upgradePackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String paymentMethod = request.getParameter("paymentMethod");

            if (user.getServicePackageId() != null && user.getServicePackageId() == packageId) {
                session.setAttribute("notification", "Bạn đã đăng ký gói này rồi!");
                reloadPackages(request, response);
                return;
            }

            if (user.getServicePackageId() != null && user.getServicePackageId() > packageId) {
                session.setAttribute("notification", "Bạn không thể chuyển xuống gói thấp hơn!");
                reloadPackages(request, response);
                return;
            }

            boolean success = PackageDAO.registerPackage(user.getId(), packageId);

            if (success) {
                user.setServicePackageId(packageId);
                session.setAttribute("user", user);
                session.setAttribute("successMessage", "Nâng cấp gói dịch vụ thành công!");
                session.setAttribute("pkg", PackageDAO.getPackageById(packageId));
                session.setAttribute("paymentMethod", paymentMethod);
                response.sendRedirect("payment_success.jsp");
                return;
            } else {
                session.setAttribute("notification", "Nâng cấp gói dịch vụ thất bại. Vui lòng thử lại!");
            }

            reloadPackages(request, response);

        } catch (NumberFormatException | SQLException e) {
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            reloadPackages(request, response);
        }
    }

    private void reloadPackages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ServicePackage> packages = PackageDAO.getAllPackages();
            request.setAttribute("packages", packages);
        } catch (SQLException e) {
            request.setAttribute("error", "Không thể tải danh sách gói: " + e.getMessage());
        }
        request.getRequestDispatcher("pricing.jsp").forward(request, response);
    }



    private void payAndRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User pendingUser = (User) session.getAttribute("pendingUser");

        if (pendingUser == null) {
            // Lấy dữ liệu từ form
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm_password");
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address"); // Thêm dòng này
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String paymentMethod = request.getParameter("paymentMethod");

            // Validate dữ liệu
            boolean hasError = false;

            if (!password.equals(confirmPassword)) {
                session.setAttribute("passwordError", "Mật khẩu nhập lại không khớp");
                hasError = true;
            }

            if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                session.setAttribute("emailError", "Email không hợp lệ");
                hasError = true;
            }

            if (!phone.matches("^(032|033|034|035|036|037|038|039|096|097|098|086|083|084|085|081|082|088|091|094|070|079|077|076|078|090|093|089|056|058|092|059|099)[0-9]{7}$")) {
                session.setAttribute("phoneError", "Số điện thoại không hợp lệ");
                hasError = true;
            }

            if (password.length() < 8 || password.length() > 32) {
                session.setAttribute("passwordError", "Mật khẩu phải từ 8-32 ký tự");
                hasError = true;
            }

            if (address == null || address.trim().isEmpty()) {
                session.setAttribute("addressError", "Địa chỉ không được để trống");
                hasError = true;
            }

            try {
                if (userDAO.checkEmailExists(email)) {
                    session.setAttribute("emailError", "Email đã tồn tại");
                    hasError = true;
                }
            } catch (SQLException e) {
                session.setAttribute("error", "Lỗi kiểm tra email: " + e.getMessage());
                hasError = true;
            }

            if (hasError) {
                // Lưu lại giá trị đã nhập
                session.setAttribute("oldEmail", email);
                session.setAttribute("oldFullname", fullname);
                session.setAttribute("oldPhone", phone);
                session.setAttribute("oldAddress", address);
                response.sendRedirect("signup.jsp?packageId=" + packageId);
                return;
            }

            // Tạo user tạm
            pendingUser = new User();
            pendingUser.setEmail(email);
            pendingUser.setPassword(password);
            pendingUser.setFullname(fullname);
            pendingUser.setPhone(phone);
            pendingUser.setAddress(address); // Thêm dòng này
            pendingUser.setServicePackageId(packageId);
            session.setAttribute("pendingUser", pendingUser);
        }
        // Xử lý thanh toán hoặc đăng ký trực tiếp
        if (pendingUser.getServicePackageId() > 1) { // Giả sử gói free có ID = 1
            try {
                ServicePackage pkg = PackageDAO.getPackageById(pendingUser.getServicePackageId());
                request.setAttribute("pkg", pkg);
                request.setAttribute("fromRegistration", true);
                request.getRequestDispatcher("payment.jsp").forward(request, response);
                return;
            } catch (SQLException e) {
                session.setAttribute("error", "Lỗi khi lấy thông tin gói: " + e.getMessage());
                response.sendRedirect("signup.jsp?packageId=" + pendingUser.getServicePackageId());
                return;
            }
        }

        // Xử lý đăng ký gói free
        try {
            String token = UUID.randomUUID().toString();
            pendingUser.setVerificationToken(token);
            pendingUser.setStatus(false);
            pendingUser.setRoleId(1);

            if (userDAO.register(pendingUser)) {
                // Gửi email xác minh
                String verificationLink = request.getScheme() + "://"
                        + request.getServerName() + ":"
                        + request.getServerPort()
                        + request.getContextPath()
                        + "/authen?action=verify&token=" + token;

                PackageDAO spDAO = new PackageDAO();
                String packageName = spDAO.getServicePackageNameById(pendingUser.getServicePackageId());

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
                        + "<h2>🎉 Chào mừng bạn đến với PetTech! 🐾</h2>"
                        + "<p>Xin chào <strong>" + pendingUser.getFullname() + "</strong>,</p>"
                        + "<p>Cảm ơn bạn đã đăng ký <strong>gói dịch vụ PetTech</strong>! 💖</p>"
                        + "<p>Vui lòng nhấp vào nút dưới đây để xác minh tài khoản của bạn:</p>"
                        + "<p><a class='button' href='" + verificationLink + "'>🔐 Xác minh tài khoản</a></p>"
                        + "<p><strong>Thông tin gói dịch vụ của bạn:</strong><br>"
                        + "- Tên gói: <strong>" + packageName + "</strong></p>"
                        + "<p>Chúng tôi rất vui khi được đồng hành cùng bạn và thú cưng trên hành trình sắp tới! 🐶🐱<br>"
                        + "Hy vọng bạn sẽ có những trải nghiệm thật tuyệt vời cùng PetTech. 🌟</p>"
                        + "<div class='footer'>"
                        + "<strong>📞 Liên hệ hỗ trợ:</strong><br>"
                        + "SĐT: <a href='tel:0352138596'>0352 138 596</a><br>"
                        + "Địa chỉ: Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội<br><br>"
                        + "Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi nhé! 🧡<br>"
                        + "<strong>❤️ PetTech Team</strong>"
                        + "</div>"
                        + "</div>"
                        + "</body>"
                        + "</html>";

                SendMailOK.send(
                        "smtp.gmail.com",
                        pendingUser.getEmail(),
                        "vdc120403@gmail.com",
                        "ednn nwbo zbyq gahs",
                        "Xác minh tài khoản PetTech",
                        emailBody
                );

                // Xóa session tạm
                session.removeAttribute("pendingUser");
                session.removeAttribute("oldEmail");
                session.removeAttribute("oldFullname");
                session.removeAttribute("oldPhone");

                session.setAttribute("notification", "Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản.");
                response.sendRedirect("login.jsp");
                return;
            } else {
                session.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                response.sendRedirect("signup.jsp?packageId=" + pendingUser.getServicePackageId());
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("signup.jsp?packageId=" + pendingUser.getServicePackageId());
        }
    }
}
