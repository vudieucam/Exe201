/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Timestamp;
import java.sql.Types;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.UserService;

/**
 *
 * @author FPT
 */
public class UserDAO extends DBConnect {

    public User login(String email, String password) throws SQLException {
        String sql = "SELECT u.*, sp.name as package_name FROM users u "
                + "LEFT JOIN service_packages sp ON u.service_package_id = sp.id "
                + "WHERE u.email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (password.equals(storedPassword)) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public boolean setActive(int userId, boolean isActive) throws SQLException {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT u.*, sp.name as package_name FROM users u "
                + "LEFT JOIN service_packages sp ON u.service_package_id = sp.id "
                + "WHERE u.email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public User findByToken(String token) throws SQLException {
        String sql = "SELECT u.*, sp.name as package_name FROM users u "
                + "LEFT JOIN service_packages sp ON u.service_package_id = sp.id "
                + "WHERE u.verification_token = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public boolean updateVerificationTokenAndStatus(int userId, String token, boolean status) throws SQLException {
        String sql = "UPDATE users SET verification_token = ?, status = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setBoolean(2, status);
            stmt.setInt(3, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean register(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, fullname, phone, address, "
                + "role_id, status, verification_token, service_package_id, "
                + "is_active, activation_token, token_expiry) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullname());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setInt(6, user.getRoleId());
            ps.setBoolean(7, user.isStatus());
            ps.setString(8, user.getVerificationToken());

            if (user.getServicePackageId() > 0) {
                ps.setInt(9, user.getServicePackageId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            ps.setBoolean(10, user.isIsActive());
            ps.setString(11, user.getActivationToken());

            if (user.getTokenExpiry() != null) {
                ps.setTimestamp(12, new Timestamp(user.getTokenExpiry().getTime()));
            } else {
                ps.setNull(12, Types.TIMESTAMP);
            }

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getInt(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    public User getUserById(int id) throws SQLException {
        String sql = "SELECT u.*, sp.name as package_name FROM users u "
                + "LEFT JOIN service_packages sp ON u.service_package_id = sp.id "
                + "WHERE u.id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public boolean saveResetToken(String email, String resetToken) throws SQLException {
        String sql = "UPDATE users SET reset_token = ?, reset_token_expiry = DATE_ADD(NOW(), INTERVAL 1 DAY) WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, resetToken);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public User getUserByResetToken(String token) throws SQLException {
        String sql = "SELECT u.*, sp.name as package_name FROM users u "
                + "LEFT JOIN service_packages sp ON u.service_package_id = sp.id "
                + "WHERE u.reset_token = ? AND u.reset_token_expiry > NOW()";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public void saveGoogleAccount(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, fullname, phone, address, "
                + "role_id, status, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, user.getEmail());
            st.setString(2, user.getPassword());
            st.setString(3, user.getFullname());
            st.setString(4, user.getPhone() != null ? user.getPhone() : "");
            st.setString(5, user.getAddress() != null ? user.getAddress() : "");
            st.setInt(6, user.getRoleId());
            st.setBoolean(7, true);
            st.setBoolean(8, true);
            st.executeUpdate();
        }
    }

    public boolean verifyUser(String token) throws SQLException {
        String sql = "UPDATE users SET status = 1, verification_token = NULL WHERE verification_token = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean changePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean resetPassword(String email, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateProfile(User user) throws SQLException {
        String sql = "UPDATE users SET fullname = ?, phone = ?, address = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getFullname());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getAddress());
            stmt.setInt(4, user.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean checkEmailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean deleteUnverifiedUser(String email) throws SQLException {
        String sql = "DELETE FROM users WHERE email = ? AND status = 0";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public void updateUserPackage(int userId, int servicePackageId) throws SQLException {
        String sql = "UPDATE users SET service_package_id = ?, is_active = 1 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, servicePackageId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void updateUserIsActive(int userId, boolean isActive) throws SQLException {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, isActive);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    public long countAllUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
            return 0;
        }
    }

    public List<User> getRecentUsers(int limit) throws SQLException {
        String sql = "SELECT TOP (?) u.*, sp.name as package_name FROM users u "
                + "LEFT JOIN service_packages sp ON u.service_package_id = sp.id "
                + "ORDER BY u.created_at DESC";
        List<User> list = new ArrayList<>();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUserFromResultSet(rs));
                }
            }
        }
        return list;
    }

    public int countUsersRegisteredOnDate(String date) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE CAST(created_at AS DATE) = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, date);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // User Service methods
    public boolean addUserService(UserService userService) throws SQLException {
        String sql = "INSERT INTO User_Service (user_id, package_id, start_date, end_date, status) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userService.getUserId());
            ps.setInt(2, userService.getPackageId());
            ps.setDate(3, new java.sql.Date(userService.getStartDate().getTime()));
            ps.setDate(4, new java.sql.Date(userService.getEndDate().getTime()));
            ps.setString(5, userService.getStatus());
            return ps.executeUpdate() > 0;
        }
    }

    public UserService getCurrentUserService(int userId) throws SQLException {
        String sql = "SELECT * FROM User_Service WHERE user_id = ? AND status = 'active'";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserService userService = new UserService();
                    userService.setId(rs.getInt("id"));
                    userService.setUserId(rs.getInt("user_id"));
                    userService.setPackageId(rs.getInt("package_id"));
                    userService.setStartDate(rs.getDate("start_date"));
                    userService.setEndDate(rs.getDate("end_date"));
                    userService.setStatus(rs.getString("status"));
                    return userService;
                }
            }
        }
        return null;
    }

    // Helper method to map ResultSet to User object
    private User mapUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFullname(rs.getString("fullname"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRoleId(rs.getInt("role_id"));
        user.setStatus(rs.getBoolean("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setVerificationToken(rs.getString("verification_token"));
        user.setServicePackageId(rs.getInt("service_package_id"));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setActivationToken(rs.getString("activation_token"));
        user.setTokenExpiry(rs.getTimestamp("token_expiry"));
        return user;
    }
}
//    public static void main(String[] args) {
//        UserDAO dao = new UserDAO();
//        String email = "user5@example.com"; // Thay bằng email user role=1
//        String password = "123456Aa"; // Thay bằng password đúng
//
//        try {
//            User user = dao.login(email, password);
//            System.out.println("Test login:");
//            System.out.println("User: " + (user != null ? user.toString() : "null"));
//            if (user != null) {
//                System.out.println("Role: " + user.getRoleId());
//                System.out.println("Status: " + user.isStatus());
//                System.out.println("Active: " + user.isIsActive());
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }

