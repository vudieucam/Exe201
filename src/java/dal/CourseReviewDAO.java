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
import java.util.Date;
import java.util.List;
import model.Course;
import model.CourseReview;
import model.User;

public class CourseReviewDAO extends DBConnect {

    // Add a new review
    public boolean addReview(CourseReview review) {
        String sql = "INSERT INTO course_reviews (course_id, user_id, rating, comment, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, review.getCourseId());
            st.setInt(2, review.getUserId());
            st.setInt(3, review.getRating());
            st.setString(4, review.getComment());
            st.setBoolean(5, review.isStatus()); // Thêm trạng thái
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding review: " + e.getMessage());
            return false;
        }
    }

    // Get all reviews for a course
    public List<CourseReview> getReviewsByCourse(int courseId) {
        List<CourseReview> reviews = new ArrayList<>();
        String sql = "SELECT cr.*, u.fullname FROM course_reviews cr "
                + "JOIN users u ON cr.user_id = u.id "
                + "WHERE cr.course_id = ? AND cr.status = 1 "
                + "ORDER BY cr.created_at DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setFullname(rs.getString("fullname"));

                CourseReview review = new CourseReview(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getInt("user_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        new Date(rs.getTimestamp("created_at").getTime()),
                        rs.getBoolean("status"),
                        user
                );

                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Error getting reviews: " + e.getMessage());
        }
        return reviews;
    }

    // Get average rating for a course (only active reviews)
    public double getAverageRating(int courseId) {
        String sql = "SELECT AVG(rating) FROM course_reviews WHERE course_id = ? AND status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting average rating: " + e.getMessage());
        }
        return 0.0;
    }

    // Get review count for a course (only active reviews)
    public int getReviewCount(int courseId) {
        String sql = "SELECT COUNT(*) FROM course_reviews WHERE course_id = ? AND status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting review count: " + e.getMessage());
        }
        return 0;
    }

    // Check if user has already reviewed a course (active review only)
    public boolean hasUserReviewed(int userId, int courseId) {
        String sql = "SELECT 1 FROM course_reviews WHERE user_id = ? AND course_id = ? AND status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, courseId);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("Error checking user review: " + e.getMessage());
            return false;
        }
    }

    // Update a review
    public boolean updateReview(CourseReview review) {
        String sql = "UPDATE course_reviews SET rating = ?, comment = ?, status = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, review.getRating());
            st.setString(2, review.getComment());
            st.setBoolean(3, review.isStatus());
            st.setInt(4, review.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating review: " + e.getMessage());
            return false;
        }
    }

    // Soft delete a review (set status to inactive)
    public boolean deleteReview(int reviewId) {
        String sql = "UPDATE course_reviews SET status = 0 WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting review: " + e.getMessage());
            return false;
        }
    }

    // Get review by ID (regardless of status)
    public CourseReview getReviewById(int reviewId) {
        String sql = "SELECT cr.*, u.fullname FROM course_reviews cr "
                + "JOIN users u ON cr.user_id = u.id "
                + "WHERE cr.id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setFullname(rs.getString("fullname"));

                return new CourseReview(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getInt("user_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        new Date(rs.getTimestamp("created_at").getTime()),
                        rs.getBoolean("status"),
                        user
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting review by ID: " + e.getMessage());
        }
        return null;
    }

    // Get reviews by user (only active reviews)
// Get reviews by user (sửa lại)
    public List<CourseReview> getReviewsByUser(int userId) {
        List<CourseReview> reviews = new ArrayList<>();
        String sql = "SELECT cr.*, c.title AS course_title FROM course_reviews cr "
                + "JOIN courses c ON cr.course_id = c.id "
                + "WHERE cr.user_id = ? AND cr.status = 1 "
                + "ORDER BY cr.created_at DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                User user = new User(); // Tạo user nếu cần

                CourseReview review = new CourseReview(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getInt("user_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        new Date(rs.getTimestamp("created_at").getTime()),
                        rs.getBoolean("status"),
                        user
                );

                // Lưu thông tin course_title vào comment nếu cần
                // review.setComment(rs.getString("course_title")); 
                // Hoặc tạo một field mới nếu cần
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Error getting user reviews: " + e.getMessage());
        }
        return reviews;
    }

    // Get recent reviews with pagination (only active reviews)
    // Get recent reviews (sửa lại)
    public List<CourseReview> getRecentReviews(int limit, int offset) {
        List<CourseReview> reviews = new ArrayList<>();
        String sql = "SELECT cr.*, u.fullname, c.title AS course_title FROM course_reviews cr "
                + "JOIN users u ON cr.user_id = u.id "
                + "JOIN courses c ON cr.course_id = c.id "
                + "WHERE cr.status = 1 "
                + "ORDER BY cr.created_at DESC LIMIT ? OFFSET ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            st.setInt(2, offset);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setFullname(rs.getString("fullname"));

                CourseReview review = new CourseReview(
                        rs.getInt("id"),
                        rs.getInt("course_id"),
                        rs.getInt("user_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        new Date(rs.getTimestamp("created_at").getTime()),
                        rs.getBoolean("status"),
                        user
                );

                // Lưu course_title vào comment nếu cần
                // review.setComment("Course: " + rs.getString("course_title") + " - " + review.getComment());
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Error getting recent reviews: " + e.getMessage());
        }
        return reviews;
    }

    // Count all active reviews (for pagination)
    public int countAllReviews() {
        String sql = "SELECT COUNT(*) FROM course_reviews WHERE status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting reviews: " + e.getMessage());
        }
        return 0;
    }
}
