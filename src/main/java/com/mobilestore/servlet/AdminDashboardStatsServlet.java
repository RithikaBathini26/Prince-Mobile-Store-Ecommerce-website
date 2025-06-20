package com.mobilestore.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mobilestore.model.Admin;
import com.mobilestore.util.DatabaseUtil;

@WebServlet("/AdminDashboardStatsServlet")
public class AdminDashboardStatsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Admin admin = (Admin) request.getSession().getAttribute("admin");
        if (admin == null) {
            response.sendRedirect("adminlogin.jsp");
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            // Get active orders count (orders with status 'Processing' or 'Pending')
            String ordersSql = "SELECT COUNT(*) as count FROM orders WHERE status IN ('Processing', 'Pending')";
            int activeOrdersCount = 0;
            
            try (PreparedStatement pstmt = conn.prepareStatement(ordersSql)) {
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        activeOrdersCount = rs.getInt("count");
                    }
                }
            }

            // Get service bookings count (bookings with status 'Pending')
            String bookingsSql = "SELECT COUNT(*) as count FROM service_bookings WHERE status = 'Pending'";
            int serviceBookingsCount = 0;
            
            try (PreparedStatement pstmt = conn.prepareStatement(bookingsSql)) {
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        serviceBookingsCount = rs.getInt("count");
                    }
                }
            }

            // Store the counts in the session
            request.getSession().setAttribute("activeOrdersCount", activeOrdersCount);
            request.getSession().setAttribute("serviceBookingsCount", serviceBookingsCount);

            // Redirect back to admin dashboard
            response.sendRedirect("admindashboard.jsp");
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("admindashboard.jsp?error=true");
        }
    }
} 