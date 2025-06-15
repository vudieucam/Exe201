package controller.Admin;

import dal.PaymentDAO;
import dal.UserDAO;
import dal.PackageDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import model.Payments;
import model.SendMailOK;
import model.ServicePackage;
import model.User;

public class AdminPaymentServlet extends HttpServlet {

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
    private PaymentDAO paymentDAO = new PaymentDAO();
    private UserDAO userDAO = new UserDAO();
    private PackageDAO packageDAO = new PackageDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String confirmationCode = request.getParameter("confirmationCode");
        String action = request.getParameter("action"); // approve or reject

        try {
            // Tìm payment theo mã xác nhận
            Payments payment = paymentDAO.getPaymentByConfirmationCode(confirmationCode);

            if (payment == null) {
                request.setAttribute("error", "Không tìm thấy giao dịch với mã xác nhận này");
                request.getRequestDispatcher("/admin/payments.jsp").forward(request, response);
                return;
            }

            if ("approve".equalsIgnoreCase(action)) {
                // Cập nhật trạng thái thanh toán là completed và đánh dấu đã xác nhận
                paymentDAO.updatePaymentStatus(payment.getId(), "completed", true);

                // Cập nhật gói dịch vụ cho user (nếu payment có servicePackageId)
                if (payment.getServicePackageId() != null) {
                    userDAO.updateUserPackage(payment.getUserId(), payment.getServicePackageId());
                }

                // Lấy user và gói dịch vụ để gửi email
                User user = userDAO.getUserById(payment.getUserId());
                ServicePackage pkg = null;
                if (payment.getServicePackageId() != null) {
                    pkg = packageDAO.getPackageById(payment.getServicePackageId());
                }

                sendApprovalEmail(user, pkg);

                request.setAttribute("message", "Đã xác nhận thanh toán thành công");
            } else if ("reject".equalsIgnoreCase(action)) {
                // Từ chối thanh toán
                paymentDAO.updatePaymentStatus(payment.getId(), "rejected", false);
                request.setAttribute("message", "Đã từ chối thanh toán");
            } else {
                request.setAttribute("error", "Hành động không hợp lệ");
            }

            request.getRequestDispatcher("/admin/payments.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/admin/payments.jsp").forward(request, response);
        }
    }

    private void sendApprovalEmail(User user, ServicePackage pkg) {

        String emailBody = "<!DOCTYPE html>"
                + "<html><head><style>body{font-family:Arial,sans-serif}</style></head>"
                + "<body>"
                + "<h2>Thanh toán Gói Dịch vụ PetTech đã được xác nhận</h2>"
                + "<p>Xin chào " + user.getFullname() + ",</p>";

        if (pkg != null) {
            emailBody += "<p>Thanh toán gói <strong>" + pkg.getName() + "</strong> của bạn đã được xác nhận thành công.</p>"
                    + "<p>Bạn có thể bắt đầu sử dụng các tính năng của gói dịch vụ ngay bây giờ.</p>";
        } else {
            emailBody += "<p>Thanh toán của bạn đã được xác nhận thành công.</p>";
        }

        if (!user.isIsActive()) {
            emailBody += "<p>Vui lòng nhấp vào liên kết sau để kích hoạt tài khoản:</p>"
                    + "<p><a href='[ACTIVATION_LINK]'>[ACTIVATION_LINK]</a></p>";
        }

        emailBody += "<p>Trân trọng,<br>Đội ngũ PetTech</p>"
                + "</body></html>";

        try {
            SendMailOK.send(
                    "smtp.gmail.com",
                    user.getEmail(),
                    "vdc120403@gmail.com",
                    "ednn nwbo zbyq gahs",
                    "Xác nhận Thanh toán Gói Dịch vụ PetTech",
                    emailBody
            );
        } catch (Exception e) {
            e.printStackTrace();
            // Có thể log lỗi hoặc lưu lại để kiểm tra
        }
    }

}
