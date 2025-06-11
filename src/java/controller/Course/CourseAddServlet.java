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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import model.Course;
import model.CourseCategory;
import org.apache.commons.io.IOUtils;

@WebServlet(name = "CourseAddServlet", urlPatterns = {"/courseadd"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class CourseAddServlet extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            List<CourseCategory> categories = courseCategoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("courseAdd.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tải trang: " + e.getMessage());
            request.getRequestDispatcher("courseAdd.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String researcher = request.getParameter("researcher");
            String time = request.getParameter("time");
            String statusParam = request.getParameter("status");
            String categoryId = request.getParameter("categoryIds");
            String startDateParam = request.getParameter("startDate");

            if (title == null || title.trim().isEmpty()) {
                throw new ServletException("Tên khóa học không được để trống");
            }
            if (categoryId == null || categoryId.trim().isEmpty()) {
                throw new ServletException("Danh mục không được để trống");
            }

            int status = 1;
            try {
                if (statusParam != null && !statusParam.trim().isEmpty()) {
                    status = Integer.parseInt(statusParam);
                }
            } catch (NumberFormatException e) {
                // Giữ giá trị mặc định
            }

            String imagePath = null;
            Part filePart = request.getPart("thumbnail");

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (!fileName.toLowerCase().matches(".*\\.(jpg|jpeg|png|gif)$")) {
                    throw new ServletException("Chỉ chấp nhận file ảnh (JPG, JPEG, PNG, GIF)");
                }
                InputStream fileContent = filePart.getInputStream();
                imagePath = saveUploadedFile(fileName, fileContent);
            } else {
                throw new ServletException("Vui lòng chọn ảnh đại diện cho khóa học");
            }

            Date startDate = null;
            try {
                if (startDateParam != null && !startDateParam.trim().isEmpty()) {
                    startDate = java.sql.Date.valueOf(startDateParam);
                } else {
                    throw new ServletException("Vui lòng chọn ngày bắt đầu");
                }
            } catch (IllegalArgumentException e) {
                throw new ServletException("Ngày bắt đầu không hợp lệ");
            }

            Course newCourse = new Course();
            newCourse.setTitle(title);
            newCourse.setContent(content);
            newCourse.setResearcher(researcher);
            newCourse.setDuration(time);
            newCourse.setStatus(status);
            newCourse.setThumbnailUrl(imagePath);
            newCourse.setCreatedAt(startDate);

            List<Integer> categories = new ArrayList<>();
            categories.add(Integer.parseInt(categoryId));

            boolean success = courseCategoryDAO.addCourseWithCategories(newCourse, categories);

            if (success) {
                request.getSession().setAttribute("success", "Thêm khóa học thành công");
                response.sendRedirect("courseadmin");
            } else {
                throw new ServletException("Thêm khóa học thất bại do lỗi database");
            }
        } catch (Exception e) {
            List<CourseCategory> categories = courseCategoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("error", "Lỗi khi thêm khóa học: " + e.getMessage());
            request.getRequestDispatcher("courseAdd.jsp").forward(request, response);
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
