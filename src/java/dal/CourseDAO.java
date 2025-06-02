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
import model.CourseImage;
import model.CourseLesson;
import model.CourseModule;
import model.CourseReview;
import model.LessonAttachment;
import model.User;

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
                        rs.getString("name"),
                        rs.getString("description")
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
        String sql = "SELECT id, title, content, post_date, researcher, duration, status, video_url, thumbnail_url, created_at, updated_at FROM courses";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setContent(rs.getString("content"));
                course.setPostDate(rs.getDate("post_date"));
                course.setResearcher(rs.getString("researcher"));
                course.setDuration(rs.getString("duration"));
                course.setStatus(rs.getInt("status"));
                course.setVideoUrl(rs.getString("video_url"));
                course.setThumbnailUrl(rs.getString("thumbnail_url"));
                course.setCreatedAt(rs.getTimestamp("created_at"));
                course.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Lấy danh mục cho từng khóa học
                course.setCategories(getCategoriesByCourseId(course.getId()));

                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách khóa học: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    private List<CourseCategory> getCategoriesByCourseId(int courseId) throws SQLException {
        List<CourseCategory> categories = new ArrayList<>();
        String sql = "SELECT cc.id, cc.name FROM course_category_mapping ccm "
                + "JOIN course_categories cc ON ccm.category_id = cc.id "
                + "WHERE ccm.course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CourseCategory cat = new CourseCategory();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                categories.add(cat);
            }
        }
        return categories;
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
                    course.setPostDate(rs.getDate("post_date")); // Sửa tại đây
                    courses.add(course);
                }
            }
        }
        return courses;
    }

