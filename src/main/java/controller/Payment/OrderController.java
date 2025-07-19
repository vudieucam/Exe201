package controller.Payment;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dal.PaymentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import vn.payos.PayOS;
import vn.payos.type.*;

public class OrderController extends HttpServlet {

    private PayOS payOS;
    private PaymentDAO paymentDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        payOS = new PayOS(
                System.getenv("PAYOS_CLIENT_ID"),
                System.getenv("PAYOS_API_KEY"),
                System.getenv("PAYOS_CHECKSUM"));
        paymentDAO = new PaymentDAO();
    }

    /* =============================================================
       POST —  (1) confirm_request | (2) /OrderController/create
       ============================================================= */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /* === 1. Người dùng ấn nút xác nhận thanh toán === */
        if ("confirm_request".equals(req.getParameter("action"))) {
            String userIdRaw = req.getParameter("userId");
            String priceRaw = req.getParameter("price");
            String packageIdRaw = req.getParameter("packageId");

            if (userIdRaw == null || userIdRaw.isBlank()
                    || priceRaw == null || priceRaw.isBlank()
                    || packageIdRaw == null || packageIdRaw.isBlank()) {
                sendClientError(req, resp, "Thiếu thông tin cần thiết (userId, price, packageId).");
                return;
            }

            int userId = Integer.parseInt(userIdRaw);
            int price = Integer.parseInt(priceRaw);
            int packageId = Integer.parseInt(packageIdRaw);
            String note = req.getParameter("note");

            String confirmationCode = UUID.randomUUID().toString();

            try {
                int paymentId = paymentDAO.recordPayment(
                        userId,
                        packageId,
                        BigDecimal.valueOf(price),
                        confirmationCode
                );

                resp.sendRedirect(req.getContextPath()
                        + "/payment_pending.jsp?pid=" + paymentId + "&msg="
                        + URLEncoder.encode("Giao dịch đã được tạo!", StandardCharsets.UTF_8));

            } catch (Exception ex) {
                Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
                sendClientError(req, resp, "Không thể tạo giao dịch.");
            }
            return;
        }

        /* === 2. AJAX gọi tạo QR === */
        if ("/create".equals(req.getPathInfo())) {
            CreateBody body = gson.fromJson(readBody(req), CreateBody.class);
            JsonObject out = new JsonObject();

            try {
                long code = Long.parseLong(
                        String.valueOf(System.currentTimeMillis()).substring(7));

                ItemData item = ItemData.builder()
                        .name(body.productName).price(body.price).quantity(1)
                        .build();

                PaymentData paymentData = PaymentData.builder()
                        .orderCode(code).amount(body.price)
                        .description(body.description)
                        .returnUrl(body.returnUrl)
                        .cancelUrl(body.cancelUrl)
                        .item(item).build();

                CheckoutResponseData data = payOS.createPaymentLink(paymentData);

                out.addProperty("error", 0);
                out.add("data", gson.toJsonTree(data));

            } catch (Exception ex) {
                Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
                out.addProperty("error", 1);
                out.addProperty("message", ex.getMessage());
            }

            writeJson(resp, out);
            return;
        }

        resp.sendError(404);
    }


    /* =============================================================
       GET (lấy link QR)  | PUT (hủy link)
       ============================================================= */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        handleOrder(req, resp, false);
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        handleOrder(req, resp, true);
    }

    private void handleOrder(HttpServletRequest req, HttpServletResponse resp, boolean cancel)
            throws IOException {

        String idStr = (req.getPathInfo() != null) ? req.getPathInfo().substring(1) : "";
        JsonObject out = new JsonObject();

        try {
            long id = Long.parseLong(idStr);
            PaymentLinkData data = cancel
                    ? payOS.cancelPaymentLink(id, null)
                    : payOS.getPaymentLinkInformation(id);

            out.addProperty("error", 0);
            out.add("data", gson.toJsonTree(data));

        } catch (Exception ex) {
            out.addProperty("error", 1);
            out.addProperty("message", ex.getMessage());
        }

        writeJson(resp, out);
    }

    private void sendClientError(HttpServletRequest req,
            HttpServletResponse resp,
            String message) throws IOException {

        if (!"XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
            String url = req.getContextPath()
                    + "/payment_pending.jsp?err="
                    + URLEncoder.encode(message, StandardCharsets.UTF_8);
            resp.sendRedirect(url);
        } else {
            JsonObject o = new JsonObject();
            o.addProperty("error", 1);
            o.addProperty("message", message);
            writeJson(resp, o);
        }
    }

    private void writeJson(HttpServletResponse resp, JsonObject o) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(gson.toJson(o));
    }

    private String readBody(HttpServletRequest r) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = r.getReader()) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }

    /* ----------- Body class cho /OrderController/create ----------- */
    private static class CreateBody {

        int userId;
        String productName;
        String description;
        int price;
        String returnUrl;
        String cancelUrl;
    }
}
