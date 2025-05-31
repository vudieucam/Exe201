/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.UserService;

/**
 *
 * @author FPT
 */
public class UserServiceDAO extends DBConnect{
    public boolean save(UserService service) throws SQLException {
        String sql = "INSERT INTO User_Service (user_id, package_id, start_date, end_date, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, service.getUserId());
            ps.setInt(2, service.getPackageId());
            ps.setDate(3, new java.sql.Date(service.getStartDate().getTime()));
            ps.setDate(4, new java.sql.Date(service.getEndDate().getTime()));
            ps.setString(5, service.getStatus());

            return ps.executeUpdate() > 0;
        }
    }
}
