package com.mobilestore.dao;

import com.mobilestore.model.Notification;
import com.mobilestore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    private static final String INSERT_NOTIFICATION = "INSERT INTO notifications (user_id, message, is_read, created_at, type) VALUES (?, ?, ?, ?, ?)";
    private static final String GET_USER_NOTIFICATIONS = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
    private static final String MARK_AS_READ = "UPDATE notifications SET is_read = true WHERE id = ?";
    private static final String GET_UNREAD_COUNT = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = false";
    private static final String DELETE_OLD_NOTIFICATIONS = "DELETE FROM notifications WHERE created_at < ?";
    private static final String INSERT_NOTIFICATION_FOR_ALL_USERS = "INSERT INTO notifications (user_id, message, is_read, created_at, type) SELECT id, ?, false, ?, 'product_added' FROM users WHERE id != ?"; // Exclude admin

    public void addNotification(int userId, String message) throws SQLException {
        System.out.println("Adding notification for user " + userId + ": " + message);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_NOTIFICATION)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, message);
            stmt.setBoolean(3, false);
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            stmt.setString(5, "general"); // Default type
            int rows = stmt.executeUpdate();
            System.out.println("Added " + rows + " notification(s)");
        }
    }

    public void addNotificationForAllUsers(String message, int excludeUserId) throws SQLException {
        System.out.println("Adding notification for all users (except " + excludeUserId + "): " + message);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_NOTIFICATION_FOR_ALL_USERS)) {
            
            stmt.setString(1, message);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(3, excludeUserId); // Exclude the admin who added the product
            int rows = stmt.executeUpdate();
            System.out.println("Added notification for " + rows + " user(s)");
        }
    }

    public List<Notification> getUserNotifications(int userId) throws SQLException {
        System.out.println("Getting notifications for user " + userId);
        List<Notification> notifications = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_NOTIFICATIONS)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = new Notification(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("message"),
                        rs.getBoolean("is_read"),
                        rs.getTimestamp("created_at")
                    );
                    notifications.add(notification);
                }
            }
            System.out.println("Found " + notifications.size() + " notification(s)");
        }
        return notifications;
    }

    public void markAsRead(int notificationId) throws SQLException {
        System.out.println("Marking notification " + notificationId + " as read");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(MARK_AS_READ)) {
            
            stmt.setInt(1, notificationId);
            int rows = stmt.executeUpdate();
            System.out.println("Marked " + rows + " notification(s) as read");
        }
    }

    public int getUnreadCount(int userId) throws SQLException {
        System.out.println("Getting unread count for user " + userId);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_UNREAD_COUNT)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("Found " + count + " unread notification(s)");
                    return count;
                }
            }
        }
        return 0;
    }

    public void clearOldNotifications(int daysOld) throws SQLException {
        System.out.println("Clearing notifications older than " + daysOld + " days");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_OLD_NOTIFICATIONS)) {
            
            Timestamp cutoffDate = new Timestamp(System.currentTimeMillis() - (daysOld * 24 * 60 * 60 * 1000L));
            stmt.setTimestamp(1, cutoffDate);
            int rows = stmt.executeUpdate();
            System.out.println("Cleared " + rows + " old notification(s)");
        }
    }

    // Test method to verify database connectivity
    public boolean testDatabaseConnection() {
        System.out.println("Testing database connection for notifications...");
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                // Test if notifications table exists
                try (PreparedStatement stmt = conn.prepareStatement("SELECT 1 FROM notifications LIMIT 1")) {
                    stmt.executeQuery();
                    System.out.println("Successfully connected to database and verified notifications table");
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
} 