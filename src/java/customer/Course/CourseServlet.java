/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package customer.Course;

import dal.CustomerCourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Course;

/**
 *
 * @author FPT
 */
public class CourseServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private CustomerCourseDAO courseCDAO = new CustomerCourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy danh sách khóa học nổi bật cho menu dropdown
            List<Course> featuredCourses = courseCDAO.getFeaturedCourses(9);
            request.setAttribute("featuredCourses", featuredCourses);
            String searchQuery = request.getParameter("search");
            String pageParam = request.getParameter("page");
            int currentPage = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
            int recordsPerPage = 9;

            List<Course> courses;
            int totalCourses;

            if (searchQuery != null && !searchQuery.isEmpty()) {
                courses = courseCDAO.searchCourses(searchQuery, currentPage, recordsPerPage);
                totalCourses = courseCDAO.getTotalSearchCourses(searchQuery);
            } else {
                courses = courseCDAO.getCoursesByPage(currentPage, recordsPerPage);
                totalCourses = courseCDAO.getTotalCourses();
            }

            int totalPages = (int) Math.ceil((double) totalCourses / recordsPerPage);

            request.setAttribute("courses", courses);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchQuery", searchQuery);

            request.getRequestDispatcher("/course.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi tải danh sách khóa học");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
