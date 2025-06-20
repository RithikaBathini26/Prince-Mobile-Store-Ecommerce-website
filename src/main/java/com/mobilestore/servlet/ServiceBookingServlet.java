package com.mobilestore.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mobilestore.model.User;
import com.mobilestore.util.DatabaseUtil;

@WebServlet("/ServiceBookingServlet")
public class ServiceBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String serviceType = request.getParameter("serviceType");
        String deviceType = request.getParameter("deviceType");
        String bookingDate = request.getParameter("bookingDate");
        String timeSlot = request.getParameter("timeSlot");
        String notes = request.getParameter("notes");

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "INSERT INTO service_bookings (user_id, service_type, device_type, booking_date, time_slot, notes, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, 'Pending')";
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, user.getId());
                pstmt.setString(2, serviceType);
                pstmt.setString(3, deviceType);
                pstmt.setString(4, bookingDate);
                pstmt.setString(5, timeSlot);
                pstmt.setString(6, notes);
                
                int rowsAffected = pstmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    response.sendRedirect("userServiceBookings.jsp?success=true");
                } else {
                    response.sendRedirect("bookService.jsp?error=true&message=Failed to create booking");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("bookService.jsp?error=true&message=" + e.getMessage());
        }
    }
} 