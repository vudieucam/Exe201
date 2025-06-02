package controller.Admin;

import dal.CourseDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import model.Course;
import model.CourseCategory;
import model.CourseLesson;
import model.CourseModule;
import org.apache.commons.io.IOUtils;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)

public class CourseAdminServlet extends HttpServlet {
// Thêm các hằng số ở đầu class

    private static final String CATEGORY_LIST_PAGE = "/courseAdmin.jsp";
    private static final String ERROR_MSG = "error";
    private static final String SUCCESS_MSG = "success";
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                // Thêm vào phương thức processRequest
                case "addCategory":
                    addCategory(request, response);
                    break;
                case "updateCategory":
                    updateCategory(request, response);
                    break;
                case "deleteCategory":
                    deleteCategory(request, response);
                    break;
                case "listCategories":
                    listCategories(request, response);
                    break;
                case "list":
                    listCourses(request, response);
                    break;
                case "add":
                    addCourse(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateCourse(request, response);
                    break;
                case "delete":
                    deleteCourse(request, response);
                    break;
                case "toggleStatus":
                    toggleCourseStatus(request, response);
                    break;
                case "search":
                    searchCourses(request, response);
                    break;
                case "addModule":
                    addModule(request, response);
                    break;
                case "updateModule":
                    updateModule(request, response);
                    break;
                case "deleteModule":
                    deleteModule(request, response);
                    break;
                case "addLesson":
                    addLesson(request, response);
                    break;
                case "updateLesson":
                    updateLesson(request, response);
                    break;
                case "deleteLesson":
                    deleteLesson(request, response);
                    break;
                default:
                    listCourses(request, response);
                    break;
            }
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/courseAdmin.jsp").forward(request, response);
        }
    }
// Thêm các phương thức mới

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("categoryName");

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute(ERROR_MSG, "Tên danh mục không được để trống");
                showEditForm(request, response);
                return;
            }

            // Kiểm tra danh mục đã tồn tại chưa
            if (courseDAO.categoryExists(name)) {
                request.setAttribute(ERROR_MSG, "Danh mục này đã tồn tại");
                showEditForm(request, response);
                return;
            }

            // Thêm vào database
            boolean success = courseDAO.addCategory(name);

            if (success) {
                request.setAttribute(SUCCESS_MSG, "Thêm danh mục thành công");
            } else {
                request.setAttribute(ERROR_MSG, "Thêm danh mục thất bại");
            }

            // Làm mới danh sách và hiển thị lại
            String courseId = request.getParameter("courseId");
            if (courseId != null && !courseId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
            } else {
                showEditForm(request, response);
            }

        } catch (Exception e) {
            request.setAttribute(ERROR_MSG, "Lỗi khi thêm danh mục: " + e.getMessage());
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("categoryId");
            String name = request.getParameter("categoryName");

            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute(ERROR_MSG, "Thiếu ID danh mục");
                showEditForm(request, response);
                return;
            }

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute(ERROR_MSG, "Tên danh mục không được để trống");
                showEditForm(request, response);
                return;
            }

            int id = Integer.parseInt(idParam);

            // Kiểm tra danh mục đã tồn tại chưa (trừ chính nó)
            if (courseDAO.categoryExists(name, id)) {
                request.setAttribute(ERROR_MSG, "Tên danh mục này đã được sử dụng");
                showEditForm(request, response);
                return;
            }

            // Cập nhật database
            boolean success = courseDAO.updateCategory(id, name);

            if (success) {
                request.setAttribute(SUCCESS_MSG, "Cập nhật danh mục thành công");
            } else {
                request.setAttribute(ERROR_MSG, "Cập nhật danh mục thất bại");
            }

            // Làm mới danh sách và hiển thị lại
            String courseId = request.getParameter("courseId");
            if (courseId != null && !courseId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
            } else {
                showEditForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute(ERROR_MSG, "ID danh mục không hợp lệ");
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        } catch (Exception e) {
            request.setAttribute(ERROR_MSG, "Lỗi khi cập nhật danh mục: " + e.getMessage());
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute(ERROR_MSG, "Thiếu ID danh mục");
                showEditForm(request, response);
                return;
            }

            int id = Integer.parseInt(idParam);

            // Kiểm tra xem danh mục có đang được sử dụng không
            if (courseDAO.isCategoryInUse(id)) {
                request.setAttribute(ERROR_MSG, "Không thể xóa danh mục đang được sử dụng");
                showEditForm(request, response);
                return;
            }

            // Xóa từ database
            boolean success = courseDAO.deleteCategory(id);

            if (success) {
                request.setAttribute(SUCCESS_MSG, "Xóa danh mục thành công");
            } else {
                request.setAttribute(ERROR_MSG, "Xóa danh mục thất bại");
            }

            // Làm mới danh sách và hiển thị lại
            String courseId = request.getParameter("courseId");
            if (courseId != null && !courseId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
            } else {
                showEditForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute(ERROR_MSG, "ID danh mục không hợp lệ");
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        } catch (Exception e) {
            request.setAttribute(ERROR_MSG, "Lỗi khi xóa danh mục: " + e.getMessage());
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<CourseCategory> categories = courseDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        } catch (Exception e) {
            request.setAttribute(ERROR_MSG, "Lỗi khi tải danh sách danh mục: " + e.getMessage());
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        }
    }

