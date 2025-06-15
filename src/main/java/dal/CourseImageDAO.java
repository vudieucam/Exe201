/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author FPT
 */
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CourseImage;

public class CourseImageDAO extends DBConnect {

    public boolean addImage(int courseId, String imageUrl, boolean isPrimary) {
        String sql = "INSERT INTO course_images (course_id, image_url, is_primary, status) VALUES (?, ?, ?, 1)";
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

    public List<CourseImage> getCourseImages(int courseId) {
        List<CourseImage> images = new ArrayList<>();
        String sql = "SELECT * FROM course_images WHERE course_id = ? AND status = 1 ORDER BY is_primary DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseImage image = new CourseImage(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_primary"),
                        rs.getTimestamp("created_at"),
                        rs.getBoolean("status")
                );
                images.add(image);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

    public boolean setPrimaryImage(int courseId, int imageId) {
        try {
            // Bỏ chọn tất cả ảnh hiện tại (chỉ cập nhật những ảnh đang active)
            String resetSql = "UPDATE course_images SET is_primary = 0 WHERE course_id = ? AND status = 1";
            try (PreparedStatement resetStmt = connection.prepareStatement(resetSql)) {
                resetStmt.setInt(1, courseId);
                resetStmt.executeUpdate();
            }

            // Đặt ảnh mới làm ảnh chính (chỉ nếu ảnh đó đang active)
            String setSql = "UPDATE course_images SET is_primary = 1 WHERE id = ? AND course_id = ? AND status = 1";
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
        // Thay vì xóa hẳn, chúng ta sẽ set status = 0 (soft delete)
        String sql = "UPDATE course_images SET status = 0 WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, imageId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Thêm phương thức để active lại image nếu cần
    public boolean activateImage(int imageId) {
        String sql = "UPDATE course_images SET status = 1 WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, imageId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
