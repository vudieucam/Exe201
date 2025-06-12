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
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;
import model.Blog;
import model.BlogCategory;

/**
 *
 * @author FPT
 */
public class BlogDetailServlet extends HttpServlet {

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

        try {
            int blogId = Integer.parseInt(request.getParameter("id"));
            BlogDAO blogDAO = new BlogDAO();

            // Lấy chi tiết blog
            Blog blog = blogDAO.getBlogById(blogId);

            if (blog == null) {
                response.sendRedirect("blog");
                return;
            }

            // Lấy danh sách loại blog
            List<BlogCategory> categories = blogDAO.getAllCategories();

            // Lấy 3 bài viết nổi bật (đảm bảo không bao gồm bài hiện tại)
            List<Blog> featuredBlogs = blogDAO.getFeaturedBlogs(3).stream()
                    .filter(b -> b.getBlogId() != blogId)
                    .collect(Collectors.toList());

            // Đặt các thuộc tính vào request
            request.setAttribute("blog", blog);
            request.setAttribute("categories", categories);
            request.setAttribute("featuredBlogs", featuredBlogs);

            // Forward đến trang blog-single.jsp
            request.getRequestDispatcher("blog-single.jsp").forward(request, response);

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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
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
