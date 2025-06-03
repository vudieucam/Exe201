/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.BlogCategory;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Blog;

/**
 *
 * @author FPT
 */
public class BlogDAO extends DBConnect {

    // Helper method to map Blog from ResultSet
    private Blog mapBlogFromResultSet(ResultSet rs) throws SQLException {
        Blog blog = new Blog();
        blog.setBlogId(rs.getInt("blog_id"));
        blog.setTitle(rs.getString("title"));
        blog.setContent(rs.getString("content"));
        blog.setShortDescription(rs.getString("short_description"));
        blog.setImageUrl(rs.getString("image_url"));
        blog.setCategoryId(rs.getInt("category_id"));
        blog.setCategoryName(rs.getString("category_name"));
        blog.setAuthorId(rs.getInt("author_id"));
        blog.setAuthorName(rs.getString("author_name"));
        blog.setViewCount(rs.getInt("view_count"));
        blog.setIsFeatured(rs.getBoolean("is_featured"));
        blog.setCreatedAt(rs.getTimestamp("created_at"));
        blog.setUpdatedAt(rs.getTimestamp("updated_at"));
        blog.setStatus(rs.getInt("status"));
        return blog;
    }
// Helper method to map BlogCategory from ResultSet

    private BlogCategory mapCategoryFromResultSet(ResultSet rs) throws SQLException {
        BlogCategory category = new BlogCategory();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setStatus(rs.getBoolean("status"));
        return category;
    }

    // Lấy danh sách blog phân trang (chỉ lấy blog active)
    public List<Blog> getBlogs(int page, int blogsPerPage) throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * blogsPerPage);
            ps.setInt(2, blogsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = mapBlogFromResultSet(rs);
                    list.add(blog);
                }
            }
        }
        return list;
    }

    // Lấy tổng số blog active để phân trang
    public int getTotalBlogs() throws Exception {
        String sql = "SELECT COUNT(*) FROM Blogs WHERE status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Lấy blog theo ID (chỉ lấy nếu active)
    public Blog getBlogById(int id) throws Exception {
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.blog_id = ? AND b.status = 1 AND c.status = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBlogFromResultSet(rs);
                }
            }
        }
        return null;
    }

    // Lấy danh sách loại blog (chỉ active)
    public List<BlogCategory> getAllCategories() throws Exception {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogCategories WHERE status = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BlogCategory category = mapCategoryFromResultSet(rs);
                list.add(category);
            }
        }
        return list;
    }

    // Lấy 3 loại blog tiêu biểu (có nhiều bài viết nhất, chỉ active)
    public List<BlogCategory> getFeaturedCategories() throws Exception {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT TOP 3 c.category_id, c.category_name, c.description, c.created_at, c.status, "
                + "COUNT(b.blog_id) as blog_count "
                + "FROM BlogCategories c "
                + "LEFT JOIN Blogs b ON c.category_id = b.category_id AND b.status = 1 "
                + "WHERE c.status = 1 "
                + "GROUP BY c.category_id, c.category_name, c.description, c.created_at, c.status "
                + "ORDER BY blog_count DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BlogCategory category = mapCategoryFromResultSet(rs);
                list.add(category);
            }
        }
        return list;
    }

    // Lấy bài viết nổi bật (chỉ active)
    public List<Blog> getFeaturedBlogs(int limit) throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.is_featured = 1 AND b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = mapBlogFromResultSet(rs);
                    list.add(blog);
                }
            }
        }
        return list;
    }

    // Tìm kiếm blog (chỉ active)
    public List<Blog> searchBlogs(String keyword) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE (b.title LIKE ? OR b.content LIKE ? OR b.short_description LIKE ?) "
                + "AND b.status = 1 AND c.status = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Blog blog = mapBlogFromResultSet(rs);
                list.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách blog theo category_id (chỉ active)
    public List<Blog> getBlogsByCategoryId(int categoryId, int page, int blogsPerPage) throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.category_id = ? AND b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, (page - 1) * blogsPerPage);
            ps.setInt(3, blogsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = mapBlogFromResultSet(rs);
                    list.add(blog);
                }
            }
        }
        return list;
    }

// Lấy tổng số blog theo category_id (chỉ active)
    public int getTotalBlogsByCategoryId(int categoryId) throws Exception {
        String sql = "SELECT COUNT(*) FROM Blogs WHERE category_id = ? AND status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

// Lấy danh sách blog gần đây (chỉ active)
    public List<Blog> getRecentBlogs(int limit) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT TOP (?) b.*, bc.category_name FROM Blogs b "
                + "JOIN BlogCategories bc ON b.category_id = bc.category_id "
                + "WHERE b.status = 1 AND bc.status = 1 "
                + "ORDER BY b.created_at DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Blog blog = mapBlogFromResultSet(rs);
                    blogs.add(blog);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }
}
