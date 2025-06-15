package controller.Blog;

import dal.BlogCategoryDAO;
import dal.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.List;
import model.Blog;
import model.BlogCategory;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)

public class BlogAdminServlet extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        Blog blog = extractBlogFromRequest(request, response, false);
        blogDAO.addBlog(blog);
        response.sendRedirect("blogadmin");
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        Blog blog = extractBlogFromRequest(request, response, true);
        blog.setBlogId(Integer.parseInt(request.getParameter("id")));
        blogDAO.updateBlog(blog);
        response.sendRedirect("blogadmin");
    }

    private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        blogDAO.deleteBlog(id);
        response.sendRedirect("blogadmin");
    }

    private void toggleBlogStatus(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        blogDAO.toggleBlogStatus(id);
        response.sendRedirect("blogadmin");
    }

    private Blog extractBlogFromRequest(HttpServletRequest request, HttpServletResponse response, boolean isEdit)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        Blog blog = new Blog();

        blog.setTitle(request.getParameter("title"));
        blog.setContent(request.getParameter("content"));
        blog.setShortDescription(request.getParameter("shortDescription"));
        blog.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        blog.setAuthorName(request.getParameter("authorName"));
        blog.setIsFeatured(Boolean.parseBoolean(request.getParameter("isFeatured")));
        blog.setStatus(Boolean.parseBoolean(request.getParameter("status")) ? 1 : 0);

        // Xử lý ảnh
        Part imagePart = request.getPart("imageFile");
        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String uploadDir = request.getServletContext().getRealPath("images/Blog");
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs();
            }

            String savePath = uploadDir + File.separator + fileName;
            imagePart.write(savePath);

            blog.setImageUrl("images/Blog/" + fileName);
        } else if (isEdit) {
            // Nếu không chọn ảnh mới khi chỉnh sửa, giữ nguyên ảnh cũ
            blog.setImageUrl(request.getParameter("existingImageUrl"));
        } else {
            blog.setImageUrl(""); // Trường hợp thêm mới mà không có ảnh
        }

        return blog;
    }

}
