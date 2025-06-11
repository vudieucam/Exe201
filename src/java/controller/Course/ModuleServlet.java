package controller.Course;

import dal.CourseCategoryDAO;
import dal.CourseDAO;
import dal.CourseLessonDAO;
import dal.CourseModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Course;
import model.CourseModule;

@WebServlet("/moduleadmin")
public class ModuleServlet extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        try {
            if (action == null) {
                // show all modules or redirect to courseadmin
                response.sendRedirect(request.getContextPath() + "/courseadmin");
            } else {
                switch (action) {
                    case "edit":
                        showEditForm(request, response);
                        break;
                    case "delete":
                        deleteModule(request, response);
                        break;
                    case "toggleStatus":
                        toggleModuleStatus(request, response);
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/courseadmin");
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    addModule(request, response);
                    break;
                case "update":
                    updateModule(request, response);
                    break;
                case "reorder":
                    reorderLessons(request, response); // xử lý reorder
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/courseadmin");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int moduleId = Integer.parseInt(request.getParameter("id"));
            CourseModule module = courseModuleDAO.getModuleById(moduleId);

            if (module == null) {
                throw new ServletException("Module không tồn tại");
            }

            // Lấy lại courseId để load đúng course và modules
            int courseId = module.getCourseId();
            Course course = courseDAO.getCourseById(courseId);
            List<CourseModule> modules = courseDAO.getCourseModules(courseId);

            request.setAttribute("currentCourse", course);
            request.setAttribute("modules", modules);
            request.setAttribute("moduleToEdit", module); // dùng để mở modal chỉnh sửa trong JSP
            request.setAttribute("courses", courseDAO.getAllCourses());
            request.setAttribute("categories", courseCategoryDAO.getAllCategories());

            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void addModule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title").trim();
            String description = request.getParameter("description") != null
                    ? request.getParameter("description").trim() : "";

            // Validate input
            if (title.isEmpty()) {
                request.getSession().setAttribute("error", "Tên module không được để trống");
                response.sendRedirect(request.getContextPath() + "/courseadmin?id=" + courseId);
                return;
            }

            CourseModule module = new CourseModule();
            module.setCourseId(courseId);
            module.setTitle(title);
            module.setDescription(description);
            module.setStatus(true);
            module.setOrderIndex(courseModuleDAO.getNextModuleOrder(courseId));

            boolean success = courseModuleDAO.addModule(module);

            if (success) {
                request.getSession().setAttribute("success", "Thêm module thành công");
            } else {
                request.getSession().setAttribute("error", "Thêm module thất bại");
            }
            response.sendRedirect(request.getContextPath() + "/courseadmin?id=" + courseId);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        } catch (Exception e) {
            logError("Lỗi khi thêm module", e);
            request.getSession().setAttribute("error", "Lỗi hệ thống khi thêm module");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

// Thêm phương thức xử lý sắp xếp lesson
    private void reorderLessons(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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

    private void updateModule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");

            CourseModule module = courseModuleDAO.getModuleById(moduleId);
            if (module != null) {
                module.setTitle(title);
                module.setDescription(description);
                courseModuleDAO.updateModule(module);

                int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
                response.sendRedirect(request.getContextPath() + "/courseadmin?id=" + courseId);
            } else {
                response.sendRedirect(request.getContextPath() + "/courseadmin");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void deleteModule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int moduleId = Integer.parseInt(request.getParameter("id"));
            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
            courseModuleDAO.deleteModule(moduleId);
            response.sendRedirect(request.getContextPath() + "/courseadmin?id=" + courseId);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void toggleModuleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int moduleId = Integer.parseInt(request.getParameter("id"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            CourseModule module = courseModuleDAO.getModuleById(moduleId);
            if (module != null) {
                boolean newStatus = !module.isStatus();
                courseModuleDAO.toggleModuleStatus(moduleId, newStatus);
            }

            response.sendRedirect(request.getContextPath() + "/courseadmin?id=" + courseId);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void logError(String message, Exception e) {
        System.err.println("[CourseAdminServlet] " + message);
        e.printStackTrace();
    }

}
