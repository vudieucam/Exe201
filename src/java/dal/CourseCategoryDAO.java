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
import model.Course;
import model.CourseCategory;

/**
 *
 * @author FPT
 */
public class CourseCategoryDAO extends DBConnect {

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
        String sql = "SELECT id, name, description, status FROM course_categories ORDER BY name";

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                categories.add(new CourseCategory(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBoolean("status")
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
        String sql = "SELECT COUNT(*) FROM course_category_mapping WHERE category_id = ? AND status = 1";
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

    public List<CourseCategory> getCategoriesByCourseId(int courseId) throws SQLException {
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

    public List<CourseCategory> getCourseCategories(int courseId) {
        List<CourseCategory> categories = new ArrayList<>();
        String sql = "SELECT cc.id, cc.name, cc.description, cc.status FROM course_categories cc "
                + "JOIN course_category_mapping ccm ON cc.id = ccm.category_id "
                + "WHERE ccm.course_id = ? AND ccm.status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
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

    public boolean addCourseCategories(int courseId, List<Integer> categoryIds) throws SQLException {
        String sql = "INSERT INTO course_category_mapping (course_id, category_id) VALUES (?, ?)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (Integer categoryId : categoryIds) {
                st.setInt(1, courseId);
                st.setInt(2, categoryId);
                st.addBatch();
            }
            int[] results = st.executeBatch();

            for (int result : results) {
                if (result != Statement.SUCCESS_NO_INFO && result <= 0) {
                    return false;
                }
            }
        }
        return true;
    }
// Thêm phương thức mới

    public boolean addCourseWithCategories(Course course, List<Integer> categoryIds) {
        String sql = "INSERT INTO courses (title, content, researcher, duration, status, thumbnail_url, post_date) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, course.getTitle());
            st.setString(2, course.getContent());
            st.setString(3, course.getResearcher());
            st.setString(4, course.getDuration());
            st.setInt(5, course.getStatus());
            st.setString(6, course.getThumbnailUrl());
            st.setDate(7, new java.sql.Date(System.currentTimeMillis())); // Thêm ngày hiện tại

            int affectedRows = st.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int courseId = generatedKeys.getInt(1);
                    // Thêm liên kết với các danh mục
                    return addCourseCategories(courseId, categoryIds);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCourseWithCategories(Course course, List<Integer> categoryIds) {
        try {
            connection.setAutoCommit(false);

            // 1. Cập nhật thông tin course
            String updateSql = "UPDATE courses SET title=?, content=?, researcher=?, duration=?, "
                    + "status=?, thumbnail_url=?, updated_at=? WHERE id=?";

            try (PreparedStatement st = connection.prepareStatement(updateSql)) {
                st.setString(1, course.getTitle());
                st.setString(2, course.getContent());
                st.setString(3, course.getResearcher());
                st.setString(4, course.getDuration());
                st.setInt(5, course.getStatus());
                st.setString(6, course.getThumbnailUrl());
                st.setDate(7, new java.sql.Date(System.currentTimeMillis())); // Thêm ngày hiện tại
                st.setInt(8, course.getId());

                if (st.executeUpdate() == 0) {
                    connection.rollback();
                    return false;
                }
            }

            // 2. Xóa các mapping cũ
            String deleteSql = "DELETE FROM course_category_mapping WHERE course_id=?";
            try (PreparedStatement st = connection.prepareStatement(deleteSql)) {
                st.setInt(1, course.getId());
                st.executeUpdate();
            }

            // 3. Thêm các mapping mới
            if (!categoryIds.isEmpty() && !addCourseCategories(course.getId(), categoryIds)) {
                connection.rollback();
                return false;
            }

            connection.commit();
            course.setUpdatedAt(new java.sql.Date(System.currentTimeMillis()));
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

}
