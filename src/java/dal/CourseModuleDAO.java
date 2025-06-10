/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.CourseModule;

/**
 *
 * @author FPT
 */
public class CourseModuleDAO extends DBConnect {

    private CourseLessonDAO courseLessonDAO; // Thêm dòng này
    // Thêm constructor để khởi tạo các DAO

    public CourseModuleDAO() {
        try {
            this.courseLessonDAO = new CourseLessonDAO(); // Khởi tạo courseCategoryDAO
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean addModule(CourseModule module) {
        String sql = "INSERT INTO course_modules (course_id, title, description, order_index, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, module.getCourseId());
            st.setString(2, module.getTitle());
            st.setString(3, module.getDescription());
            st.setInt(4, module.getOrderIndex());
            st.setBoolean(5, module.isStatus());

            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) {
                        module.setId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateModule(CourseModule module) {
        String sql = "UPDATE course_modules SET title = ?, description = ?, order_index = ?, status = ?, updated_at = GETDATE() WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, module.getTitle());
            st.setString(2, module.getDescription());
            st.setInt(3, module.getOrderIndex());
            st.setBoolean(4, module.isStatus());
            st.setInt(5, module.getId());

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteModule(int moduleId) {
        // Thay vì xóa, chúng ta sẽ set status = 0 (inactive)
        String sql = "UPDATE course_modules SET status = 0 WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void deleteAllModulesByCourseId(int courseId) throws SQLException {
        // Cập nhật status = 0 thay vì xóa
        String sql = "UPDATE course_modules SET status = 0 WHERE course_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            st.executeUpdate();
        }
    }

    public CourseModule getModuleById(int moduleId) {
        String sql = "SELECT * FROM course_modules WHERE id = ? AND status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, moduleId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                CourseModule module = new CourseModule();
                module.setId(rs.getInt("id"));
                module.setCourseId(rs.getInt("course_id"));
                module.setTitle(rs.getString("title"));
                module.setDescription(rs.getString("description"));
                module.setOrderIndex(rs.getInt("order_index"));
                module.setStatus(rs.getBoolean("status"));
                module.setCreatedAt(rs.getTimestamp("created_at"));
                module.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Lấy danh sách lessons (chỉ những lesson active)
                CourseLessonDAO lessonDAO = new CourseLessonDAO();
                module.setLessons(lessonDAO.getLessonsByModuleId(moduleId));

                return module;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<CourseModule> getCourseModules(int courseId) {
        List<CourseModule> modules = new ArrayList<>();
        String sql = "SELECT * FROM course_modules WHERE course_id = ? AND status = 1 ORDER BY order_index ASC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseModule module = new CourseModule();
                module.setId(rs.getInt("id"));
                module.setCourseId(courseId);
                module.setTitle(rs.getString("title"));
                module.setDescription(rs.getString("description"));
                module.setOrderIndex(rs.getInt("order_index"));
                module.setStatus(rs.getBoolean("status"));
                module.setCreatedAt(rs.getTimestamp("created_at"));
                module.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Lấy danh sách bài học (chỉ những lesson active)
                CourseLessonDAO lessonDAO = new CourseLessonDAO();
                module.setLessons(lessonDAO.getLessonsByModuleId(module.getId()));

                modules.add(module);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return modules;
    }

    

    public int getCourseIdByModuleId(int moduleId) {
        String sql = "SELECT course_id FROM course_modules WHERE id = ? AND status = 1";
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

    // Thêm hàm để toggle trạng thái module
    public boolean toggleModuleStatus(int moduleId, boolean newStatus) {
        String sql = "UPDATE course_modules SET status = ?, updated_at = GETDATE() WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setBoolean(1, newStatus);
            st.setInt(2, moduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Trong CourseModuleDAO.java
    public boolean updateModuleOrder(int moduleId, int orderIndex) {
        String sql = "UPDATE course_modules SET order_index = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, orderIndex);
            stmt.setInt(2, moduleId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating module order: " + e.getMessage());
            return false;
        }
    }

    public int getNextModuleOrder(int courseId) {
        String sql = "SELECT COALESCE(MAX(order_index), 0) + 1 FROM course_modules WHERE course_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 1;
        } catch (SQLException e) {
            System.err.println("Error getting next module order: " + e.getMessage());
            return 1;
        }
    }
    
   


}
