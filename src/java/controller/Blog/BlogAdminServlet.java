package controller.Blog;

import dal.BlogCategoryDAO;
import dal.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Blog;
import model.BlogCategory;

public class BlogAdminServlet extends HttpServlet {

    private BlogDAO blogDAO;
    private BlogCategoryDAO categoryDAO;

    @Override
    public void init() {
        blogDAO = new BlogDAO();
        categoryDAO = new BlogCategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                listBlogs(request, response);
            } else {
                switch (action) {
                    case "delete":
                        deleteBlog(request, response);
                        break;
                    case "toggle":
                        toggleBlogStatus(request, response);
                        break;
                    default:
                        listBlogs(request, response);
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
                listBlogs(request, response);
            } else {
                switch (action) {
                    case "insert":
                        insertBlog(request, response);
                        break;
                    case "update":
                        updateBlog(request, response);
                        break;
                    default:
                        listBlogs(request, response);
                        break;
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new ServletException(ex);
        }
    }

    private void listBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String statusFilter = request.getParameter("statusFilter");
            String featuredFilter = request.getParameter("featuredFilter");
            String search = request.getParameter("search");

            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                }
            } catch (NumberFormatException e) {
                page = 1;
            }

            int recordsPerPage = 10;

            List<Blog> blogs = blogDAO.getBlogs(page, recordsPerPage, statusFilter, featuredFilter, search);
            int totalRecords = blogDAO.getTotalBlogs(statusFilter, featuredFilter, search);
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            List<BlogCategory> categories = categoryDAO.getAllCategories();

            request.setAttribute("blogs", blogs);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("featuredFilter", featuredFilter);
            request.setAttribute("search", search);

            request.getRequestDispatcher("/blogsAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void insertBlog(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Blog blog = extractBlogFromRequest(request);
        int newId = blogDAO.addBlog(blog);
        response.sendRedirect("blogadmin");
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Blog blog = extractBlogFromRequest(request);
        blog.setBlogId(Integer.parseInt(request.getParameter("id")));
        blogDAO.updateBlog(blog);
        response.sendRedirect("blogadmin");
    }

    private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        blogDAO.deleteBlog(id);
        response.sendRedirect("blogadmin");
    }

    private void toggleBlogStatus(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        blogDAO.toggleBlogStatus(id);
        response.sendRedirect("blogadmin");
    }

    private Blog extractBlogFromRequest(HttpServletRequest request) {
        Blog blog = new Blog();
        blog.setTitle(request.getParameter("title"));
        blog.setContent(request.getParameter("content"));
        blog.setShortDescription(request.getParameter("shortDescription"));
        blog.setImageUrl(request.getParameter("imageUrl"));
        blog.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        blog.setAuthorName(request.getParameter("authorName"));
        blog.setIsFeatured(Boolean.parseBoolean(request.getParameter("isFeatured")));
        blog.setStatus(Boolean.parseBoolean(request.getParameter("status")) ? 1 : 0);
        return blog;
    }
}
