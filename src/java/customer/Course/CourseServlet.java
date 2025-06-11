/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package customer.Course;

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
import model.Course;
import model.CourseCategory;

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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID");
            return;
        }

        try {
            Course course = courseDAO.getCourseById(Integer.parseInt(id));
            if (course == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khóa học không tồn tại");
                return;
            }

            request.setAttribute("course", course);
            request.getRequestDispatcher("/course_detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khóa học không hợp lệ");
        }
    }

    private void handleCourseList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        // Lấy danh sách tất cả danh mục khóa học
        List<CourseCategory> courseCategories = CustomercourseDAO.getAllCategories();
        request.setAttribute("courseCategories", courseCategories);

        // Lấy danh sách khóa học nổi bật
        List<Course> featuredCourses = CustomercourseDAO.getFeaturedCourses(6);
        request.setAttribute("featuredCourses", featuredCourses);

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

        List<Course> courses;
        int totalCourses;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            courses = CustomercourseDAO.searchCourses(searchQuery.trim());
            totalCourses = CustomercourseDAO.getTotalSearchCourses(searchQuery.trim());
        } else {
            courses = CustomercourseDAO.getCoursesByPage(currentPage, recordsPerPage);
            totalCourses = CustomercourseDAO.getTotalCourses();
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
        response.setContentType("text/html;charset=UTF-8");
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
