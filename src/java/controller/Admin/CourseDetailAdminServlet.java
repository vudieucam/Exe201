package controller.Admin;

import dal.CourseDAO;
import dal.CourseLessonDAO;
import dal.CourseModuleDAO;
import dal.CourseCategoryDAO; // Thêm DAO mới
import dal.CourseDAO; // Đã có nhưng cần cho tính năng mới
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import model.CourseLesson;
import model.CourseModule;
import model.CourseCategory; // Thêm model mới

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CourseDetailAdminServlet", urlPatterns = {"/coursedetailadmin"})
public class CourseDetailAdminServlet extends HttpServlet {

    private CourseDAO courseDAO = new CourseDAO();
    private CourseModuleDAO moduleDAO = new CourseModuleDAO();
    private CourseLessonDAO lessonDAO = new CourseLessonDAO();
    private CourseCategoryDAO categoryDAO = new CourseCategoryDAO(); // Khởi tạo DAO mới

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy danh sách danh mục và khóa học nổi bật
            List<CourseCategory> courseCategories = categoryDAO.getAllCategories();
            req.setAttribute("courseCategories", courseCategories);

            String rawId = req.getParameter("courseId");

            if (rawId == null || rawId.isEmpty()) {
                rawId = req.getParameter("id");
            }

            if (rawId == null || rawId.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Thiếu ID khóa học.");
                res.sendRedirect("courseadmin");
                return;
            }

            int courseId;
            try {
                courseId = Integer.parseInt(rawId.trim());
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("error", "ID khóa học không hợp lệ.");
                res.sendRedirect("courseadmin");
                return;
            }

            Course course = courseDAO.getCourseDetail(courseId);
            if (course == null) {
                req.getSession().setAttribute("error", "Không tìm thấy khóa học với ID: " + courseId);
                res.sendRedirect("courseadmin");
                return;
            }

            // Xử lý bài học
            String lessonIdRaw = req.getParameter("lesson");
            int lessonId = (lessonIdRaw != null && !lessonIdRaw.isEmpty()) ? Integer.parseInt(lessonIdRaw) : 0;

            List<CourseModule> modules = moduleDAO.getCourseModules(courseId);
            Map<Integer, List<CourseLesson>> lessonsByModule = new HashMap<>();
            CourseLesson currentLesson = null;
            List<CourseLesson> allLessons = new ArrayList<>();

            for (CourseModule module : modules) {
                List<CourseLesson> lessons = lessonDAO.getLessonsByModuleId(module.getId());
                lessonsByModule.put(module.getId(), lessons != null ? lessons : new ArrayList<>());
                allLessons.addAll(lessons);

                // Chọn bài học đầu tiên nếu không có lessonId được chỉ định
                if (lessonId == 0 && currentLesson == null && !lessons.isEmpty()) {
                    currentLesson = lessons.get(0);
                }
            }

            // Nếu chỉ định lessonId
            if (lessonId > 0) {
                currentLesson = lessonDAO.getLessonById(lessonId);
                if (currentLesson != null) {
                    boolean valid = false;
                    for (CourseLesson lesson : allLessons) {
                        if (lesson.getId() == currentLesson.getId()) {
                            valid = true;
                            break;
                        }
                    }
                    if (!valid) {
                        currentLesson = null;
                    }
                }
            }

            // Tìm bài học trước/sau
            int currentIndex = -1;
            if (currentLesson != null) {
                for (int i = 0; i < allLessons.size(); i++) {
                    if (allLessons.get(i).getId() == currentLesson.getId()) {
                        currentIndex = i;
                        break;
                    }
                }
            }

            CourseLesson previousLesson = (currentIndex > 0) ? allLessons.get(currentIndex - 1) : null;
            CourseLesson nextLesson = (currentIndex >= 0 && currentIndex < allLessons.size() - 1)
                    ? allLessons.get(currentIndex + 1) : null;

            // Load thông báo
            Object success = req.getSession().getAttribute("success");
            Object error = req.getSession().getAttribute("error");
            if (success != null) {
                req.setAttribute("success", success.toString());
                req.getSession().removeAttribute("success");
            }
            if (error != null) {
                req.setAttribute("error", error.toString());
                req.getSession().removeAttribute("error");
            }

            // Đặt các thuộc tính vào request
            req.setAttribute("course", course);
            req.setAttribute("modules", modules);
            req.setAttribute("lessonsByModule", lessonsByModule);
            req.setAttribute("currentLesson", currentLesson);
            req.setAttribute("previousLesson", previousLesson);
            req.setAttribute("nextLesson", nextLesson);

            req.getRequestDispatcher("courseDetailAdmin.jsp").forward(req, res);

        } catch (Exception ex) {
            Logger.getLogger(CourseDetailAdminServlet.class.getName()).log(Level.SEVERE, null, ex);
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            res.sendRedirect("courseadmin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST không được hỗ trợ.");
    }
}
