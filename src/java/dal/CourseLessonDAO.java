/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.CourseLesson;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.CourseModule;
import model.LessonAttachment;

/**
 *
 * @author FPT
 */
public class CourseLessonDAO extends DBConnect {

    public boolean addLesson(CourseLesson lesson) {
        String sql = "INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lesson.getModuleId());
            st.setString(2, lesson.getTitle());
            st.setString(3, lesson.getContent());
            st.setString(4, lesson.getVideoUrl());
            st.setInt(5, lesson.getDuration());
            st.setInt(6, lesson.getOrderIndex());
            st.setBoolean(7, lesson.isStatus());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateLesson(CourseLesson lesson) {
        String sql = "UPDATE course_lessons SET title = ?, content = ?, video_url = ?, "
                + "duration = ?, order_index = ?, status = ?, updated_at = GETDATE() WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, lesson.getTitle());
            st.setString(2, lesson.getContent());
            st.setString(3, lesson.getVideoUrl());
            st.setInt(4, lesson.getDuration());
            st.setInt(5, lesson.getOrderIndex());
            st.setBoolean(6, lesson.isStatus());
            st.setInt(7, lesson.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteLesson(int lessonId) {
        // First delete all attachments
        deleteAttachmentsByLesson(lessonId);

        // Then delete the lesson
        String sql = "UPDATE course_lessons SET status = 0 WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void deleteAllLessonsByModuleId(int moduleId) {
        List<CourseLesson> lessons = getLessonsByModuleId(moduleId);
        for (CourseLesson lesson : lessons) {
            deleteLesson(lesson.getId());
        }
    }

    private void deleteAttachmentsByLesson(int lessonId) {
        String sql = "UPDATE lesson_attachments SET status = 0 WHERE lesson_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getModuleIdByLessonId(int lessonId) {
        String sql = "SELECT module_id FROM course_lessons WHERE id = ? AND status = 1";
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

    public List<CourseLesson> getLessonsByModuleId(int moduleId) {
        List<CourseLesson> list = new ArrayList<>();
        String sql = "SELECT * FROM course_lessons WHERE module_id = ? AND status = 1 ORDER BY order_index ASC";
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
                        new Date(rs.getTimestamp("created_at").getTime()),
                        new Date(rs.getTimestamp("updated_at").getTime()),
                        rs.getBoolean("status"),
                        new ArrayList<>()
                );
                lesson.setAttachments(getAttachmentsByLessonId(rs.getInt("id")));
                list.add(lesson);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        int courseIdToTest = 1; // 👈 Nhớ thay bằng ID thật trong DB của bạn

        CourseModuleDAO moduleDAO = new CourseModuleDAO();
        List<CourseModule> modules = moduleDAO.getCourseModules(courseIdToTest);

        System.out.println("== MODULE LIST FOR COURSE ID: " + courseIdToTest + " ==");

        if (modules.isEmpty()) {
            System.out.println("❌ Không tìm thấy module nào.");
        } else {
            for (CourseModule module : modules) {
                System.out.println("📘 Module: " + module.getTitle() + " (ID: " + module.getId() + ")");
                List<CourseLesson> lessons = module.getLessons();
                if (lessons == null || lessons.isEmpty()) {
                    System.out.println("   ⚠️ Không có bài học.");
                } else {
                    System.out.println("   📝 Tổng bài học: " + lessons.size());
                    for (CourseLesson lesson : lessons) {
                        System.out.println("     • " + lesson.getTitle() + " (ID: " + lesson.getId() + ")");
                    }
                }
            }
        }
    }

    public List<LessonAttachment> getAttachmentsByLessonId(int lessonId) {
        List<LessonAttachment> list = new ArrayList<>();
        String sql = "SELECT * FROM lesson_attachments WHERE lesson_id = ? AND status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                LessonAttachment attachment = new LessonAttachment(
                        rs.getInt("id"),
                        rs.getInt("lesson_id"),
                        rs.getString("file_name"),
                        rs.getString("file_url"),
                        rs.getInt("file_size"),
                        rs.getBoolean("status")
                );
                list.add(attachment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public CourseLesson getLessonById(int lessonId) {
        String sql = "SELECT * FROM course_lessons WHERE id = ? AND status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, lessonId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                CourseLesson lesson = new CourseLesson(
                        rs.getInt("id"),
                        rs.getInt("module_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("video_url"),
                        rs.getInt("duration"),
                        rs.getInt("order_index"),
                        new Date(rs.getTimestamp("created_at").getTime()),
                        new Date(rs.getTimestamp("updated_at").getTime()),
                        rs.getBoolean("status"),
                        new ArrayList<>()
                );
                lesson.setAttachments(getAttachmentsByLessonId(lessonId));
                return lesson;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    // Trong CourseLessonDAO.java

    public boolean updateLessonOrder(int lessonId, int orderIndex) {
        String sql = "UPDATE course_lessons SET order_index = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, orderIndex);
            stmt.setInt(2, lessonId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating lesson order: " + e.getMessage());
            return false;
        }
    }
}
