/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Payments;
import model.ServicePackage;
import model.User;
import model.UserService;

/**
 *
 * @author FPT
 */
public class PackageDAO extends DBConnect {

    public List<ServicePackage> getAllPackages() throws SQLException {
        List<ServicePackage> list = new ArrayList<>();
        String sql = "SELECT id, name, description, price, type, status FROM service_packages WHERE status = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ServicePackage pkg = new ServicePackage();
                pkg.setId(rs.getInt("id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setType(rs.getString("type"));
                pkg.setStatus(rs.getBoolean("status"));
                list.add(pkg);
            }
        }
        return list;
    }

    public boolean registerPackage(int userId, int packageId) throws SQLException {
        // Start transaction
        connection.setAutoCommit(false);

        try {
            // 1. Insert into user_packages
            String sql1 = "INSERT INTO user_packages (user_id, service_package_id, start_date, end_date) "
                    + "VALUES (?, ?, GETDATE(), DATEADD(MONTH, 1, GETDATE()))";

            try (PreparedStatement ps1 = connection.prepareStatement(sql1)) {
                ps1.setInt(1, userId);
                ps1.setInt(2, packageId);
                int affectedRows = ps1.executeUpdate();

                if (affectedRows == 0) {
                    connection.rollback();
                    return false;
                }
            }

            // 2. Update users table
            String sql2 = "UPDATE users SET service_package_id = ?, is_active = 1 WHERE id = ?";
            try (PreparedStatement ps2 = connection.prepareStatement(sql2)) {
                ps2.setInt(1, packageId);
                ps2.setInt(2, userId);
                int updated = ps2.executeUpdate();

                if (updated == 0) {
                    connection.rollback();
                    return false;
                }
            }
// 3. Insert into user_packages
            String sql3 = "INSERT INTO user_packages (user_id, service_package_id, start_date, end_date, status) "
                    + "VALUES (?, ?, GETDATE(), DATEADD(MONTH, 1, GETDATE()), 1)"; // status: 1 = active

            try (PreparedStatement ps3 = connection.prepareStatement(sql3)) {
                ps3.setInt(1, userId);
                ps3.setInt(2, packageId);
                int inserted = ps3.executeUpdate();

                if (inserted == 0) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public ServicePackage getPackageById(int packageId) throws SQLException {
        String sql = "SELECT id, name, description, price, type, status FROM service_packages WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, packageId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                ServicePackage pkg = new ServicePackage();
                pkg.setId(rs.getInt("id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setType(rs.getString("type"));
                pkg.setStatus(rs.getBoolean("status"));
                return pkg;
            }
        }
        return null;
    }

    public String getServicePackageNameById(int id) throws SQLException {
        String sql = "SELECT name FROM service_packages WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("name") : "";
            }
        }
    }

    public boolean checkCurrentPackage(int userId, int packageId) throws SQLException {
        String sql = "SELECT 1 FROM user_packages "
                + "WHERE user_id = ? AND service_package_id = ? "
                + "AND end_date > GETDATE() AND status = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, packageId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean recordPayment(int userId, int packageId, String paymentMethod,
            BigDecimal amount, String confirmationCode) throws SQLException {

        String sql = "INSERT INTO payments (user_id, service_package_id, payment_method, "
                + "amount, payment_date, status, confirmation_code, confirmation_expiry) "
                + "VALUES (?, ?, ?, ?, GETDATE(), 'pending', ?, DATEADD(MINUTE, 10, GETDATE()))";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, packageId);
            ps.setString(3, paymentMethod);
            ps.setBigDecimal(4, amount);
            ps.setString(5, confirmationCode);

            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateUserPackage(int userId, int packageId) throws SQLException {
        String sql = "UPDATE users SET service_package_id = ?, is_active = 1 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<UserService> getUserActiveServices(int userId) throws SQLException {
        List<UserService> services = new ArrayList<>();
        String sql = "SELECT id, user_id, service_package_id, start_date, end_date, status "
                + "FROM user_packages WHERE user_id = ?"; // lấy tất cả các gói (cả ẩn và hiện)

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserService service = new UserService();
                    service.setId(rs.getInt("id"));
                    service.setUserId(rs.getInt("user_id"));
                    service.setPackageId(rs.getInt("service_package_id")); // tên mới trong user_packages
                    service.setStartDate(rs.getDate("start_date"));
                    service.setEndDate(rs.getDate("end_date"));

                    // Nếu UserService.status là String, bạn có thể tự convert BIT → String:
                    int statusBit = rs.getInt("status");
                    service.setStatus(statusBit == 1 ? "active" : "inactive");

                    services.add(service);
                }
            }
        }
        return services;
    }

    // Lấy tất cả các gói (cả ẩn và hiện)
    public List<ServicePackage> getAllPackagesAdmin() throws SQLException {
        String sql = "SELECT * FROM service_packages";
        List<ServicePackage> list = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ServicePackage sp = new ServicePackage(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("price"),
                        rs.getString("type"),
                        rs.getBoolean("status")
                );
                list.add(sp);
            }
        }
        return list;
    }

