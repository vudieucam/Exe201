/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package customer.Course;

import dal.CustomerCourseDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import model.CourseCategory;

@WebFilter("/*") // áp dụng cho mọi request
public class CategoryFilter implements Filter {

    private CustomerCourseDAO courseDAO = new CustomerCourseDAO();

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;

        // Chỉ set nếu chưa có (đỡ tốn query mỗi request tĩnh)
        if (request.getAttribute("courseCategories") == null) {
            List<CourseCategory> categories = courseDAO.getAllCategories();
            request.setAttribute("courseCategories", categories);
        }

        chain.doFilter(req, res);
    }

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void destroy() {
    }
}
