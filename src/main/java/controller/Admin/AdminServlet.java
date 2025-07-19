package controller.Admin;

import dal.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;
    private CourseDAO courseDAO;
    private CourseCategoryDAO categoryDAO;
    private PackageDAO packageDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        courseDAO = new CourseDAO();
        categoryDAO = new CourseCategoryDAO();
        packageDAO = new PackageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /*  --------- 1. Đọc & chuyển đổi tham số lọc ---------- */
        String keyword = trimParam(req.getParameter("search"));
        Boolean status = parseStatus(req.getParameter("status"));      // null/true/false
        Integer categoryId = parseInt(req.getParameter("category"));       // null / ID

        /*  --------- 2. Lấy dữ liệu từ DB qua DAO ------------- */
        try {
            List<Course> courses = (keyword == null && status == null && categoryId == null)
                    ? courseDAO.getAllCourses()
                    : courseDAO.searchCourses(keyword, status, categoryId);

            List<CourseCategory> categories = categoryDAO.getAllCategories();
            List<User> users = userDAO.getAllUsers();
            List<ServicePackage> packages = packageDAO.getAllPackagesAdmin();
            Map<String, Integer> distribution = userDAO.getUserDistribution();

            /*  --------- 3. Đưa dữ liệu lên request scope ------- */
            req.setAttribute("courses", courses);
            req.setAttribute("categories", categories);
            req.setAttribute("users", users);
            req.setAttribute("packages", packages);
            req.setAttribute("distribution", distribution);

            // Trả lại các giá trị filter để giữ nguyên form lọc
            req.setAttribute("search", keyword);
            req.setAttribute("status", req.getParameter("status"));
            req.setAttribute("category", req.getParameter("category"));

        } catch (SQLException ex) {
            throw new ServletException("Không thể tải dữ liệu dashboard", ex);
        }

        req.getRequestDispatcher("/Admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);                 // chỉ có lọc – không có ghi dữ liệu
    }

    /* ================================================================== */
 /*                       Helpers (private)                            */
 /* ================================================================== */
    private static String trimParam(String p) {
        return (p == null || p.trim().isEmpty()) ? null : p.trim();
    }

    private static Boolean parseStatus(String s) {
        if (s == null || s.isEmpty()) {
            return null;
        }
        return "1".equals(s) || "true".equalsIgnoreCase(s);
    }

    private static Integer parseInt(String s) {
        try {
            return (s == null || s.isEmpty()) ? null : Integer.valueOf(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
