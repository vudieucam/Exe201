/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.CourseCategory;
import model.CourseLesson;
import model.CourseModule;

/**
 *
 * @author FPT
 */
public class CourseDAO extends DBConnect {

    public boolean addCategory(String name) {
        String sql = "INSERT INTO course_categories (name) VALUES (?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding category: " + e.getMessage());
            return false;
        }
    }

    public boolean updateCategory(int id, String name) {
        String sql = "UPDATE course_categories SET name = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteCategory(int id) {
        if (isCategoryInUse(id)) {
            System.err.println("Cannot delete category in use");
            return false;
        }

        String sql = "DELETE FROM course_categories WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            return false;
        }
    }

    public List<CourseCategory> getAllCategories() {
        List<CourseCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM course_categories ORDER BY name";

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.add(new CourseCategory(
                        rs.getInt("id"),
                        rs.getString("name")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error getting categories: " + e.getMessage());
        }
        return categories;
    }

    public boolean categoryExists(String name) {
        String sql = "SELECT COUNT(*) FROM course_categories WHERE name = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("Error checking category exists: " + e.getMessage());
            return false;
        }
    }

    public boolean categoryExists(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM course_categories WHERE name = ? AND id != ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setInt(2, excludeId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("Error checking category exists: " + e.getMessage());
            return false;
        }
    }

    public boolean isCategoryInUse(int categoryId) {
        String sql = "SELECT COUNT(*) FROM courses WHERE category_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("Error checking category in use: " + e.getMessage());
            return false;
        }
    }

    public boolean updateCourseCategory(int courseId, int categoryId) {
        String sql = "UPDATE courses SET category_id = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            stmt.setInt(2, courseId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating course category: " + e.getMessage());
            return false;
        }
    }

// Lấy toàn bộ khóa học
    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        // Sử dụng FOR XML PATH để nối các danh mục thành chuỗi
        String sql = "SELECT c.id, c.title, c.researcher, c.duration AS time, c.status, "
                + "STUFF((SELECT ', ' + cc.name "
                + "       FROM course_category_mapping ccm "
                + "       JOIN course_categories cc ON ccm.category_id = cc.id "
                + "       WHERE ccm.course_id = c.id "
                + "       FOR XML PATH('')), 1, 2, '') AS categories "
                + "FROM courses c";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setResearcher(rs.getString("researcher"));
                course.setTime(rs.getString("time"));
                course.setStatus(rs.getInt("status"));
                course.setCategories(rs.getString("categories")); // Lưu ý: có thể null nếu không có danh mục
                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách khóa học: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Lấy chi tiết khóa học


    public Course getCourseDetails(int courseId) {
        String sql = "SELECT c.*, "
                + "STUFF((SELECT ', ' + cc.name "
                + "       FROM course_category_mapping ccm "
                + "       JOIN course_categories cc ON ccm.category_id = cc.id "
                + "       WHERE ccm.course_id = c.id "
                + "       FOR XML PATH('')), 1, 2, '') AS categories "
                + "FROM courses c WHERE c.id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setContent(rs.getString("content"));
                course.setPostDate(rs.getString("post_date"));
                course.setResearcher(rs.getString("researcher"));
                course.setTime(rs.getString("duration")); // Sửa thành duration
                course.setStatus(rs.getInt("status"));
                course.setImageUrl(rs.getString("thumbnail_url")); // Thêm thumbnail
                course.setCategories(rs.getString("categories"));
                return course;
            }
        } catch (SQLException e) {
            System.out.println("ERROR in getCourseDetails: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<CourseModule> getCourseModules(int courseId) {
        List<CourseModule> modules = new ArrayList<>();
        String sql = "SELECT * FROM course_modules WHERE course_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseModule module = new CourseModule();
                module.setId(rs.getInt("id"));
                module.setCourseId(courseId);
                module.setTitle(rs.getString("title"));
                module.setDescription(rs.getString("description"));

                modules.add(module);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return modules;
    }

    // Đếm tổng số khóa học
    public long countAllCourses() throws SQLException {
        String sql = "SELECT COUNT(*) FROM courses";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
            return 0;
        }
    }

    // Lấy danh sách khóa học gần đây
    public List<Course> getRecentCourses(int limit) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM courses ORDER BY post_date DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setPostDate(rs.getDate("post_date").toString()); // Convert Date to String
                    courses.add(course);
                }
            }
        }
        return courses;
    }

