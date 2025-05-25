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
import model.ServicePackage;

/**
 *
 * @author FPT
 */
public class PackageDAO extends DBConnect {

    public List<ServicePackage> getAllPackages() throws SQLException {
        List<ServicePackage> list = new ArrayList<>();
        String sql = "SELECT TOP (1000) id, name, description, price, type FROM service_packages";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ServicePackage pkg = new ServicePackage();
                pkg.setId(rs.getInt("id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setType(rs.getString("type"));
                list.add(pkg);
            }
        }

        return list;
    }

    public boolean registerPackage(int userId, int packageId) throws SQLException {
        String sql = "INSERT INTO user_packages (user_id, service_package_id, start_date, end_date) "
                + "VALUES (?, ?, GETDATE(), DATEADD(MONTH, 1, GETDATE()))";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, packageId);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                // Cập nhật package_id cho user
                String updateUserSql = "UPDATE users SET service_package_id = ? WHERE id = ?";
                try (PreparedStatement updatePs = connection.prepareStatement(sql)) {
                    updatePs.setInt(1, packageId);
                    updatePs.setInt(2, userId);
                    return updatePs.executeUpdate() > 0;
                }
            }

            return false;
        }
    }

    public ServicePackage getPackageById(int packageId) throws SQLException {
        String sql = "SELECT * FROM service_packages WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, packageId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new ServicePackage(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("price"),
                        rs.getString("type")
                );
            }
        }
        return null;
    }

    public boolean checkCurrentPackage(int userId, int packageId) throws SQLException {
        String sql = "SELECT 1 FROM user_packages "
                + "WHERE user_id = ? AND service_package_id = ? "
                + "AND end_date > GETDATE()";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, packageId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
