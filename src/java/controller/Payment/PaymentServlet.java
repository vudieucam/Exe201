/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Payment;

import dal.PackageDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.UUID;
import model.SendMailOK;
import model.ServicePackage;
import model.User;

public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET không được hỗ trợ. Vui lòng sử dụng POST.");
    }

    private PackageDAO packageDAO = new PackageDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        String paymentMethod = request.getParameter("paymentMethod");
        String packageIdParam = request.getParameter("packageId");
        int packageId = 0;

        if (packageIdParam != null && !packageIdParam.trim().isEmpty()) {
            packageId = Integer.parseInt(packageIdParam);
        } else {
            request.setAttribute("error", "Thiếu thông tin gói dịch vụ");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();

        try {
            ServicePackage pkg = packageDAO.getPackageById(packageId);

            if ("payAndRegister".equals(action)) {
                handleNewRegistrationPayment(request, response, session, pkg, paymentMethod);
            } else if ("upgrade".equals(action)) {
                handleUpgradePayment(request, response, session, pkg, paymentMethod);
            } else {
                session.setAttribute("error", "Hành động không hợp lệ");
                response.sendRedirect("pricing.jsp");
            }
        } catch (SQLException e) {
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("pricing.jsp");
        }
    }

    private void handleNewRegistrationPayment(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ServicePackage pkg, String paymentMethod)
            throws ServletException, IOException, SQLException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        User pendingUser = (User) session.getAttribute("pendingUser");

        if (pendingUser == null) {
            session.setAttribute("error", "Không tìm thấy thông tin đăng ký. Vui lòng đăng ký lại.");
            response.sendRedirect("signup.jsp");
            return;
        }

        String token = UUID.randomUUID().toString();
        pendingUser.setVerificationToken(token);
        pendingUser.setStatus(false);
        pendingUser.setRoleId(1);

        String confirmationCode = UUID.randomUUID().toString();

        boolean paymentSuccess = packageDAO.recordPayment(
                pendingUser.getId(), // Changed from null to pendingUser.getId()
                pkg.getId(),
                paymentMethod,
                pkg.getPrice(),
                confirmationCode
        );

        if (paymentSuccess) {
            boolean registerSuccess = userDAO.register(pendingUser);

            if (registerSuccess) {
                sendUpgradeEmail(request, pendingUser, pkg);

                session.removeAttribute("pendingUser");
                session.removeAttribute("oldEmail");
                session.removeAttribute("oldFullname");
                session.removeAttribute("oldPhone");

                session.setAttribute("successMessage", "Đăng ký và thanh toán thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.");
                session.setAttribute("pkg", pkg);
                session.setAttribute("paymentMethod", paymentMethod);
                response.sendRedirect("payment_success.jsp");
            } else {
                session.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                response.sendRedirect("signup.jsp?packageId=" + pkg.getId());
            }
        } else {
            session.setAttribute("error", "Thanh toán thất bại. Vui lòng thử lại.");
            response.sendRedirect("payment.jsp?packageId=" + pkg.getId());
        }
    }

    private void handleUpgradePayment(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ServicePackage pkg, String paymentMethod)
            throws ServletException, IOException, SQLException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để thực hiện thanh toán");
            response.sendRedirect("login.jsp");
            return;
        }

        // Changed these checks since servicePackageId is int (primitive) and can't be null
        if (user.getServicePackageId() == pkg.getId()) {
            session.setAttribute("notification", "Bạn đã đăng ký gói này rồi!");
            response.sendRedirect("pricing.jsp");
            return;
        }

        if (user.getServicePackageId() > pkg.getId()) {
            session.setAttribute("notification", "Bạn không thể chuyển xuống gói thấp hơn!");
            response.sendRedirect("pricing.jsp");
            return;
        }

        String confirmationCode = UUID.randomUUID().toString();

        boolean paymentSuccess = packageDAO.recordPayment(
                user.getId(),
                pkg.getId(),
                paymentMethod,
                pkg.getPrice(),
                confirmationCode
        );

        if (paymentSuccess) {
            boolean updateSuccess = packageDAO.registerPackage(user.getId(), pkg.getId());

            if (updateSuccess) {
                user.setServicePackageId(pkg.getId());
                session.setAttribute("user", user);

                sendUpgradeEmail(request, user, pkg);

                session.setAttribute("successMessage", "Nâng cấp gói dịch vụ thành công!");
                session.setAttribute("pkg", pkg);
                session.setAttribute("paymentMethod", paymentMethod);
                response.sendRedirect("payment_success.jsp");
            } else {
                session.setAttribute("error", "Nâng cấp gói dịch vụ thất bại. Vui lòng liên hệ hỗ trợ.");
                response.sendRedirect("pricing.jsp");
            }
        } else {
            session.setAttribute("error", "Thanh toán thất bại. Vui lòng thử lại.");
            response.sendRedirect("payment.jsp?packageId=" + pkg.getId());
        }
    }

    private void sendUpgradeEmail(HttpServletRequest request, User user, ServicePackage pkg) throws UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        try {
            String emailBody = "<!DOCTYPE html>"
                    + "<html lang='vi'>"
                    + "<head><meta charset='UTF-8'><style>"
                    + "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #fffaf4; color: #333; padding: 20px; }"
                    + ".container { max-width: 600px; margin: auto; background-color: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 20px; }"
                    + "h2 { color: #ff6600; }"
                    + ".footer { font-size: 13px; color: #888; margin-top: 30px; line-height: 1.6; }"
                    + "</style></head>"
                    + "<body><div class='container'>"
                    + "<h2>🐶 Nâng cấp gói dịch vụ thành công! 🐱</h2>"
                    + "<p>Xin chào <strong>" + user.getFullname() + "</strong>,</p>"
                    + "<p>Cảm ơn bạn đã nâng cấp lên <strong>gói " + pkg.getName() + "</strong> với số tiền <strong>"
                    + pkg.getPrice().toString() + "₫</strong>.</p>"
                    + "<p>Bạn có thể bắt đầu sử dụng các tính năng mới ngay bây giờ!</p>"
                    + "<p>Nếu có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi.</p>"
                    + "<div class='footer'>"
                    + "<strong>📞 Hỗ trợ:</strong> 0352 138 596<br>"
                    + "<strong>📧 Email:</strong> pettech@email.com<br><br>"
                    + "❤️ PetTech Team"
                    + "</div></div></body></html>";

            SendMailOK.send(
                    "smtp.gmail.com",
                    user.getEmail(),
                    "vdc120403@gmail.com",
                    "ednn nwbo zbyq gahs",
                    "Thông báo nâng cấp gói dịch vụ PetTech",
                    emailBody
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}