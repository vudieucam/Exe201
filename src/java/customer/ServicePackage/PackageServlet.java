package customer.ServicePackage;

import dal.BlogDAO;
import dal.CourseDAO;
import dal.CustomerCourseDAO;
import dal.PackageDAO;
import dal.UserDAO;
import dal.UserServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import model.SendMailOK;
import model.ServicePackage;
import model.User;
import java.util.Date;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BlogCategory;
import model.Course;
import model.CourseCategory;
import model.UserService;

public class PackageServlet extends HttpServlet {

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
    private PackageDAO PackageDAO = new PackageDAO();
    private UserDAO userDAO = new UserDAO();
    private static final int FREE_PACKAGE_ID = 1;
    private CustomerCourseDAO CustomercourseDAO = new CustomerCourseDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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

                    // ✅ Chèn ở đây nếu cần trong trang payment.jsp
                    List<CourseCategory> courseCategories = CustomercourseDAO.getAllCategories();
                    request.setAttribute("courseCategories", courseCategories);

                    List<Course> featuredCourses = CustomercourseDAO.getFeaturedCourses(6);
                    request.setAttribute("featuredCourses", featuredCourses);

                    List<BlogCategory> featuredCategories = blogDAO.getFeaturedCategories();
                    request.setAttribute("featuredCategories", featuredCategories);

                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                    return;
                }
            }

            List<ServicePackage> packages = PackageDAO.getAllPackages();
            request.setAttribute("packages", packages);

            // ✅ CHÈN Ở ĐÂY TRƯỚC KHI forward sang pricing.jsp
            List<CourseCategory> courseCategories = CustomercourseDAO.getAllCategories();
            request.setAttribute("courseCategories", courseCategories);

            List<BlogCategory> featuredCategories = blogDAO.getFeaturedCategories();
            request.setAttribute("featuredCategories", featuredCategories);

        } catch (SQLException | NumberFormatException e) {
            request.setAttribute("error", "Không thể tải danh sách gói: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(PackageServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        request.getRequestDispatcher("pricing.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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
                try {
                payAndRegister(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Lỗi khi xử lý đăng ký: " + e.getMessage());
                response.sendRedirect("signup.jsp");
            }
            break;
            case "confirmPayment":
                processPayment(request, response);
                break;
            default:
                response.sendRedirect("pricing.jsp");
        }
    }

    private boolean isFreePackage(int packageId) {
        return packageId == FREE_PACKAGE_ID;
    }

    private void registerPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            response.sendRedirect("signup.jsp?packageId=" + packageId);
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));

            // Changed these checks since servicePackageId is int (primitive) and can't be null
            if (user.getServicePackageId() == packageId) {
                session.setAttribute("notification", "Bạn đã đăng ký gói này rồi!");
                reloadPackages(request, response);
                return;
            }

            if (user.getServicePackageId() > packageId) {
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String paymentMethod = request.getParameter("paymentMethod");

            // Changed these checks since servicePackageId is int (primitive) and can't be null
            if (user.getServicePackageId() == packageId) {
                session.setAttribute("notification", "Bạn đã đăng ký gói này rồi!");
                reloadPackages(request, response);
                return;
            }

            if (user.getServicePackageId() > packageId) {
                session.setAttribute("notification", "Bạn không thể chuyển xuống gói thấp hơn!");
                reloadPackages(request, response);
                return;
            }

            if (isFreePackage(packageId)) {
                boolean success = PackageDAO.registerPackage(user.getId(), packageId);
                if (success) {
                    user.setServicePackageId(packageId);
                    session.setAttribute("user", user);
                    session.setAttribute("notification", "Đăng ký gói miễn phí thành công!");
                    reloadPackages(request, response);
                    return;
                }
            }

            ServicePackage pkg = PackageDAO.getPackageById(packageId);
            if (pkg != null) {
                request.setAttribute("pkg", pkg);
                request.setAttribute("fromRegistration", false);
                request.getRequestDispatcher("payment.jsp").forward(request, response);
            }

        } catch (NumberFormatException | SQLException e) {
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            reloadPackages(request, response);
        }
    }

    private void reloadPackages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            List<ServicePackage> packages = PackageDAO.getAllPackages();
            request.setAttribute("packages", packages);
        } catch (SQLException e) {
            request.setAttribute("error", "Không thể tải danh sách gói: " + e.getMessage());
        }
        request.getRequestDispatcher("pricing.jsp").forward(request, response);
    }

    private void payAndRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User pendingUser = (User) session.getAttribute("pendingUser");

        if (pendingUser == null) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm_password");
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String paymentMethod = request.getParameter("paymentMethod");

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
                session.setAttribute("oldEmail", email);
                session.setAttribute("oldFullname", fullname);
                session.setAttribute("oldPhone", phone);
                session.setAttribute("oldAddress", address);
                response.sendRedirect("signup.jsp?packageId=" + packageId);
                return;
            }

            pendingUser = new User();
            pendingUser.setEmail(email);
            pendingUser.setPassword(password);
            pendingUser.setFullname(fullname);
            pendingUser.setPhone(phone);
            pendingUser.setAddress(address);
            pendingUser.setServicePackageId(packageId);
            session.setAttribute("pendingUser", pendingUser);
        }

        if (isFreePackage(pendingUser.getServicePackageId())) {
            try {
                pendingUser.setRoleId(1);
                if (userDAO.register(pendingUser)) {
                    User createdUser = userDAO.getUserByEmail(pendingUser.getEmail());

                    if (createdUser == null) {
                        session.setAttribute("error", "Lỗi: Không tìm thấy người dùng sau khi đăng ký.");
                        response.sendRedirect("signup.jsp?packageId=" + pendingUser.getServicePackageId());
                        return;
                    }

                    userDAO.setActive(createdUser.getId(), true);

                    UserService service = new UserService();
                    service.setUserId(createdUser.getId());
                    service.setPackageId(createdUser.getServicePackageId());
                    service.setStartDate(new Date());

                    Calendar cal = Calendar.getInstance();
                    cal.setTime(new Date());
                    cal.add(Calendar.DAY_OF_MONTH, 7);
                    service.setEndDate(cal.getTime());

                    service.setStatus("Đang sử dụng");

                    UserServiceDAO userServiceDAO = new UserServiceDAO();
                    userServiceDAO.save(service);

                    String token = UUID.randomUUID().toString();
                    pendingUser.setVerificationToken(token);
                    pendingUser.setStatus(false);
                    boolean updated = userDAO.updateVerificationTokenAndStatus(createdUser.getId(), token, false);
                    if (!updated) {
                        session.setAttribute("error", "Lỗi lưu token xác minh.");
                        response.sendRedirect("signup.jsp?packageId=" + pendingUser.getServicePackageId());
                        return;
                    }

                    String verificationLink = request.getScheme() + "://"
                            + request.getServerName()
                            + (request.getServerPort() != 80 && request.getServerPort() != 443
                            ? ":" + request.getServerPort() : "")
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
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                response.sendRedirect("signup.jsp?packageId=" + pendingUser.getServicePackageId());
                return;
            }
        } else {
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
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        User pendingUser = (User) session.getAttribute("pendingUser");

        int packageId = Integer.parseInt(request.getParameter("packageId"));
        String paymentMethod = request.getParameter("paymentMethod");

        try {
            ServicePackage pkg = PackageDAO.getPackageById(packageId);

            String confirmationCode = UUID.randomUUID().toString().substring(0, 8);
            boolean paymentRecorded = PackageDAO.recordPayment(
                    user != null ? user.getId() : 0, // Changed to use 0 instead of null
                    packageId,
                    paymentMethod,
                    pkg.getPrice(),
                    confirmationCode
            );

            if (paymentRecorded) {
                if (pendingUser != null) {
                    String activationToken = UUID.randomUUID().toString();

                    pendingUser.setActivationToken(activationToken);
                    pendingUser.setTokenExpiry(calculateExpiryDate(24));
                    session.setAttribute("pendingUser", pendingUser);

                    sendPaymentConfirmationEmail(pendingUser, pkg, confirmationCode, request);

                    session.removeAttribute("oldEmail");
                    session.removeAttribute("oldFullname");
                    session.removeAttribute("oldPhone");
                    session.removeAttribute("oldAddress");

                    session.setAttribute("message", "Vui lòng kiểm tra email để xác nhận thanh toán. Bạn có 10 phút để hoàn tất quy trình.");
                    request.getRequestDispatcher("payment_success.jsp").forward(request, response);
                } else {
                    sendPaymentConfirmationEmail(user, pkg, confirmationCode, request);

                    session.setAttribute("notification", "Yêu cầu nâng cấp gói của bạn đã được ghi nhận. Vui lòng kiểm tra email để xác nhận thanh toán.");
                    response.sendRedirect("login.jsp");
                }
            } else {
                session.setAttribute("error", "Ghi nhận thanh toán thất bại. Vui lòng thử lại.");
                response.sendRedirect("payment.jsp?packageId=" + packageId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("payment.jsp?packageId=" + packageId);
        }
    }

    private void sendPaymentConfirmationEmail(User user, ServicePackage pkg, String confirmationCode, HttpServletRequest request) {

        String activationLink = "";
        if (user.getActivationToken() != null) {
            activationLink = request.getScheme() + "://"
                    + request.getServerName() + ":"
                    + request.getServerPort()
                    + request.getContextPath()
                    + "/authen?action=activate&token=" + user.getActivationToken();
        }

        String emailBody = "<!DOCTYPE html>"
                + "<html lang='vi'>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<style>"
                + "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #fffaf4; color: #333; padding: 20px; }"
                + ".container { max-width: 600px; margin: auto; background-color: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 20px; }"
                + "h2 { color: #ff6600; }"
                + ".button { display: inline-block; background-color: #ff9966; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: bold; }"
                + ".highlight { background-color: #fff2cc; padding: 6px 12px; border-radius: 8px; font-weight: bold; display: inline-block; margin: 10px 0; }"
                + ".footer { font-size: 13px; color: #888; margin-top: 30px; line-height: 1.6; }"
                + ".footer strong { color: #555; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "<h2>🔔 Xác nhận thanh toán PetTech</h2>"
                + "<p>Xin chào <strong>" + user.getFullname() + "</strong>,</p>"
                + "<p>Bạn đã yêu cầu đăng ký/nâng cấp gói dịch vụ <strong>" + pkg.getName() + "</strong>.</p>"
                + "<p>Mã xác nhận thanh toán của bạn là: <span class='highlight'>" + confirmationCode + "</span></p>"
                + "<p>Vui lòng chờ quản trị viên kiểm tra và xác nhận thanh toán trong vòng 10 phút.</p>";

        if (!activationLink.isEmpty()) {
            emailBody += "<p>Sau khi thanh toán được xác nhận, vui lòng nhấp vào nút bên dưới để kích hoạt tài khoản:</p>"
                    + "<p><a class='button' href='" + activationLink + "'>✅ Kích hoạt tài khoản</a></p>";
        }

        emailBody += "<p>Cảm ơn bạn đã tin tưởng PetTech! 🐾</p>"
                + "<div class='footer'>"
                + "<strong>📞 Hỗ trợ:</strong><br>"
                + "SĐT: <a href='tel:0352138596'>0352 138 596</a><br>"
                + "Email: <a href='mailto:vdc120403@gmail.com'>vdc120403@gmail.com</a><br>"
                + "Địa chỉ: Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội<br><br>"
                + "<strong>❤️ PetTech Team</strong>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";

        try {
            SendMailOK.send(
                    "smtp.gmail.com",
                    user.getEmail(),
                    "vdc120403@gmail.com",
                    "ednn nwbo zbyq gahs",
                    "🔔 Xác nhận thanh toán PetTech",
                    emailBody
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Date calculateExpiryDate(int expiryTimeInHours) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.HOUR, expiryTimeInHours);
        return cal.getTime();
    }
}
