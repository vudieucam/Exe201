package controller.Payment;

import com.google.gson.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.payos.PayOS;
import vn.payos.type.WebhookData;
import vn.payos.type.Webhook;

import java.io.BufferedReader;
import java.io.IOException;


@WebServlet(name = "PayOSWebhookServlet", urlPatterns = {"/payos_transfer_handler"})
public class PayOSWebhookServlet extends HttpServlet {

    private PayOS payOS = new PayOS(
            System.getenv("PAYOS_CLIENT_ID"),
            System.getenv("PAYOS_API_KEY"),
            System.getenv("PAYOS_CHECKSUM"));

    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        JsonObject out = new JsonObject();
        try {
            String rawBody = readBody(req);

            // Dùng class Webhook đúng của SDK (vn.payos.type.Webhook)
            Webhook webhook = gson.fromJson(rawBody, Webhook.class);

            // Xác thực & giải mã webhook
            WebhookData data = payOS.verifyPaymentWebhookData(webhook);

            // TODO: cập nhật bảng payments theo data.getTransactionId() hoặc data.getOrderCode()
            // ví dụ: cập nhật trạng thái 'paid' cho payments theo mã đơn
            // PaymentDAO.updateStatusByTransactionId(data.getTransactionId(), "paid");

            out.addProperty("error", 0);
            out.addProperty("message", "Webhook delivered");
        } catch (Exception ex) {
            ex.printStackTrace();
            out.addProperty("error", -1);
            out.addProperty("message", ex.getMessage());
        }

        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(gson.toJson(out));
    }

    private String readBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}
