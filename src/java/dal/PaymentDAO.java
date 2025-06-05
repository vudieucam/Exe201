/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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

    // Tính tổng doanh thu
//    public double getTotalRevenue() {
//        String sql = "SELECT SUM(amount) FROM payments WHERE status = 'completed'";
//        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
//            if (rs.next()) {
//                return rs.getDouble(1);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return 0;
//    }
    // Lấy danh sách thanh toán gần đây
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
    
    

    public static void main(String[] args) {
        // Giả sử bạn đã có kết nối database
        PaymentDAO paymentDAO = new PaymentDAO(); // Giả sử constructor không cần tham số

        // Test getRecentPayments
        System.out.println("=== Testing getRecentPayments ===");
        List<Payments> recentPayments = paymentDAO.getRecentPayments(5);
        printPayments(recentPayments);

        // Test getTotalRevenue
        System.out.println("\n=== Testing getTotalRevenue ===");
        double totalRevenue = paymentDAO.getTotalRevenue();
        System.out.printf("Total Revenue: $%,.2f\n", totalRevenue);

        // Test getMonthlyRevenue
        System.out.println("\n=== Testing getMonthlyRevenue ===");
        double monthlyRevenue = paymentDAO.getMonthlyRevenue();
        System.out.printf("Monthly Revenue: $%,.2f\n", monthlyRevenue);
    }

    private static void printPayments(List<Payments> payments) {
        if (payments == null || payments.isEmpty()) {
            System.out.println("No payments found.");
            return;
        }

        System.out.println("ID\tAmount\tDate\t\tStatus\t\tMethod\tCustomer");
        for (Payments payment : payments) {
            System.out.printf("%d\t$%,.2f\t%s\t%s\t%s\t%s\n",
                    payment.getId(),
                    payment.getAmount(),
                    payment.getPaymentDate(),
                    payment.getStatus(),
                    payment.getPaymentMethod(),
                    payment.getBankAccountNumber());
        }
    }
}