// Lấy danh sách khóa học phổ biến
    public List<Course> getPopularCourses(int limit) {
        String sql = "SELECT TOP (?) c.id, c.title, c.content, c.post_date, c.researcher, "
                + "c.duration, c.status, c.video_url, "
                + "COALESCE(ci.image_url, c.thumbnail_url, '/images/corgin-1.jpg') AS thumbnail_url "
                + "FROM courses c "
                + "LEFT JOIN course_images ci ON c.id = ci.course_id AND ci.is_primary = 1 "
                + "LEFT JOIN course_access ca ON c.id = ca.course_id "
                + "WHERE c.status = 1 "
                + "GROUP BY c.id, c.title, c.content, c.post_date, c.researcher, "
                + "c.duration, c.status, c.video_url, ci.image_url, c.thumbnail_url "
                + "ORDER BY COUNT(ca.course_id) DESC";

        List<Course> list = new ArrayList<>();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setContent(rs.getString("content"));
                c.setPostDate(rs.getDate("post_date"));
                c.setResearcher(rs.getString("researcher"));
                c.setVideoUrl(rs.getString("video_url"));
                c.setThumbnailUrl(rs.getString("thumbnail_url")); // ✅ Dùng thumbnailUrl
                c.setDuration(rs.getString("duration"));
                c.setStatus(rs.getInt("status"));

                // Gọi hàm phụ để lấy danh mục đúng kiểu List<CourseCategory>
                c.setCategories(getCategoriesByCourseId(c.getId()));

                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy khóa học phổ biến: " + e.getMessage());
            e.printStackTrace();
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

    public Course getCourseById(int courseId) throws SQLException {
        String sql = "SELECT * FROM Courses WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setContent(rs.getString("content"));
                    course.setDuration(rs.getString("duration"));
                    course.setResearcher(rs.getString("researcher"));
                    course.setThumbnailUrl(rs.getString("thumbnail_url"));
                    // Thêm các trường khác nếu cần
                    return course;
                }
            }
        }
        return null; // hoặc throw exception nếu không tìm thấy
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
            st.setString(4, course.getDuration());
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
                CourseModule module = new CourseModule(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("order_index"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );

                // Gán thêm danh sách lessons nếu cần
                module.setLessons(getLessonsByModuleId(moduleId));
                return module;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<CourseLesson> getLessonsByModuleId(int moduleId) {
        List<CourseLesson> list = new ArrayList<>();
        String sql = "SELECT * FROM course_lessons WHERE module_id = ? ORDER BY order_index ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CourseLesson lesson = new CourseLesson(
                        rs.getInt("id"),
                        rs.getInt("module_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("video_url"),
                        rs.getInt("duration"),
                        rs.getInt("order_index"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );

                // Gán attachments nếu cần
                lesson.setAttachments(getAttachmentsByLessonId(rs.getInt("id")));
                list.add(lesson);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<LessonAttachment> getAttachmentsByLessonId(int lessonId) {
        List<LessonAttachment> list = new ArrayList<>();
        String sql = "SELECT * FROM lesson_attachments WHERE lesson_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new LessonAttachment(
                        rs.getInt("id"),
                        rs.getInt("lesson_id"),
                        rs.getString("file_name"),
                        rs.getString("file_url"),
                        rs.getInt("file_size")
                ));

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "COALESCE(ci.image_url, c.thumbnail_url, '/images/corgin-1.jpg') AS thumbnail_url "
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
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setContent(rs.getString("content"));
                c.setPostDate(rs.getDate("post_date")); // ✅ đúng kiểu Date
                c.setResearcher(rs.getString("researcher"));
                c.setThumbnailUrl(rs.getString("thumbnail_url")); // ✅ đúng tên biến
                c.setDuration(rs.getString("duration")); // ✅ sửa lại từ 'time' sang 'duration'
                c.setStatus(rs.getInt("status"));

                // Lấy danh mục theo đúng kiểu List<CourseCategory>
                c.setCategories(getCategoriesByCourseId(c.getId()));

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

    // Thay đổi từ course_category_course sang course_category_mapping
    private boolean addCourseCategory(int courseId, int categoryId) {
        String sql = "INSERT INTO course_category_mapping (course_id, category_id) VALUES (?, ?)";
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
                + "JOIN course_category_mapping ccm ON cc.id = ccm.category_id "
                + "WHERE ccm.course_id = ?";
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

    public int addCourse(String title, String content, String researcher, String videoUrl,
            String duration, String thumbnailUrl, List<Integer> categoryIds) throws SQLException {
        int courseId = -1;
        try {
            connection.setAutoCommit(false);

            String insertCourseSQL = "INSERT INTO courses (title, content, post_date, researcher, video_url, status, duration, thumbnail_url) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement courseStmt = connection.prepareStatement(insertCourseSQL, Statement.RETURN_GENERATED_KEYS)) {
                courseStmt.setString(1, title);
                courseStmt.setString(2, content);
                courseStmt.setDate(3, new java.sql.Date(System.currentTimeMillis()));
                courseStmt.setString(4, researcher);
                courseStmt.setString(5, videoUrl);
                courseStmt.setInt(6, 1); // status = active
                courseStmt.setString(7, duration);
                courseStmt.setString(8, thumbnailUrl);
                courseStmt.executeUpdate();

                try (ResultSet generatedKeys = courseStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        courseId = generatedKeys.getInt(1);
                    }
                }
            }

            if (courseId != -1 && categoryIds != null && !categoryIds.isEmpty()) {
                String insertMappingSQL = "INSERT INTO course_category_mapping (course_id, category_id) VALUES (?, ?)";
                try (PreparedStatement mappingStmt = connection.prepareStatement(insertMappingSQL)) {
                    for (int categoryId : categoryIds) {
                        mappingStmt.setInt(1, courseId);
                        mappingStmt.setInt(2, categoryId);
                        mappingStmt.addBatch();
                    }
                    mappingStmt.executeBatch();
                }
            }

            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
        return courseId;
    }

    public boolean addImage(int courseId, String imageUrl, boolean isPrimary) {
        String sql = "INSERT INTO course_images (course_id, image_url, is_primary) VALUES (?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            st.setString(2, imageUrl);
            st.setBoolean(3, isPrimary);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Thêm hàm lấy danh sách hình ảnh của khóa học
    public List<CourseImage> getCourseImages(int courseId) {
        List<CourseImage> images = new ArrayList<>();
        String sql = "SELECT * FROM course_images WHERE course_id = ? ORDER BY is_primary DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseImage image = new CourseImage(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_primary"),
                        rs.getTimestamp("created_at")
                );
                images.add(image);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

    // Thêm hàm lấy đánh giá khóa học
    public List<CourseReview> getCourseReviews(int courseId) {
        List<CourseReview> reviews = new ArrayList<>();
        String sql = "SELECT cr.*, u.fullname FROM course_reviews cr "
                + "JOIN users u ON cr.user_id = u.id "
                + "WHERE cr.course_id = ? ORDER BY cr.created_at DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseReview review = new CourseReview(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getInt("user_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        rs.getTimestamp("created_at")
                );

                // Thêm thông tin user
                User user = new User();
                user.setFullname(rs.getString("fullname"));
                review.setUser(user);

                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Cập nhật hàm getCourseDetails để lấy đầy đủ thông tin
    public Course getCourseDetails(int courseId) {
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "COALESCE(c.thumbnail_url, '/images/corgin-1.jpg') AS thumbnail_url "
                + "FROM courses c "
                + "WHERE c.id = ? AND c.status = 1";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setContent(rs.getString("content"));
                course.setPostDate(rs.getDate("post_date"));
                course.setResearcher(rs.getString("researcher"));
                course.setDuration(rs.getString("duration"));
                course.setStatus(rs.getInt("status"));
                course.setThumbnailUrl(rs.getString("thumbnail_url"));

                // Lấy danh mục khóa học
                course.setCategories(getCategoriesByCourseId(course.getId()));

                return course;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy chi tiết khóa học: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Thêm hàm cập nhật thông tin khóa học đầy đủ
    public boolean updateCourse(Course course) {
        String sql = "UPDATE courses SET title = ?, content = ?, researcher = ?, "
                + "video_url = ?, status = ?, duration = ?, thumbnail_url = ?, "
                + "updated_at = GETDATE() WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, course.getTitle());
            st.setString(2, course.getContent());
            st.setString(3, course.getResearcher());
            st.setString(4, course.getVideoUrl());
            st.setInt(5, course.getStatus());
            st.setString(6, course.getDuration());
            st.setString(7, course.getThumbnailUrl());
            st.setInt(8, course.getId());

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Thêm hàm xóa hình ảnh khóa học
    public boolean deleteCourseImage(int imageId) {
        String sql = "DELETE FROM course_images WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, imageId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
