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
import java.util.ArrayList;
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

    private CustomerCourseDAO courseDAO = new CustomerCourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy danh sách khóa học nổi bật cho menu dropdown
            List<Course> featuredCourses = courseDAO.getFeaturedCourses(9);
            request.setAttribute("featuredCourses", featuredCourses);
            String idRaw = request.getParameter("id");
            String lessonIdRaw = request.getParameter("lesson");

            if (idRaw == null || idRaw.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Thiếu ID khóa học");
                response.sendRedirect("course");
                return;
            }

            int courseId = Integer.parseInt(idRaw);
            int lessonId = (lessonIdRaw != null && !lessonIdRaw.isEmpty()) ? Integer.parseInt(lessonIdRaw) : 0;

            Course course = courseDAO.getCourseDetails(courseId);
            if (course == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khóa học");
                response.sendRedirect("course");
                return;
            }

            List<CourseModule> modules = courseDAO.getCourseModules(courseId);
            Map<Integer, List<CourseLesson>> moduleLessonsMap = new HashMap<>();
            CourseLesson currentLesson = null;
            List<CourseLesson> allLessons = new ArrayList<>();

            // Lấy tất cả bài học
            for (CourseModule module : modules) {
                List<CourseLesson> lessons = courseDAO.getModuleLessons(module.getId());
                moduleLessonsMap.put(module.getId(), lessons);
                allLessons.addAll(lessons);

                if (lessonId == 0 && currentLesson == null && !lessons.isEmpty()) {
                    currentLesson = lessons.get(0);
                }
            }

            // Nếu chỉ định lessonId
            if (lessonId > 0) {
                currentLesson = courseDAO.getLessonDetails(lessonId);

                boolean valid = allLessons.stream().anyMatch(l -> l.getId() == lessonId);
                if (!valid) {
                    currentLesson = null;
                }
            }

            // Căn lề và xuống dòng HTML
            if (currentLesson != null && currentLesson.getContent() != null) {
                currentLesson.setContent(currentLesson.getContent().replace("\n", "<br>"));
            }

            // Tìm vị trí hiện tại và bài liền trước / sau
            int currentIndex = -1;
            for (int i = 0; i < allLessons.size(); i++) {
                if (allLessons.get(i).getId() == currentLesson.getId()) {
                    currentIndex = i;
                    break;
                }
            }

            CourseLesson previousLesson = (currentIndex > 0) ? allLessons.get(currentIndex - 1) : null;
            CourseLesson nextLesson = (currentIndex >= 0 && currentIndex < allLessons.size() - 1)
                    ? allLessons.get(currentIndex + 1) : null;

            // Đưa ra view
            request.setAttribute("course", course);
            request.setAttribute("modules", modules);
            request.setAttribute("moduleLessonsMap", moduleLessonsMap);
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("previousLesson", previousLesson);
            request.setAttribute("nextLesson", nextLesson);

            request.getRequestDispatcher("course_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID không hợp lệ");
            response.sendRedirect("course");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
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
