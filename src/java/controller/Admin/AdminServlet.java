package controller.Admin;

import dal.BlogDAO;
import dal.CourseDAO;
import dal.OrderDAO;
import dal.PaymentDAO;
import dal.ProductDAO;
import dal.UserDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final BlogDAO blogDAO = new BlogDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("========== [AdminServlet] Bắt đầu xử lý ==========");

            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            if (currentUser == null) {
                System.out.println("❌ Người dùng chưa đăng nhập. Chuyển hướng đến login.jsp");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            System.out.println("✅ Đã đăng nhập với email: " + currentUser.getEmail());
            System.out.println("✅ Role ID: " + currentUser.getRoleId());

            if (currentUser.getRoleId() != 2 && currentUser.getRoleId() != 3) {
                System.out.println("❌ Người dùng không có quyền truy cập admin.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            Map<String, Object> stats = new HashMap<>();

            // Số lượng phiên hoạt động
            stats.put("onlineUsers", SessionCounterListenerServlet.getActiveSessions());
            System.out.println("✅ onlineUsers: " + SessionCounterListenerServlet.getActiveSessions());

            // Lấy tổng số người dùng và đang hoạt động
            try {
                long totalUsers = userDAO.countAllUsers();
                int activeUsers = userDAO.countActiveUsers();
                stats.put("totalUsers", totalUsers);
                stats.put("activeUsers", activeUsers);
                System.out.println("✅ totalUsers: " + totalUsers + ", activeUsers: " + activeUsers);
            } catch (Exception e) {
                System.out.println("❌ Lỗi khi lấy dữ liệu người dùng: " + e.getMessage());
                e.printStackTrace();
            }

            // Tổng và đang hoạt động khóa học
            try {
                long totalUsers = userDAO.countAllUsers();
                long totalCourses = courseDAO.countAllCourses();
                int activeCourses = courseDAO.countActiveCourses();
                stats.put("totalCourses", totalCourses);
                stats.put("activeCourses", activeCourses);
                System.out.println("✅ totalCourses: " + totalCourses + ", activeCourses: " + activeCourses);
            } catch (Exception e) {
                System.out.println("❌ Lỗi khi lấy dữ liệu khóa học: " + e.getMessage());
                e.printStackTrace();
            }

            // Doanh thu
            try {
                double monthlyRevenue = paymentDAO.getMonthlyRevenue();
                double totalRevenue = paymentDAO.getTotalRevenue();
                stats.put("monthlyRevenue", monthlyRevenue);
                stats.put("totalRevenue", totalRevenue);
                System.out.println("✅ monthlyRevenue: " + monthlyRevenue + ", totalRevenue: " + totalRevenue);
            } catch (Exception e) {
                System.out.println("❌ Lỗi khi lấy dữ liệu doanh thu: " + e.getMessage());
                e.printStackTrace();
            }

            // Tăng trưởng người dùng
            try {
                double growth = userDAO.calculateUserGrowth();
                stats.put("userGrowth", String.format("%.1f", growth));
                System.out.println("✅ userGrowth: " + growth + "%");
            } catch (Exception e) {
                System.out.println("❌ Lỗi khi tính tăng trưởng người dùng: " + e.getMessage());
                e.printStackTrace();
            }

            // Thống kê theo ngày
            try {
                List<Map<String, Object>> dailyStats = userDAO.getDailyStats(30);
                stats.put("dailyStats", dailyStats);
                System.out.println("✅ dailyStats: " + (dailyStats != null ? dailyStats.size() : "null"));
            } catch (Exception e) {
                System.out.println("❌ Lỗi khi lấy dailyStats: " + e.getMessage());
                e.printStackTrace();
            }

            // Top khóa học
            try {
                stats.put("mostViewedCourses", courseDAO.getMostViewedCourses(5));
                stats.put("highestRatedCourses", courseDAO.getHighestRatedCourses(5));
                System.out.println("✅ Đã lấy được top khóa học");
            } catch (Exception e) {
                System.out.println("❌ Lỗi khi lấy top khóa học: " + e.getMessage());
                e.printStackTrace();
            }

            // Phân bố người dùng
            try {
                Map<String, Integer> userActivity = userDAO.getUserDistribution();
                stats.put("userActivity", userActivity); // Không lỗi vì put(Object, Object)

                stats.put("userActivity", userActivity);
                System.out.println("✅ userActivity: " + userActivity);
            } catch (Exception e) {
                System.out.println("❌ Lỗi khi lấy phân bố người dùng: " + e.getMessage());
                e.printStackTrace();
            }

            // Gắn dữ liệu lên request
            request.setAttribute("stats", stats);
            System.out.println("✅ Gán stats vào request thành công");

            // Forward đến trang JSP
            request.getRequestDispatcher("/Admin.jsp").forward(request, response);
            System.out.println("✅ Forward đến Admin.jsp thành công");

        } catch (Exception e) {
            System.out.println("❌ Lỗi lớn trong AdminServlet: " + e.getMessage());
            e.printStackTrace();
            getServletContext().log("Error in AdminServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
