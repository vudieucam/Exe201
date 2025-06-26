package controller.Payment;

import dal.PackageDAO;
import dal.PaymentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import model.Payments;
import model.SendMailOK;
import model.ServicePackage;
import model.User;

public class PaymentAdminServlet extends HttpServlet {

    private PackageDAO dao = new PackageDAO();
    private PaymentDAO paymentDao = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Payments> pending = paymentDao.getAllPayments();
            req.setAttribute("pendingPayments", pending);
            req.getRequestDispatcher("paymentsAdmin.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Lỗi truy vấn thanh toán", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String message = null;

        try {
            int paymentId = Integer.parseInt(req.getParameter("paymentId"));

            switch (action) {
                case "confirmPayment": {
                    Payments payment = dao.getPaymentById(paymentId);
                    if (!"confirmed".equalsIgnoreCase(payment.getStatus()) || payment.isIsConfirmed()) {
                        req.setAttribute("error", "❌ Chỉ được xác nhận khi trạng thái là 'confirmed' và chưa được xác nhận.");
                        break;
                    }

                    boolean ok = paymentDao.setConfirmed(paymentId, true);
                    if (ok) {
                        Object[] data = dao.getPaymentInfo(paymentId);
                        if (data != null) {
                            User user = (User) data[0];
                            ServicePackage pkg = (ServicePackage) data[1];
                            String code = (String) data[2];
                            sendPaymentConfirmationEmail(user, pkg, code, req);
                        }
                        req.setAttribute("success", "✅ Đã xác nhận thanh toán.");
                    } else {
                        req.setAttribute("error", "❌ Không thể xác nhận.");
                    }
                    break;
                }

                case "revokeConfirmation": {
                    Payments payment = dao.getPaymentById(paymentId);
                    if (!"confirmed".equalsIgnoreCase(payment.getStatus())) {
                        req.setAttribute("error", "⚠️ Chỉ huỷ được nếu trạng thái là 'confirmed'.");
                        break;
                    }

                    boolean revoked = paymentDao.setConfirmed(paymentId, false);
                    if (revoked) {
                        req.setAttribute("success", "⚠️ Đã huỷ xác nhận.");
                    } else {
                        req.setAttribute("error", "❌ Không thể huỷ xác nhận.");
                    }
                    break;
                }

                case "completePayment": {
                    Payments payment = dao.getPaymentById(paymentId);
                    if (!"confirmed".equalsIgnoreCase(payment.getStatus()) || !payment.isIsConfirmed()) {
                        req.setAttribute("error", "⚠️ Chỉ hoàn tất khi đã xác nhận.");
                        break;
                    }

                    boolean completed = paymentDao.setCompleted(paymentId);
                    if (completed) {
                        req.setAttribute("success", "🎉 Đã hoàn tất thanh toán.");
                    } else {
                        req.setAttribute("error", "❌ Không thể hoàn tất.");
                    }
                    break;
                }

                case "retryPayment": {
                    Payments payment = dao.getPaymentById(paymentId);
                    if (!"failed".equalsIgnoreCase(payment.getStatus())) {
                        req.setAttribute("error", "❌ Chỉ gửi lại yêu cầu nếu trạng thái là 'failed'.");
                        break;
                    }

                    boolean retried = dao.retryPayment(paymentId); // ví dụ đặt lại về confirmed và isConfirmed = false
                    if (retried) {
                        req.setAttribute("success", "🔁 Đã gửi lại yêu cầu.");
                    } else {
                        req.setAttribute("error", "❌ Không thể gửi lại.");
                    }
                    break;
                }

                default:
                    req.setAttribute("error", "⚠️ Hành động không hợp lệ.");
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID thanh toán không hợp lệ.");
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi xử lý thanh toán: " + e.getMessage());
        }

        // Load lại danh sách
        try {
            List<Payments> list = paymentDao.getAllPayments();
            req.setAttribute("pendingPayments", list);
        } catch (Exception e) {
            req.setAttribute("error", "Không thể tải danh sách thanh toán.");
        }

        req.getRequestDispatcher("paymentsAdmin.jsp").forward(req, resp);
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
}
