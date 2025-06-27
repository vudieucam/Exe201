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
    public int countAllUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
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
// Trong UserDAO.java

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

    // Lấy thống kê phân bố người dùng
    public Map<String, Integer> getUserDistribution() {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT\n"
                + "  SUM(CASE WHEN role_id = 1 THEN 1 ELSE 0 END) AS regular_users,\n"
                + "  SUM(CASE WHEN role_id = 2 THEN 1 ELSE 0 END) AS staff_users,\n"
                + "  SUM(CASE WHEN role_id = 3 THEN 1 ELSE 0 END) AS admin_users,\n"
                + "  SUM(CASE WHEN service_package_id IS NOT NULL THEN 1 ELSE 0 END) AS premium_users\n"
                + "FROM users\n"
                + "WHERE status = 1";

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
    public List<Map<String, Object>> getWeeklyStats(int weeks) throws SQLException {
        String sql = "SELECT DATEADD(WEEK, DATEDIFF(WEEK, 0, date), 0) AS week_start, "
                + "SUM(total_visits) AS visits, "
                + "SUM(unique_visitors) AS uniqueVisitors, "
                + "SUM(new_users) AS newUsers, "
                + "AVG(avg_session_duration) AS avgSessionDuration, "
                + "SUM(page_views) AS pageViews, "
                + "MAX(total_users) AS totalUsers, "
                + "MAX(active_users) AS activeUsers, "
                + "SUM(new_registrations) AS newRegistrations, "
                + "MAX(premium_users) AS premiumUsers "
                + "FROM daily_statistics "
                + "WHERE date >= DATEADD(WEEK, -?, CAST(GETDATE() AS DATE)) "
                + "GROUP BY DATEADD(WEEK, DATEDIFF(WEEK, 0, date), 0) "
                + "ORDER BY week_start";

        List<Map<String, Object>> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, weeks); // KHÔNG cần dấu trừ vì đã có sẵn -? trong SQL
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("date", rs.getDate("week_start"));
                    map.put("visits", rs.getInt("visits"));
                    map.put("uniqueVisitors", rs.getInt("uniqueVisitors"));
                    map.put("newUsers", rs.getInt("newUsers"));
                    map.put("avgSessionDuration", rs.getInt("avgSessionDuration"));
                    map.put("pageViews", rs.getInt("pageViews"));
                    map.put("totalUsers", rs.getInt("totalUsers"));
                    map.put("activeUsers", rs.getInt("activeUsers"));
                    map.put("newRegistrations", rs.getInt("newRegistrations"));
                    map.put("premiumUsers", rs.getInt("premiumUsers"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getMonthlyStats(int months) throws SQLException {
        String sql = "SELECT DATEFROMPARTS(YEAR(date), MONTH(date), 1) AS month_start, "
                + "SUM(total_visits) AS visits, "
                + "SUM(unique_visitors) AS uniqueVisitors, "
                + "SUM(new_users) AS newUsers, "
                + "AVG(avg_session_duration) AS avgSessionDuration, "
                + "SUM(page_views) AS pageViews, "
                + "MAX(total_users) AS totalUsers, "
                + "MAX(active_users) AS activeUsers, "
                + "SUM(new_registrations) AS newRegistrations, "
                + "MAX(premium_users) AS premiumUsers "
                + "FROM daily_statistics "
                + "WHERE date >= DATEADD(MONTH, -?, CAST(GETDATE() AS DATE)) "
                + "GROUP BY YEAR(date), MONTH(date) "
                + "ORDER BY month_start";

        List<Map<String, Object>> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, months); // ✅ sửa chỗ này
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("date", rs.getDate("month_start"));
                    map.put("visits", rs.getInt("visits"));
                    map.put("uniqueVisitors", rs.getInt("uniqueVisitors"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    // Lưu thông tin phiên làm việc
    public void saveSessionInfo(Integer userId, String sessionId, String ipAddress,
            String userAgent, String deviceType, String browser, String os,
            String screenResolution, Timestamp loginTime, Timestamp logoutTime,
            int duration, boolean isNewUser, boolean isNewSession, int pageViews,
            boolean bounceStatus, String countryCode, String region, String city,
            String referrerUrl, String landingPage, String exitPage) {

        String sql = "INSERT INTO user_sessions (user_id, session_id, ip_address, "
                + "user_agent, device_type, browser, os, screen_resolution, "
                + "login_time, logout_time, duration, is_new_user, is_new_session, "
                + "page_views, bounce_status, country_code, region, city, "
                + "referrer_url, landing_page, exit_page) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setObject(1, userId, Types.INTEGER);
            st.setString(2, sessionId);
            st.setString(3, ipAddress);
            st.setString(4, userAgent);
            st.setString(5, deviceType);
            st.setString(6, browser);
            st.setString(7, os);
            st.setString(8, screenResolution);
            st.setTimestamp(9, loginTime);
            st.setTimestamp(10, logoutTime);
            st.setInt(11, duration);
            st.setBoolean(12, isNewUser);
            st.setBoolean(13, isNewSession);
            st.setInt(14, pageViews);
            st.setBoolean(15, bounceStatus);
            st.setString(16, countryCode);
            st.setString(17, region);
            st.setString(18, city);
            st.setString(19, referrerUrl);
            st.setString(20, landingPage);
            st.setString(21, exitPage);

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
    // Tính phần trăm tăng trưởng người dùng

    public double calculateUserGrowth() {
        String sql = "WITH current_month AS (\n"
                + "    SELECT COUNT(*) AS count FROM users\n"
                + "    WHERE created_at >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)\n"
                + "),\n"
                + "prev_month AS (\n"
                + "    SELECT COUNT(*) AS count FROM users\n"
                + "    WHERE created_at >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)\n"
                + "      AND created_at < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)\n"
                + ")\n"
                + "SELECT \n"
                + "    CASE \n"
                + "        WHEN prev_month.count = 0 THEN 0.0\n"
                + "        ELSE (current_month.count - prev_month.count) * 100.0 / prev_month.count\n"
                + "    END AS growth_rate\n"
                + "FROM current_month, prev_month;";

        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0.0;
    }

    public List<Map<String, Object>> getDailyStats(int days) throws SQLException {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT date, total_visits AS visits, unique_visitors AS uniqueVisitors "
                + "FROM daily_statistics "
                + "WHERE date >= DATEADD(DAY, -?, CAST(GETDATE() AS DATE)) "
                + "ORDER BY date ASC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, days);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("date", rs.getDate("date"));
                    map.put("visits", rs.getInt("visits"));
                    map.put("uniqueVisitors", rs.getInt("uniqueVisitors"));
                    stats.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // TODO: Logging hoặc xử lý lỗi chi tiết
        }
        return stats;
    }

    public Map<String, Object> getTechnicalPerformanceMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        String sql = "SELECT\n"
                + "  AVG(page_load_time) AS avg_page_load_time,\n"
                + "  AVG(server_response_time) AS avg_server_response_time,\n"
                + "  (SUM(error_count) * 1.0 / NULLIF(SUM(page_views), 0)) AS error_rate\n"
                + "FROM performance_metrics\n"
                + "WHERE [date] >= DATEADD(DAY, -30, GETDATE())";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                metrics.put("avg_page_load_time", rs.getDouble("avg_page_load_time"));
                metrics.put("avg_server_response_time", rs.getDouble("avg_server_response_time"));
                metrics.put("error_rate", rs.getDouble("error_rate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            metrics.put("avg_page_load_time", 0.0);
            metrics.put("avg_server_response_time", 0.0);
            metrics.put("error_rate", 0.0);
        }
        return metrics;
    }

    public Map<String, Object> getUserBehaviorMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        String sql = "SELECT\n"
                + "  AVG(bounce_rate) AS bounce_rate,\n"
                + "  AVG(session_duration) AS avg_session_duration,\n"
                + "  AVG(pages_per_session) AS pages_per_session,\n"
                + "  AVG(scroll_depth) AS avg_scroll_depth\n"
                + "FROM user_behavior_metrics\n"
                + "WHERE [date] >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                metrics.put("bounce_rate", rs.getObject("bounce_rate") != null ? rs.getDouble("bounce_rate") : 0.0);
                metrics.put("avg_session_duration", rs.getObject("avg_session_duration") != null ? rs.getInt("avg_session_duration") : 0);
                metrics.put("pages_per_session", rs.getObject("pages_per_session") != null ? rs.getDouble("pages_per_session") : 0.0);
                metrics.put("avg_scroll_depth", rs.getObject("avg_scroll_depth") != null ? rs.getDouble("avg_scroll_depth") : 0.0);
            } else {
                metrics.put("bounce_rate", 0.0);
                metrics.put("avg_session_duration", 0);
                metrics.put("pages_per_session", 0.0);
                metrics.put("avg_scroll_depth", 0.0);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            metrics.put("bounce_rate", 0.0);
            metrics.put("avg_session_duration", 0);
            metrics.put("pages_per_session", 0.0);
            metrics.put("avg_scroll_depth", 0.0);
        }

        return metrics;
    }

    public Map<String, Object> getTrafficMetrics() {
        Map<String, Object> metrics = new HashMap<>();

        String userSql = "SELECT\n"
                + "  SUM(CASE WHEN is_new_user = 1 THEN 1 ELSE 0 END) AS new_users,\n"
                + "  SUM(CASE WHEN is_new_user = 0 THEN 1 ELSE 0 END) AS returning_users\n"
                + "FROM user_sessions\n"
                + "WHERE login_time >= DATEADD(DAY, -30, GETDATE());";

        String sourceSql = "SELECT traffic_source, COUNT(*) AS count\n"
                + "FROM traffic_sources\n"
                + "WHERE visit_date >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))\n"
                + "GROUP BY traffic_source;";

        try {
            try (PreparedStatement stmt = connection.prepareStatement(userSql); ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    metrics.put("new_users", rs.getInt("new_users"));
                    metrics.put("returning_users", rs.getInt("returning_users"));
                }
            }

            Map<String, Integer> sources = new HashMap<>();
            try (PreparedStatement stmt = connection.prepareStatement(sourceSql); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sources.put(rs.getString("traffic_source"), rs.getInt("count"));
                }
            }
            metrics.put("traffic_sources", sources);

        } catch (SQLException e) {
            e.printStackTrace();
            metrics.put("new_users", 0);
            metrics.put("returning_users", 0);
            metrics.put("traffic_sources", new HashMap<>());
        }

        return metrics;
    }

    public Map<String, Object> getConversionMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        String sql = "SELECT "
                + "(COUNT(DISTINCT CASE WHEN converted = 1 THEN user_id END) / COUNT(DISTINCT user_id)) AS conversion_rate, "
                + "(COUNT(DISTINCT CASE WHEN signed_up = 1 THEN user_id END) / COUNT(DISTINCT user_id)) AS signup_conversion, "
                + "(COUNT(DISTINCT CASE WHEN purchased = 1 THEN user_id END) / COUNT(DISTINCT user_id)) AS purchase_conversion "
                + "FROM conversion_metrics "
                + "WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                metrics.put("conversion_rate", rs.getDouble("conversion_rate"));
                metrics.put("signup_conversion", rs.getDouble("signup_conversion"));
                metrics.put("purchase_conversion", rs.getDouble("purchase_conversion"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            metrics.put("conversion_rate", 0.0);
            metrics.put("signup_conversion", 0.0);
            metrics.put("purchase_conversion", 0.0);
        }
        return metrics;
    }

    public double getClickThroughRate() {
        String sql = "SELECT \n"
                + "    SUM(clicks) AS total_clicks, \n"
                + "    SUM(impressions) AS total_impressions\n"
                + "FROM user_behavior_metrics\n"
                + "WHERE [date] >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE));";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                int clicks = rs.getInt("total_clicks");
                int impressions = rs.getInt("total_impressions");
                if (impressions == 0) {
                    return 0.0;
                }
                return (double) clicks / impressions;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<Map<String, Object>> getDailyCTRStats(int days) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT CAST(date AS DATE) AS day, SUM(clicks) AS total_clicks, SUM(impressions) AS total_impressions "
                + "FROM user_behavior_metrics "
                + "WHERE date >= DATEADD(DAY, -?, GETDATE()) "
                + "GROUP BY CAST(date AS DATE) "
                + "ORDER BY day ASC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, days);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    Date date = rs.getDate("day");
                    int clicks = rs.getInt("total_clicks");
                    int impressions = rs.getInt("total_impressions");
                    double ctr = (impressions == 0) ? 0.0 : (double) clicks / impressions;
                    row.put("date", date);
                    row.put("ctr", ctr);
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
// Trong UserDAO.java

    public List<Map<String, Object>> getCTRStats(String type, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "";

        switch (type) {
            case "month":
                sql = "SELECT DATEADD(month, DATEDIFF(month, 0, date), 0) AS date, "
                        + "       CASE WHEN SUM(impressions) = 0 THEN 0 "
                        + "            ELSE CAST(SUM(clicks) * 100.0 / SUM(impressions) AS DECIMAL(5,2)) "
                        + "       END AS ctr "
                        + "FROM user_behavior_metrics "
                        + "WHERE date >= DATEADD(month, -?, GETDATE()) "
                        + "GROUP BY DATEADD(month, DATEDIFF(month, 0, date), 0) "
                        + "ORDER BY date ASC";
                break;
            case "week":
                sql = "SELECT DATEADD(week, DATEDIFF(week, 0, date), 0) AS date, "
                        + "       CASE WHEN SUM(impressions) = 0 THEN 0 "
                        + "            ELSE CAST(SUM(clicks) * 100.0 / SUM(impressions) AS DECIMAL(5,2)) "
                        + "       END AS ctr "
                        + "FROM user_behavior_metrics "
                        + "WHERE date >= DATEADD(week, -?, GETDATE()) "
                        + "GROUP BY DATEADD(week, DATEDIFF(week, 0, date), 0) "
                        + "ORDER BY date ASC";
                break;
            default: // day
                sql = "SELECT CAST(date AS DATE) AS date, "
                        + "       CASE WHEN SUM(impressions) = 0 THEN 0 "
                        + "            ELSE CAST(SUM(clicks) * 100.0 / SUM(impressions) AS DECIMAL(5,2)) "
                        + "       END AS ctr "
                        + "FROM user_behavior_metrics "
                        + "WHERE date >= DATEADD(day, -?, GETDATE()) "
                        + "GROUP BY CAST(date AS DATE) "
                        + "ORDER BY date ASC";
        }

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("date", rs.getDate("date"));
                    row.put("ctr", rs.getDouble("ctr"));
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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

        // Xử lý ngày tháng
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(new Date(createdAt.getTime()));
        }

        user.setVerificationToken(resultSet.getString("verification_token"));
        user.setServicePackageId(resultSet.getInt("service_package_id"));
        user.setIsActive(resultSet.getBoolean("is_active"));
        user.setActivationToken(resultSet.getString("activation_token"));

        // Xử lý ngày hết hạn token
        Timestamp tokenExpiry = resultSet.getTimestamp("token_expiry");
        if (tokenExpiry != null) {
            user.setTokenExpiry(new Date(tokenExpiry.getTime()));
        }

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
