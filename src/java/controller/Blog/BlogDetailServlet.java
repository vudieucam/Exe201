package controller.Blog;

import dal.BlogDAO;
import model.Blog;
import model.BlogCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class BlogDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int blogId = Integer.parseInt(request.getParameter("id"));
            BlogDAO blogDAO = new BlogDAO();

            Blog blog = blogDAO.getBlogById(blogId);
            if (blog == null) {
                response.sendRedirect("blog.jsp");
                return;
            }

            List<BlogCategory> categories = blogDAO.getAllCategories();
            List<Blog> featuredBlogs = blogDAO.getFeaturedBlogs(3).stream()
                    .filter(b -> b.getBlogId() != blogId)
                    .collect(Collectors.toList());

            request.setAttribute("blog", blog);
            request.setAttribute("categories", categories);
            request.setAttribute("featuredBlogs", featuredBlogs);

            request.getRequestDispatcher("blog-single.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Displays the detail page of a specific blog post.";
    }
}
