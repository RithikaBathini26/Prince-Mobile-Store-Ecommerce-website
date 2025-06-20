package com.mobilestore.servlet;

import com.mobilestore.dao.NotificationDAO;
import com.mobilestore.model.Notification;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.text.SimpleDateFormat;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private SimpleDateFormat dateFormat;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
        dateFormat = new SimpleDateFormat("MMM d, yyyy");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("list".equals(action)) {
                // Return JSON response for AJAX requests
                List<Notification> notifications = notificationDAO.getUserNotifications(user.getId());
                int unreadCount = notificationDAO.getUnreadCount(user.getId());
                
                StringBuilder responseText = new StringBuilder();
                responseText.append(unreadCount).append("\n"); // First line is unread count
                
                for (Notification notification : notifications) {
                    // Format: id|message|isRead|createdAt
                    responseText.append(notification.getId())
                              .append("|")
                              .append(notification.getMessage())
                              .append("|")
                              .append(notification.isRead())
                              .append("|")
                              .append(dateFormat.format(notification.getCreatedAt()))
                              .append("\n");
                }
                
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(responseText.toString());
                out.flush();
            } else {
                // Regular page load - set attributes and forward to JSP
                List<Notification> notifications = notificationDAO.getUserNotifications(user.getId());
                int unreadCount = notificationDAO.getUnreadCount(user.getId());
                
                request.setAttribute("notifications", notifications);
                request.setAttribute("unreadCount", unreadCount);
                request.getRequestDispatcher("/notifications.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Log the error
            getServletContext().log("Error getting notifications", e);
            
            // For AJAX requests, return error response
            if ("list".equals(action)) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error: " + e.getMessage());
            } else {
                // For regular page loads, show error message
                request.setAttribute("error", "Error loading notifications: " + e.getMessage());
                request.setAttribute("notifications", new ArrayList<>());
                request.setAttribute("unreadCount", 0);
                request.getRequestDispatcher("/notifications.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("markAsRead".equals(action)) {
                int notificationId = Integer.parseInt(request.getParameter("id"));
                notificationDAO.markAsRead(notificationId);
                
                // Return plain text response
                int unreadCount = notificationDAO.getUnreadCount(user.getId());
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print("success\n" + unreadCount);
                out.flush();
            }
        } catch (SQLException e) {
            // Log the error
            getServletContext().log("Error marking notification as read", e);
            
            // Return error response
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
} 