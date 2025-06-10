/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Timestamp;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Course;
import model.CourseImage;
import model.CourseLesson;
import model.CourseModule;
import model.CourseReview;
import model.LessonAttachment;

public class CourseDAO extends DBConnect {

    private CourseCategoryDAO courseCategoryDAO; // Thêm dòng này
    // Thêm constructor để khởi tạo các DAO

    public CourseDAO() {
        try {
            this.courseCategoryDAO = new CourseCategoryDAO(); // Khởi tạo courseCategoryDAO
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Course mapCourseFromResultSet(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setId(rs.getInt("id"));
        course.setTitle(rs.getString("title"));
        course.setContent(rs.getString("content"));
        course.setPostDate(rs.getDate("post_date"));
        course.setResearcher(rs.getString("researcher"));
        course.setDuration(rs.getString("duration"));
        course.setStatus(rs.getBoolean("status") ? 1 : 0);
        course.setVideoUrl(rs.getString("video_url"));
        course.setThumbnailUrl(rs.getString("thumbnail_url"));
        course.setCreatedAt(rs.getTimestamp("created_at"));
        course.setUpdatedAt(rs.getTimestamp("updated_at"));
        course.setIsPaid(rs.getBoolean("is_paid"));
        return course;
    }

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT id, title, content, post_date, researcher, duration, status, video_url, "
                + "thumbnail_url, created_at, updated_at, is_paid FROM courses";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = mapCourseFromResultSet(rs);

                // Get categories for each course
                course.setCategories(courseCategoryDAO.getCategoriesByCourseId(course.getId()));
                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách khóa học: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> getRecentCourses(int limit) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM courses ORDER BY post_date DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = mapCourseFromResultSet(rs);
                    courses.add(course);
                }
            }
        }
        return courses;
    }

    public List<Course> getPopularCourses(int limit) {
        String sql = "SELECT TOP (?) c.*, "
                + "COALESCE(ci.image_url, c.thumbnail_url, '/images/corgin-1.jpg') AS thumbnail_url "
                + "FROM courses c "
                + "LEFT JOIN course_images ci ON c.id = ci.course_id AND ci.is_primary = 1 "
                + "LEFT JOIN course_access ca ON c.id = ca.course_id "
                + "WHERE c.status = 1 "
                + "GROUP BY c.id, c.title, c.content, c.post_date, c.researcher, "
                + "c.duration, c.status, c.video_url, c.thumbnail_url, c.created_at, "
                + "c.updated_at, c.is_paid, ci.image_url "
                + "ORDER BY COUNT(ca.course_id) DESC";

        List<Course> list = new ArrayList<>();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = mapCourseFromResultSet(rs);
                course.setThumbnailUrl(rs.getString("thumbnail_url"));

                course.setCategories(courseCategoryDAO.getCategoriesByCourseId(course.getId()));
                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy khóa học phổ biến: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int getAccessCount(int courseId) {
        String sql = "SELECT COUNT(*) AS access_count FROM course_access WHERE course_id = ? AND status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
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
        String sql = "SELECT COUNT(DISTINCT up.user_id) * 100 / "
                + "(SELECT COUNT(DISTINCT ca.user_id) FROM course_access ca WHERE ca.course_id = ? AND ca.status = 1) AS completion_rate "
                + "FROM user_progress up "
                + "JOIN course_lessons cl ON up.lesson_id = cl.id AND cl.status = 1 "
                + "JOIN course_modules cm ON cl.module_id = cm.id AND cm.status = 1 "
                + "WHERE cm.course_id = ? AND up.completed = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
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

    public Course getCourseById(int courseId) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Course course = mapCourseFromResultSet(rs);

                    // Get additional course details
                    course.setCategories(courseCategoryDAO.getCategoriesByCourseId(courseId));
                    course.setImages(getCourseImages(courseId));
                    course.setModules(getCourseModules(courseId));
                    course.setReviews(getCourseReviews(courseId));

                    return course;
                }
            }
        }
        return null;
    }

    public boolean courseExists(int courseId) {
        String sql = "SELECT 1 FROM courses WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCourseTitleExists(String title) {
        String sql = "SELECT COUNT(*) FROM courses WHERE title = ?";
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

    public List<Course> searchCourses(String keyword) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.*, "
                + "COALESCE(ci.image_url, c.thumbnail_url, '/images/corgin-1.jpg') AS thumbnail_url "
                + "FROM courses c "
                + "LEFT JOIN course_images ci ON c.id = ci.course_id AND ci.is_primary = 1 "
                + "WHERE (c.title LIKE ? OR c.content LIKE ? OR c.researcher LIKE ?) "
                + "AND c.status = 1 "
                + "ORDER BY c.id";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchParam = "%" + keyword + "%";
            st.setString(1, searchParam);
            st.setString(2, searchParam);
            st.setString(3, searchParam);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course course = mapCourseFromResultSet(rs);
                course.setThumbnailUrl(rs.getString("thumbnail_url"));

                course.setCategories(courseCategoryDAO.getCategoriesByCourseId(course.getId()));
                list.add(course);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int addCourse(String title, String content, String researcher, String videoUrl,
            String duration, String thumbnailUrl, boolean isPaid, List<Integer> categoryIds) throws SQLException {
        int courseId = -1;
        try {
            connection.setAutoCommit(false);

            String insertCourseSQL = "INSERT INTO courses (title, content, post_date, researcher, video_url, "
                    + "status, duration, thumbnail_url, is_paid) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement courseStmt = connection.prepareStatement(insertCourseSQL,
                    Statement.RETURN_GENERATED_KEYS)) {
                courseStmt.setString(1, title);
                courseStmt.setString(2, content);
                courseStmt.setDate(3, new java.sql.Date(System.currentTimeMillis()));
                courseStmt.setString(4, researcher);
                courseStmt.setString(5, videoUrl);
                courseStmt.setBoolean(6, true); // status = active
                courseStmt.setString(7, duration);
                courseStmt.setString(8, thumbnailUrl);
                courseStmt.setBoolean(9, isPaid);
                courseStmt.executeUpdate();

                try (ResultSet generatedKeys = courseStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        courseId = generatedKeys.getInt(1);
                    }
                }
            }

            if (courseId != -1 && categoryIds != null && !categoryIds.isEmpty()) {
                courseCategoryDAO.addCourseCategories(courseId, categoryIds);
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

    // Helper methods to get related entities
    private List<CourseImage> getCourseImages(int courseId) throws SQLException {
        List<CourseImage> images = new ArrayList<>();
        String sql = "SELECT * FROM course_images WHERE course_id = ? AND status = 1 ORDER BY is_primary DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseImage image = new CourseImage();
                image.setId(rs.getInt("id"));
                image.setCourseId(rs.getInt("course_id"));
                image.setImageUrl(rs.getString("image_url"));
                image.setIsPrimary(rs.getBoolean("is_primary"));
                image.setCreatedAt(rs.getTimestamp("created_at"));
                images.add(image);
            }
        }
        return images;
    }

    public List<CourseModule> getCourseModules(int courseId) throws SQLException {
        List<CourseModule> modules = new ArrayList<>();
        String sql = "SELECT * FROM course_modules WHERE course_id = ? AND status = 1 ORDER BY order_index";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseModule module = new CourseModule();
                module.setId(rs.getInt("id"));
                module.setCourseId(rs.getInt("course_id"));
                module.setTitle(rs.getString("title"));
                module.setDescription(rs.getString("description"));
                module.setOrderIndex(rs.getInt("order_index"));
                module.setCreatedAt(rs.getTimestamp("created_at"));
                module.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Get lessons for this module
                module.setLessons(getModuleLessons(module.getId()));

                modules.add(module);
            }
        }
        return modules;
    }

    private List<CourseLesson> getModuleLessons(int moduleId) throws SQLException {
        List<CourseLesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM course_lessons WHERE module_id = ? AND status = 1 ORDER BY order_index";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, moduleId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseLesson lesson = new CourseLesson();
                lesson.setId(rs.getInt("id"));
                lesson.setModuleId(rs.getInt("module_id"));
                lesson.setTitle(rs.getString("title"));
                lesson.setContent(rs.getString("content"));
                lesson.setVideoUrl(rs.getString("video_url"));
                lesson.setDuration(rs.getInt("duration"));
                lesson.setOrderIndex(rs.getInt("order_index"));
                lesson.setCreatedAt(rs.getTimestamp("created_at"));
                lesson.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Get attachments for this lesson
                lesson.setAttachments(getLessonAttachments(lesson.getId()));

                lessons.add(lesson);
            }
        }
        return lessons;
    }

    private List<LessonAttachment> getLessonAttachments(int lessonId) throws SQLException {
        List<LessonAttachment> attachments = new ArrayList<>();
        String sql = "SELECT * FROM lesson_attachments WHERE lesson_id = ? AND status = 1";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, lessonId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LessonAttachment attachment = new LessonAttachment();
                attachment.setId(rs.getInt("id"));
                attachment.setLessonId(rs.getInt("lesson_id"));
                attachment.setFileName(rs.getString("file_name"));
                attachment.setFileUrl(rs.getString("file_url"));
                attachment.setFileSize(rs.getInt("file_size"));
                attachments.add(attachment);
            }
        }
        return attachments;
    }

    private List<CourseReview> getCourseReviews(int courseId) throws SQLException {
        List<CourseReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM course_reviews WHERE course_id = ? AND status = 1 ORDER BY created_at DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseReview review = new CourseReview();
                review.setId(rs.getInt("id"));
                review.setCourseId(rs.getInt("course_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                reviews.add(review);
            }
        }
        return reviews;
    }

    public Course getCourseDetail(int courseId) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setContent(rs.getString("content"));
                course.setResearcher(rs.getString("researcher"));
                course.setDuration(rs.getString("duration"));
                course.setStatus(rs.getInt("status"));
                course.setThumbnailUrl(rs.getString("thumbnail_url"));

                CourseCategoryDAO categoryDAO = new CourseCategoryDAO();
                course.setCategories(categoryDAO.getCategoriesByCourseId(courseId));

                Timestamp ts = rs.getTimestamp("updated_at");
                if (ts != null) {
                    course.setUpdatedAt(new Date(ts.getTime()));
                }

                return course;
            }
        }
        return null;
    }

    // Đếm tổng số khóa học
    public long countAllCourses() {
        String sql = "SELECT COUNT(*) FROM courses WHERE status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Đếm số khóa học đang hoạt động
    public int countActiveCourses() {
        String sql = "SELECT COUNT(*) FROM courses WHERE status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Lấy top khóa học xem nhiều nhất
    public List<Map<String, Object>> getMostViewedCourses(int limit) {
        List<Map<String, Object>> courses = new ArrayList<>();
        String sql = "SELECT TOP (?) c.id, c.title, cs.views, cs.avg_view_duration "
                + "FROM courses c "
                + "JOIN ("
                + "    SELECT course_id, SUM(views) as views, "
                + "           AVG(avg_view_duration) as avg_view_duration "
                + "    FROM course_statistics "
                + "    GROUP BY course_id"
                + ") cs ON c.id = cs.course_id "
                + "WHERE c.status = 1 "
                + "ORDER BY cs.views DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> course = new HashMap<>();
                    course.put("id", rs.getInt("id"));
                    course.put("title", rs.getString("title"));
                    course.put("views", rs.getInt("views"));
                    course.put("avgViewDuration", rs.getInt("avg_view_duration"));
                    courses.add(course);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return courses;
    }

    // Lấy top khóa học đánh giá cao nhất
    public List<Map<String, Object>> getHighestRatedCourses(int limit) {
        List<Map<String, Object>> courses = new ArrayList<>();
        String sql = "SELECT TOP (?) c.id, c.title, "
                + "AVG(cr.rating) as rating, COUNT(cr.id) as review_count, "
                + "(SELECT COUNT(*) FROM user_progress up "
                + " JOIN course_lessons cl ON up.lesson_id = cl.id "
                + " JOIN course_modules cm ON cl.module_id = cm.id "
                + " WHERE cm.course_id = c.id) as enrollments "
                + "FROM courses c "
                + "LEFT JOIN course_reviews cr ON c.id = cr.course_id "
                + "WHERE c.status = 1 AND cr.status = 1 "
                + "GROUP BY c.id, c.title "
                + "ORDER BY rating DESC, review_count DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> course = new HashMap<>();
                    course.put("id", rs.getInt("id"));
                    course.put("title", rs.getString("title"));
                    course.put("rating", rs.getDouble("rating"));
                    course.put("enrollments", rs.getInt("enrollments"));
                    courses.add(course);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return courses;
    }

    public boolean checkCourseExists(int courseId) throws SQLException {
        String sql = "SELECT 1 FROM courses WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Map<String, Object>> getAverageLearningTime() {
        List<Map<String, Object>> data = new ArrayList<>();
        String sql = "SELECT c.title, AVG(l.duration_minutes) as avg_time "
                + "FROM courses c "
                + "JOIN lessons l ON c.id = l.course_id "
                + "GROUP BY c.id, c.title "
                + "ORDER BY avg_time DESC "
                + "LIMIT 5";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("title", rs.getString("title"));
                row.put("avg_time", rs.getInt("avg_time"));
                data.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    public List<Map<String, Object>> getCourseCompletionRates() {
        List<Map<String, Object>> data = new ArrayList<>();
        String sql = "SELECT c.title, "
                + "ROUND(100.0 * SUM(CASE WHEN ce.completion_status = 1 THEN 1 ELSE 0 END) / COUNT(ce.id), 2) as completion_rate "
                + "FROM courses c "
                + "JOIN course_enrollments ce ON c.id = ce.course_id "
                + "GROUP BY c.id, c.title "
                + "ORDER BY completion_rate DESC "
                + "LIMIT 5";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("title", rs.getString("title"));
                row.put("completion_rate", rs.getDouble("completion_rate"));
                data.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    public boolean deleteCourse(int id) throws SQLException {
        connection.setAutoCommit(false);

        try {
            // 1. Xóa các bài học và tài liệu đính kèm
            String deleteAttachmentsSQL = "DELETE FROM lesson_attachments WHERE lesson_id IN "
                    + "(SELECT id FROM course_lessons WHERE module_id IN "
                    + "(SELECT id FROM course_modules WHERE course_id = ?))";
            try (PreparedStatement st = connection.prepareStatement(deleteAttachmentsSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 2. Xóa các bài học
            String deleteLessonsSQL = "DELETE FROM course_lessons WHERE module_id IN "
                    + "(SELECT id FROM course_modules WHERE course_id = ?)";
            try (PreparedStatement st = connection.prepareStatement(deleteLessonsSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 3. Xóa các module
            String deleteModulesSQL = "DELETE FROM course_modules WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteModulesSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 4. Xóa mapping với danh mục
            String deleteCategoryMappingSQL = "DELETE FROM course_category_mapping WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteCategoryMappingSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 5. Xóa hình ảnh
            String deleteImagesSQL = "DELETE FROM course_images WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteImagesSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 6. Xóa đánh giá
            String deleteReviewsSQL = "DELETE FROM course_reviews WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteReviewsSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 7. Cuối cùng xóa khóa học
            String deleteCourseSQL = "DELETE FROM courses WHERE id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteCourseSQL)) {
                st.setInt(1, id);
                int affectedRows = st.executeUpdate();

                connection.commit();
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public boolean updateCourseStatus(int id, boolean status) {
        String sql = "UPDATE courses SET status = ?, updated_at = GETDATE() WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setBoolean(1, status);
            st.setInt(2, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Course getCourseAdminDetail(int courseId) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setContent(rs.getString("content"));
                    course.setResearcher(rs.getString("researcher"));
                    course.setDuration(rs.getString("duration"));
                    course.setStatus(rs.getInt("status"));
                    course.setThumbnailUrl(rs.getString("thumbnail_url"));

                    // Lấy danh sách danh mục
                    CourseCategoryDAO categoryDAO = new CourseCategoryDAO();
                    course.setCategories(categoryDAO.getCategoriesByCourseId(courseId));

                    return course;
                }
            }
        }
        return null;
    }
}
