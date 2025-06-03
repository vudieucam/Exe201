/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Course;

import dal.CourseCategoryDAO;
import dal.CourseDAO;
import dal.CourseModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.CourseCategory;
import model.CourseModule;
import org.apache.commons.io.IOUtils;

@WebServlet(name = "CourseEditServlet", urlPatterns = {"/courseedit"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class CourseEditServlet extends HttpServlet {


    private CourseDAO courseDAO;
    private dal.CourseLessonDAO courseLessonDAO;
    private CourseModuleDAO courseModuleDAO;
    private CourseCategoryDAO courseCategoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        courseModuleDAO = new CourseModuleDAO();
        courseLessonDAO = new dal.CourseLessonDAO();
        courseCategoryDAO = new CourseCategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                throw new ServletException("Thiếu ID khóa học");
            }

            int id = Integer.parseInt(idParam);
            Course course = courseDAO.getCourseDetail(id);
            if (course == null) {
                throw new ServletException("Khóa học không tồn tại");
            }

            course.setCategories(courseCategoryDAO.getCourseCategories(id));
            List<CourseModule> modules = courseModuleDAO.getCourseModules(id);
            List<CourseCategory> categories = courseCategoryDAO.getAllCategories();

            request.setAttribute("currentCourse", course);
            request.setAttribute("modules", modules);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("courseEdit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khóa học không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/courseadmin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String researcher = request.getParameter("researcher");
            String time = request.getParameter("time");
            String statusParam = request.getParameter("status");
            String categoryId = request.getParameter("categoryId");

            if (idParam == null || idParam.trim().isEmpty()) {
                throw new ServletException("ID khóa học không được để trống");
            }
            int id = Integer.parseInt(idParam);

            Course existingCourse = courseDAO.getCourseDetail(id);
            if (existingCourse == null) {
                throw new ServletException("Không tìm thấy khóa học với ID: " + id);
            }

            String imagePath = existingCourse.getThumbnailUrl();
            Part filePart = request.getPart("thumbnail");

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (!fileName.toLowerCase().matches(".*\\.(jpg|jpeg|png|gif)$")) {
                    throw new ServletException("Chỉ chấp nhận file ảnh (JPG, JPEG, PNG, GIF)");
                }
                InputStream fileContent = filePart.getInputStream();
                imagePath = saveUploadedFile(fileName, fileContent);
            }

            Course updatedCourse = new Course();
            updatedCourse.setId(id);
            updatedCourse.setTitle(title != null ? title : existingCourse.getTitle());
            updatedCourse.setContent(content != null ? content : existingCourse.getContent());
            updatedCourse.setResearcher(researcher != null ? researcher : existingCourse.getResearcher());
            updatedCourse.setDuration(time != null ? time : existingCourse.getDuration());

            try {
                updatedCourse.setStatus(statusParam != null ? Integer.parseInt(statusParam) : existingCourse.getStatus());
            } catch (NumberFormatException e) {
                updatedCourse.setStatus(existingCourse.getStatus());
            }

            updatedCourse.setThumbnailUrl(imagePath);
            updatedCourse.setCreatedAt(existingCourse.getCreatedAt());
            updatedCourse.setUpdatedAt(new Date());

            List<Integer> categories = new ArrayList<>();
            if (categoryId != null && !categoryId.isEmpty()) {
                categories.add(Integer.parseInt(categoryId));
            } else {
                categories.add(existingCourse.getCategories().get(0).getId());
            }

            boolean success = courseCategoryDAO.updateCourseWithCategories(updatedCourse, categories);

            if (success) {
                request.getSession().setAttribute("success", "Cập nhật khóa học thành công");
                response.sendRedirect(request.getContextPath() + "/courseedit?id=" + id);
            } else {
                throw new ServletException("Cập nhật khóa học thất bại");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật: " + e.getMessage());

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    Course currentCourse = courseDAO.getCourseDetail(Integer.parseInt(idParam));
                    request.setAttribute("currentCourse", currentCourse);
                } catch (NumberFormatException ex) {
                    // Bỏ qua nếu ID không hợp lệ
                } catch (SQLException ex) {
                    Logger.getLogger(CourseEditServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            List<CourseCategory> categories = courseCategoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("courseEdit.jsp").forward(request, response);
        }
    }

    private String saveUploadedFile(String fileName, InputStream fileContent) throws IOException {
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        String filePath = uploadPath + File.separator + uniqueFileName;

        try (OutputStream out = new FileOutputStream(filePath)) {
            IOUtils.copy(fileContent, out);
        }

        return "uploads/" + uniqueFileName;
    }

}