// Cập nhật trạng thái ẩn/hiện
    public boolean toggleStatus(int id, boolean status) throws SQLException {
        String sql = "UPDATE service_packages SET status = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        }
    }

// Thêm gói
    public boolean addPackage(ServicePackage pkg) throws SQLException {
        String sql = "INSERT INTO service_packages(name, description, price, type, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, pkg.getName());
            stmt.setString(2, pkg.getDescription());
            stmt.setBigDecimal(3, pkg.getPrice());
            stmt.setString(4, pkg.getType());
            stmt.setBoolean(5, pkg.isStatus());
            return stmt.executeUpdate() > 0;
        }
    }

// Sửa gói
    public boolean updatePackage(ServicePackage pkg) throws SQLException {
        String sql = "UPDATE service_packages SET name=?, description=?, price=?, type=?, status=? WHERE id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, pkg.getName());
            stmt.setString(2, pkg.getDescription());
            stmt.setBigDecimal(3, pkg.getPrice());
            stmt.setString(4, pkg.getType());
            stmt.setBoolean(5, pkg.isStatus());
            stmt.setInt(6, pkg.getId());
            return stmt.executeUpdate() > 0;
        }
    }

// Xóa (soft delete: set status = 0)
    public boolean deletePackage(int id) throws SQLException {
        return toggleStatus(id, false);
    }
// ------------------------------
// 3. PackageDAO.java - getPendingPayments & confirmPayment (THÊM MỚI)
// ------------------------------

    public List<Payments> getPendingPayments() throws SQLException {
        List<Payments> list = new ArrayList<>();
        String sql = "SELECT * FROM Payments WHERE is_confirmed = 0 ORDER BY payment_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Payments p = new Payments();
                p.setId(rs.getInt("id"));
                p.setUserId(rs.getInt("user_id"));
                p.setServicePackageId(rs.getInt("service_package_id"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setAmount(rs.getBigDecimal("amount"));
                p.setStatus(rs.getString("status"));
                p.setConfirmationCode(rs.getString("confirmation_code"));
                p.setPaymentDate(rs.getTimestamp("payment_date"));
                p.setIsConfirmed(rs.getBoolean("is_confirmed"));
                list.add(p);
            }
        }
        return list;
    }

    public boolean confirmPayment(int paymentId) throws SQLException {
        String sql = "UPDATE payments SET status = 'confirmed', is_confirmed = 1 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean revokeConfirmation(int paymentId) throws SQLException {
        String sql = "UPDATE payments SET is_confirmed = 0, status = 'pending' WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean retryPayment(int paymentId) throws SQLException {
        String sql = "UPDATE payments SET status = 'pending' WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            return ps.executeUpdate() > 0;
        }
    }

// Dùng cho gửi email sau khi admin xác nhận
    public Object[] getPaymentInfo(int paymentId) throws SQLException {
        String sql = "SELECT "
                + "u.id AS u_id, u.fullname AS u_fullname, u.email AS u_email, "
                + "u.activation_token AS u_activation_token, "
                + "s.id AS s_id, s.name AS s_name, s.description AS s_description, "
                + "p.confirmation_code "
                + "FROM payments p "
                + "JOIN users u ON p.user_id = u.id "
                + "JOIN service_packages s ON p.service_package_id = s.id "
                + "WHERE p.id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // 1. Map user
                    User user = new User();
                    user.setId(rs.getInt("u_id"));
                    user.setFullname(rs.getString("u_fullname"));
                    user.setEmail(rs.getString("u_email"));
                    user.setActivationToken(rs.getString("u_activation_token"));

                    // 2. Map package
                    ServicePackage pkg = new ServicePackage();
                    pkg.setId(rs.getInt("s_id"));
                    pkg.setName(rs.getString("s_name"));
                    pkg.setDescription(rs.getString("s_description"));

                    // 3. Get confirmation code
                    String confirmationCode = rs.getString("confirmation_code");

                    return new Object[]{user, pkg, confirmationCode};
                }
            }
        }

        return null; // Không tìm thấy payment
    }

    public Payments getPaymentById(int id) throws SQLException {
        String sql = "SELECT * FROM payments WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payments p = new Payments();
                    p.setId(rs.getInt("id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setServicePackageId(rs.getInt("service_package_id"));
                    p.setAmount(rs.getBigDecimal("amount"));
                    p.setPaymentDate(rs.getTimestamp("payment_date"));
                    p.setStatus(rs.getString("status"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setConfirmationCode(rs.getString("confirmation_code"));
                    p.setIsConfirmed(rs.getBoolean("is_confirmed"));
                    return p;
                }
            }
        }
        return null;
    }

}
