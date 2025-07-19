package controller.Payment;

import dal.PaymentDAO;
import dal.PackageDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.Payments;
import model.ServicePackage;
import model.User;
import model.SendMailOK;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PaymentAdminServlet extends HttpServlet {

    private PaymentDAO paymentDao;
    private PackageDAO pkgDao;
    private UserDAO userDao;

    @Override
    public void init() {
        paymentDao = new PaymentDAO();
        pkgDao = new PackageDAO();
        userDao = new UserDAO();
    }

    /* ------------ HIỂN THỊ DANH SÁCH ------------- */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        loadPayments(req);
        req.getRequestDispatcher("paymentsAdmin.jsp").forward(req, resp);
    }

    /* ------------- XỬ LÝ NÚT BẤM ----------------- */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String reason = req.getParameter("reason");    // reject / refund
        try {
            int paymentId = Integer.parseInt(req.getParameter("paymentId"));
            Payments p = pkgDao.getPaymentById(paymentId);

            switch (action) {
                /* =========== DUYỆT =========== */
                case "approve": {
                    if (!"waiting_admin_confirm".equalsIgnoreCase(p.getStatus())) {
                        req.setAttribute("err",
                                "Chỉ duyệt giao dịch đang ở trạng thái 'waiting_admin_confirm'.");
                        break;
                    }
                    paymentDao.updatePaymentStatus(paymentId, "completed", true);
                    try {
                        sendSuccessMail(paymentId, req);
                    } catch (Exception ex) {
                        Logger.getLogger(PaymentAdminServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    req.setAttribute("msg", "✅ Đã duyệt giao dịch #" + paymentId);
                    break;
                }

                /* =========== HUỶ ============= */
                case "reject": {
                    if (!"waiting_admin_confirm".equalsIgnoreCase(p.getStatus())) {
                        req.setAttribute("err",
                                "Chỉ huỷ giao dịch đang ở trạng thái 'waiting_admin_confirm'.");
                        break;
                    }
                    paymentDao.updatePaymentStatus(paymentId, "failed", false);
                    try {
                        sendFailMail(paymentId, reason);
                    } catch (Exception ex) {
                        Logger.getLogger(PaymentAdminServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    req.setAttribute("msg", "❌ Đã huỷ giao dịch #" + paymentId);
                    break;
                }

                /* ========== HOÀN TIỀN ========= */
                case "refund": {
                    if (!"completed".equalsIgnoreCase(p.getStatus())) {
                        req.setAttribute("err",
                                "Chỉ hoàn tiền giao dịch đã 'completed'.");
                        break;
                    }
                    paymentDao.updatePaymentStatus(paymentId, "refunded", false);
                    try {
                        sendRefundMail(paymentId, reason);
                    } catch (Exception ex) {
                        Logger.getLogger(PaymentAdminServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    req.setAttribute("msg", "💸 Đã hoàn tiền giao dịch #" + paymentId);
                    break;
                }

                default:
                    req.setAttribute("err", "Hành động không hợp lệ!");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("err", "ID thanh toán không hợp lệ.");
        } catch (SQLException e) {
            req.setAttribute("err", "Lỗi SQL: " + e.getMessage());
        }

        // load lại danh sách & forward
        loadPayments(req);
        req.getRequestDispatcher("paymentsAdmin.jsp").forward(req, resp);
    }

    /* ------------- HÀM TIỆN ÍCH -------------- */
    private void loadPayments(HttpServletRequest req) {
        try {
            List<Payments> list = paymentDao.getAllPayments();
            req.setAttribute("payments", list);
        } catch (SQLException e) {
            req.setAttribute("err", "Không thể tải danh sách thanh toán.");
        }
    }

    /* ---------- EMAIL TEMPLATE ---------- */
    private void sendSuccessMail(int payId, HttpServletRequest rq) throws SQLException, Exception {
        Payments p = pkgDao.getPaymentById(payId);
        User u = userDao.getUserById(p.getUserId());
        ServicePackage sp = (p.getServicePackageId() != null)
                ? pkgDao.getPackageById(p.getServicePackageId())
                : null;

        String activationLink = (u.getActivationToken() != null)
                ? rq.getScheme() + "://" + rq.getServerName() + ":" + rq.getServerPort()
                + rq.getContextPath() + "/authen?action=activate&token="
                + u.getActivationToken()
                : "";

        String body = "<div style='font-family:Arial,sans-serif;padding:20px;border:1px solid #e0e0e0;border-radius:8px;'>"
                + "<h2 style='color:#2ecc71;'>🎉 Thanh toán thành công #" + payId + "</h2>"
                + "<p>Xin chào <strong>" + u.getFullname() + "</strong>,</p>"
                + "<p>Chúng tôi đã xác nhận giao dịch thanh toán của bạn tại <strong>PetTech</strong>.</p>"
                + (sp != null
                        ? "<p>Gói dịch vụ được kích hoạt: <strong>" + sp.getName() + "</strong></p>"
                        : "")
                + (!activationLink.isEmpty()
                ? "<p style='margin-top:20px;'>Vui lòng <a href='" + activationLink + "' style='color:#3498db;text-decoration:none;font-weight:bold;'>bấm vào đây để kích hoạt tài khoản của bạn</a>.</p>"
                : "")
                + "<p style='margin-top:30px;color:#555;'>Cảm ơn bạn đã sử dụng dịch vụ của PetTech! 🐾</p>"
                + "<hr style='margin-top:30px;border:none;border-top:1px solid #eee;'>"
                + "<p style='font-size:12px;color:#999;'>Email này được gửi tự động, vui lòng không trả lời lại.</p>"
                + "</div>";

        SendMailOK.send(
                "smtp.gmail.com",
                u.getEmail(),
                "pettech2495@gmail.com",
                "ntjj uyia dvxk atta",
                "PetTech - Thanh toán thành công",
                body
        );
    }

    private void sendFailMail(int payId, String reason) throws SQLException, Exception {
        Payments p = pkgDao.getPaymentById(payId);
        User u = userDao.getUserById(p.getUserId());

        String body = "<div style='font-family:Arial,sans-serif;padding:20px;border:1px solid #f1c0c0;border-radius:8px;'>"
                + "<h2 style='color:#e74c3c;'>💔 Giao dịch bị từ chối #" + payId + "</h2>"
                + "<p>Xin chào <strong>" + u.getFullname() + "</strong>,</p>"
                + "<p>Rất tiếc! Giao dịch của bạn đã bị từ chối.</p>"
                + "<p><strong>Lý do từ chối:</strong> <i>" + reason + "</i></p>"
                + "<p style='margin-top:30px;color:#555;'>Bạn có thể thử lại hoặc liên hệ bộ phận hỗ trợ để được giúp đỡ.</p>"
                + "<hr style='margin-top:30px;border:none;border-top:1px solid #eee;'>"
                + "<p style='font-size:12px;color:#999;'>Email này được gửi tự động, vui lòng không trả lời lại.</p>"
                + "</div>";

        SendMailOK.send(
                "smtp.gmail.com", u.getEmail(), "pettech2495@gmail.com",
                "ntjj uyia dvxk atta",
                "PetTech - Thanh toán thất bại", body
        );
    }

    private void sendRefundMail(int payId, String reason) throws SQLException, Exception {
        Payments p = pkgDao.getPaymentById(payId);
        User u = userDao.getUserById(p.getUserId());

        String body = "<div style='font-family:Arial,sans-serif;padding:20px;border:1px solid #ffe0a3;border-radius:8px;'>"
                + "<h2 style='color:#f39c12;'>💸 Giao dịch được hoàn tiền #" + payId + "</h2>"
                + "<p>Xin chào <strong>" + u.getFullname() + "</strong>,</p>"
                + "<p>Chúng tôi đã hoàn tiền cho giao dịch của bạn tại <strong>PetTech</strong>.</p>"
                + "<p><strong>Lý do hoàn tiền:</strong> <i>" + reason + "</i></p>"
                + "<p style='margin-top:30px;color:#555;'>Cảm ơn bạn đã tin tưởng chúng tôi.</p>"
                + "<hr style='margin-top:30px;border:none;border-top:1px solid #eee;'>"
                + "<p style='font-size:12px;color:#999;'>Email này được gửi tự động, vui lòng không trả lời lại.</p>"
                + "</div>";

        SendMailOK.send(
                "smtp.gmail.com", u.getEmail(), "pettech2495@gmail.com",
                "ntjj uyia dvxk atta",
                "PetTech - Giao dịch hoàn tiền", body
        );
    }
}
