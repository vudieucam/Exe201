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
import java.util.List;
import model.Blog;
import model.Course;
import model.Order;
import model.Payments;
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

        // Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect("authen?action=login");
            return;
        }

        // Kiểm tra quyền truy cập, chỉ cho phép role 2 hoặc 3
        if (currentUser.getRoleId() == 1) {
            response.sendRedirect("home.jsp");
            return;
        }

        try {
            // Lấy thống kê tổng quan
            long totalUsers = userDAO.countAllUsers();
            long totalCourses = courseDAO.countAllCourses();
            long totalOrders = orderDAO.countAllOrders();
            double totalRevenue = paymentDAO.getTotalRevenue();

            // Lấy các hoạt động gần đây
            List<User> recentUsers = userDAO.getRecentUsers(5);
            List<Order> recentOrders = orderDAO.getRecentOrders(5);
            List<Course> recentCourses = courseDAO.getRecentCourses(5);
            List<Payments> recentPayments = paymentDAO.getRecentPayments(5);

            // Lấy các khóa học phổ biến
            List<Course> popularCourses = courseDAO.getPopularCourses(5);

            // Lấy các bài blog mới nhất
            List<Blog> recentBlogs = blogDAO.getRecentBlogs(3);

            // Thống kê truy cập =============================================
            // Cách 1: Sử dụng SessionCounterListener (recommended)
            int onlineUsers = SessionCounterListener.getActiveSessions();

            // Cách 2: Sử dụng Application Scope (nếu không dùng listener)
            int totalVisits = 0;
            Integer counterObj = (Integer) getServletContext().getAttribute("visitorCounter");
            if (counterObj != null) {
                totalVisits = counterObj;
            }

            // Cách 3: Lấy từ database nếu cần lưu trữ lâu dài
            // int totalVisitsFromDB = visitorDAO.getTotalVisits();
            // ==============================================================
            // Set các thuộc tính cho request
            request.setAttribute("totalVisits", totalVisits);
            request.setAttribute("onlineUsers", onlineUsers);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);

            request.setAttribute("recentUsers", recentUsers);
            request.setAttribute("recentOrders", recentOrders);
            request.setAttribute("recentCourses", recentCourses);
            request.setAttribute("recentPayments", recentPayments);

            request.setAttribute("popularCourses", popularCourses);
            request.setAttribute("recentBlogs", recentBlogs);

            // Forward tới trang admin dashboard
            request.getRequestDispatcher("Admin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Chuyển hướng đến trang lỗi
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải thống kê");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Gọi luôn doGet để xử lý
    }
}
