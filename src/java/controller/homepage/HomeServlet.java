/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.homepage;

import dal.CustomerCourseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Course;
import model.CourseCategory;
import model.User;

/**
 *
 * @author FPT
 */
public class HomeServlet extends HttpServlet {

    private CustomerCourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CustomerCourseDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // CHỈ redirect nếu là admin/staff, còn lại cho phép truy cập
        if (currentUser != null) {
            if (currentUser.getRoleId() == 2 || currentUser.getRoleId() == 3) {
                response.sendRedirect("admin");
                return;
            }
        }

        try {
            // Lấy danh sách tất cả danh mục khóa học
            List<CourseCategory> courseCategories = courseDAO.getAllCategories();
            request.setAttribute("courseCategories", courseCategories);

            // Lấy danh sách khóa học nổi bật (giới hạn 3 khóa)
            List<Course> featuredCourses = courseDAO.getFeaturedCourses(3);
            request.setAttribute("featuredCourses", featuredCourses);

            // Forward đến trang JSP
            request.getRequestDispatcher("/Home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading home page: " + e.getMessage());
            return;
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu trang chủ");
            //request.getRequestDispatcher("/Home.jsp").forward(request, response);

        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
