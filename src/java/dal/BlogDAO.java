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

    // Lấy danh sách blog phân trang
    public List<Blog> getBlogs(int page, int blogsPerPage) throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "ORDER BY b.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * blogsPerPage);
            ps.setInt(2, blogsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setBlogId(rs.getInt("blog_id"));
                    blog.setTitle(rs.getString("title"));
                    blog.setContent(rs.getString("content"));
                    blog.setShortDescription(rs.getString("short_description"));
                    blog.setImageUrl(rs.getString("image_url"));
                    blog.setCategoryId(rs.getInt("category_id"));
                    blog.setCategoryName(rs.getString("category_name"));
                    blog.setAuthorName(rs.getString("author_name"));
                    blog.setViewCount(rs.getInt("view_count"));
                    blog.setIsFeatured(rs.getBoolean("is_featured"));
                    blog.setCreatedAt(rs.getDate("created_at"));
                    blog.setUpdatedAt(rs.getDate("updated_at"));
                    list.add(blog);
                }
            }
        }
        return list;
    }

    // Lấy tổng số blog để phân trang
    public int getTotalBlogs() throws Exception {
        String sql = "SELECT COUNT(*) FROM Blogs";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Lấy blog theo ID
    public Blog getBlogById(int id) throws Exception {
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.blog_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Blog blog = new Blog();
                    blog.setBlogId(rs.getInt("blog_id"));
                    blog.setTitle(rs.getString("title"));
                    blog.setContent(rs.getString("content"));
                    blog.setShortDescription(rs.getString("short_description"));
                    blog.setImageUrl(rs.getString("image_url"));
                    blog.setCategoryId(rs.getInt("category_id"));
                    blog.setCategoryName(rs.getString("category_name"));
                    blog.setAuthorName(rs.getString("author_name"));
                    blog.setViewCount(rs.getInt("view_count"));
                    blog.setIsFeatured(rs.getBoolean("is_featured"));
                    blog.setCreatedAt(rs.getDate("created_at"));
                    blog.setUpdatedAt(rs.getDate("updated_at"));
                    return blog;
                }
            }
        }
        return null;
    }

    // Lấy danh sách loại blog
    public List<BlogCategory> getAllCategories() throws Exception {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogCategories";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BlogCategory category = new BlogCategory();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                list.add(category);
            }
        }
        return list;
    }

    // Lấy 3 loại blog tiêu biểu (có nhiều bài viết nhất)
    public List<BlogCategory> getFeaturedCategories() throws Exception {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT TOP 3 c.category_id, c.category_name, c.description, COUNT(b.blog_id) as blog_count "
                + "FROM BlogCategories c "
                + "LEFT JOIN Blogs b ON c.category_id = b.category_id "
                + "GROUP BY c.category_id, c.category_name, c.description "
                + "ORDER BY blog_count DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BlogCategory category = new BlogCategory();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                list.add(category);
            }
        }
        return list;
    }

    // Lấy bài viết nổi bật
    public List<Blog> getFeaturedBlogs(int limit) throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.is_featured = 1 "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setBlogId(rs.getInt("blog_id"));
                    blog.setTitle(rs.getString("title"));
                    blog.setContent(rs.getString("content"));
                    blog.setShortDescription(rs.getString("short_description"));
                    blog.setImageUrl(rs.getString("image_url"));
                    blog.setCategoryId(rs.getInt("category_id"));
                    blog.setCategoryName(rs.getString("category_name"));
                    blog.setAuthorName(rs.getString("author_name"));
                    blog.setViewCount(rs.getInt("view_count"));
                    blog.setIsFeatured(rs.getBoolean("is_featured"));
                    blog.setCreatedAt(rs.getDate("created_at"));
                    blog.setUpdatedAt(rs.getDate("updated_at"));
                    list.add(blog);
                }
            }
        }
        return list;
    }

    public List<Blog> searchBlogs(String keyword) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blogs WHERE title LIKE ? OR content LIKE ? OR short_description LIKE ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("blog_id"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setShortDescription(rs.getString("short_description"));
                blog.setImageUrl(rs.getString("image_url"));
                blog.setAuthorName(rs.getString("author_name"));
                blog.setCreatedAt(rs.getDate("created_at"));
                list.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    // Lấy danh sách blog theo category_id

    public List<Blog> getBlogsByCategoryId(int categoryId, int page, int blogsPerPage) throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.category_id = ? "
                + "ORDER BY b.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, (page - 1) * blogsPerPage);
            ps.setInt(3, blogsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setBlogId(rs.getInt("blog_id"));
                    blog.setTitle(rs.getString("title"));
                    blog.setContent(rs.getString("content"));
                    blog.setShortDescription(rs.getString("short_description"));
                    blog.setImageUrl(rs.getString("image_url"));
                    blog.setCategoryId(rs.getInt("category_id"));
                    blog.setCategoryName(rs.getString("category_name"));
                    blog.setAuthorName(rs.getString("author_name"));
                    blog.setViewCount(rs.getInt("view_count"));
                    blog.setIsFeatured(rs.getBoolean("is_featured"));
                    blog.setCreatedAt(rs.getDate("created_at"));
                    blog.setUpdatedAt(rs.getDate("updated_at"));
                    list.add(blog);
                }
            }
        }
        return list;
    }
// Lấy tổng số blog theo category_id

    public int getTotalBlogsByCategoryId(int categoryId) throws Exception {
        String sql = "SELECT COUNT(*) FROM Blogs WHERE category_id = ?";
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

}
