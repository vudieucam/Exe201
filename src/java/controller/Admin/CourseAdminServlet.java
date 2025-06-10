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
import java.sql.SQLException;
import java.util.List;
import model.Course;
import model.CourseCategory;
import dal.CourseModuleDAO;
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
        courseCategoryDAO = new CourseCategoryDAO(); // Thêm dòng này
        courseModuleDAO = new CourseModuleDAO();
        courseLessonDAO = new CourseLessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        System.out.println("=== DEBUG: doGet called with action = " + action + " ===");

        try {
            if (action == null) {
                listCourses(request, response);
            } else {
                switch (action) {
                    case "delete":
                        deleteCourse(request, response);
                        break;
                    case "toggleStatus":
                        toggleCourseStatus(request, response);
                        break;
                    case "deleteLesson":
                        deleteLesson(request, response);
                        break;
                    default:
                        listCourses(request, response);
                        break;
                }
            }
        } catch (Exception ex) {
            System.err.println("=== CRITICAL ERROR IN doGet ===");
            ex.printStackTrace();
            // Send error to client
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "An error occurred: " + ex.getMessage());
        }
    }

    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== START listCourses DEBUG ===");

        try {
            // 1. Load toàn bộ danh sách khóa học và danh mục
            List<Course> courses = courseDAO.getAllCourses();
            List<CourseCategory> categories = courseCategoryDAO.getAllCategories();

            request.setAttribute("courses", courses);
            request.setAttribute("categories", categories);

            System.out.println("Total courses: " + courses.size());
            System.out.println("Total categories: " + categories.size());

            // 2. Lấy courseId từ URL nếu có
            String courseIdParam = request.getParameter("id");
            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                try {
                    int courseId = Integer.parseInt(courseIdParam);
                    System.out.println("Parsed courseId: " + courseId);

                    // 3. Lấy thông tin khóa học
                    Course currentCourse = courseDAO.getCourseDetail(courseId);
                    if (currentCourse == null) {
                        request.setAttribute("error", "Không tìm thấy khóa học với ID: " + courseId);
                        System.out.println("ERROR: Course not found.");
                    } else {
                        request.setAttribute("currentCourse", currentCourse);
                        System.out.println("Loaded course: " + currentCourse.getTitle());

                        // 4. Lấy danh sách module + lesson tương ứng
                        List<CourseModule> modules = courseModuleDAO.getCourseModules(courseId);
                        System.out.println("Total modules found: " + modules.size());

                        // DEBUG từng module và bài học bên trong
                        for (CourseModule module : modules) {
                            System.out.println(" - Module: " + module.getTitle() + " (ID: " + module.getId() + ")");
                            List<CourseLesson> lessons = module.getLessons();
                            if (lessons != null) {
                                System.out.println("   Lessons: " + lessons.size());
                                for (CourseLesson lesson : lessons) {
                                    System.out.println("     • " + lesson.getTitle());
                                }
                            } else {
                                System.out.println("   No lessons.");
                            }
                        }

                        request.setAttribute("modules", modules);
                    }

                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID khóa học không hợp lệ: " + courseIdParam);
                    System.out.println("ERROR: Invalid course ID format");
                } catch (Exception e) {
                    request.setAttribute("error", "Lỗi khi tải khóa học: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("No course ID selected.");
            }

            // 5. Forward đến JSP
            request.getRequestDispatcher("/courseAdmin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống khi tải danh sách khóa học.");
            request.getRequestDispatcher("/courseAdmin.jsp").forward(request, response);
        }

        System.out.println("=== END listCourses DEBUG ===");
    }

// Thêm phương thức xử lý sắp xếp module
    private void reorderModules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

            String statusMessage = newStatus == 1 ? "Kích hoạt khóa học thành công" : "Ẩn khóa học thành công";
            request.getSession().setAttribute("success", statusMessage);
        } else {
            request.getSession().setAttribute("error", "Không tìm thấy khóa học");
        }

        response.sendRedirect("courseadmin");
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
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

    private void logError(String lỗi_khi_sắp_xếp_modules, Exception e) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
