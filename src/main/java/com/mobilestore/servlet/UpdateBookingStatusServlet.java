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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.mobilestore.model.Admin;
import com.mobilestore.util.DatabaseUtil;

@WebServlet("/UpdateBookingStatusServlet")
public class UpdateBookingStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Admin admin = (Admin) request.getSession().getAttribute("admin");
        if (admin == null) {
            response.sendRedirect("adminlogin.jsp");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String status = request.getParameter("status");

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "UPDATE service_bookings SET status = ? WHERE booking_id = ?";
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, status);
                pstmt.setInt(2, bookingId);
                
                pstmt.executeUpdate();
            }
            
            response.sendRedirect("AdminServiceBookings.jsp?success=true");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("AdminServiceBookings.jsp?error=true");
        }
    }
} 