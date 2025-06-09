/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.BlogCategory;

/**
 *
 * @author FPT
 */
public class BlogCategoryDAO extends DBConnect {

    // Create a new blog category
    public boolean createCategory(BlogCategory category) {
        String sql = "INSERT INTO BlogCategories (category_name, description, status) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setBoolean(3, category.isStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update an existing blog category
    public boolean updateCategory(BlogCategory category) {
        String sql = "UPDATE BlogCategories SET category_name = ?, description = ?, status = ? WHERE category_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setBoolean(3, category.isStatus());
            ps.setInt(4, category.getCategoryId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a blog category (soft delete by setting status to false)
    public boolean deleteCategory(int categoryId) {
        // Kiểm tra xem có bài viết nào thuộc danh mục này không
        String checkSql = "SELECT COUNT(*) FROM Blogs WHERE category_id = ?";
        try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
            checkStmt.setInt(1, categoryId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // Nếu có bài viết, chỉ cập nhật status thành false
                String updateSql = "UPDATE BlogCategories SET status = 0 WHERE category_id = ?";
                try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, categoryId);
                    return updateStmt.executeUpdate() > 0;
                }
            } else {
                // Nếu không có bài viết, xóa hoàn toàn
                String deleteSql = "DELETE FROM BlogCategories WHERE category_id = ?";
                try (PreparedStatement deleteStmt = connection.prepareStatement(deleteSql)) {
                    deleteStmt.setInt(1, categoryId);
                    return deleteStmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addCategory(BlogCategory category) {
        String sql = "INSERT INTO BlogCategories (category_name, description, status) VALUES (?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setBoolean(3, category.isStatus());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    category.setCategoryId(generatedKeys.getInt(1));
                }
            }
            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Get all active categories
    public List<BlogCategory> getAllActiveCategories() {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogCategories WHERE status = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapCategoryFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get all categories (including inactive)
    public List<BlogCategory> getAllCategories() {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogCategories";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapCategoryFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get category by ID
    public BlogCategory getCategoryById(int id) {
        String sql = "SELECT * FROM BlogCategories WHERE category_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCategoryFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật phương thức mapCategoryFromResultSet trong BlogCategoryDAO
    private BlogCategory mapCategoryFromResultSet(ResultSet rs) throws SQLException {
        BlogCategory category = new BlogCategory();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setStatus(rs.getBoolean("status"));

        // Thêm dòng này nếu ResultSet có cột blog_count
        try {
            category.setBlogCount(rs.getInt("blog_count"));
        } catch (SQLException e) {
            // Nếu không có cột blog_count thì bỏ qua
        }

        return category;
    }

    // Bổ sung các hàm còn thiếu vào lớp BlogCategoryDAO
// Toggle trạng thái category (active/inactive)
public boolean toggleCategoryStatus(int categoryId) {
        String sql = "UPDATE BlogCategories SET status = CASE WHEN status = 1 THEN 0 ELSE 1 END WHERE category_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

// Đếm số lượng blog trong mỗi category
    public Map<Integer, Integer> countBlogsPerCategory() {
        Map<Integer, Integer> result = new HashMap<>();
        String sql = "SELECT category_id, COUNT(*) as blog_count FROM Blogs "
                + "WHERE status = 1 GROUP BY category_id";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.put(rs.getInt("category_id"), rs.getInt("blog_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

// Kiểm tra category có tồn tại không
    public boolean existsById(int categoryId) {
        String sql = "SELECT 1 FROM BlogCategories WHERE category_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Kiểm tra tên category có tồn tại không (dùng khi thêm mới)
    public boolean existsByName(String categoryName) {
        String sql = "SELECT 1 FROM BlogCategories WHERE category_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Lấy danh sách category với số lượng blog (dùng cho trang chủ)
    public List<BlogCategory> getCategoriesWithBlogCount() {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(b.blog_id) as blog_count "
                + "FROM BlogCategories c "
                + "LEFT JOIN Blogs b ON c.category_id = b.category_id AND b.status = 1 "
                + "WHERE c.status = 1 "
                + "GROUP BY c.category_id, c.category_name, c.description, c.created_at, c.status "
                + "ORDER BY c.category_name";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BlogCategory category = mapCategoryFromResultSet(rs);
                // Có thể thêm thuộc tính blogCount vào model nếu cần
                list.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// Lấy category theo tên
    public BlogCategory getCategoryByName(String categoryName) {
        String sql = "SELECT * FROM BlogCategories WHERE category_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCategoryFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

// Đếm tổng số category
    public int countAllCategories() {
        String sql = "SELECT COUNT(*) FROM BlogCategories";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

// Đếm số category active
    public int countActiveCategories() {
        String sql = "SELECT COUNT(*) FROM BlogCategories WHERE status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Thêm các phương thức sau vào BlogCategoryDAO.java
    public List<BlogCategory> getCategories(int page, int recordsPerPage, String statusFilter) {
        List<BlogCategory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM BlogCategories WHERE 1=1");

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ").append(statusFilter.equals("active") ? "1" : "0");
        }

        sql.append(" ORDER BY category_name OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int offset = (page - 1) * recordsPerPage;
            ps.setInt(1, offset);
            ps.setInt(2, recordsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCategoryFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCategories(String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BlogCategories WHERE 1=1");

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ").append(statusFilter.equals("active") ? "1" : "0");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString()); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<BlogCategory> searchCategories(String keyword) {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogCategories WHERE category_name LIKE ? OR description LIKE ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCategoryFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
