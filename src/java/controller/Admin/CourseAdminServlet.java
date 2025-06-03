package controller.Admin;

import dal.CourseCategoryDAO;
import dal.CourseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import model.Course;
import model.CourseCategory;
import dal.CourseModuleDAO;
import model.CourseModule;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class CourseAdminServlet extends HttpServlet {

    private CourseDAO courseDAO;

    private CourseCategoryDAO courseCategoryDAO;

    private CourseModuleDAO courseModuleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        courseCategoryDAO = new CourseCategoryDAO(); // Thêm dòng này
        courseModuleDAO = new CourseModuleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if (action == null || action.equals("list")) {
                listCourses(request, response);
            } else {
                switch (action) {
                    case "search":
                        searchCourses(request, response);
                        break;
                    case "toggleStatus":
                        toggleCourseStatus(request, response);
                        break;
                    case "getModules": // Xử lý AJAX request cho modules
                        getCourseModules(request, response);
                        break;
                    default:
                        listCourses(request, response);
                }
            }
        } catch (Exception e) {

            // Xử lý response phù hợp cho AJAX request
            if ("getModules".equals(request.getParameter("action"))) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error: " + e.getMessage());
            } else {
                request.setAttribute("error", "Lỗi khi xử lý: " + e.getMessage());
                request.getRequestDispatcher("/courseAdmin.jsp").forward(request, response);
            }
        }
    }

    private void getCourseModules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            List<CourseModule> modules = courseModuleDAO.getCourseModules(courseId);
            Course course = courseDAO.getCourseDetail(courseId);

            // Thêm các thuộc tính vào request
            request.setAttribute("currentCourse", course);
            request.setAttribute("modules", modules);

            // Gửi lại toàn bộ trang với phần modules được hiển thị
            listCourses(request, response);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error loading modules: " + e.getMessage());
        }
    }

    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Course> courses = courseDAO.getAllCourses();
            List<CourseCategory> categories = courseCategoryDAO.getAllCategories();

            request.setAttribute("courses", courses);
            request.setAttribute("categories", categories);

            // Giữ nguyên currentCourse và modules nếu đã được set trước đó
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        }
    }

    private void searchCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Course> courses = courseDAO.searchCourses(keyword);
        List<CourseCategory> categories = courseCategoryDAO.getAllCategories();

        request.setAttribute("courses", courses);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
    }

    private void toggleCourseStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseDetail(id);
        if (course != null) {
            int newStatus = course.getStatus() == 1 ? 0 : 1;
            courseDAO.updateCourseStatus(id, true);
        }
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=list");
    }

}
