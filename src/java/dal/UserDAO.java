/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.GoogleAccount;
import model.User;

/**
 *
 * @author FPT
 */
public class UserDAO extends DBConnect {

    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setFullname(rs.getString("fullname"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setStatus(rs.getBoolean("status"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean register(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, fullname, phone, address, role_id, status, verification_token) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFullname());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());
            stmt.setInt(6, user.getRoleId());
            stmt.setBoolean(7, user.isStatus());
            stmt.setString(8, user.getVerificationToken());

            return stmt.executeUpdate() > 0;
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setFullname(rs.getString("fullname"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setStatus(rs.getBoolean("status"));
                    return user;
                }
            }
        }
        return null;
    }

    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setFullname(rs.getString("fullname"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setStatus(rs.getBoolean("status"));
                    return user;
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
        String sql = "SELECT * FROM users WHERE reset_token = ? AND reset_token_expiry > NOW()";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    // Các thông tin khác nếu cần
                    return user;
                }
            }
        }
        return null;
    }

    public User findByToken(String token) throws SQLException {
        String sql = "SELECT * FROM users WHERE verification_token = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setFullname(rs.getString("fullname"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setStatus(rs.getBoolean("status"));
                    user.setVerificationToken(rs.getString("verification_token"));
                    return user;
                }
            }
        }
        return null;
    }

    public void saveGoogleAccount(User user) {
        String sql = "INSERT INTO [dbo].[users]\n"
                + "           ([email]\n"
                + "           ,[password]\n"
                + "           ,[fullname]\n"
                + "           ,[phone]\n"
                + "           ,[address]\n"
                + "           ,[role_id]\n"
                + "           ,[status])\n"
                + "     VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.getEmail());
            st.setString(2, user.getPassword()); // Mật khẩu mặc định cho tài khoản Google
            st.setString(3, user.getFullname());
            st.setString(4, user.getPhone() != null ? user.getPhone() : ""); // Số điện thoại mặc định nếu không có
            st.setString(5, user.getAddress() != null ? user.getAddress() : ""); // Địa chỉ mặc định nếu không có
            st.setInt(6, user.getRoleId()); // Chuyển role_id từ String sang int
            st.setBoolean(7, true); // Tài khoản Google luôn active

            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
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
        String sql = "UPDATE users SET password = ? WHERE email = ?";
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

    
    public User convert(GoogleAccount googleAccount) {
        User user = new User();
        user.setEmail(googleAccount.getEmail());
        user.setFullname(googleAccount.getName());
        user.setPhone(""); // hoặc null
        user.setAddress(""); // hoặc null
        user.setPassword("google_default_password"); // mật khẩu mặc định
        user.setRoleId(1); // role_id = 1 cho user thông thường
        user.setStatus(true); // kích hoạt tài khoản
        return user;
    }
}
