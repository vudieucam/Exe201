package controller.Admin;

import dal.CourseCategoryDAO;
import dal.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import model.CourseCategory;

import java.io.IOException;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class CourseAdminServlet extends HttpServlet {

    private CourseDAO courseDAO;
    private CourseCategoryDAO courseCategoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        courseCategoryDAO = new CourseCategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listCourses(request, response);
                    break;
                case "deleteCourse":
                    deleteCourse(request, response);
                    return;
                case "toggleCourseStatus":
                    toggleCourseStatus(request, response);
                    return;
                default:
                    listCourses(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            listCourses(request, response);
        }

        request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "add":
                    // TODO: xử lý thêm khóa học
                    response.sendRedirect("courseadmin?action=list");
                    return;
                case "edit":
                    // TODO: xử lý cập nhật khóa học
                    response.sendRedirect("courseadmin?action=list");
                    return;
                default:
                    doGet(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi xử lý POST: " + e.getMessage());
            listCourses(request, response);
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        }
    }

    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy tham số lọc từ request
            String search = request.getParameter("search");
            String statusStr = request.getParameter("status");
            String categoryStr = request.getParameter("category");

            // Xử lý tham số lọc
            Boolean status = null;
            if (statusStr != null && !statusStr.isEmpty()) {
                status = "1".equals(statusStr);
            }

            Integer categoryId = null;
            if (categoryStr != null && !categoryStr.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryStr);
                } catch (NumberFormatException e) {
                    categoryId = null;
                }
            }

            // Nếu không có lọc, hiển thị toàn bộ
            List<Course> courses;
            if ((search == null || search.trim().isEmpty()) && status == null && categoryId == null) {
                courses = courseDAO.getAllCourses();
            } else {
                courses = courseDAO.searchCourses(search, status, categoryId);
            }

            // Danh mục
            List<CourseCategory> categories = courseCategoryDAO.getAllCategories();

            // Gửi về JSP
            request.setAttribute("courses", courses);
            request.setAttribute("categories", categories);
            request.setAttribute("search", search);
            request.setAttribute("status", statusStr);
            request.setAttribute("category", categoryStr);

        } catch (Exception e) {
            throw new ServletException("Không thể tải danh sách khóa học", e);
        }
    }

    private void deleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = courseDAO.deleteCourse(id);

        if (success) {
            request.getSession().setAttribute("success", "Xóa khóa học thành công");
        } else {
            request.getSession().setAttribute("error", "Xóa khóa học thất bại");
        }

        response.sendRedirect("courseadmin");
    }

    private void toggleCourseStatus(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseDetail(id);

        if (course != null) {
            int newStatus = course.getStatus() == 1 ? 0 : 1;
            courseDAO.updateCourseStatus(id, newStatus == 1);
            String msg = newStatus == 1 ? "Kích hoạt khóa học" : "Ẩn khóa học";
            request.getSession().setAttribute("success", msg + " thành công");
        } else {
            request.getSession().setAttribute("error", "Không tìm thấy khóa học");
        }

        response.sendRedirect("courseadmin");
    }
}
