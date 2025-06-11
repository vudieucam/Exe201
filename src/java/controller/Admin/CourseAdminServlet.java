package controller.Admin;

import dal.CourseCategoryDAO;
import dal.CourseDAO;
import dal.CourseLessonDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Course;
import model.CourseCategory;
import dal.CourseModuleDAO;
import java.util.HashMap;
import java.util.Map;
import model.CourseLesson;
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
    private CourseLessonDAO courseLessonDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        courseCategoryDAO = new CourseCategoryDAO();
        courseModuleDAO = new CourseModuleDAO();
        courseLessonDAO = new CourseLessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        // Đặt hành động mặc định là "list" nếu không có hoặc rỗng
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        request.setAttribute("currentAction", action); // Truyền hành động hiện tại đến JSP

        try {
            switch (action) {
                case "list":
                    listCourses(request, response); // Gọi phương thức xử lý danh sách khóa học
                    break;
                case "detail":
                    viewCourseDetails(request, response); // Gọi phương thức xử lý xem chi tiết khóa học
                    break;
                // Các case khác cho các chức năng 'add', 'edit', 'delete' form, v.v.
                // Nếu các chức năng này cũng sử dụng cùng một JSP, hãy đảm bảo chúng
                // cũng thiết lập 'currentAction' và các thuộc tính cần thiết.
                case "deleteCourse": // Action này có thể gọi từ doGet hoặc doPost tùy cách bạn thiết kế link/form
                    deleteCourse(request, response);
                    return; // Quan trọng: return sau khi redirect
                case "toggleCourseStatus":
                    toggleCourseStatus(request, response);
                    return; // Quan trọng: return sau khi redirect
                case "deleteLesson":
                    deleteLesson(request, response);
                    return; // Quan trọng: return sau khi redirect
                // Các case khác nếu có
                default:
                    listCourses(request, response); // Mặc định hiển thị danh sách nếu hành động không xác định
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console để debug
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            // Luôn fallback về trang danh sách khi có lỗi
            request.setAttribute("currentAction", "list");
            try {
                request.setAttribute("courses", courseDAO.getAllCourses());
                request.setAttribute("categories", courseCategoryDAO.getAllCategories());
            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tải lại danh sách khóa học: " + ex.getMessage());
            }
        }

        // Luôn forward đến cùng một file CourseAdmin.jsp
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
            action = "list"; // Mặc định nếu không có hành động POST cụ thể
        }

        try {
            switch (action) {
                case "add":
                    // Logic xử lý thêm khóa học mới
                    // Sau khi thêm, redirect để tránh gửi lại form
                    response.sendRedirect("CourseAdminServlet?action=list");
                    return;
                case "edit":
                    // Logic xử lý cập nhật khóa học
                    // Sau khi sửa, redirect
                    response.sendRedirect("CourseAdminServlet?action=list");
                    return;
                case "reorderModules":
                    reorderModules(request, response);
                    return;
                // Các case khác cho các hành động POST (ví dụ: upload file, v.v.)
                default:
                    // Nếu không phải hành động POST cụ thể, có thể chuyển về doGet để hiển thị danh sách
                    doGet(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi trong quá trình xử lý POST: " + e.getMessage());
            request.setAttribute("currentAction", "list"); // Fallback về danh sách
            try {
                request.setAttribute("courses", courseDAO.getAllCourses());
                request.setAttribute("categories", courseCategoryDAO.getAllCategories());
            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tải lại danh sách khóa học sau POST: " + ex.getMessage());
            }
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        }
    }

    // Phương thức chỉ để lấy danh sách các khóa học và danh mục
    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            List<Course> courses = courseDAO.getAllCourses();
            List<CourseCategory> categories = courseCategoryDAO.getAllCategories(); // Giả sử hàm này tồn tại
            request.setAttribute("courses", courses);
            request.setAttribute("categories", categories);
        } catch (Exception e) {
            // Log lỗi và re-throw để được xử lý bởi khối try-catch lớn hơn trong doGet/doPost
            throw new ServletException("Error loading courses for list view", e);
        }
    }

    // **** PHƯƠNG THỨC MỚI ĐỂ XỬ LÝ XEM CHI TIẾT KHÓA HỌC ****
    private void viewCourseDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int courseId = 0;
        try {
            courseId = Integer.parseInt(request.getParameter("courseId")); // Lấy ID khóa học từ request
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID khóa học không hợp lệ.");
            request.setAttribute("currentAction", "list"); // Chuyển về chế độ danh sách
            listCourses(request, response); // Tải dữ liệu cho danh sách
            return;
        }

        try {
            // Lấy thông tin chi tiết của khóa học
            Course course = courseDAO.getCourseDetail(courseId); // Sử dụng getCourseDetail theo code của bạn

            if (course == null) {
                request.setAttribute("errorMessage", "Không tìm thấy khóa học với ID: " + courseId);
                request.setAttribute("currentAction", "list"); // Chuyển về chế độ danh sách
                listCourses(request, response); // Tải dữ liệu cho danh sách
                return;
            }

            // Lấy danh sách modules của khóa học
            List<CourseModule> modules = courseModuleDAO.getCourseModules(courseId); // Sử dụng getCourseModules theo code của bạn

            // Lấy danh sách lessons cho từng module và lưu vào Map
            Map<Integer, List<CourseLesson>> lessonsByModule = new HashMap<>();
            for (CourseModule module : modules) {
                // Giả sử CourseModule có phương thức getId() để lấy ID module
                List<CourseLesson> lessons = courseLessonDAO.getLessonsByModuleId(module.getId());
                lessonsByModule.put(module.getId(), lessons);
            }

            // Đặt các thuộc tính vào request để JSP có thể truy cập
            request.setAttribute("course", course);
            request.setAttribute("modules", modules);
            request.setAttribute("lessonsByModule", lessonsByModule);

        } catch (Exception e) {
            // Log lỗi chi tiết và truyền thông báo lỗi về JSP
            throw new ServletException("Lỗi khi tải chi tiết khóa học cho ID: " + courseId, e);
        }
    }

    // Các phương thức private khác (reorderModules, deleteCourse, toggleCourseStatus, deleteLesson, logError)
    // Các phương thức này vẫn giữ nguyên như bạn đã cung cấp, hoặc được chỉnh sửa nhẹ
    // để phù hợp với việc truyền action từ doGet/doPost.
    // Thêm phương thức xử lý sắp xếp module
    private void reorderModules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String[] moduleIds = request.getParameterValues("moduleOrder");

            if (moduleIds != null) {
                for (int i = 0; i < moduleIds.length; i++) {
                    int moduleId = Integer.parseInt(moduleIds[i]);
                    courseModuleDAO.updateModuleOrder(moduleId, i + 1);
                }
                request.getSession().setAttribute("success", "Sắp xếp modules thành công");
            }
            response.sendRedirect("courseadmin?id=" + courseId);
        } catch (Exception e) {
            logError("Lỗi khi sắp xếp modules", e);
            request.getSession().setAttribute("error", "Lỗi khi sắp xếp modules");
            response.sendRedirect("courseadmin");
        }
    }

    private void deleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseDetail(id);

        if (course != null) {
            int newStatus = course.getStatus() == 1 ? 0 : 1;
            courseDAO.updateCourseStatus(id, newStatus == 1);

            String statusMessage = newStatus == 1 ? "Kích hoạt khóa học thành công" : "Ẩn khóa học thành công";
            request.getSession().setAttribute("success", statusMessage);
        } else {
            request.getSession().setAttribute("error", "Không tìm thấy khóa học");
        }

        response.sendRedirect("courseadmin");
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int lessonId = Integer.parseInt(request.getParameter("id"));
        boolean success = courseLessonDAO.deleteLesson(lessonId);

        if (success) {
            request.getSession().setAttribute("success", "Xóa bài học thành công");
        } else {
            request.getSession().setAttribute("error", "Xóa bài học thất bại");
        }

        // Quay lại trang trước đó
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer);
    }

    private void logError(String message, Exception e) {
        
        System.err.println("[CourseAdminServlet] " + message);
        e.printStackTrace();
    }

}
