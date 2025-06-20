/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Course;

import dal.CourseCategoryDAO;
import dal.CourseDAO;
import dal.CourseModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.CourseCategory;

/**
 *
 * @author FPT
 */
public class CourseCategoryServlet extends HttpServlet {

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
    private dal.CourseLessonDAO courseLessonDAO;
    private CourseModuleDAO courseModuleDAO;
    private CourseCategoryDAO courseCategoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        courseModuleDAO = new CourseModuleDAO();
        courseLessonDAO = new dal.CourseLessonDAO();
        courseCategoryDAO = new CourseCategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {
            listCategories(request, response);
        } else if (action.equals("delete")) {
            deleteCategory(request, response);
        } else if (action.equals("toggleStatus")) {
            toggleCategoryStatus(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        if (action == null || action.equals("add")) {
            addCategory(request, response);
        } else if (action.equals("update")) {
            updateCategory(request, response);
        }

    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            List<CourseCategory> categories = courseCategoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tải danh sách danh mục: " + e.getMessage());
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);

        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            String name = request.getParameter("categoryName");

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên danh mục không được để trống");
                listCategories(request, response);
                return;
            }

            if (courseCategoryDAO.categoryExists(name)) {
                request.setAttribute("error", "Danh mục này đã tồn tại");
                listCategories(request, response);
                return;
            }

            boolean success = courseCategoryDAO.addCategory(name);

            if (success) {
                request.setAttribute("success", "Thêm danh mục thành công");
            } else {
                request.setAttribute("error", "Thêm danh mục thất bại");
            }

            listCategories(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi thêm danh mục: " + e.getMessage());
            listCategories(request, response);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            String idParam = request.getParameter("categoryId");
            String name = request.getParameter("categoryName");

            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute("error", "Thiếu ID danh mục");
                listCategories(request, response);
                return;
            }

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên danh mục không được để trống");
                listCategories(request, response);
                return;
            }

            int id = Integer.parseInt(idParam);

            if (courseCategoryDAO.categoryExists(name, id)) {
                request.setAttribute("error", "Tên danh mục này đã được sử dụng");
                listCategories(request, response);
                return;
            }

            boolean success = courseCategoryDAO.updateCategory(id, name);

            if (success) {
                request.setAttribute("success", "Cập nhật danh mục thành công");
            } else {
                request.setAttribute("error", "Cập nhật danh mục thất bại");
            }

            listCategories(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID danh mục không hợp lệ");
            listCategories(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi cập nhật danh mục: " + e.getMessage());
            listCategories(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute("error", "Thiếu ID danh mục");
                listCategories(request, response);
                return;
            }

            int id = Integer.parseInt(idParam);

            if (courseCategoryDAO.isCategoryInUse(id)) {
                request.setAttribute("error", "Không thể xóa danh mục đang được sử dụng");
                listCategories(request, response);
                return;
            }

            boolean success = courseCategoryDAO.deleteCategory(id);

            if (success) {
                request.setAttribute("success", "Xóa danh mục thành công");
            } else {
                request.setAttribute("error", "Xóa danh mục thất bại");
            }

            listCategories(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID danh mục không hợp lệ");
            listCategories(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi xóa danh mục: " + e.getMessage());
            listCategories(request, response);
        }
    }

    private void toggleCategoryStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = courseCategoryDAO.toggleStatus(id);

            if (success) {
                request.setAttribute("success", "Đã cập nhật trạng thái danh mục");
            } else {
                request.setAttribute("error", "Cập nhật trạng thái thất bại");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }
        listCategories(request, response);
    }

}