// Cập nhật phương thức showEditForm để load danh sách categories
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
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

            // Lấy categoryId của khóa học
            course.setCategories(courseDAO.getCourseCategories(id));

            List<CourseModule> modules = courseDAO.getCourseModules(id);
            List<CourseCategory> categories = courseDAO.getAllCategories();
            List<Course> courses = courseDAO.getAllCourses();

            request.setAttribute("currentCourse", course); // Đổi từ "course" sang "currentCourse"
            request.setAttribute("modules", modules);
            request.setAttribute("categories", categories);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute(ERROR_MSG, "ID khóa học không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/courseadmin?action=list");
        } catch (Exception e) {
            request.setAttribute(ERROR_MSG, e.getMessage());
            response.sendRedirect(request.getContextPath() + "/courseadmin?action=list");
        }
    }

//    private void listCourses(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        List<Course> courses = courseDAO.getAllCourses();
//        List<CourseCategory> categories = courseDAO.getAllCategories(); // Thêm dòng này
//        System.out.println("DEBUG: Total courses: " + (courses != null ? courses.size() : "null"));
//        System.out.println("DEBUG: Total categories: " + (categories != null ? categories.size() : "null"));
//
//        request.setAttribute("courses", courses);
//        request.setAttribute("categories", categories); // Thêm dòng này
//        request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
//    }
    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Course> courses = courseDAO.getAllCourses();
            List<CourseCategory> categories = courseDAO.getAllCategories();

            //System.out.println("DEBUG - Tổng số khóa học: " + (courses != null ? courses.size() : "null"));

            request.setAttribute("courses", courses);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            //System.err.println("LỖI LÚC LẤY DANH SÁCH KHÓA HỌC: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
        }
    }

    private void addCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số từ request
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String researcher = request.getParameter("researcher");
            String time = request.getParameter("time");
            int status = Integer.parseInt(request.getParameter("status"));
            String[] categoryIds = request.getParameterValues("categoryIds");

            // Validate dữ liệu
            if (title == null || title.trim().isEmpty()) {
                throw new ServletException("Tên khóa học không được để trống");
            }

            // Xử lý upload file
            Part filePart = request.getPart("thumbnail");
            String imagePath = null;

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                InputStream fileContent = filePart.getInputStream();
                imagePath = saveUploadedFile(fileName, fileContent);
            }

            // Tạo đối tượng Course
            Course newCourse = new Course();
            newCourse.setTitle(title);
            newCourse.setContent(content);
            newCourse.setResearcher(researcher);
            newCourse.setDuration(time);
            newCourse.setStatus(status);
            newCourse.setThumbnailUrl(imagePath);

            // Chuyển categoryIds từ String[] sang List<Integer>
            List<Integer> categories = new ArrayList<>();
            if (categoryIds != null) {
                for (String id : categoryIds) {
                    categories.add(Integer.parseInt(id));
                }
            }

            // Thêm vào database
            boolean success = courseDAO.addCourseWithCategories(newCourse, categories);

            if (success) {
                request.getSession().setAttribute("success", "Thêm khóa học thành công");
                response.sendRedirect("courseadmin");
            } else {
                request.setAttribute("error", "Thêm khóa học thất bại");
                request.getRequestDispatcher("courseAdd.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi thêm khóa học: " + e.getMessage());
            request.getRequestDispatcher("courseAdd.jsp").forward(request, response);
        }
    }

    private void updateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                throw new ServletException("ID khóa học không được để trống");
            }

            int id = Integer.parseInt(idParam);
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String researcher = request.getParameter("researcher");
            String time = request.getParameter("time");
            String statusParam = request.getParameter("status");

            if (title == null || content == null || researcher == null || time == null || statusParam == null) {
                throw new ServletException("Thiếu thông tin bắt buộc");
            }

            int status = Integer.parseInt(statusParam);

            Course course = new Course();
            course.setId(id);
            course.setTitle(title);
            course.setContent(content);
            course.setResearcher(researcher);
            course.setDuration(time);
            course.setStatus(status);

            // Handle file upload if new thumbnail is provided
            Part filePart = request.getPart("thumbnail");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                InputStream fileContent = filePart.getInputStream();
                String imagePath = saveUploadedFile(fileName, fileContent);
                course.setThumbnailUrl(imagePath);
            }

            boolean updated = courseDAO.updateCourse(course);
            if (!updated) {
                throw new ServletException("Cập nhật khóa học thất bại");
            }

            response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + id);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khóa học không hợp lệ");
            request.getRequestDispatcher("/courseAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi cập nhật: " + e.getMessage());
            request.getRequestDispatcher("/courseAdmin.jsp").forward(request, response);
        }
    }

    private void deleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        courseDAO.deleteCourse(id);
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=list");
    }

    private void toggleCourseStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseDetails(id);
        if (course != null) {
            int newStatus = course.getStatus() == 1 ? 0 : 1;
            courseDAO.updateCourseStatus(id, newStatus);
        }
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=list");
    }

    private void searchCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Course> courses = courseDAO.searchCourses(keyword);
        List<CourseCategory> categories = courseDAO.getAllCategories(); // Thêm dòng này

        request.setAttribute("courses", courses);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("categories", categories); // Thêm dòng này
        request.getRequestDispatcher("courseAdmin.jsp").forward(request, response);
    }

    private void addModule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");

        CourseModule module = new CourseModule();
        module.setCourseId(courseId);
        module.setTitle(title);
        module.setDescription(description);

        courseDAO.addModule(module);
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
    }

    private void updateModule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");

        CourseModule module = new CourseModule();
        module.setId(moduleId);
        module.setTitle(title);
        module.setDescription(description);

        courseDAO.updateModule(module);

        // Get courseId to redirect back to course edit page
        int courseId = courseDAO.getCourseIdByModuleId(moduleId);
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
    }

    private void deleteModule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("id"));
        int courseId = courseDAO.getCourseIdByModuleId(moduleId);
        courseDAO.deleteModule(moduleId);
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
    }

    private void addLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String videoUrl = request.getParameter("videoUrl");

        CourseLesson lesson = new CourseLesson();
        lesson.setModuleId(moduleId);
        lesson.setTitle(title);
        lesson.setContent(content);
        lesson.setVideoUrl(videoUrl);

        courseDAO.addLesson(lesson);

        // Redirect back to course edit page
        int courseId = courseDAO.getCourseIdByModuleId(moduleId);
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
    }

    private void updateLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String videoUrl = request.getParameter("videoUrl");

        CourseLesson lesson = new CourseLesson();
        lesson.setId(lessonId);
        lesson.setTitle(title);
        lesson.setContent(content);
        lesson.setVideoUrl(videoUrl);

        courseDAO.updateLesson(lesson);

        // Redirect back to course edit page
        int moduleId = courseDAO.getModuleIdByLessonId(lessonId);
        int courseId = courseDAO.getCourseIdByModuleId(moduleId);
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int lessonId = Integer.parseInt(request.getParameter("id"));
        int moduleId = courseDAO.getModuleIdByLessonId(lessonId);
        int courseId = courseDAO.getCourseIdByModuleId(moduleId);
        courseDAO.deleteLesson(lessonId);
        response.sendRedirect(request.getContextPath() + "/courseadmin?action=edit&id=" + courseId);
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
