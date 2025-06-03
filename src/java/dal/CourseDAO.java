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
import java.util.List;
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

    public long countAllCourses() throws SQLException {
        String sql = "SELECT COUNT(*) FROM courses";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
            return 0;
        }
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

    public boolean updateCourse(int courseId, int categoryId, String title, String content, String researcher,
            String videoUrl, String duration, String thumbnailUrl,
            boolean isPaid, List<Integer> categoryIds) throws SQLException {
        try {
            connection.setAutoCommit(false);

            String updateSQL = "UPDATE courses SET title = ?, content = ?, researcher = ?, "
                    + "video_url = ?, duration = ?, thumbnail_url = ?, is_paid = ?, "
                    + "updated_at = GETDATE() WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(updateSQL)) {
                stmt.setString(1, title);
                stmt.setString(2, content);
                stmt.setString(3, researcher);
                stmt.setString(4, videoUrl);
                stmt.setString(5, duration);
                stmt.setString(6, thumbnailUrl);
                stmt.setBoolean(7, isPaid);
                stmt.setInt(8, courseId);

                int affectedRows = stmt.executeUpdate();
                if (affectedRows == 0) {
                    return false;
                }
            }

            // Update categories
            courseCategoryDAO.updateCourseCategory(courseId, categoryId);

            connection.commit();
            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
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

    private List<CourseModule> getCourseModules(int courseId) throws SQLException {
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

    public boolean deleteCourse(int id) throws SQLException {
        connection.setAutoCommit(false);

        try {
            // 1. Xóa lesson_attachments
            String deleteAttachmentsSQL = "DELETE a FROM lesson_attachments a "
                    + "INNER JOIN course_lessons l ON a.lesson_id = l.id "
                    + "INNER JOIN course_modules m ON l.module_id = m.id "
                    + "WHERE m.course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteAttachmentsSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 2. Xóa course_lessons
            String deleteLessonsSQL = "DELETE l FROM course_lessons l "
                    + "INNER JOIN course_modules m ON l.module_id = m.id "
                    + "WHERE m.course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteLessonsSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 3. Xóa course_modules
            String deleteModulesSQL = "DELETE FROM course_modules WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteModulesSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 4. Xóa course_reviews
            String deleteReviewsSQL = "DELETE FROM course_reviews WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteReviewsSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 5. Xóa course_access
            String deleteAccessSQL = "DELETE FROM course_access WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteAccessSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 6. Xóa course_images
            String deleteImagesSQL = "DELETE FROM course_images WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteImagesSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 7. Xóa course_category_mapping
            String deleteCategoryMappingSQL = "DELETE FROM course_category_mapping WHERE course_id = ?";
            try (PreparedStatement st = connection.prepareStatement(deleteCategoryMappingSQL)) {
                st.setInt(1, id);
                st.executeUpdate();
            }

            // 8. Xóa bản ghi trong course_categories (nếu cần - chỉ khi mapping không đủ)
            // Bỏ qua nếu không liên quan trực tiếp tới khóa học
            // 9. Xóa chính course
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

    public boolean checkCourseExists(int courseId) throws SQLException {
        String sql = "SELECT 1 FROM courses WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        }
    }

    public static void main(String[] args) {
        // Tạo instance của DAO
        CourseDAO courseDAO = new CourseDAO();

        try {
            // Test case 1: ID tồn tại
            System.out.println("=== Test case 1: ID tồn tại ===");
            int existingCourseId = 1; // Thay bằng ID có thật trong DB của bạn
            testGetCourseById(courseDAO, existingCourseId);

            // Test case 2: ID không tồn tại
            System.out.println("\n=== Test case 2: ID không tồn tại ===");
            int nonExistingCourseId = 9999; // ID chắc chắn không tồn tại
            testGetCourseById(courseDAO, nonExistingCourseId);

            // Test case 3: ID âm
            System.out.println("\n=== Test case 3: ID âm ===");
            int negativeId = -1;
            testGetCourseById(courseDAO, negativeId);

            // Test case 4: ID bằng 0
            System.out.println("\n=== Test case 4: ID bằng 0 ===");
            int zeroId = 0;
            testGetCourseById(courseDAO, zeroId);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void testGetCourseById(CourseDAO courseDAO, int courseId) throws SQLException {
        System.out.println("Testing with course ID: " + courseId);

        long startTime = System.currentTimeMillis();
        Course course = courseDAO.getCourseById(courseId);
        long endTime = System.currentTimeMillis();

        if (course != null) {
            System.out.println("✅ Tìm thấy khóa học:");
            System.out.println("ID: " + course.getId());
            System.out.println("Tiêu đề: " + course.getTitle());
            System.out.println("Mô tả: " + (course.getContent() != null
                    ? course.getContent().substring(0, Math.min(50, course.getContent().length())) + "..." : "null"));
            System.out.println("Số module: " + (course.getModules() != null ? course.getModules().size() : 0));
            System.out.println("Số hình ảnh: " + (course.getImages() != null ? course.getImages().size() : 0));
            System.out.println("Số đánh giá: " + (course.getReviews() != null ? course.getReviews().size() : 0));
        } else {
            System.out.println("❌ Không tìm thấy khóa học với ID: " + courseId);
        }

        System.out.printf("Thời gian thực thi: %d ms\n", (endTime - startTime));
    }
}
//    public static void main(String[] args) {
//        CourseDAO courseDAO = new CourseDAO();
//
//        try {
//            // 1. Lấy thông tin course hiện tại
//            System.out.println("=== THÔNG TIN TRƯỚC KHI UPDATE ===");
//            Course currentCourse = courseDAO.getCourseDetails(15);
//            if (currentCourse == null) {
//                System.out.println("Không tìm thấy course với id=15");
//                return;
//            }
//            System.out.println("Title: " + currentCourse.getTitle());
//            System.out.println("Content: " + currentCourse.getContent().substring(0, Math.min(50, currentCourse.getContent().length())) + "...");
//
//            // 2. Chuẩn bị dữ liệu update
//            Course updatedCourse = new Course();
//
//            updatedCourse.setId(15);
//            updatedCourse.setTitle(currentCourse.getTitle());
//            updatedCourse.setContent("Nội dung mới đã được cập nhật vào " + new java.util.Date());
//            updatedCourse.setResearcher(currentCourse.getResearcher());
//            updatedCourse.setDuration(currentCourse.getDuration());
//            updatedCourse.setStatus(currentCourse.getStatus());
//            updatedCourse.setThumbnailUrl(currentCourse.getThumbnailUrl());
//
//            // Lấy danh sách category hiện tại
//            List<Integer> currentCategories = courseDAO.getCourseCategoryIds(15);
//
//            // 3. Thực hiện update
//            System.out.println("\n=== ĐANG THỰC HIỆN UPDATE ===");
//            boolean success = courseDAO.updateCourseWithCategories(updatedCourse, currentCategories);
//
//            if (success) {
//                System.out.println("✅ UPDATE THÀNH CÔNG!");
//
//                // Kiểm tra kết quả
//                Course afterUpdate = courseDAO.getCourseDetails(15);
//                System.out.println("\n=== THÔNG TIN SAU KHI UPDATE ===");
//                System.out.println("Content: " + afterUpdate.getContent());
//                Date updatedAt = afterUpdate.getUpdatedAt();
//                if (updatedAt != null) {
//                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//                    System.out.println("Updated At: " + sdf.format(updatedAt));
//                } else {
//                    System.out.println("Updated At: null");
//                }
//
//            } else {
//                System.out.println("❌ UPDATE THẤT BẠI!");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//
//        }
//    }
//// Helper method để in thông tin khóa học
//
//    private static void printCourseInfo(Course course) {
//        System.out.println("ID: " + course.getId());
//        System.out.println("Title: " + course.getTitle());
//        System.out.println("Content: " + (course.getContent() != null
//                ? course.getContent().substring(0, Math.min(50, course.getContent().length())) + "..."
//                : "null"));
//        System.out.println("Researcher: " + course.getResearcher());
//        System.out.println("Duration: " + course.getDuration());
//        System.out.println("Status: " + (course.getStatus() == 1 ? "Active" : "Inactive"));
//        System.out.println("Thumbnail: " + course.getThumbnailUrl());
//        System.out.println("Last Updated: " + course.getUpdatedAt());
//    }
//    public static void main(String[] args) {
//        CourseDAO courseDAO = new CourseDAO();
//
//        // ID khóa học muốn test xóa (ở đây test với id=13)
//        int courseIdToDelete = 13;
//
//        System.out.println("Bắt đầu test xóa khóa học ID = " + courseIdToDelete);
//
//        try {
//            // Kiểm tra xem khóa học có tồn tại trước khi xóa không
//            boolean courseExists = courseDAO.checkCourseExists(courseIdToDelete);
//            System.out.println("Khóa học có tồn tại trước khi xóa: " + courseExists);
//
//            if (courseExists) {
//                // Thực hiện xóa
//                System.out.println("Đang thực hiện xóa...");
//                boolean deleteResult = courseDAO.deleteCourse(courseIdToDelete);
//
//                System.out.println("Kết quả xóa: " + (deleteResult ? "THÀNH CÔNG" : "THẤT BẠI"));
//
//                // Kiểm tra lại sau khi xóa
//                courseExists = courseDAO.checkCourseExists(courseIdToDelete);
//                System.out.println("Khóa học có tồn tại sau khi xóa: " + courseExists);
//            } else {
//                System.out.println("Khóa học không tồn tại, không thể xóa");
//            }
//        } catch (Exception e) {
//            System.err.println("Lỗi khi test xóa khóa học:");
//            e.printStackTrace();
//        }
//    }
//    public static void main(String[] args) {
//        // 1. Khởi tạo DAO
//        CourseDAO courseDAO = new CourseDAO();
//
//        // 2. Tạo dữ liệu test
//        Course newCourse = new Course();
//        newCourse.setTitle("Khóa học Test Java");
//        newCourse.setContent("Nội dung test khóa học");
//        newCourse.setResearcher("Nguyễn Văn Test");
//        newCourse.setDuration("10 giờ");
//        newCourse.setStatus(1); // 1 = Active
//        newCourse.setThumbnailUrl("/uploads/test.jpg");
//
//        List<Integer> categoryIds = new ArrayList<>();
//        categoryIds.add(1); // ID danh mục 1
//        categoryIds.add(3); // ID danh mục 3
//
//        // 3. Test phương thức
//        System.out.println("=== Bắt đầu test addCourseWithCategories() ===");
//        boolean result = courseDAO.addCourseWithCategories(newCourse, categoryIds);
//
//        // 4. Kiểm tra kết quả
//        if (result) {
//            System.out.println("✅ Thêm khóa học thành công");
//
//            // In ra danh sách khóa học để kiểm tra
//            System.out.println("\nDanh sách khóa học sau khi thêm:");
//            List<Course> courses = courseDAO.getAllCourses();
//            courses.forEach(c -> System.out.println(c.getId() + " - " + c.getTitle()));
//        } else {
//            System.out.println("❌ Thêm khóa học thất bại");
//        }
//
//        System.out.println("=== Kết thúc test ===");
//    }

