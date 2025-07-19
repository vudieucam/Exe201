package controller.Payment;

import dal.PaymentDAO;
import dal.PackageDAO;
import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Payments;
import model.ServicePackage;
import model.User;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;

public class CheckoutController extends HttpServlet {

    private PayOS payOS;
    private PaymentDAO paymentDAO;
    private PackageDAO pkgDAO;

    @Override
    public void init() throws ServletException {
        payOS = new PayOS(
                System.getenv("PAYOS_CLIENT_ID"),
                System.getenv("PAYOS_API_KEY"),
                System.getenv("PAYOS_CHECKSUM"));
        paymentDAO = new PaymentDAO();
        pkgDAO = new PackageDAO();
    }

    /* ======================  GET : hiển thị form chọn gói  ====================== */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            User user = new UserDAO().getUserById(userId);
            req.setAttribute("user", user);
        } catch (SQLException ex) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
            resp.sendError(500, "Không lấy được thông tin người dùng");
            return;
        }

        /* Hiển thị trang form lựa chọn gói */
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    /* ======================  POST : tạo link PayOS & hiển thị QR  =============== */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        try {
            int userId = Integer.parseInt(req.getParameter("userId"));
            int packageId = Integer.parseInt(req.getParameter("packageId"));
            String note = req.getParameter("note");

            ServicePackage selectedPkg = pkgDAO.getPackageById(packageId);
            if (selectedPkg == null) {
                resp.sendError(400, "Không tìm thấy gói dịch vụ");
                return;
            }

            // ✅ Tạo giao dịch TRƯỚC khi tạo QR
            String confirmationCode = UUID.randomUUID().toString();
            // Trong doPost()
            int paymentId = paymentDAO.recordPayment(
                    userId,
                    packageId,
                    selectedPkg.getPrice(),
                    confirmationCode
            );

// Lưu ý: Thêm xử lý ghi note nếu cần
// paymentDAO.updatePaymentNote(paymentId, note); // Nếu cần lưu note
            long orderCode = Long.parseLong(String.valueOf(System.currentTimeMillis()).substring(7));
            int price = selectedPkg.getPrice().intValue();
            String baseUrl = getBaseUrl(req);

            ItemData item = ItemData.builder()
                    .name(selectedPkg.getName()).price(price).quantity(1).build();

            PaymentData paymentData = PaymentData.builder()
                    .orderCode(orderCode).amount(price)
                    .description("Thanh toán gói " + selectedPkg.getName())
                    .returnUrl(baseUrl + "/payment_pending.jsp?pid=" + paymentId) // ✅ Truyền paymentId
                    .cancelUrl(baseUrl + "/cancel_payment.jsp")
                    .item(item)
                    .build();

            CheckoutResponseData data = payOS.createPaymentLink(paymentData);

            // Gửi về form xác nhận
            req.setAttribute("checkoutUrl", data.getCheckoutUrl());
            req.setAttribute("qrEncoded", URLEncoder.encode(data.getCheckoutUrl(), StandardCharsets.UTF_8));
            req.setAttribute("pkg", selectedPkg);
            req.setAttribute("userId", userId);
            req.setAttribute("price", price);
            req.setAttribute("note", note);
            req.setAttribute("paymentId", paymentId); // ✅ Thêm paymentId

            req.getRequestDispatcher("/payment.jsp").forward(req, resp);

        } catch (Exception ex) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
            resp.sendError(500, "Có lỗi khi xử lý thanh toán");
        }
    }

    /* -------------------------------------------------------------------------- */
    private String getBaseUrl(HttpServletRequest req) {
        String scheme = req.getScheme();
        int port = req.getServerPort();
        boolean def = ("http".equals(scheme) && port == 80) || ("https".equals(scheme) && port == 443);
        return scheme + "://" + req.getServerName() + (def ? "" : ":" + port) + req.getContextPath();
    }
}
