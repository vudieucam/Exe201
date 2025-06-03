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
import model.ServicePackage;
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

            // 3. Insert into User_Service
            String sql3 = "INSERT INTO User_Service (user_id, package_id, start_date, end_date, status) "
                    + "VALUES (?, ?, GETDATE(), DATEADD(MONTH, 1, GETDATE()), 'active')";
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
        String sql = "SELECT id, user_id, package_id, start_date, end_date, status "
                + "FROM User_Service WHERE user_id = ? AND status = 'active'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserService service = new UserService();
                    service.setId(rs.getInt("id"));
                    service.setUserId(rs.getInt("user_id"));
                    service.setPackageId(rs.getInt("package_id"));
                    service.setStartDate(rs.getDate("start_date"));
                    service.setEndDate(rs.getDate("end_date"));
                    service.setStatus(rs.getString("status"));
                    services.add(service);
                }
            }
        }
        return services;
    }
}