// Lấy danh sách khóa học phổ biến
    public List<Course> getPopularCourses(int limit) {
        String sql = "SELECT TOP (?) c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "COALESCE(ci.image_url, '/images/corgin-1.jpg') AS image_url "
                + "FROM courses c "
                + "LEFT JOIN course_images ci ON c.id = ci.course_id AND ci.is_primary = 1 "
                + "LEFT JOIN course_access ca ON c.id = ca.course_id "
                + "WHERE c.status = 1 "
                + "GROUP BY c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, ci.image_url "
                + "ORDER BY COUNT(ca.id) DESC";
        List<Course> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("post_date"),
                        rs.getString("researcher"),
                        rs.getString("image_url"),
                        rs.getString("time"),
                        rs.getInt("status"),
                        rs.getString("categories") // Thêm categories vào constructor
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public int getAccessCount(int courseId) {
        String sql = "SELECT COUNT(*) AS access_count FROM course_access WHERE course_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("access_count");
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }

    public int getCompletionRate(int courseId) {
        // Giả sử chúng ta có bảng user_progress để theo dõi tiến độ học tập
        String sql = "SELECT COUNT(DISTINCT up.user_id) * 100 / "
                + "(SELECT COUNT(DISTINCT ca.user_id) FROM course_access ca WHERE ca.course_id = ?) AS completion_rate "
                + "FROM user_progress up "
                + "JOIN course_lessons cl ON up.lesson_id = cl.id "
                + "JOIN course_modules cm ON cl.module_id = cm.id "
                + "WHERE cm.course_id = ? AND up.completed = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, courseId);
            st.setInt(2, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("completion_rate");
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }

    public int addCourse(String title, String content, String researcher, String videoUrl,
            String duration, String thumbnailUrl, List<Integer> categoryIds) throws SQLException {
        int courseId = -1;
        try {
            connection.setAutoCommit(false); // Bắt đầu transaction

            // 1. Thêm khóa học vào bảng `courses`
            String insertCourseSQL = "INSERT INTO courses (title, content, post_date, researcher, video_url, status, duration, thumbnail_url) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement courseStmt = connection.prepareStatement(insertCourseSQL, Statement.RETURN_GENERATED_KEYS)) {
                courseStmt.setString(1, title);
                courseStmt.setString(2, content);
                courseStmt.setDate(3, new java.sql.Date(System.currentTimeMillis())); // Ngày hiện tại
                courseStmt.setString(4, researcher);
                courseStmt.setString(5, videoUrl);
                courseStmt.setInt(6, 1); // status = 1 (active)
                courseStmt.setString(7, duration);
                courseStmt.setString(8, thumbnailUrl);
                courseStmt.executeUpdate();

                // Lấy ID của khóa học vừa thêm
                try (ResultSet generatedKeys = courseStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        courseId = generatedKeys.getInt(1);
                    }
                }
            }

            // 2. Thêm các danh mục vào `course_category_mapping`
            if (courseId != -1 && categoryIds != null && !categoryIds.isEmpty()) {
                String insertMappingSQL = "INSERT INTO course_category_mapping (course_id, category_id) VALUES (?, ?)";
                try (PreparedStatement mappingStmt = connection.prepareStatement(insertMappingSQL)) {
                    for (int categoryId : categoryIds) {
                        mappingStmt.setInt(1, courseId);
                        mappingStmt.setInt(2, categoryId);
                        mappingStmt.addBatch(); // Thêm vào batch để thực thi cùng lúc
                    }
                    mappingStmt.executeBatch(); // Thực thi tất cả
                }
            }

            connection.commit(); // Commit transaction nếu thành công
        } catch (SQLException e) {
            connection.rollback(); // Rollback nếu có lỗi
            throw e;
        } finally {
            connection.setAutoCommit(true); // Reset auto-commit
        }
        return courseId;
    }

    public int getLastInsertedCourseId() throws SQLException {
        String sql = "SELECT LAST_INSERT_ID()";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1; // Trả về -1 nếu không lấy được ID
        }
    }

    public Integer getCourseCategoryId(int courseId) {
        String sql = "SELECT TOP 1 category_id FROM course_category_mapping WHERE course_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("category_id");
            }
            return null;
        } catch (SQLException e) {
            System.err.println("Error getting course category: " + e.getMessage());
            return null;
        }
    }

    public boolean updateCourse(Course course) {
        String sql = "UPDATE courses SET title = ?, content = ?, researcher = ?, status = ?, duration = ?, thumbnail_url = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, course.getTitle());
            st.setString(2, course.getContent());
            st.setString(3, course.getResearcher());
            st.setInt(4, course.getStatus());
            st.setString(5, course.getTime());
            st.setString(6, course.getImageUrl());
            st.setInt(7, course.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCourse(int id) {
        String sql = "DELETE FROM courses WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCourseStatus(int id, int status) {
        String sql = "UPDATE courses SET status = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, status);
            st.setInt(2, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addModule(CourseModule module) {
        String sql = "INSERT INTO course_modules (course_id, title, description, order_index) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, module.getCourseId());
            st.setString(2, module.getTitle());
            st.setString(3, module.getDescription());
            st.setInt(4, module.getOrderIndex());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addLesson(CourseLesson lesson) {
        String sql = "INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lesson.getModuleId());
            st.setString(2, lesson.getTitle());
            st.setString(3, lesson.getContent());
            st.setString(4, lesson.getVideoUrl());
            st.setInt(5, lesson.getDuration());
            st.setInt(6, lesson.getOrderIndex());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getCourseIdByModuleId(int moduleId) {
        String sql = "SELECT course_id FROM course_modules WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("course_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int addCourseWithCategory(Course course, int categoryId) {
        String sql = "INSERT INTO courses (title, content, post_date, researcher, time, status) VALUES (?, ?, GETDATE(), ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, course.getTitle());
            st.setString(2, course.getContent());
            st.setString(3, course.getResearcher());
            st.setString(4, course.getTime());
            st.setInt(5, course.getStatus());

            int affectedRows = st.executeUpdate();
            if (affectedRows == 0) {
                return 0;
            }

            try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int courseId = generatedKeys.getInt(1);
                    // Thêm liên kết với danh mục
                    addCourseCategory(courseId, categoryId);
                    return courseId;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private boolean addCourseCategory(int courseId, int categoryId) {
        String sql = "INSERT INTO course_category_course (course_id, category_item_id) VALUES (?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            st.setInt(2, categoryId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCourseTitleExists(String title) {
        String sql = "SELECT COUNT(*) FROM Courses WHERE title = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, title);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public List<CourseCategory> getAllCourseCategories() {
        List<CourseCategory> categories = new ArrayList<>();
        String sql = "SELECT id, name FROM course_categories";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                CourseCategory category = new CourseCategory();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                categories.add(category);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return categories;
    }

    // Thêm vào class CourseDAO
// ========== CÁC PHƯƠNG THỨC CHO MODULE ==========
    public boolean updateModule(CourseModule module) {
        String sql = "UPDATE course_modules SET title = ?, description = ?, order_index = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, module.getTitle());
            st.setString(2, module.getDescription());
            st.setInt(3, module.getOrderIndex());
            st.setInt(4, module.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteModule(int moduleId) {
        // Xóa tất cả lesson thuộc module trước
        deleteLessonsByModule(moduleId);

        String sql = "DELETE FROM course_modules WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void deleteLessonsByModule(int moduleId) {
        String sql = "DELETE FROM course_lessons WHERE module_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public CourseModule getModuleById(int moduleId) {
        String sql = "SELECT * FROM course_modules WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new CourseModule(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("order_index")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

// ========== CÁC PHƯƠNG THỨC CHO LESSON ==========
    public boolean updateLesson(CourseLesson lesson) {
        String sql = "UPDATE course_lessons SET title = ?, content = ?, video_url = ?, "
                + "duration = ?, order_index = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, lesson.getTitle());
            st.setString(2, lesson.getContent());
            st.setString(3, lesson.getVideoUrl());
            st.setInt(4, lesson.getDuration());
            st.setInt(5, lesson.getOrderIndex());
            st.setInt(6, lesson.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteLesson(int lessonId) {
        String sql = "DELETE FROM course_lessons WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getModuleIdByLessonId(int lessonId) {
        String sql = "SELECT module_id FROM course_lessons WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("module_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

// ========== CÁC PHƯƠNG THỨC HỖ TRỢ KHÁC ==========
    public List<Course> searchCourses(String keyword) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.time, c.status, "
                + "COALESCE(ci.image_url, '/images/corgin-1.jpg') AS image_url "
                + "FROM courses c "
                + "LEFT JOIN course_images ci ON c.id = ci.course_id AND ci.is_primary = 1 "
                + "WHERE c.title LIKE ? OR c.content LIKE ? OR c.researcher LIKE ? "
                + "ORDER BY c.id";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchParam = "%" + keyword + "%";
            st.setString(1, searchParam);
            st.setString(2, searchParam);
            st.setString(3, searchParam);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("post_date"),
                        rs.getString("researcher"),
                        rs.getString("image_url"),
                        rs.getString("time"),
                        rs.getInt("status"),
                        rs.getString("categories") // Thêm categories vào constructor
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

// ========== CÁC PHƯƠNG THỨC CHO HÌNH ẢNH KHÓA HỌC ==========
    public boolean setPrimaryImage(int courseId, int imageId) {
        try {
            // Bỏ chọn tất cả ảnh hiện tại
            String resetSql = "UPDATE course_images SET is_primary = 0 WHERE course_id = ?";
            try (PreparedStatement resetStmt = connection.prepareStatement(resetSql)) {
                resetStmt.setInt(1, courseId);
                resetStmt.executeUpdate();
            }

            // Đặt ảnh mới làm ảnh chính
            String setSql = "UPDATE course_images SET is_primary = 1 WHERE id = ? AND course_id = ?";
            try (PreparedStatement setStmt = connection.prepareStatement(setSql)) {
                setStmt.setInt(1, imageId);
                setStmt.setInt(2, courseId);
                return setStmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteImage(int imageId) {
        String sql = "DELETE FROM course_images WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, imageId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<String> getCourseImages(int courseId) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT image_url FROM course_images WHERE course_id = ? ORDER BY is_primary DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                images.add(rs.getString("image_url"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

// ========== CÁC PHƯƠNG THỨC CHO DANH MỤC KHÓA HỌC ==========
    public boolean addCategoryToCourse(int courseId, int categoryId) {
        String sql = "INSERT INTO course_category_course (course_id, category_item_id) VALUES (?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            st.setInt(2, categoryId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeCategoryFromCourse(int courseId, int categoryId) {
        String sql = "DELETE FROM course_category_course WHERE course_id = ? AND category_item_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            st.setInt(2, categoryId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CourseCategory> getCourseCategories(int courseId) {
        List<CourseCategory> categories = new ArrayList<>();
        String sql = "SELECT cc.id, cc.name FROM course_categories cc "
                + "JOIN course_category_course ccc ON cc.id = ccc.category_item_id "
                + "WHERE ccc.course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CourseCategory category = new CourseCategory();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
}
