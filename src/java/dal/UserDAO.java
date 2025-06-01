/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Types;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.GoogleAccount;
import model.User;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPT
 */
public class UserDAO extends DBConnect {

    public User login(String email, String password) throws SQLException {
        // Chỉ kiểm tra email trước
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // So sánh mật khẩu plain text
                String storedPassword = rs.getString("password");
                if (password.equals(storedPassword)) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(storedPassword);
                    user.setFullname(rs.getString("fullname"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setStatus(rs.getBoolean("status"));
                    user.setIsActive(rs.getBoolean("is_active"));
                    return user;
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
                    user.setIsActive(rs.getBoolean("is_active"));  // thêm isActive
                    user.setVerificationToken(rs.getString("verification_token"));
                    user.setServicePackageId((Integer) rs.getObject("service_package_id"));
                    user.setActivationToken(rs.getString("activation_token"));
                    user.setTokenExpiry(rs.getTimestamp("token_expiry"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
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
                    user.setIsActive(rs.getBoolean("is_active"));  // thêm isActive
                    user.setVerificationToken(rs.getString("verification_token"));
                    user.setServicePackageId((Integer) rs.getObject("service_package_id"));
                    user.setActivationToken(rs.getString("activation_token"));
                    user.setTokenExpiry(rs.getTimestamp("token_expiry"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean updateVerificationTokenAndStatus(int userId, String token, boolean status) throws SQLException {
        String sql = "UPDATE Users SET verification_token = ?, status = ? WHERE id = ?";
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

            if (user.getServicePackageId() != null) {
                ps.setInt(9, user.getServicePackageId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            ps.setBoolean(10, user.isIsActive());
            ps.setString(11, user.getActivationToken());

            if (user.getTokenExpiry() != null) {
                ps.setTimestamp(12, new java.sql.Timestamp(user.getTokenExpiry().getTime()));
            } else {
                ps.setNull(12, Types.TIMESTAMP);
            }

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getInt(1)); // Lấy id tự động sinh và gán cho user
                    }
                }
                return true;
            } else {
                return false;
            }
        }
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
                    user.setIsActive(rs.getBoolean("is_active"));  // <- thêm dòng này
                    user.setVerificationToken(rs.getString("verification_token"));
                    user.setServicePackageId((Integer) rs.getObject("service_package_id"));
                    user.setActivationToken(rs.getString("activation_token"));
                    user.setTokenExpiry(rs.getTimestamp("token_expiry"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
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

    // Đếm tổng số người dùng
    public long countAllUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
            return 0;
        }
    }

    // Lấy danh sách người dùng gần đây
    // Trong UserDAO
    public List<User> getRecentUsers(int limit) {
        String sql = "SELECT TOP (?) * FROM users ORDER BY created_at DESC";
        List<User> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullname(rs.getString("fullname"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                // Thêm các trường khác nếu cần
                list.add(user);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    // Đếm số user đăng ký trong ngày cụ thể
    public int countUsersRegisteredOnDate(String date) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE CAST(created_at AS DATE) = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, date);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        String email = "user5@example.com"; // Thay bằng email user role=1
        String password = "123456Aa"; // Thay bằng password đúng

        try {
            User user = dao.login(email, password);
            System.out.println("Test login:");
            System.out.println("User: " + (user != null ? user.toString() : "null"));
            if (user != null) {
                System.out.println("Role: " + user.getRoleId());
                System.out.println("Status: " + user.isStatus());
                System.out.println("Active: " + user.isIsActive());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
