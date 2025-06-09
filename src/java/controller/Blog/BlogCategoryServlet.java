package controller.Blog;

import dal.BlogCategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BlogCategory;

import java.io.IOException;
import java.util.List;

public class BlogCategoryServlet extends HttpServlet {

    private BlogCategoryDAO blogCategoryDAO;

    @Override
    public void init() {
        blogCategoryDAO = new BlogCategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                listCategories(request, response);
            } else {
                switch (action) {
                    case "delete":
                        deleteCategory(request, response);
                        break;
                    case "toggle":
                        toggleCategoryStatus(request, response);
                        break;
                    case "edit":
                        getCategoryJson(request, response);
                        break;

                    default:
                        listCategories(request, response);
                        break;
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                listCategories(request, response);
            } else {
                switch (action) {
                    case "insert":
                        insertCategory(request, response);
                        break;
                    case "update":
                        updateCategory(request, response);
                        break;
                    default:
                        listCategories(request, response);
                        break;
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new ServletException(ex);
        }
    }

    private void getCategoryJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BlogCategory category = blogCategoryDAO.getCategoryById(id);

        if (category == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"categoryId\":").append(category.getCategoryId()).append(",");
        json.append("\"categoryName\":\"").append(escapeJson(category.getCategoryName())).append("\",");
        json.append("\"description\":\"").append(escapeJson(category.getDescription())).append("\",");
        json.append("\"status\":").append(category.isStatus());
        json.append("}");

        response.getWriter().write(json.toString());
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<BlogCategory> categories = blogCategoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/blogCategories.jsp").forward(request, response);
    }

    private void insertCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        BlogCategory category = extractCategoryFromRequest(request);

        if (blogCategoryDAO.existsByName(category.getCategoryName())) {
            request.getSession().setAttribute("error", "Tên danh mục đã tồn tại.");
        } else if (blogCategoryDAO.addCategory(category)) {
            request.getSession().setAttribute("success", "Thêm danh mục thành công.");
        } else {
            request.getSession().setAttribute("error", "Thêm danh mục thất bại.");
        }

        response.sendRedirect("blogcategory");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        BlogCategory existing = blogCategoryDAO.getCategoryById(id);

        if (existing == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Danh mục không tồn tại.");
            return;
        }

        BlogCategory sameName = blogCategoryDAO.getCategoryByName(request.getParameter("categoryName"));
        if (sameName != null && sameName.getCategoryId() != id) {
            request.getSession().setAttribute("error", "Tên danh mục đã tồn tại.");
            response.sendRedirect("blogcategory");
            return;
        }

        BlogCategory category = extractCategoryFromRequest(request);
        category.setCategoryId(id);

        if (blogCategoryDAO.updateCategory(category)) {
            request.getSession().setAttribute("success", "Cập nhật thành công.");
        } else {
            request.getSession().setAttribute("error", "Cập nhật thất bại.");
        }

        response.sendRedirect("blogcategory");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID danh mục.");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            if (blogCategoryDAO.deleteCategory(id)) {
                request.getSession().setAttribute("success", "Xóa danh mục thành công.");
            } else {
                request.getSession().setAttribute("error", "Xóa danh mục thất bại.");
            }
            response.sendRedirect("blogcategory");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID danh mục không hợp lệ.");
        }
    }

    private void toggleCategoryStatus(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID danh mục.");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            if (blogCategoryDAO.toggleCategoryStatus(id)) {
                request.getSession().setAttribute("success", "Cập nhật trạng thái thành công.");
            } else {
                request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại.");
            }
            response.sendRedirect("blogcategory");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID danh mục không hợp lệ.");
        }
    }

    private BlogCategory extractCategoryFromRequest(HttpServletRequest request) {
        BlogCategory category = new BlogCategory();
        category.setCategoryName(request.getParameter("categoryName"));
        category.setDescription(request.getParameter("description"));
        category.setStatus(Boolean.parseBoolean(request.getParameter("status")));
        return category;
    }
}
