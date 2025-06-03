/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Course;

import dal.CourseDAO;
import dal.CourseModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.CourseModule;

/**
 *
 * @author FPT
 */
public class ModuleServlet extends HttpServlet {

    private CourseDAO courseDAO;

    private CourseModuleDAO courseModuleDAO;
    
    private CourseLessonDAO courseLessonDAO;
    
    
    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        courseModuleDAO = new CourseModuleDAO();
        courseLessonDAO = new CourseLessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("delete")) {
            deleteModule(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.equals("add")) {
            addModule(request, response);
        } else if (action.equals("update")) {
            updateModule(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("id"));
            CourseModule module = courseModuleDAO.getModuleById(moduleId);

            if (module == null) {
                throw new ServletException("Module không tồn tại");
            }

            request.setAttribute("module", module);
            request.getRequestDispatcher("moduleEdit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID module không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void addModule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title").trim();
            String description = request.getParameter("description").trim();

            if (title.isEmpty()) {
                request.setAttribute("error", "Tên module không được để trống");
                response.sendRedirect(request.getContextPath() + "/courseedit?id=" + courseId);
                return;
            }

            if (!courseDAO.courseExists(courseId)) {
                request.setAttribute("error", "Khóa học không tồn tại");
                response.sendRedirect(request.getContextPath() + "/courseadmin");
                return;
            }

            CourseModule module = new CourseModule();
            module.setCourseId(courseId);
            module.setTitle(title);
            module.setDescription(description);
            module.setOrderIndex(courseModuleDAO.getNextModuleOrder(courseId));

            if (courseModuleDAO.addModule(module)) {
                request.setAttribute("success", "Thêm module thành công");
            } else {
                request.setAttribute("error", "Thêm module thất bại");
            }

            response.sendRedirect(request.getContextPath() + "/courseedit?id=" + courseId);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khóa học không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void updateModule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");

            CourseModule module = new CourseModule();
            module.setId(moduleId);
            module.setTitle(title);
            module.setDescription(description);

            courseModuleDAO.updateModule(module);

            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
            response.sendRedirect(request.getContextPath() + "/courseedit?id=" + courseId);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID module không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void deleteModule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("id"));
            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
            courseModuleDAO.deleteModule(moduleId);
            response.sendRedirect(request.getContextPath() + "/courseedit?id=" + courseId);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID module không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }
}
