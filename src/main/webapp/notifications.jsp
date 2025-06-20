<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.model.Notification" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get notifications from request attributes
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    
    // If attributes are not set, redirect to servlet
    if (notifications == null || unreadCount == null) {
        response.sendRedirect("notifications");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .notification-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s;
            cursor: pointer;
        }
        .notification-item:hover {
            background-color: #f8f9fa;
        }
        .notification-item.unread {
            background-color: #e8f4fd;
        }
        .notification-item.unread:hover {
            background-color: #d8eaf9;
        }
        .notification-time {
            color: #6c757d;
            font-size: 0.875rem;
        }
        .notification-message {
            margin-bottom: 5px;
            color: #333;
        }
        .empty-notifications {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }
        .back-button {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="back-button">
            <a href="home.jsp" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
        </div>
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">Notifications</h4>
                        <span class="badge bg-primary" id="unreadCount"><%= unreadCount %> Unread</span>
                    </div>
                    <div class="card-body p-0">
                        <div id="notificationContainer">
                            <% if (notifications.isEmpty()) { %>
                                <div class="empty-notifications">
                                    <i class="fas fa-bell-slash fa-3x mb-3"></i>
                                    <p>No notifications yet</p>
                                </div>
                            <% } else { %>
                                <div class="notification-list">
                                    <% for (Notification notification : notifications) { %>
                                        <div class="notification-item <%= notification.isRead() ? "" : "unread" %>"
                                             data-notification-id="<%= notification.getId() %>">
                                            <div class="notification-message">
                                                <%= notification.getMessage() %>
                                            </div>
                                            <div class="notification-time">
                                                <%= notification.getCreatedAt() %>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Mark notification as read when clicked
            $('.notification-item.unread').click(function() {
                const $item = $(this);
                const notificationId = $item.data('notification-id');
                
                $.post('notifications', {
                    action: 'markAsRead',
                    id: notificationId
                }, function(response) {
                    const [status, unreadCount] = response.split('\n');
                    if (status === 'success') {
                        $item.removeClass('unread');
                        $('#unreadCount').text(unreadCount + ' Unread');
                        
                        // If no more unread notifications, refresh the page
                        if (parseInt(unreadCount) === 0) {
                            location.reload();
                        }
                    }
                });
            });
            
            // Refresh notifications every 30 seconds
            setInterval(function() {
                location.reload();
            }, 30000);
        });
    </script>
</body>
</html> 