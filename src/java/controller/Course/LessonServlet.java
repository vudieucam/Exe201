package controller.Course;

import dal.CourseDAO;
import dal.CourseLessonDAO;
import dal.CourseModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.CourseLesson;

import java.io.IOException;
import java.util.Date;

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
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String action = req.getParameter("action");

        try {
            if (action == null) {
                resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
            } else if (action.equals("delete")) {
                deleteLesson(req, resp);
            } else if (action.equals("toggleStatus")) {
                toggleLessonStatus(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
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
                    resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
        }
    }

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
            } catch (NumberFormatException ignored) {
            }

            if (title.isEmpty()) {
                request.getSession().setAttribute("error", "Tên lesson không được để trống");
                response.sendRedirect(request.getContextPath() + "/coursedetailadmin?id=" + courseModuleDAO.getCourseIdByModuleId(moduleId));
                return;
            }

            CourseLesson lesson = new CourseLesson();
            lesson.setModuleId(moduleId);
            lesson.setTitle(title);
            lesson.setContent(content);
            lesson.setVideoUrl(videoUrl.isEmpty() ? null : videoUrl);
            lesson.setDuration(duration);
            lesson.setStatus(true);
            lesson.setOrderIndex(courseLessonDAO.getLessonsByModuleIdAdmin(moduleId).size() + 1);
            lesson.setCreatedAt(new Date());
            lesson.setUpdatedAt(new Date());

            boolean success = courseLessonDAO.addLesson(lesson);
            request.getSession().setAttribute(success ? "success" : "error",
                    success ? "Thêm lesson thành công" : "Thêm lesson thất bại");

            int courseId = courseModuleDAO.getCourseIdByModuleIdAdmin(moduleId);
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin?id=" + courseId);
        } catch (Exception e) {
            logError("Lỗi khi thêm lesson", e);
            request.getSession().setAttribute("error", "Lỗi hệ thống khi thêm lesson");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
        }
    }

    private void reorderLessons(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
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
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin?id=" + courseId);
        } catch (Exception e) {
            logError("Lỗi khi sắp xếp lessons", e);
            request.getSession().setAttribute("error", "Lỗi khi sắp xếp lessons");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
        }
    }

    private void updateLesson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int lessonId = Integer.parseInt(req.getParameter("lessonId"));
            String title = req.getParameter("title").trim();
            String content = req.getParameter("content").trim();
            String videoUrl = req.getParameter("videoUrl").trim();
            int duration = 0;
            try {
                duration = Integer.parseInt(req.getParameter("duration"));
            } catch (NumberFormatException ignored) {
            }

            CourseLesson lesson = courseLessonDAO.getLessonById(lessonId);
            if (lesson != null) {
                lesson.setTitle(title);
                lesson.setContent(content);
                lesson.setVideoUrl(videoUrl.isEmpty() ? null : videoUrl);
                lesson.setDuration(duration);
                lesson.setUpdatedAt(new Date());

                boolean updated = courseLessonDAO.updateLesson(lesson);
                int courseId = courseModuleDAO.getCourseIdByModuleIdAdmin(lesson.getModuleId());

                if (updated) {
                    req.getSession().setAttribute("success", "Cập nhật bài học thành công");
                } else {
                    req.getSession().setAttribute("error", "Cập nhật bài học thất bại");
                }

                resp.sendRedirect(req.getContextPath() + "/coursedetailadmin?id=" + courseId);
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy bài học để cập nhật");
                resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
            }
        } catch (Exception e) {
            logError("Lỗi khi cập nhật lesson", e);
            req.getSession().setAttribute("error", "Lỗi hệ thống khi cập nhật bài học");
            resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
        }
    }

    private void deleteLesson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int lessonId = Integer.parseInt(req.getParameter("id"));
            int moduleId = courseLessonDAO.getModuleIdByLessonIdAdmin(lessonId);
            int courseId = courseModuleDAO.getCourseIdByModuleIdAdmin(moduleId);

            boolean deleted = courseLessonDAO.deleteLesson(lessonId); // ✅ nên trả về true/false
            if (deleted) {
                req.getSession().setAttribute("success", "Xóa bài học thành công");
            } else {
                req.getSession().setAttribute("error", "Xóa bài học thất bại");
            }

            resp.sendRedirect(req.getContextPath() + "/coursedetailadmin?id=" + courseId);
        } catch (Exception e) {
            logError("Lỗi khi xóa lesson", e);
            req.getSession().setAttribute("error", "Lỗi hệ thống khi xóa bài học");
            resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
        }
    }

    private void toggleLessonStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int lessonId = Integer.parseInt(req.getParameter("id"));
            int moduleId = Integer.parseInt(req.getParameter("moduleId"));

            CourseLesson lesson = courseLessonDAO.getLessonByIdAdmin(lessonId);
            if (lesson != null) {
                lesson.setStatus(!lesson.isStatus());
                courseLessonDAO.updateLesson(lesson);
                req.getSession().setAttribute("success", lesson.isStatus() ? "Hiển thị bài học thành công" : "Ẩn bài học thành công");
                int courseId = courseModuleDAO.getCourseIdByModuleIdAdmin(moduleId);
                resp.sendRedirect(req.getContextPath() + "/coursedetailadmin?id=" + courseId);
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy bài học để thay đổi trạng thái");
                resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
            }

        } catch (Exception e) {
            logError("Lỗi khi đổi trạng thái lesson", e);
            resp.sendRedirect(req.getContextPath() + "/coursedetailadmin");
        }
    }

    private void logError(String message, Exception e) {
        System.err.println("[LessonServlet] " + message);
        e.printStackTrace();
    }
}
