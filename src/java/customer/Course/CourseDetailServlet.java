/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package customer.Course;

import dal.CourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;

/**
 *
 * @author FPT
 */
public class CourseDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourseDetailServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseDetailServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            System.out.println("DEBUG: ID nhận được từ URL = " + idRaw); // ✅ In ra console

            int courseId = Integer.parseInt(idRaw);

            Course course = courseDAO.getCourseDetails(courseId);
            System.out.println("DEBUG: Course = " + (course != null ? course.getTitle() : "null")); // ✅ Xác minh course

            if (course == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khóa học với ID: " + courseId);
                response.sendRedirect("course");
                return;
            }

            request.setAttribute("course", course);
            request.getRequestDispatcher("course_detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            System.out.println("DEBUG: ID không hợp lệ - " + e.getMessage()); // ✅ In lỗi sai kiểu số
            request.getSession().setAttribute("errorMessage", "ID khóa học không hợp lệ");
            response.sendRedirect("course");
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
