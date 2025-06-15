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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.GoogleAccount;
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
        // 1. Lấy userId từ email
        String getUserIdSql = "SELECT id FROM users WHERE email = ?";
        try (PreparedStatement stmt1 = connection.prepareStatement(getUserIdSql)) {
            stmt1.setString(1, email);
            try (ResultSet rs = stmt1.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("id");

                    // 2. Lưu token vào bảng user_reset_tokens
                    String insertSql = "INSERT INTO user_reset_tokens (user_id, reset_token, expiry) VALUES (?, ?, DATEADD(DAY, 1, GETDATE()))";
                    try (PreparedStatement stmt2 = connection.prepareStatement(insertSql)) {
                        stmt2.setInt(1, userId);
                        stmt2.setString(2, resetToken);
                        return stmt2.executeUpdate() > 0;
                    }
                } else {
                    // Không tìm thấy user với email này
                    return false;
                }
            }
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

    public User convert(GoogleAccount googleAccount) {
        User user = new User();

        // Convert id String sang int, nếu không convert được gán 0
        try {
            user.setId(Integer.parseInt(googleAccount.getId()));
        } catch (NumberFormatException e) {
            user.setId(0);
        }

        user.setEmail(googleAccount.getEmail());
        user.setFullname(googleAccount.getName());

        // Các trường không có trong GoogleAccount thì để mặc định hoặc trống
        user.setPassword("111111111"); // Mật khẩu mặc định
        user.setPhone(""); // chưa có dữ liệu, để trống
        user.setAddress(""); // chưa có dữ liệu, để trống
        user.setRoleId(1); // mặc định role user
        user.setStatus(true); // kích hoạt mặc định
        user.setCreatedAt(new Date()); // ngày tạo là ngày hiện tại
        user.setVerificationToken(null);
        user.setServicePackageId(0);
        user.setIsActive(true);
        user.setActivationToken(null);
        user.setTokenExpiry(null);

        return user;
    }

    // Đếm tổng số người dùng
    public long countAllUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Đếm số người dùng online (active sessions)
    public int countOnlineUsers() {
        String sql = "SELECT COUNT(DISTINCT user_id) FROM user_sessions WHERE logout_time IS NULL";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Đếm số người dùng active (đã đăng nhập trong 30 ngày)
    public int countActiveUsers() {
        String sql = "SELECT COUNT(DISTINCT user_id) FROM user_sessions "
                + "WHERE login_time >= DATEADD(day, -30, GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Tính phần trăm tăng trưởng người dùng
    public double calculateUserGrowth() {
        String sql = "WITH current_month AS ("
                + "    SELECT COUNT(*) as count FROM users "
                + "    WHERE created_at >= DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) "
                + "), "
                + "prev_month AS ("
                + "    SELECT COUNT(*) as count FROM users "
                + "    WHERE created_at >= DATEADD(month, DATEDIFF(month, 0, GETDATE()) - 1, 0) "
                + "    AND created_at < DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)"
                + ") "
                + "SELECT CASE WHEN prev_month.count = 0 THEN 100.0 "
                + "       ELSE (current_month.count - prev_month.count) * 100.0 / prev_month.count "
                + "       END as growth_rate "
                + "FROM current_month, prev_month";

        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0.0;
    }

    // Lấy thống kê phân bố người dùng
    public Map<String, Integer> getUserDistribution() {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT "
                + "SUM(CASE WHEN role_id = 1 THEN 1 ELSE 0 END) as regular_users, "
                + "SUM(CASE WHEN role_id = 2 THEN 1 ELSE 0 END) as staff_users, "
                + "SUM(CASE WHEN role_id = 3 THEN 1 ELSE 0 END) as admin_users, "
                + "SUM(CASE WHEN service_package_id IS NOT NULL THEN 1 ELSE 0 END) as premium_users "
                + "FROM users WHERE status = 1";

        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                distribution.put("regularUsers", rs.getInt("regular_users"));
                distribution.put("staffUsers", rs.getInt("staff_users"));
                distribution.put("adminUsers", rs.getInt("admin_users"));
                distribution.put("premiumUsers", rs.getInt("premium_users"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return distribution;
    }

    // Lấy thống kê theo ngày (7 ngày gần nhất)
    public List<Map<String, Object>> getDailyStats(int days) {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT TOP (?) date, total_visits, unique_visitors, new_users, "
                + "avg_session_duration as avg_duration, page_views "
                + "FROM daily_statistics "
                + "ORDER BY date DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, days);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> dayStat = new HashMap<>();
                    dayStat.put("date", rs.getDate("date"));
                    dayStat.put("visits", rs.getInt("total_visits"));
                    dayStat.put("uniqueVisitors", rs.getInt("unique_visitors"));
                    dayStat.put("newUsers", rs.getInt("new_users"));
                    dayStat.put("avgDuration", rs.getInt("avg_duration"));
                    dayStat.put("pageViews", rs.getInt("page_views"));
                    stats.add(dayStat);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return stats;
    }

    // Lưu thông tin phiên làm việc
    public void saveSessionInfo(Integer userId, String sessionId, String ipAddress,
            String userAgent, Timestamp loginTime, Timestamp logoutTime,
            int duration) {
        String sql = "INSERT INTO user_sessions (user_id, session_id, ip_address, "
                + "user_agent, login_time, logout_time, duration, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 1)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setObject(1, userId, Types.INTEGER);
            st.setString(2, sessionId);
            st.setString(3, ipAddress);
            st.setString(4, userAgent);
            st.setTimestamp(5, loginTime);
            st.setTimestamp(6, logoutTime);
            st.setInt(7, duration);
            st.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

// Trong UserDAO.java
    // Get all users
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";

        try (PreparedStatement statement = connection.prepareStatement(sql); ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                User user = mapResultSetToUser(resultSet);
                users.add(user);
            }
        }
        return users;
    }

    // Helper method to map ResultSet to User object
    private User mapResultSetToUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getInt("id"));
        user.setEmail(resultSet.getString("email"));
        user.setPassword(resultSet.getString("password"));
        user.setFullname(resultSet.getString("fullname"));
        user.setPhone(resultSet.getString("phone"));
        user.setAddress(resultSet.getString("address"));
        user.setRoleId(resultSet.getInt("role_id"));
        user.setStatus(resultSet.getBoolean("status"));
        user.setCreatedAt(resultSet.getDate("created_at"));
        user.setVerificationToken(resultSet.getString("verification_token"));
        user.setServicePackageId(resultSet.getInt("service_package_id"));
        user.setIsActive(resultSet.getBoolean("is_active"));
        user.setActivationToken(resultSet.getString("activation_token"));
        user.setTokenExpiry(resultSet.getDate("token_expiry"));
        return user;
    }

    public boolean addUser(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, fullname, phone, address, role_id, status, service_package_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, user.getEmail());
            statement.setString(2, user.getPassword());
            statement.setString(3, user.getFullname());
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getAddress());
            statement.setInt(6, user.getRoleId());
            statement.setBoolean(7, user.isStatus());

            if (user.getServicePackageId() > 0) {
                statement.setInt(8, user.getServicePackageId());
            } else {
                statement.setNull(8, Types.INTEGER);
            }

            int affectedRows = statement.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET email = ?, fullname = ?, phone = ?, address = ?, "
                + "role_id = ?, status = ?, service_package_id = ? "
                + "WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getEmail());
            statement.setString(2, user.getFullname());
            statement.setString(3, user.getPhone());
            statement.setString(4, user.getAddress());
            statement.setInt(5, user.getRoleId());
            statement.setBoolean(6, user.isStatus());

            if (user.getServicePackageId() > 0) {
                statement.setInt(7, user.getServicePackageId());
            } else {
                statement.setNull(7, Types.INTEGER);
            }

            statement.setInt(8, user.getId());

            return statement.executeUpdate() > 0;
        }
    }

    public boolean deactivateUser(int userId) throws SQLException {
        String sql = "UPDATE users SET status = CASE WHEN status = 1 THEN 0 ELSE 1 END WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            return statement.executeUpdate() > 0;
        }
    }
}
