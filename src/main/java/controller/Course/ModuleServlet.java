package controller.Course;

import dal.CourseCategoryDAO;
import dal.CourseDAO;
import dal.CourseLessonDAO;
import dal.CourseModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import model.Course;
import model.CourseModule;

public class ModuleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourseDetailAdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseDetailAdminServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
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
                response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
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
                        response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
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
                case "delete":
                    deleteModule(request, response);
                    break;

                case "reorder":
                    reorderLessons(request, response); // xử lý reorder
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int moduleId = Integer.parseInt(request.getParameter("id"));
            CourseModule module = courseModuleDAO.getModuleByIdAdmin(moduleId);

            if (module == null) {
                throw new ServletException("Module không tồn tại");
            }

            // Lấy lại courseId để load đúng course và modules
            int courseId = module.getCourseId();
            Course course = courseDAO.getCourseById(courseId);
            List<CourseModule> modules = courseDAO.getCourseModulesAdmin(courseId);

            request.setAttribute("currentCourse", course);
            request.setAttribute("modules", modules);
            request.setAttribute("moduleToEdit", module); // dùng để mở modal chỉnh sửa trong JSP
            request.setAttribute("courses", courseDAO.getAllCourses());
            request.setAttribute("categories", courseCategoryDAO.getAllCategories());

            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
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
                response.sendRedirect(request.getContextPath() + "/coursedetailadmin?courseId=" + courseId);
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
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin?courseId=" + courseId);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
        } catch (Exception e) {
            logError("Lỗi khi thêm module", e);
            request.getSession().setAttribute("error", "Lỗi hệ thống khi thêm module");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
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
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin?courseId=" + courseId);
        } catch (Exception e) {
            logError("Lỗi khi sắp xếp lessons", e);
            request.getSession().setAttribute("error", "Lỗi khi sắp xếp lessons");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
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

            CourseModule module = courseModuleDAO.getModuleByIdAdmin(moduleId);
            if (module != null) {
                module.setTitle(title);
                module.setDescription(description);
                courseModuleDAO.updateModule(module);

                int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);

                // ✅ THÊM thông báo
                request.getSession().setAttribute("success", "Cập nhật module thành công");

                response.sendRedirect(request.getContextPath() + "/coursedetailadmin?courseId=" + courseId);
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy module");
                response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID module không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
        }
    }

    private void deleteModule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("id"));
            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);

            CourseModule module = courseModuleDAO.getModuleByIdAdmin(moduleId);
            if (module == null) {
                request.getSession().setAttribute("error", "Module không tồn tại");
                response.sendRedirect(request.getContextPath() + "/coursedetailadmin?courseId=" + courseId);
                return;
            }

            // Gọi hàm void
            courseModuleDAO.deleteModuleWithLessons(moduleId);

            request.getSession().setAttribute("success", "Xóa module và các bài học liên quan thành công");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin?courseId=" + courseId);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi xóa module. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
        }
    }

    private void toggleModuleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("id"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            // Kiểm tra module có tồn tại không
            CourseModule module = courseModuleDAO.getModuleByIdAdmin(moduleId);
            if (module == null) {
                request.getSession().setAttribute("error", "Module không tồn tại");
                response.sendRedirect(request.getContextPath() + "/coursedetailadmin?courseId=" + courseId);
                return;
            }

            boolean newStatus = !module.isStatus();
            boolean success = courseModuleDAO.toggleModuleStatus(moduleId, newStatus);

            if (success) {
                String statusMsg = newStatus ? "hiển thị" : "ẩn";
                request.getSession().setAttribute("success",
                        "Đã chuyển trạng thái module thành " + statusMsg);
            } else {
                request.getSession().setAttribute("error",
                        "Thay đổi trạng thái module thất bại");
            }

            response.sendRedirect(request.getContextPath() + "/coursedetailadmin?courseId=" + courseId);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/coursedetailadmin");
        }
    }

    private void logError(String message, Exception e) {
        System.err.println("[CourseAdminServlet] " + message);
        e.printStackTrace();
    }

}
