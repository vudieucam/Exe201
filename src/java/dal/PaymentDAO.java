/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Payments;



/**
 *
 * @author FPT
 */
public class PaymentDAO extends DBConnect {

    // Tìm thanh toán theo mã xác nhận
    public Payments getPaymentByConfirmationCode(String code) throws SQLException {
        String sql = "SELECT * FROM payments WHERE confirmation_code = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractPayment(rs);
            }
        }
        return null;
    }

    // Cập nhật trạng thái thanh toán + đánh dấu đã xác nhận
    public void updatePaymentStatus(int paymentId, String status, boolean confirmed) throws SQLException {
        String sql = "UPDATE payments SET status = ?, is_confirmed = ?, payment_date = GETDATE() WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setBoolean(2, confirmed);
            ps.setInt(3, paymentId);
            ps.executeUpdate();
        }
    }

    // Hàm hỗ trợ: tạo đối tượng Payment từ ResultSet
    private Payments extractPayment(ResultSet rs) throws SQLException {
        Payments payment = new Payments();
        payment.setId(rs.getInt("id"));
        payment.setUserId(rs.getInt("user_id"));
        payment.setServicePackageId(rs.getInt("service_package_id"));
        payment.setOrderId(rs.getInt("order_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setStatus(rs.getString("status"));
        payment.setTransactionId(rs.getString("transaction_id"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setQrCodeUrl(rs.getString("qr_code_url"));
        payment.setBankAccountNumber(rs.getString("bank_account_number"));
        payment.setBankName(rs.getString("bank_name"));
        payment.setNotes(rs.getString("notes"));
        payment.setIsConfirmed(rs.getBoolean("is_confirmed"));
        payment.setConfirmationCode(rs.getString("confirmation_code"));
        payment.setConfirmationExpiry(rs.getTimestamp("confirmation_expiry"));
        return payment;
    }
}
