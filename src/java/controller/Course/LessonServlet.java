package controller.Course;

import dal.CourseDAO;
import dal.CourseLessonDAO;
import dal.CourseModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CourseLesson;

import java.io.IOException;
import java.util.Date;

@WebServlet("/lessonadmin")
public class LessonServlet extends HttpServlet {

    private CourseDAO courseDAO;
    private CourseModuleDAO courseModuleDAO;
    private CourseLessonDAO courseLessonDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        courseModuleDAO = new CourseModuleDAO();
        courseLessonDAO = new CourseLessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if (action == null) {
                resp.sendRedirect(req.getContextPath() + "/courseadmin");
            } else if (action.equals("delete")) {
                deleteLesson(req, resp);
            } else if (action.equals("toggleStatus")) {
                toggleLessonStatus(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/courseadmin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "add":
                    addLesson(req, resp);
                    break;
                case "update":
                    updateLesson(req, resp);
                    break;
                case "reorder":
                    reorderLessons(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/courseadmin");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/courseadmin");
        }
    }

    // Cải thiện phương thức addLesson
    private void addLesson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title").trim();
            String content = request.getParameter("content").trim();
            String videoUrl = request.getParameter("videoUrl").trim();
            int duration = 0;

            try {
                duration = Integer.parseInt(request.getParameter("duration"));
            } catch (NumberFormatException e) {
                // Giữ giá trị mặc định là 0 nếu duration không hợp lệ
            }

            // Validate input
            if (title.isEmpty()) {
                request.getSession().setAttribute("error", "Tên lesson không được để trống");
                response.sendRedirect(request.getContextPath() + "/courseadmin?id="
                        + courseModuleDAO.getCourseIdByModuleId(moduleId));
                return;
            }

            CourseLesson lesson = new CourseLesson();
            lesson.setModuleId(moduleId);
            lesson.setTitle(title);
            lesson.setContent(content);
            lesson.setVideoUrl(videoUrl.isEmpty() ? null : videoUrl);
            lesson.setDuration(duration);
            lesson.setStatus(true);
            lesson.setOrderIndex(courseLessonDAO.getLessonsByModuleId(moduleId).size() + 1);
            lesson.setCreatedAt(new Date());
            lesson.setUpdatedAt(new Date());

            boolean success = courseLessonDAO.addLesson(lesson);

            if (success) {
                request.getSession().setAttribute("success", "Thêm lesson thành công");
            } else {
                request.getSession().setAttribute("error", "Thêm lesson thất bại");
            }

            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
            response.sendRedirect(request.getContextPath() + "/courseadmin?id=" + courseId);
        } catch (Exception e) {
            logError("Lỗi khi thêm lesson", e);
            request.getSession().setAttribute("error", "Lỗi hệ thống khi thêm lesson");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }
// Thêm phương thức xử lý sắp xếp lesson

    private void reorderLessons(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String[] lessonIds = request.getParameterValues("lessonOrder");
            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);

            if (lessonIds != null) {
                for (int i = 0; i < lessonIds.length; i++) {
                    int lessonId = Integer.parseInt(lessonIds[i]);
                    courseLessonDAO.updateLessonOrder(lessonId, i + 1);
                }
                request.getSession().setAttribute("success", "Sắp xếp lessons thành công");
            }
            response.sendRedirect(request.getContextPath() + "/courseadmin?id=" + courseId);
        } catch (Exception e) {
            logError("Lỗi khi sắp xếp lessons", e);
            request.getSession().setAttribute("error", "Lỗi khi sắp xếp lessons");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void updateLesson(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int lessonId = Integer.parseInt(req.getParameter("lessonId"));
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            String videoUrl = req.getParameter("videoUrl");
            int duration = Integer.parseInt(req.getParameter("duration"));

            CourseLesson lesson = courseLessonDAO.getLessonById(lessonId);
            if (lesson != null) {
                lesson.setTitle(title);
                lesson.setContent(content);
                lesson.setVideoUrl(videoUrl);
                lesson.setDuration(duration);
                lesson.setUpdatedAt(new Date());
                courseLessonDAO.updateLesson(lesson);

                int courseId = courseModuleDAO.getCourseIdByModuleId(lesson.getModuleId());
                resp.sendRedirect(req.getContextPath() + "/courseadmin?id=" + courseId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/courseadmin");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/courseadmin");
        }
    }

    private void deleteLesson(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int lessonId = Integer.parseInt(req.getParameter("id"));
            int moduleId = courseLessonDAO.getModuleIdByLessonId(lessonId);
            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
            courseLessonDAO.deleteLesson(lessonId);
            resp.sendRedirect(req.getContextPath() + "/courseadmin?id=" + courseId);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/courseadmin");
        }
    }

    private void toggleLessonStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int lessonId = Integer.parseInt(req.getParameter("id"));
            int moduleId = Integer.parseInt(req.getParameter("moduleId"));

            CourseLesson lesson = courseLessonDAO.getLessonById(lessonId);
            if (lesson != null) {
                lesson.setStatus(!lesson.isStatus());
                courseLessonDAO.updateLesson(lesson);

                int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
                resp.sendRedirect(req.getContextPath() + "/courseadmin?id=" + courseId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/courseadmin");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/courseadmin");
        }
    }

    private void logError(String lỗi_khi_thêm_lesson, Exception e) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
