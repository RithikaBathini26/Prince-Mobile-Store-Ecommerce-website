package com.mobilestore.model;

import java.util.Date;

public class Notification {
    private int id;
    private int userId;
    private String message;
    private boolean isRead;
    private Date createdAt;
    private String type;
    private String productName;

    public Notification(int id, int userId, String message, boolean isRead, Date createdAt) {
        this.id = id;
        this.userId = userId;
        this.message = message;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    // Constructor for NotificationManager
    public Notification(String message, String type, String productName) {
        this.message = message;
        this.type = type;
        this.productName = productName;
        this.isRead = false;
        this.createdAt = new Date(); // Current timestamp
    }

    public int getId() {
        return id;
    }

    public int getUserId() {
        return userId;
    }

    public String getMessage() {
        return message;
    }

    public boolean isRead() {
        return isRead;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public String getType() {
        return type;
    }

    public String getProductName() {
        return productName;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
} 