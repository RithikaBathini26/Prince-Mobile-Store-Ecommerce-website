package com.mobilestore.util;

import com.mobilestore.model.Notification;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class NotificationManager {
    private static final Map<Integer, List<Notification>> userNotifications = new ConcurrentHashMap<>();
    
    public static void addNotification(int userId, String message, String type, String productName) {
        Notification notification = new Notification(message, type, productName);
        userNotifications.computeIfAbsent(userId, k -> Collections.synchronizedList(new ArrayList<>()))
                        .add(0, notification); // Add at the beginning for newest first
    }
    
    public static void addNotificationForAllUsers(List<Integer> userIds, String message, String type, String productName) {
        for (Integer userId : userIds) {
            addNotification(userId, message, type, productName);
        }
    }
    
    public static List<Notification> getNotifications(int userId) {
        return userNotifications.getOrDefault(userId, Collections.emptyList());
    }
    
    public static void markAsRead(int userId, int index) {
        List<Notification> notifications = userNotifications.get(userId);
        if (notifications != null && index >= 0 && index < notifications.size()) {
            notifications.get(index).setRead(true);
        }
    }
    
    public static int getUnreadCount(int userId) {
        List<Notification> notifications = userNotifications.get(userId);
        if (notifications == null) return 0;
        
        return (int) notifications.stream()
                                .filter(n -> !n.isRead())
                                .count();
    }
    
    // Optional: Clear old notifications (you can call this periodically)
    public static void clearOldNotifications(int daysOld) {
        Date cutoffDate = new Date(System.currentTimeMillis() - (daysOld * 24 * 60 * 60 * 1000L));
        userNotifications.values().forEach(notifications -> 
            notifications.removeIf(n -> n.getCreatedAt().before(cutoffDate))
        );
    }
} 