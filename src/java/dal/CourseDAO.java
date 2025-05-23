/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.CourseLesson;
import model.CourseModule;

/**
 *
 * @author FPT
 */
public class CourseDAO extends DBConnect {

// Lấy toàn bộ khóa học
    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.time, "
                + "COALESCE(ci.image_url, '/images/corgin-1.jpg') AS image_url "
                + "FROM courses c "
                + "LEFT JOIN course_images ci ON c.id = ci.course_id AND ci.is_primary = 1";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("post_date"),
                        rs.getString("researcher"),
                        rs.getString("image_url"), // Đã có giá trị mặc định nếu null
                        rs.getString("time")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Lấy khóa học theo danh mục
    public List<Course> getCoursesByCategory(String category) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher "
                + "FROM courses c "
                + "JOIN course_category_course cc ON c.id = cc.course_id "
                + "JOIN course_category_items ci ON cc.category_item_id = ci.id "
                + "WHERE ci.label = ? AND c.status = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, category);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("post_date"),
                        rs.getString("researcher"),
                        rs.getString("image_url"), // Lấy ảnh từ DB
                        rs.getString("time")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
        }
        return list;
    }

    // Lấy chi tiết khóa học
    public Course getCourseDetails(int courseId) {
        Course course = null;
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.time, "
                + "ci.image_url "
                + "FROM courses c "
                + "LEFT JOIN course_images ci ON c.id = ci.course_id AND ci.is_primary = 1 "
                + "WHERE c.id = ?"; // Bỏ điều kiện status = 1 để test

        System.out.println("DEBUG: Executing query: " + sql); // Thêm log debug
        System.out.println("DEBUG: With courseId: " + courseId);

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                course = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("post_date"),
                        rs.getString("researcher"),
                        rs.getString("image_url"),
                        rs.getString("time")
                );
                System.out.println("DEBUG: Found course: " + course.getTitle()); // Log khi tìm thấy
            } else {
                System.out.println("DEBUG: No course found with id: " + courseId); // Log khi không tìm thấy
            }
        } catch (SQLException e) {
            System.out.println("ERROR in getCourseDetails: " + e.getMessage());
            e.printStackTrace();
        }
        return course;
    }

// Thêm các phương thức sau vào class CourseDAO
    public List<CourseModule> getCourseModules(int courseId) {
        List<CourseModule> modules = new ArrayList<>();
        String sql = "SELECT * FROM course_modules WHERE course_id = ? ORDER BY order_index";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                CourseModule module = new CourseModule(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getInt("order_index")
                );
                modules.add(module);
            }
        } catch (SQLException e) {
            System.out.println("Error getting course modules: " + e.getMessage());
            e.printStackTrace();
        }
        return modules;
    }

    public List<CourseLesson> getModuleLessons(int moduleId) {
        List<CourseLesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM course_lessons WHERE module_id = ? ORDER BY order_index";

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
                        rs.getInt("order_index")
                );
                lessons.add(lesson);
            }
        } catch (SQLException e) {
            System.out.println("Error getting module lessons: " + e.getMessage());
            e.printStackTrace();
        }
        return lessons;
    }

    public CourseLesson getLessonDetails(int lessonId) {
        String sql = "SELECT * FROM course_lessons WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return new CourseLesson(
                        rs.getInt("id"),
                        rs.getInt("module_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("video_url"),
                        rs.getInt("duration"),
                        rs.getInt("order_index")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getting lesson details: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        CourseDAO dao = new CourseDAO();

        // 1. Test lấy tất cả khóa học trước
        System.out.println("=== TEST GET ALL COURSES ===");
        List<Course> allCourses = dao.getAllCourses();
        System.out.println("Tổng số khóa học: " + allCourses.size());
        for (Course c : allCourses) {
            System.out.println("- ID: " + c.getId() + ", Title: " + c.getTitle());
        }

        // 2. Chỉ test getCourseDetails nếu có khóa học
        if (!allCourses.isEmpty()) {
            System.out.println("\n=== TEST GET COURSE DETAILS ===");
            // Lấy ID khóa học đầu tiên để test
            int testId = allCourses.get(0).getId();

            // Gọi phương thức getCourseDetails (đúng cách)
            Course courseDetail = dao.getCourseDetails(testId);

            if (courseDetail != null) {
                System.out.println("Chi tiết khóa học:");
                System.out.println("ID: " + courseDetail.getId());
                System.out.println("Title: " + courseDetail.getTitle());
                System.out.println("Content: " + (courseDetail.getContent() != null
                        ? courseDetail.getContent().substring(0, Math.min(30, courseDetail.getContent().length())) + "..." : "null"));
                System.out.println("Image: " + courseDetail.getImageUrl());
            } else {
                System.out.println("Không tìm thấy khóa học với ID: " + testId);
            }

            // Test với ID không tồn tại
            System.out.println("\n=== TEST WITH INVALID ID ===");
            Course notFound = dao.getCourseDetails(9999);
            System.out.println("Kết quả với ID không tồn tại: " + (notFound != null ? notFound.getTitle() : "null"));
        } else {
            System.out.println("Không có khóa học nào để test");
        }
    }
    // Lấy ảnh chính của khóa học

    public String getPrimaryImageUrl(int courseId) {
        String sql = "SELECT TOP 1 image_url FROM course_images WHERE course_id = ? AND is_primary = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("image_url");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm ảnh mới
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
    
    // Lấy bài học theo ID
    public CourseLesson getLessonById(int id) {
        String sql = "SELECT * FROM course_lessons WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapLesson(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách bài học theo course_id (dựa vào course_modules)
    public List<CourseLesson> getLessonsByCourse(int courseId) {
        List<CourseLesson> list = new ArrayList<>();
        String sql = "SELECT cl.* FROM course_lessons cl " +
                     "JOIN course_modules cm ON cl.module_id = cm.id " +
                     "WHERE cm.course_id = ? ORDER BY cl.module_id, cl.order_index";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapLesson(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm tiện ích để map từ ResultSet sang Lesson
    private CourseLesson mapLesson(ResultSet rs) throws SQLException {
        CourseLesson l = new CourseLesson();
        l.setId(rs.getInt("id"));
        l.setModuleId(rs.getInt("module_id"));
        l.setTitle(rs.getString("title"));
        l.setContent(rs.getString("content"));
        l.setVideoUrl(rs.getString("video_url"));
        l.setDuration(rs.getInt("duration"));
        l.setOrderIndex(rs.getInt("order_index"));
        return l;
    }
}
