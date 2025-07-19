/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Payments;

/**
 *
 * @author FPT
 */
public class PaymentDAO extends DBConnect {

    public List<Payments> getAllPayments() throws SQLException {
        List<Payments> list = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY payment_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payments payment = extractPayment(rs); // Gọi hàm hỗ trợ
                list.add(payment);
            }
        }
        return list;
    }

    public boolean setConfirmed(int paymentId, boolean confirmed) throws SQLException {
        String sql = "UPDATE payments SET is_confirmed = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, confirmed);
            ps.setInt(2, paymentId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean setCompleted(int paymentId) throws SQLException {
        String sql = "UPDATE payments SET status = 'completed', is_confirmed = 1 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            return ps.executeUpdate() > 0;
        }
    }

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

// shortcut cho huỷ
    public void cancelPayment(int id, String reason) throws SQLException {
        updatePaymentStatus(id, "failed", false);
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
        payment.setFailureReason(rs.getString("failure_reason"));
        return payment;
    }

    public List<Payments> getRecentPayments(int limit) {
        List<Payments> payments = new ArrayList<>();
        String sql = "SELECT TOP (?) p.*, u.fullname as customer_name FROM payments p "
                + "JOIN users u ON p.user_id = u.id "
                + "ORDER BY p.payment_date DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payments payment = new Payments();
                    payment.setId(rs.getInt("id"));
                    // Use getBigDecimal instead of getDouble
                    payment.setAmount(rs.getBigDecimal("amount"));
                    payment.setPaymentDate(rs.getTimestamp("payment_date"));
                    payment.setStatus(rs.getString("status"));
                    payment.setPaymentMethod(rs.getString("payment_method"));
                    // If your Payments class doesn't have customerName field,
                    // you'll need to add it or remove this line
                    payment.setBankAccountNumber(rs.getString("customer_name"));
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    // Tính tổng doanh thu
    public double getTotalRevenue() {
        String sql = "SELECT SUM(amount) FROM payments WHERE status = 'completed'";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Tính doanh thu tháng hiện tại
    public double getMonthlyRevenue() {
        String sql = "SELECT SUM(amount) FROM payments "
                + "WHERE status = 'completed' "
                + "AND payment_date >= DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) "
                + "AND payment_date < DATEADD(month, DATEDIFF(month, 0, GETDATE()) + 1, 0)";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0.0;
    }

    /* ================= CẬP NHẬT TRẠNG THÁI THANH TOÁN ================= */
    public void updatePaymentStatus(int id,
            String status,
            boolean confirmed,
            String reason) throws SQLException {

        String sql = "UPDATE Payments "
                + "SET status      = ?, "
                + "    isConfirmed = ?, "
                + "    failureReason = ? "
                + // (có thể null)
                "WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setBoolean(2, confirmed);
            ps.setString(3, reason);   // nếu reason == null ⇒ setNull OK
            ps.setInt(4, id);
            ps.executeUpdate();
        }
    }

    /* OVERLOAD tiện dụng nếu không có lý do lỗi */
    public void updatePaymentStatus(int id,
            String status,
            boolean confirmed) throws SQLException {
        updatePaymentStatus(id, status, confirmed, null);
    }

    public int recordPayment(int userId, int servicePackageId, BigDecimal amount, String confirmationCode) throws SQLException {
        String sql = "INSERT INTO payments ("
                + "user_id, service_package_id, payment_method, amount, "
                + "status, is_confirmed, confirmation_code, confirmation_expiry, payment_date"
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"; // Sử dụng ? cho payment_date

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);

            if (servicePackageId > 0) {
                ps.setInt(2, servicePackageId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setString(3, "BANK_QR");
            ps.setBigDecimal(4, amount);
            ps.setString(5, "pending");
            ps.setBoolean(6, false);
            ps.setString(7, confirmationCode);

            // Tính thời gian hết hạn (10 phút sau)
            Timestamp expiry = new Timestamp(System.currentTimeMillis() + 10 * 60 * 1000);
            ps.setTimestamp(8, expiry);

            // Thiết lập payment_date là thời điểm hiện tại
            ps.setTimestamp(9, new Timestamp(System.currentTimeMillis()));

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

            throw new SQLException("Không lấy được paymentId sau khi ghi thanh toán.");
        }
    }

    public boolean confirmPaymentRequest(int paymentId) throws SQLException {
        String sql = "UPDATE payments SET status = ?, is_confirmed = ? WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "waiting_admin_confirm");
            ps.setBoolean(2, false); // vẫn chưa được admin xác nhận
            ps.setInt(3, paymentId);
            return ps.executeUpdate() > 0;
        }
    }

    public void updateStatusByTransactionId(String transactionId, String status) throws SQLException {
        String sql = "UPDATE payments SET status = ?, is_confirmed = 1 WHERE transaction_id = ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, status);
        ps.setString(2, transactionId);
        ps.executeUpdate();
        ps.close();
    }

}
