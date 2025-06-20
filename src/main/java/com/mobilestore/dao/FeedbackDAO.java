package com.mobilestore.dao;

import com.mobilestore.model.Feedback;
import com.mobilestore.model.User;
import com.mobilestore.model.Product;
import com.mobilestore.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class FeedbackDAO {
    private static final String ADD_FEEDBACK = "INSERT INTO feedback (user_id, product_id, order_id, rating, comment, type, issue_type, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_FEEDBACK = "UPDATE feedback SET rating = ?, comment = ?, updated_at = CURRENT_TIMESTAMP, status = ? WHERE id = ? AND user_id = ?";
    private static final String DELETE_FEEDBACK = "DELETE FROM feedback WHERE id = ? AND user_id = ?";
    private static final String GET_FEEDBACK_BY_ID = "SELECT f.*, u.name as user_name, u.email as user_email FROM feedback f JOIN users u ON f.user_id = u.id WHERE f.id = ?";
    private static final String GET_PRODUCT_FEEDBACK = "SELECT f.*, u.name as user_name, u.email as user_email, u.id as user_id FROM feedback f " +
            "JOIN users u ON f.user_id = u.id " +
            "WHERE f.product_id = ? AND f.type = 'review' " +
            "ORDER BY f.created_at DESC";
    private static final String GET_USER_FEEDBACK = "SELECT f.*, p.name as product_name, p.image_url FROM feedback f JOIN products p ON f.product_id = p.id WHERE f.user_id = ? ORDER BY f.created_at DESC";
    private static final String GET_PRODUCT_RATING = "SELECT AVG(rating) as avg_rating, COUNT(*) as total_reviews FROM feedback WHERE product_id = ? AND type = 'review'";
    private static final String CHECK_USER_FEEDBACK = "SELECT COUNT(*) FROM feedback WHERE user_id = ? AND product_id = ? AND order_id = ? AND type = 'review'";
    private static final String GET_ALL_FEEDBACK = "SELECT f.*, u.name as user_name, u.email as user_email, p.name as product_name FROM feedback f JOIN users u ON f.user_id = u.id JOIN products p ON f.product_id = p.id ORDER BY f.created_at DESC";
    private static final String GET_USER_HELP_REQUESTS = "SELECT f.*, p.name as product_name FROM feedback f JOIN products p ON f.product_id = p.id WHERE f.user_id = ? AND f.type = 'help' ORDER BY f.created_at DESC";

    public int addFeedback(Feedback feedback) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(ADD_FEEDBACK, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, feedback.getUserId());
            stmt.setInt(2, feedback.getProductId());
            stmt.setInt(3, feedback.getOrderId());
            stmt.setInt(4, feedback.getRating());
            stmt.setString(5, feedback.getComment());
            stmt.setString(6, feedback.getType() != null ? feedback.getType() : "review");
            stmt.setString(7, feedback.getIssueType());
            stmt.setString(8, feedback.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateFeedback(Feedback feedback) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_FEEDBACK)) {
            
            stmt.setInt(1, feedback.getRating());
            stmt.setString(2, feedback.getComment());
            stmt.setString(3, feedback.getStatus());
            stmt.setInt(4, feedback.getId());
            stmt.setInt(5, feedback.getUserId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteFeedback(int feedbackId, int userId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_FEEDBACK)) {
            
            stmt.setInt(1, feedbackId);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Feedback getFeedbackById(int feedbackId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_FEEDBACK_BY_ID)) {
            
            stmt.setInt(1, feedbackId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFeedbackFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Feedback> getProductFeedback(int productId) {
        List<Feedback> feedbackList = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_PRODUCT_FEEDBACK)) {
            
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(extractFeedbackFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public List<Feedback> getUserFeedback(int userId) {
        List<Feedback> feedbackList = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_FEEDBACK)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = extractFeedbackFromResultSet(rs);
                    Product product = new Product();
                    product.setName(rs.getString("product_name"));
                    product.setImageUrl(rs.getString("image_url"));
                    feedback.setProduct(product);
                    feedbackList.add(feedback);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public double[] getProductRating(int productId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_PRODUCT_RATING)) {
            
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double avgRating = rs.getDouble("avg_rating");
                    int totalReviews = rs.getInt("total_reviews");
                    return new double[]{avgRating, totalReviews};
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new double[]{0.0, 0};
    }

    public boolean hasUserReviewed(int userId, int productId, int orderId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(CHECK_USER_FEEDBACK)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.setInt(3, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_ALL_FEEDBACK)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = extractFeedbackFromResultSet(rs);
                    Product product = new Product();
                    product.setName(rs.getString("product_name"));
                    feedback.setProduct(product);
                    feedbackList.add(feedback);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    private Feedback extractFeedbackFromResultSet(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setProductId(rs.getInt("product_id"));
        feedback.setOrderId(rs.getInt("order_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setComment(rs.getString("comment"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        feedback.setUpdatedAt(rs.getTimestamp("updated_at"));
        feedback.setType(rs.getString("type"));
        feedback.setIssueType(rs.getString("issue_type"));
        feedback.setStatus(rs.getString("status"));

        // Create and set user information
        User user = new User();
        user.setId(rs.getInt("user_id"));
        String userName = rs.getString("user_name");
        String userEmail = rs.getString("user_email");
        
        if (userName != null && !userName.trim().isEmpty()) {
            user.setName(userName);
            user.setEmail(userEmail);
            feedback.setUser(user);
        }

        return feedback;
    }

    public List<Feedback> getUserHelpRequests(int userId) {
        List<Feedback> helpRequests = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_HELP_REQUESTS)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = extractFeedbackFromResultSet(rs);
                    Product product = new Product();
                    product.setName(rs.getString("product_name"));
                    feedback.setProduct(product);
                    helpRequests.add(feedback);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return helpRequests;
    }

    public Map<Integer, Integer> getRatingDistribution(int productId) {
        Map<Integer, Integer> distribution = new HashMap<>();
        String sql = "SELECT rating, COUNT(*) as count FROM feedback WHERE product_id = ? AND type = 'review' GROUP BY rating ORDER BY rating DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    distribution.put(rs.getInt("rating"), rs.getInt("count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distribution;
    }
} 