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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Course;
import model.CourseLesson;
import model.CourseModule;

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
            String lessonIdRaw = request.getParameter("lesson");

            // Validate course ID
            if (idRaw == null || idRaw.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Thiếu tham số ID khóa học");
                response.sendRedirect("course");
                return;
            }

            int courseId = Integer.parseInt(idRaw);
            int lessonId = (lessonIdRaw != null && !lessonIdRaw.isEmpty()) ? Integer.parseInt(lessonIdRaw) : 0;

            // Get course details
            Course course = courseDAO.getCourseDetails(courseId);
            if (course == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khóa học với ID: " + courseId);
                response.sendRedirect("course");
                return;
            }

            // Get all modules for the course
            List<CourseModule> modules = courseDAO.getCourseModules(courseId);

            // Create a map to store lessons for each module
            Map<Integer, List<CourseLesson>> moduleLessonsMap = new HashMap<>();
            CourseLesson currentLesson = null;

            // Load lessons for each module and find the current lesson
            for (CourseModule module : modules) {
                List<CourseLesson> lessons = courseDAO.getModuleLessons(module.getId());
                moduleLessonsMap.put(module.getId(), lessons);

                // If no specific lesson requested, select the first one from the first module
                if (lessonId == 0 && currentLesson == null && !lessons.isEmpty()) {
                    currentLesson = lessons.get(0);
                }
            }

            // If a specific lesson is requested, get it
            if (lessonId > 0) {
                currentLesson = courseDAO.getLessonDetails(lessonId);

                // Verify the lesson belongs to this course
                if (currentLesson != null) {
                    boolean lessonBelongsToCourse = false;
                    for (List<CourseLesson> lessons : moduleLessonsMap.values()) {
                        if (lessons.stream().anyMatch(l -> l.getId() == lessonId)) {
                            lessonBelongsToCourse = true;
                            break;
                        }
                    }

                    if (!lessonBelongsToCourse) {
                        currentLesson = null;
                    }
                }
            }

            // Format lesson content if exists
            if (currentLesson != null && currentLesson.getContent() != null) {
                currentLesson.setContent(currentLesson.getContent().replace("\n", "<br>"));
            }

            // Set attributes for JSP
            request.setAttribute("course", course);
            request.setAttribute("modules", modules);
            request.setAttribute("moduleLessonsMap", moduleLessonsMap);
            request.setAttribute("currentLesson", currentLesson);

            // Forward to JSP
            request.getRequestDispatcher("course_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID không hợp lệ");
            response.sendRedirect("course");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
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
