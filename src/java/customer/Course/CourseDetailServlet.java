/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package customer.Course;

import dal.BlogDAO;
import dal.CourseDAO;
import dal.CourseModuleDAO;
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
import model.BlogCategory;
import model.Course;
import model.CourseCategory;
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

    private CustomerCourseDAO CustomercourseDAO = new CustomerCourseDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private CourseModuleDAO courseModuleDAO = new CourseModuleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BlogDAO blogDAO = new BlogDAO();
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            // Debug: In ra tham số request
            System.out.println("Request parameters - id: " + request.getParameter("id")
                    + ", lesson: " + request.getParameter("lesson"));

            // Lấy danh sách danh mục và khóa học nổi bật
            List<CourseCategory> courseCategories = CustomercourseDAO.getAllCategories();
            request.setAttribute("courseCategories", courseCategories);

            List<Course> featuredCourses = CustomercourseDAO.getFeaturedCourses(9);
            request.setAttribute("featuredCourses", featuredCourses);
// Dữ liệu bổ sung
            List<BlogCategory> featuredCategories = blogDAO.getFeaturedCategories();

// Gửi sang JSP
            request.setAttribute("featuredCategories", featuredCategories);
            String idRaw = request.getParameter("id");

            // Kiểm tra tham số id
            if (idRaw == null || idRaw.isEmpty()) {
                request.setAttribute("errorMessage", "Thiếu ID khóa học");
                request.getRequestDispatcher("course_detail.jsp").forward(request, response);
                return;
            }

            int courseId;
            try {
                courseId = Integer.parseInt(idRaw);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID khóa học không hợp lệ");
                request.getRequestDispatcher("course_detail.jsp").forward(request, response);
                return;
            }

            System.out.println("=== DEBUG START ===");
            System.out.println("Request URL: " + request.getRequestURL());
            System.out.println("Query String: " + request.getQueryString());
            System.out.println("Session ID: " + request.getSession().getId());

            Course course = courseDAO.getCourseById(courseId);
            System.out.println("Course object from DAO: " + course);
            if (course != null) {
                System.out.println("Course details - ID: " + course.getId()
                        + ", Title: " + course.getTitle());
            }
            System.out.println("=== DEBUG END ===");

            if (course == null) {
                request.setAttribute("errorMessage", "Không tìm thấy khóa học với ID: " + courseId);
                request.getRequestDispatcher("course_detail.jsp").forward(request, response);
                return;
            }

            // Xử lý bài học
            String lessonIdRaw = request.getParameter("lesson");
            int lessonId = (lessonIdRaw != null && !lessonIdRaw.isEmpty()) ? Integer.parseInt(lessonIdRaw) : 0;

            List<CourseModule> modules = courseModuleDAO.getCourseModules(courseId);
            System.out.println("Number of modules: " + modules.size());

            Map<Integer, List<CourseLesson>> moduleLessonsMap = new HashMap<>();
            CourseLesson currentLesson = null;
            List<CourseLesson> allLessons = new ArrayList<>();

            // Lấy tất cả bài học
            for (CourseModule module : modules) {
                List<CourseLesson> lessons = CustomercourseDAO.getModuleLessons(module.getId());
                moduleLessonsMap.put(module.getId(), lessons);
                allLessons.addAll(lessons);

                // Chọn bài học đầu tiên nếu không có lessonId được chỉ định
                if (lessonId == 0 && currentLesson == null && !lessons.isEmpty()) {
                    currentLesson = lessons.get(0);
                }
            }

            // Nếu chỉ định lessonId
            if (lessonId > 0) {
                currentLesson = CustomercourseDAO.getLessonDetails(lessonId);
                System.out.println("Current lesson: " + currentLesson);

                if (currentLesson != null) {
                    boolean valid = false;
                    for (CourseLesson lesson : allLessons) {
                        if (lesson.getId() == currentLesson.getId()) {
                            valid = true;
                            break;
                        }
                    }
                    if (!valid) {
                        currentLesson = null;
                    }
                }
            }

            // Format nội dung bài học
            if (currentLesson != null && currentLesson.getContent() != null) {
                currentLesson.setContent(currentLesson.getContent().replace("\n", "<br>"));
            }

            // Tìm bài học trước/sau
            int currentIndex = -1;
            if (currentLesson != null) {
                for (int i = 0; i < allLessons.size(); i++) {
                    if (allLessons.get(i).getId() == currentLesson.getId()) {
                        currentIndex = i;
                        break;
                    }
                }
            }

            CourseLesson previousLesson = (currentIndex > 0) ? allLessons.get(currentIndex - 1) : null;
            CourseLesson nextLesson = (currentIndex >= 0 && currentIndex < allLessons.size() - 1)
                    ? allLessons.get(currentIndex + 1) : null;

            // Đặt các thuộc tính vào request
            request.setAttribute("course", course);
            request.setAttribute("modules", modules);
            request.setAttribute("moduleLessonsMap", moduleLessonsMap);
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("previousLesson", previousLesson);
            request.setAttribute("nextLesson", nextLesson);

            // Forward đến trang JSP
            request.getRequestDispatcher("course_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("course_detail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
