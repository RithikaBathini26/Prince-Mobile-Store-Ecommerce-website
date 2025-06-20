package com.mobilestore.servlet;

import com.mobilestore.util.NotificationManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/markNotificationRead")
public class MarkNotificationReadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String indexStr = request.getParameter("index");
        
        if (userIdStr != null && !userIdStr.isEmpty() && indexStr != null && !indexStr.isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdStr);
                int index = Integer.parseInt(indexStr);
                NotificationManager.markAsRead(userId, index);
                response.setStatus(HttpServletResponse.SC_OK);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
} 