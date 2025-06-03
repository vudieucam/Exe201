/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Course;

import dal.CourseCategoryDAO;
import dal.CourseDAO;
import dal.CourseLessonDAO;
import dal.CourseModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.CourseLesson;

/**
 *
 * @author FPT
 */
public class LessonServlet extends HttpServlet {

    private CourseDAO courseDAO;
    private CourseLessonDAO courseLessonDAO;
    private CourseModuleDAO courseModuleDAO;
    private CourseCategoryDAO courseCategoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        courseModuleDAO = new CourseModuleDAO();
        courseLessonDAO = new CourseLessonDAO();
        courseCategoryDAO = new CourseCategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("delete")) {
            deleteLesson(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.equals("add")) {
            addLesson(request, response);
        } else if (action.equals("update")) {
            updateLesson(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("id"));
            CourseLesson lesson = courseLessonDAO.getLessonById(lessonId);

            if (lesson == null) {
                throw new ServletException("Bài học không tồn tại");
            }

            request.setAttribute("lesson", lesson);
            request.getRequestDispatcher("lessonEdit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID bài học không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void addLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String videoUrl = request.getParameter("videoUrl");

            CourseLesson lesson = new CourseLesson();
            lesson.setModuleId(moduleId);
            lesson.setTitle(title);
            lesson.setContent(content);
            lesson.setVideoUrl(videoUrl);

            courseLessonDAO.addLesson(lesson);

            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
            response.sendRedirect(request.getContextPath() + "/courseedit?id=" + courseId);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID module không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void updateLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String videoUrl = request.getParameter("videoUrl");

            CourseLesson lesson = new CourseLesson();
            lesson.setId(lessonId);
            lesson.setTitle(title);
            lesson.setContent(content);
            lesson.setVideoUrl(videoUrl);

            courseLessonDAO.updateLesson(lesson);

            int moduleId = courseLessonDAO.getModuleIdByLessonId(lessonId);
            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
            response.sendRedirect(request.getContextPath() + "/courseedit?id=" + courseId);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID bài học không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("id"));
            int moduleId = courseLessonDAO.getModuleIdByLessonId(lessonId);
            int courseId = courseModuleDAO.getCourseIdByModuleId(moduleId);
            courseLessonDAO.deleteLesson(lessonId);
            response.sendRedirect(request.getContextPath() + "/courseedit?id=" + courseId);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID bài học không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

}
