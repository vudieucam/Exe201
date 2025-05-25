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
            if (action != null && action.equals("upgrade")) {
                // Lấy ID gói
                int packageId = Integer.parseInt(request.getParameter("packageId"));
                ServicePackage pkg = PackageDAO.getPackageById(packageId);

                if (pkg != null) {
                    // Gán gói cho request để hiển thị
                    request.setAttribute("pkg", pkg);

                    // Nếu đang trong quá trình đăng ký (chưa login), gán fromRegistration = true
                    HttpSession session = request.getSession();
                    User pendingUser = (User) session.getAttribute("pendingUser");
                    if (pendingUser != null) {
                        request.setAttribute("fromRegistration", true);
                    } else {
                        request.setAttribute("fromRegistration", false);
                    }

                    // Chuyển tới trang thanh toán
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                    return;
                }
            }

            // Load danh sách gói như bình thường
            List<ServicePackage> packages = PackageDAO.getAllPackages();
            request.setAttribute("packages", packages);

        } catch (SQLException | NumberFormatException e) {
            request.setAttribute("error", "Không thể tải danh sách gói: " + e.getMessage());
            e.printStackTrace();
        }

        // Hiển thị trang pricing nếu không phải upgrade
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
            // Chuyển hướng đến trang đăng ký với packageId
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            response.sendRedirect("signup.jsp?packageId=" + packageId);
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));

            // Kiểm tra nếu user đã đăng ký gói này rồi
            if (user.getServicePackageId() != null && user.getServicePackageId() == packageId) {
                request.setAttribute("notification", "Bạn đã đăng ký gói này rồi!");
                reloadPackages(request, response);
                return;
            }

            // Kiểm tra nếu user đang cố downgrade gói
            if (user.getServicePackageId() != null && user.getServicePackageId() > packageId) {
                request.setAttribute("notification", "Bạn không thể chuyển xuống gói thấp hơn!");
                reloadPackages(request, response);
                return;
            }

            // Đăng ký gói mới
            boolean success = PackageDAO.registerPackage(user.getId(), packageId);

            if (success) {
                // Cập nhật thông tin user trong session
                user.setServicePackageId(packageId);
                session.setAttribute("user", user);
                request.setAttribute("notification", "Đăng ký gói dịch vụ thành công!");
            } else {
                request.setAttribute("notification", "Đăng ký gói dịch vụ thất bại. Vui lòng thử lại!");
            }

            reloadPackages(request, response);

        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
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

            // Kiểm tra nếu user đã đăng ký gói này rồi
            if (user.getServicePackageId() != null && user.getServicePackageId() == packageId) {
                request.setAttribute("notification", "Bạn đã đăng ký gói này rồi!");
                reloadPackages(request, response);
                return;
            }

            // Kiểm tra nếu user đang cố downgrade gói
            if (user.getServicePackageId() != null && user.getServicePackageId() > packageId) {
                request.setAttribute("notification", "Bạn không thể chuyển xuống gói thấp hơn!");
                reloadPackages(request, response);
                return;
            }

            // Thực hiện nâng cấp gói
            boolean success = PackageDAO.registerPackage(user.getId(), packageId);

            if (success) {
                // Cập nhật thông tin user trong session
                user.setServicePackageId(packageId);
                session.setAttribute("user", user);

                // Chuyển đến trang thành công
                request.setAttribute("successMessage", "Nâng cấp gói dịch vụ thành công!");
                request.setAttribute("package", PackageDAO.getPackageById(packageId));
                request.setAttribute("paymentMethod", paymentMethod);
                request.getRequestDispatcher("payment_success.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("notification", "Nâng cấp gói dịch vụ thất bại. Vui lòng thử lại!");
            }

            reloadPackages(request, response);

        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
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
            request.setAttribute("notification", "Thông tin đăng ký không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");

        // Đăng ký tài khoản như AuthenServlet.register()
        try {
            // Kiểm tra lại email
            if (userDAO.checkEmailExists(pendingUser.getEmail())) {
                request.setAttribute("notification", "Email đã tồn tại. Vui lòng dùng email khác.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            // Gửi email xác minh
            String token = UUID.randomUUID().toString();
            pendingUser.setVerificationToken(token);
            pendingUser.setStatus(false);
            pendingUser.setRoleId(1); // user

            if (userDAO.register(pendingUser)) {
                String link = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                        + request.getContextPath() + "/authen?action=verify&token=" + token;

                String content = "Xin chào " + pendingUser.getFullname() + ",<br>"
                        + "Cảm ơn bạn đã đăng ký. Nhấp vào liên kết để xác minh: <a href='" + link + "'>Xác minh</a>";

                SendMailOK.send("smtp.gmail.com", pendingUser.getEmail(),
                        "vdc120403@gmail.com", "ednn nwbo zbyq gahs",
                        "Xác minh tài khoản PetTech", content);

                session.removeAttribute("pendingUser");
                request.setAttribute("notification", "🎉 Đăng ký thành công! Vui lòng kiểm tra email để xác minh.");
                request.setAttribute("package", PackageDAO.getPackageById(pendingUser.getServicePackageId()));
                request.setAttribute("paymentMethod", paymentMethod);
                request.getRequestDispatcher("payment_success.jsp").forward(request, response);
            } else {
                request.setAttribute("notification", "Đăng ký thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }

}
