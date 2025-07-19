/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package customer.Course;

import dal.BlogDAO;
import dal.CourseDAO;
import dal.CustomerCourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BlogCategory;
import model.Course;
import model.CourseCategory;
import model.User;

/**
 *
 * @author FPT
 */
public class CourseServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private CustomerCourseDAO CustomercourseDAO = new CustomerCourseDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            String action = request.getParameter("action");

            // Xử lý yêu cầu xem chi tiết khóa học
            if ("detail".equals(action)) {
                handleCourseDetail(request, response);
                return;
            }

            // Xử lý yêu cầu danh sách khóa học
            handleCourseList(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi hệ thống khi xử lý yêu cầu");
        }
    }

    private void handleCourseDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID");
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);

            /* ======= CHỈNH Ở ĐÂY ======= */
            Course course = courseDAO.getCourseWithStatsById(id);   // <‑‑ dòng bạn hỏi
            /* ======= HẾT CHỈNH ======= */

            if (course == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khóa học không tồn tại");
                return;
            }

            request.setAttribute("course", course);
            request.getRequestDispatcher("/course_detail.jsp").forward(request, response);

        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khóa học không hợp lệ");
        }
    }

    private void handleCourseList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        // Lấy danh sách tất cả danh mục khóa học
        List<CourseCategory> courseCategories = CustomercourseDAO.getAllCategories();
        request.setAttribute("courseCategories", courseCategories);

        // Lấy danh sách khóa học nổi bật
        List<Course> featuredCourses = CustomercourseDAO.getFeaturedCourses(6);
        request.setAttribute("featuredCourses", featuredCourses);

// Dữ liệu bổ sung
        List<BlogCategory> featuredCategories = blogDAO.getFeaturedCategories();

// Gửi sang JSP
        request.setAttribute("featuredCategories", featuredCategories);
        // Xử lý phân trang và tìm kiếm
        String searchQuery = request.getParameter("search");
        int currentPage = 1;
        int recordsPerPage = 9;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            // Giữ giá trị mặc định nếu page không hợp lệ
        }

        String categoryIdRaw = request.getParameter("categoryId");

        // Sửa lại phần lấy danh sách khóa học
        List<Course> courses;
        int totalCourses;

        if (categoryIdRaw != null && !categoryIdRaw.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdRaw);
            courses = courseDAO.getCoursesByCategory(categoryId);
            totalCourses = courses.size();
            request.setAttribute("selectedCategoryId", categoryId);
        } else if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            courses = CustomercourseDAO.searchCourses(searchQuery.trim());
            totalCourses = CustomercourseDAO.getTotalSearchCourses(searchQuery.trim());
        } else {
            // Luôn lấy tất cả khóa học active, không phụ thuộc vào đăng nhập
            courses = CustomercourseDAO.getCoursesByPage(currentPage, recordsPerPage);
            totalCourses = CustomercourseDAO.getTotalCourses();
        }
        // Sau khi lấy danh sách courses
        if (request.getSession().getAttribute("user") != null) {
            User user = (User) request.getSession().getAttribute("user");
            for (Course course : courses) {
                int userCourseStatus = CustomercourseDAO.getCourseStatusForUser(user.getId(), course.getId());
                course.setStatus(userCourseStatus);
            }
        }
        int totalPages = (int) Math.ceil((double) totalCourses / recordsPerPage);

        request.setAttribute("courses", courses);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", searchQuery);

        request.getRequestDispatcher("/course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");

            if ("activate".equals(action)) {
                handleActivateCourse(request, response); // ✅ Dùng lại
                return;
            }

            processRequest(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống khi xử lý.");
            request.getRequestDispatcher("course.jsp").forward(request, response);
        }
    }

    private void handleActivateCourse(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, Exception {
        try {
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect("authen?action=login");
                return;
            }

            int courseId = Integer.parseInt(req.getParameter("courseId"));
            boolean success = CustomercourseDAO.activateCourseForUser(user.getId(), courseId);

            if (success) {
                // Chuyển hướng về trang chi tiết khóa học với thông báo thành công
                resp.sendRedirect(req.getContextPath() + "/course?action=detail&id=" + courseId + "&activated=true");
            } else {
                req.setAttribute("error", "Kích hoạt khóa học thất bại");
                handleCourseList(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            handleCourseList(req, resp);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
