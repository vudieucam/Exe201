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
import java.util.Date;
import java.util.List;
import model.Blog;

/**
 *
 * @author FPT
 */
public class BlogDAO extends DBConnect {

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

    // Create a new blog
    public boolean createBlog(Blog blog) {
        String sql = "INSERT INTO Blogs (title, content, short_description, image_url, category_id, "
                + "author_id, author_name, is_featured, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getShortDescription());
            ps.setString(4, blog.getImageUrl());
            ps.setInt(5, blog.getCategoryId());
            ps.setInt(6, blog.getAuthorId());
            ps.setString(7, blog.getAuthorName());
            ps.setBoolean(8, blog.isIsFeatured());
            ps.setBoolean(9, blog.getStatus() == 1);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete a blog (soft delete by setting status to false)
    public boolean deleteBlog(int blogId) {
        String sql = "UPDATE Blogs SET status = 0 WHERE blog_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all blogs (including inactive)
    public List<Blog> getAllBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBlogFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get all active blogs
    public List<Blog> getAllActiveBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBlogFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get blog by ID
    public Blog getBlogById(int id) {
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.blog_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBlogFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get blogs by category ID
    public List<Blog> getBlogsByCategoryId(int categoryId) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.category_id = ? AND b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBlogFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get featured blogs
    public List<Blog> getFeaturedBlogs(int limit) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.is_featured = 1 AND b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBlogFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Search blogs by keyword
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

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBlogFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Helper method to map ResultSet to Blog object
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
        blog.setStatus(rs.getBoolean("status") ? 1 : 0);
        return blog;
    }

    // Bổ sung các hàm còn thiếu vào lớp BlogDAO
// Toggle trạng thái blog (active/inactive)
    public boolean toggleBlogStatus(int blogId) {
        String sql = "UPDATE Blogs SET status = ~status WHERE blog_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Tăng số lượt xem blog
    public boolean incrementViewCount(int blogId) {
        String sql = "UPDATE Blogs SET view_count = view_count + 1 WHERE blog_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Lấy danh sách blog theo trạng thái featured
    public List<Blog> getBlogsByFeaturedStatus(boolean isFeatured) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.is_featured = ? AND b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isFeatured);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBlogFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// Lấy tổng số blog theo trạng thái
    public int countBlogsByStatus(boolean status) {
        String sql = "SELECT COUNT(*) FROM Blogs WHERE status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

// Lấy blog theo khoảng thời gian
    public List<Blog> getBlogsByDateRange(Date startDate, Date endDate) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.created_at BETWEEN ? AND ? "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBlogFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// Lấy blog mới nhất
    public Blog getLatestBlog() {
        String sql = "SELECT TOP 1 b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapBlogFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

// Lấy các blog liên quan (cùng category)
    public List<Blog> getRelatedBlogs(int blogId, int limit) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.category_id = (SELECT category_id FROM Blogs WHERE blog_id = ?) "
                + "AND b.blog_id != ? AND b.status = 1 AND c.status = 1 "
                + "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, blogId);
            ps.setInt(3, blogId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBlogFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm các phương thức sau vào BlogDAO.java
    public List<Blog> getBlogs(int page, int recordsPerPage, String statusFilter, String featuredFilter) {
        List<Blog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id WHERE 1=1");

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND b.status = ").append(statusFilter.equals("active") ? "1" : "0");
        }

        if (featuredFilter != null && !featuredFilter.isEmpty()) {
            sql.append(" AND b.is_featured = ").append(featuredFilter.equals("featured") ? "1" : "0");
        }

        sql.append(" ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int offset = (page - 1) * recordsPerPage;
            ps.setInt(1, offset);
            ps.setInt(2, recordsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBlogFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalBlogs(String statusFilter, String featuredFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Blogs WHERE 1=1");

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ").append(statusFilter.equals("active") ? "1" : "0");
        }

        if (featuredFilter != null && !featuredFilter.isEmpty()) {
            sql.append(" AND is_featured = ").append(featuredFilter.equals("featured") ? "1" : "0");
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
    // Thêm phương thức addBlog mới

    public int addBlog(Blog blog) throws SQLException {
        String sql = "INSERT INTO Blogs (title, content, short_description, image_url, category_id, "
                + "author_name, is_featured, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getShortDescription());
            ps.setString(4, blog.getImageUrl());
            ps.setInt(5, blog.getCategoryId());
            ps.setString(6, blog.getAuthorName());
            ps.setBoolean(7, blog.isIsFeatured());
            ps.setBoolean(8, blog.getStatus() == 1);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return -1;
        }
    }

// Cải thiện phương thức updateBlog
    public boolean updateBlog(Blog blog) throws SQLException {
        String sql = "UPDATE Blogs SET title = ?, content = ?, short_description = ?, image_url = ?, "
                + "category_id = ?, is_featured = ?, status = ?, updated_at = GETDATE() "
                + "WHERE blog_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getShortDescription());
            ps.setString(4, blog.getImageUrl());
            ps.setInt(5, blog.getCategoryId());
            ps.setBoolean(6, blog.isIsFeatured());
            ps.setBoolean(7, blog.getStatus() == 1);
            ps.setInt(8, blog.getBlogId());

            return ps.executeUpdate() > 0;
        }
    }

// Thêm phương thức getBlogByIdForAdmin
    public Blog getBlogByIdForAdmin(int id) throws SQLException {
        String sql = "SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id "
                + "WHERE b.blog_id = ?";

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
    
    // Thêm phương thức getBlogs với tham số search
    public List<Blog> getBlogs(int page, int recordsPerPage, String statusFilter, String featuredFilter, String search) {
        List<Blog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT b.*, c.category_name FROM Blogs b "
                + "JOIN BlogCategories c ON b.category_id = c.category_id WHERE 1=1");

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND b.status = ").append(statusFilter.equals("active") ? "1" : "0");
        }

        if (featuredFilter != null && !featuredFilter.isEmpty()) {
            sql.append(" AND b.is_featured = ").append(featuredFilter.equals("featured") ? "1" : "0");
        }

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (b.title LIKE ? OR b.content LIKE ? OR b.short_description LIKE ?)");
        }

        sql.append(" ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            
            if (search != null && !search.isEmpty()) {
                String searchPattern = "%" + search + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            int offset = (page - 1) * recordsPerPage;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, recordsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBlogFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm phương thức getTotalBlogs với tham số search
    public int getTotalBlogs(String statusFilter, String featuredFilter, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Blogs b WHERE 1=1");

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND b.status = ").append(statusFilter.equals("active") ? "1" : "0");
        }

        if (featuredFilter != null && !featuredFilter.isEmpty()) {
            sql.append(" AND b.is_featured = ").append(featuredFilter.equals("featured") ? "1" : "0");
        }

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (b.title LIKE ? OR b.content LIKE ? OR b.short_description LIKE ?)");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            
            if (search != null && !search.isEmpty()) {
                String searchPattern = "%" + search + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
