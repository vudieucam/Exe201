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
public class CustomerCourseDAO extends DBConnect {

    // Lấy toàn bộ khóa học
    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "COALESCE(c.thumbnail_url, '/images/corgin-1.jpg') AS image_url, "
                + "STUFF((SELECT ', ' + cc.name "
                + "       FROM course_category_mapping ccm "
                + "       JOIN course_categories cc ON ccm.category_id = cc.id "
                + "       WHERE ccm.course_id = c.id "
                + "       FOR XML PATH('')), 1, 2, '') AS categories "
                + "FROM courses c "
                + "WHERE c.status = 1"; // Chỉ lấy khóa học active

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
                        rs.getString("image_url"),
                        rs.getString("duration"),
                        rs.getInt("status"),
                        rs.getString("categories")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> getCoursesByPage(int page, int recordsPerPage) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "COALESCE(c.thumbnail_url, '/images/corgin-1.jpg') AS image_url, "
                + "STUFF((SELECT ', ' + cc.name "
                + "       FROM course_category_mapping ccm "
                + "       JOIN course_categories cc ON ccm.category_id = cc.id "
                + "       WHERE ccm.course_id = c.id "
                + "       FOR XML PATH('')), 1, 2, '') AS categories "
                + "FROM courses c "
                + "WHERE c.status = 1 "
                + "ORDER BY c.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, (page - 1) * recordsPerPage);
            st.setInt(2, recordsPerPage);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("post_date"),
                        rs.getString("researcher"),
                        rs.getString("image_url"),
                        rs.getString("duration"),
                        rs.getInt("status"),
                        rs.getString("categories")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCourses() {
        String sql = "SELECT COUNT(*) FROM courses";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Course> searchCourses(String query, int page, int recordsPerPage) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "COALESCE(c.thumbnail_url, '/images/corgin-1.jpg') AS image_url, "
                + "STUFF((SELECT ', ' + cc.name "
                + "       FROM course_category_mapping ccm "
                + "       JOIN course_categories cc ON ccm.category_id = cc.id "
                + "       WHERE ccm.course_id = c.id "
                + "       FOR XML PATH('')), 1, 2, '') AS categories "
                + "FROM courses c "
                + "WHERE c.status = 1 AND (c.title LIKE ? OR c.content LIKE ? OR c.researcher LIKE ?) "
                + "ORDER BY c.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            String searchParam = "%" + query + "%";
            st.setString(1, searchParam);
            st.setString(2, searchParam);
            st.setString(3, searchParam);
            st.setInt(4, (page - 1) * recordsPerPage);
            st.setInt(5, recordsPerPage);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("post_date"),
                        rs.getString("researcher"),
                        rs.getString("image_url"),
                        rs.getString("duration"),
                        rs.getInt("status"),
                        rs.getString("categories")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalSearchCourses(String query) {
        String sql = "SELECT COUNT(*) FROM courses "
                + "WHERE title LIKE ? OR content LIKE ? OR researcher LIKE ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            String searchParam = "%" + query + "%";
            st.setString(1, searchParam);
            st.setString(2, searchParam);
            st.setString(3, searchParam);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Course> getFeaturedCourses(int limit) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT TOP (?) c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "COALESCE(c.thumbnail_url, '/images/corgin-1.jpg') AS image_url, "
                + "STUFF((SELECT ', ' + cc.name "
                + "       FROM course_category_mapping ccm "
                + "       JOIN course_categories cc ON ccm.category_id = cc.id "
                + "       WHERE ccm.course_id = c.id "
                + "       FOR XML PATH('')), 1, 2, '') AS categories "
                + "FROM courses c "
                + "WHERE c.status = 1 "
                + "ORDER BY c.post_date DESC";

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
                        rs.getString("duration"),
                        rs.getInt("status"),
                        rs.getString("categories")
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
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "COALESCE(c.thumbnail_url, '/images/corgin-1.jpg') AS image_url, "
                + "STUFF((SELECT ', ' + cc.name "
                + "       FROM course_category_mapping ccm "
                + "       JOIN course_categories cc ON ccm.category_id = cc.id "
                + "       WHERE ccm.course_id = c.id "
                + "       FOR XML PATH('')), 1, 2, '') AS categories "
                + "FROM courses c "
                + "JOIN course_category_mapping ccm ON c.id = ccm.course_id "
                + "JOIN course_categories cc ON ccm.category_id = cc.id "
                + "WHERE cc.name = ? AND c.status = 1";

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
                        rs.getString("image_url"),
                        rs.getString("duration"),
                        rs.getInt("status"),
                        rs.getString("categories")
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

    public List<CourseLesson> getModuleLessons(int moduleId) {
        List<CourseLesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM course_lessons WHERE module_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, moduleId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseLesson lesson = new CourseLesson();
                lesson.setId(rs.getInt("id"));
                lesson.setModuleId(moduleId);
                lesson.setTitle(rs.getString("title"));
                lesson.setContent(rs.getString("content"));
                lesson.setVideoUrl(rs.getString("video_url"));

                lessons.add(lesson);
            }
        } catch (Exception e) {
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
        String sql = "SELECT cl.* FROM course_lessons cl "
                + "JOIN course_modules cm ON cl.module_id = cm.id "
                + "WHERE cm.course_id = ? ORDER BY cl.module_id, cl.order_index";
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
