/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Admin;

import dal.BlogDAO;
import dal.CourseDAO;
import dal.OrderDAO;
import dal.PaymentDAO;
import dal.ProductDAO;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import model.User;
import listener.SessionCounterListener;

/**
 *
 * @author FPT
 */
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private BlogDAO blogDAO = new BlogDAO();
    private ProductDAO productDAO = new ProductDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (!checkAdminPermission(currentUser)) {
            response.sendRedirect(currentUser == null ? "authen?action=login" : "home");
            return;
        }

        try {
            // Sử dụng ExecutorService để chạy song song các task không phụ thuộc
            ExecutorService executor = Executors.newFixedThreadPool(3);

            Future<Long> totalUsersFuture = executor.submit(() -> userDAO.countAllUsers());
            Future<Long> totalCoursesFuture = executor.submit(() -> courseDAO.countAllCourses());
            Future<Double> totalRevenueFuture = executor.submit(() -> paymentDAO.getTotalRevenue());

            // Lấy các thống kê khác
            Map<String, Object> stats = new HashMap<>();
            stats.put("onlineUsers", SessionCounterListener.getActiveSessions());
            stats.put("totalVisits", getVisitCountFromContext());

            // Kết hợp kết quả
            stats.put("totalUsers", totalUsersFuture.get());
            stats.put("totalCourses", totalCoursesFuture.get());
            stats.put("totalRevenue", totalRevenueFuture.get());

            // Đóng executor
            executor.shutdown();

            // Set attributes
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("Admin.jsp").forward(request, response);

        } catch (Exception e) {
            //logError(e); // Method ghi log riêng
            request.setAttribute("errorMessage", "Lỗi hệ thống");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private boolean checkAdminPermission(User user) {
        return user != null && (user.getRoleId() == 2 || user.getRoleId() == 3);
    }

    private int getVisitCountFromContext() {
        Integer count = (Integer) getServletContext().getAttribute("visitCount");
        return count != null ? count : 0;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Gọi luôn doGet để xử lý
    }
}
