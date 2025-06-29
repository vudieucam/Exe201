/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package controller.Blog;

import dal.BlogDAO;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import model.BlogCategory;

/**
 *
 * @author FPT
 */
public class BlogCategoryFilter implements Filter {

    private final BlogDAO blogDAO = new BlogDAO();

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;

        if (request.getAttribute("featuredCategories") == null) {
            try {
                List<BlogCategory> featured = blogDAO.getFeaturedCategories();
                request.setAttribute("featuredCategories", featured);
            } catch (Exception e) {
                e.printStackTrace(); // hoặc ghi log ra file/logging framework
                request.setAttribute("featuredCategories", java.util.Collections.emptyList());
            }
        }

        chain.doFilter(req, res);
    }

    @Override
    public void init(FilterConfig filterConfig) {
        /* Không cần cấu hình gì thêm */ }

    @Override
    public void destroy() {
        /* Không có resource nào cần đóng */ }
}
