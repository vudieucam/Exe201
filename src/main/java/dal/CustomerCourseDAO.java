/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Course;
import model.CourseCategory;
import model.CourseImage;
import model.CourseLesson;
import model.CourseModule;
import model.CourseReview;
import model.LessonAttachment;
import model.UserProgress;

/**
 *
 * @author FPT
 */
public class CustomerCourseDAO extends DBConnect {

    public List<CourseCategory> getAllCategories() {
        List<CourseCategory> categories = new ArrayList<>();
        String sql = "SELECT id, name, description, status FROM course_categories";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CourseCategory category = new CourseCategory();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setStatus(rs.getBoolean("status"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<Course> getCoursesByCategoryId(int categoryId) {
        List<Course> courses = new ArrayList<>();
        String sql = "String sql = \"SELECT \" +\n"
                + "             \"c.id, \" +\n"
                + "             \"c.title, \" +\n"
                + "             \"c.content, \" +\n"
                + "             \"c.post_date, \" +\n"
                + "             \"c.researcher, \" +\n"
                + "             \"c.video_url, \" +\n"
                + "             \"c.status, \" +\n"
                + "             \"c.duration, \" +\n"
                + "             \"c.thumbnail_url, \" +\n"
                + "             \"c.created_at, \" +\n"
                + "             \"c.updated_at, \" +\n"
                + "             \"c.is_paid \" +\n"
                + "             \"FROM courses c \" +\n"
                + "             \"JOIN course_category_mapping m ON c.id = m.course_id \" +\n"
                + "             \"JOIN course_categories cat ON m.category_id = cat.id \" +\n"
                + "             \"WHERE m.category_id = ? \" +\n"
                + "             \"AND c.status = 1 \" +\n"
                + "             \"AND m.status = 1 \" +\n"
                + "             \"AND cat.status = 1\";";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setContent(rs.getString("content"));
                    course.setPostDate(rs.getDate("post_date"));
                    course.setResearcher(rs.getString("researcher"));
                    course.setVideoUrl(rs.getString("video_url"));
                    course.setStatus(rs.getInt("status"));
                    course.setDuration(rs.getString("duration"));
                    course.setThumbnailUrl(rs.getString("thumbnail_url"));
                    course.setCreatedAt(rs.getTimestamp("created_at"));
                    course.setUpdatedAt(rs.getTimestamp("updated_at"));
                    course.setIsPaid(rs.getBoolean("is_paid"));

                    // categories, images, modules, reviews sẽ được set riêng nếu cần lazy loading
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courses;
    }

    private List<CourseCategory> getCategoriesByCourseId(int courseId) throws SQLException {
        List<CourseCategory> categories = new ArrayList<>();
        String sql = "SELECT cc.id, cc.name, cc.description, cc.status FROM course_category_mapping ccm "
                + "JOIN course_categories cc ON ccm.category_id = cc.id "
                + "WHERE ccm.course_id = ? AND ccm.status = 1";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CourseCategory cat = new CourseCategory();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                cat.setDescription(rs.getString("description"));
                cat.setStatus(rs.getBoolean("status"));
                categories.add(cat);
            }
        }
        return categories;
    }

    public List<Course> getCoursesByPage(int page, int recordsPerPage) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "c.thumbnail_url, c.video_url, c.created_at, c.updated_at, c.is_paid "
                + "FROM courses c "
                + "WHERE c.status = 1 "
                + "ORDER BY c.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, (page - 1) * recordsPerPage);
            st.setInt(2, recordsPerPage);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Course c = mapCourse(rs);
                c.setCategories(getCategoriesByCourseId(c.getId()));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public Course getCourseById(int courseId) throws SQLException {
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "c.thumbnail_url, c.video_url, c.created_at, c.updated_at, c.is_paid "
                + "FROM courses c "
                + "WHERE c.id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Course c = mapCourse(rs);
                c.setCategories(getCategoriesByCourseId(c.getId()));
                c.setImages(getCourseImages(c.getId()));
                c.setModules(getCourseModules(c.getId()));
                c.setReviews(getCourseReviews(c.getId()));
                return c;
            }
        }
        return null;
    }

    public List<Course> searchCourses(String query) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.content, c.post_date, c.researcher, c.duration, c.status, "
                + "c.thumbnail_url, c.video_url, c.created_at, c.updated_at, c.is_paid "
                + "FROM courses c "
                + "WHERE (c.title LIKE ? OR c.content LIKE ? OR c.researcher LIKE ?) AND c.status = 1 "
                + "ORDER BY c.id";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchParam = "%" + query + "%";
            st.setString(1, searchParam);
            st.setString(2, searchParam);
            st.setString(3, searchParam);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course c = mapCourse(rs);
                c.setCategories(getCategoriesByCourseId(c.getId()));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCourses() {
        String sql = "SELECT COUNT(*) FROM courses WHERE status = 1";
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

    public int getTotalSearchCourses(String query) {
        String sql = "SELECT COUNT(*) FROM courses "
                + "WHERE (title LIKE ? OR content LIKE ? OR researcher LIKE ?) AND status = 1";
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
                + "c.thumbnail_url, c.video_url, c.created_at, c.updated_at, c.is_paid "
                + "FROM courses c "
                + "WHERE c.status = 1 "
                + "ORDER BY c.post_date DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Course c = mapCourse(rs);
                c.setCategories(getCategoriesByCourseId(c.getId()));
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
                + "c.thumbnail_url, c.video_url, c.created_at, c.updated_at, c.is_paid "
                + "FROM courses c "
                + "JOIN course_category_mapping ccm ON c.id = ccm.course_id "
                + "JOIN course_categories cc ON ccm.category_id = cc.id "
                + "WHERE cc.name = ? AND c.status = 1 AND ccm.status = 1";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, category);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Course c = mapCourse(rs);
                c.setCategories(getCategoriesByCourseId(c.getId()));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<CourseModule> getCourseModules(int courseId) {
        List<CourseModule> modules = new ArrayList<>();
        String sql = "SELECT id, course_id, title, description, order_index, created_at, updated_at, status "
                + "FROM course_modules WHERE course_id = ? AND status = 1 ORDER BY order_index";

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
                module.setCreatedAt(rs.getDate("created_at"));
                module.setUpdatedAt(rs.getDate("updated_at"));
                module.setStatus(rs.getBoolean("status"));
                module.setLessons(getModuleLessons(module.getId()));
                modules.add(module);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return modules;
    }

    public List<CourseLesson> getModuleLessons(int moduleId) {
        List<CourseLesson> lessons = new ArrayList<>();
        String sql = "SELECT id, module_id, title, content, video_url, duration, order_index, created_at, updated_at, status "
                + "FROM course_lessons WHERE module_id = ? AND status = 1 ORDER BY order_index";

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
                lesson.setCreatedAt(rs.getDate("created_at"));
                lesson.setUpdatedAt(rs.getDate("updated_at"));
                lesson.setStatus(rs.getBoolean("status"));
                lesson.setAttachments(getLessonAttachments(lesson.getId()));
                lessons.add(lesson);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lessons;
    }

    private List<CourseImage> getCourseImages(int courseId) {
        List<CourseImage> images = new ArrayList<>();
        String sql = "SELECT id, course_id, image_url, is_primary, created_at, status "
                + "FROM course_images WHERE course_id = ? AND status = 1";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseImage image = new CourseImage();
                image.setId(rs.getInt("id"));
                image.setCourseId(rs.getInt("course_id"));
                image.setImageUrl(rs.getString("image_url"));
                image.setIsPrimary(rs.getBoolean("is_primary"));
                image.setCreatedAt(rs.getDate("created_at"));
                image.setStatus(rs.getBoolean("status"));
                images.add(image);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return images;
    }

    private List<CourseReview> getCourseReviews(int courseId) {
        List<CourseReview> reviews = new ArrayList<>();
        String sql = "SELECT id, course_id, user_id, rating, comment, created_at, status "
                + "FROM course_reviews WHERE course_id = ? AND status = 1";

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
                review.setCreatedAt(rs.getDate("created_at"));
                review.setStatus(rs.getBoolean("status"));
                reviews.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    private List<LessonAttachment> getLessonAttachments(int lessonId) {
        List<LessonAttachment> attachments = new ArrayList<>();
        String sql = "SELECT id, lesson_id, file_name, file_url, file_size, status "
                + "FROM lesson_attachments WHERE lesson_id = ? AND status = 1";

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
                attachment.setStatus(rs.getBoolean("status"));
                attachments.add(attachment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return attachments;
    }

    private Course mapCourse(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setId(rs.getInt("id"));
        c.setTitle(rs.getString("title"));
        c.setContent(rs.getString("content"));
        c.setPostDate(rs.getDate("post_date"));
        c.setResearcher(rs.getString("researcher"));
        c.setDuration(rs.getString("duration"));
        c.setStatus(rs.getInt("status"));
        c.setThumbnailUrl(rs.getString("thumbnail_url"));
        c.setVideoUrl(rs.getString("video_url"));
        c.setCreatedAt(rs.getDate("created_at"));
        c.setUpdatedAt(rs.getDate("updated_at"));
        c.setIsPaid(rs.getBoolean("is_paid"));
        return c;
    }

    public CourseLesson getLessonDetails(int lessonId) {
        String sql = "SELECT * FROM course_lessons WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                CourseLesson lesson = new CourseLesson();
                lesson.setId(rs.getInt("id"));
                lesson.setModuleId(rs.getInt("module_id"));
                lesson.setTitle(rs.getString("title"));
                lesson.setContent(rs.getString("content"));
                lesson.setVideoUrl(rs.getString("video_url"));
                lesson.setDuration(rs.getInt("duration"));
                lesson.setOrderIndex(rs.getInt("order_index"));
                lesson.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
                lesson.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
                lesson.setStatus(rs.getBoolean("status"));
                lesson.setAttachments(getLessonAttachments(lessonId));

                return lesson;
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
            // Nếu không có ảnh chính, trả về thumbnail từ bảng courses
            sql = "SELECT thumbnail_url FROM courses WHERE id = ?";

            st.setInt(1, courseId);
            rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("thumbnail_url");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "/images/default-course.jpg"; // Ảnh mặc định
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

    // Thêm kiểm tra quyền truy cập khóa học
    public boolean canAccessCourse(int userId, int courseId) {
        String sql = "SELECT COUNT(*) FROM user_packages up "
                + "JOIN course_access ca ON up.service_package_id = ca.service_package_id "
                + "WHERE up.user_id = ? AND ca.course_id = ? AND up.end_date >= GETDATE()";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, courseId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Thêm hàm lấy tiến độ học tập
    public UserProgress getUserProgress(int userId, int lessonId) {
        String sql = "SELECT * FROM user_progress WHERE user_id = ? AND lesson_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, lessonId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new UserProgress(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("lesson_id"),
                        rs.getBoolean("completed"),
                        rs.getTimestamp("completed_at"),
                        rs.getBoolean("status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUserProgress(UserProgress progress) {
        String sql = "IF EXISTS (SELECT 1 FROM user_progress WHERE user_id = ? AND lesson_id = ?) "
                + "BEGIN "
                + "UPDATE user_progress SET completed = ?, completed_at = ?, status = ? "
                + "WHERE user_id = ? AND lesson_id = ? "
                + "END "
                + "ELSE "
                + "BEGIN "
                + "INSERT INTO user_progress (user_id, lesson_id, completed, completed_at, status) "
                + "VALUES (?, ?, ?, ?, ?) "
                + "END";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            Timestamp now = new Timestamp(System.currentTimeMillis());

            // Các tham số cho IF EXISTS và UPDATE
            stmt.setInt(1, progress.getUserId());  // Check exists - user_id
            stmt.setInt(2, progress.getLessonId()); // Check exists - lesson_id

            stmt.setBoolean(3, progress.isCompleted()); // UPDATE - completed
            stmt.setTimestamp(4, now);                  // UPDATE - completed_at
            stmt.setBoolean(5, progress.isStatus());    // UPDATE - status
            stmt.setInt(6, progress.getUserId());       // UPDATE - WHERE user_id
            stmt.setInt(7, progress.getLessonId());     // UPDATE - WHERE lesson_id

            // Các tham số cho INSERT
            stmt.setInt(8, progress.getUserId());       // INSERT - user_id
            stmt.setInt(9, progress.getLessonId());     // INSERT - lesson_id
            stmt.setBoolean(10, progress.isCompleted()); // INSERT - completed
            stmt.setTimestamp(11, now);                 // INSERT - completed_at
            stmt.setBoolean(12, progress.isStatus());   // INSERT - status

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
