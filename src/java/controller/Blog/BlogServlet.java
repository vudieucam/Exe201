/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Blog;

import dal.BlogDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Blog;
import model.BlogCategory;

/**
 *
 * @author FPT
 */
public class BlogServlet extends HttpServlet {

    private static final int BLOGS_PER_PAGE = 9;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            BlogDAO blogDAO = new BlogDAO();

            String keyword = request.getParameter("keyword");
            String categoryIdParam = request.getParameter("categoryId");

            List<Blog> blogs;
            int currentPage = 1;
            int totalBlogs = 0;
            int totalPages = 1;

            // Nếu có từ khóa tìm kiếm
            if (keyword != null && !keyword.trim().isEmpty()) {
                blogs = blogDAO.searchBlogs(keyword.trim());
                request.setAttribute("keyword", keyword);

                // Nếu có categoryId để lọc theo loại blog
            } else if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                int categoryId = Integer.parseInt(categoryIdParam);
                if (request.getParameter("page") != null) {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                }

                blogs = blogDAO.getBlogsByCategoryId(categoryId, currentPage, BLOGS_PER_PAGE);
                totalBlogs = blogDAO.getTotalBlogsByCategoryId(categoryId);
                totalPages = (int) Math.ceil((double) totalBlogs / BLOGS_PER_PAGE);

                request.setAttribute("categoryId", categoryId); // để JSP giữ trạng thái lọc
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);

                // Trường hợp mặc định: không tìm kiếm, không lọc loại
            } else {
                if (request.getParameter("page") != null) {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                }

                blogs = blogDAO.getBlogs(currentPage, BLOGS_PER_PAGE);
                totalBlogs = blogDAO.getTotalBlogs();
                totalPages = (int) Math.ceil((double) totalBlogs / BLOGS_PER_PAGE);

                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
            }

            // Dữ liệu bổ sung
            List<BlogCategory> categories = blogDAO.getAllCategories();
            List<BlogCategory> featuredCategories = blogDAO.getFeaturedCategories();
            List<Blog> featuredBlogs = blogDAO.getFeaturedBlogs(3);

            // Gửi dữ liệu sang JSP
            request.setAttribute("blogs", blogs);
            request.setAttribute("categories", categories);
            request.setAttribute("featuredCategories", featuredCategories);
            request.setAttribute("featuredBlogs", featuredBlogs);

            request.getRequestDispatcher("blog.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
