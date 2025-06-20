package com.mobilestore.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mobilestore.model.Admin;
import com.mobilestore.util.DatabaseUtil;

@WebServlet("/AdminBookingServlet")
public class AdminBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("AdminBookingServlet: doGet method called");
        
        Admin admin = (Admin) request.getSession().getAttribute("admin");
        if (admin == null) {
            System.out.println("AdminBookingServlet: Admin not logged in");
            response.sendRedirect("adminlogin.jsp");
            return;
        }

        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            System.out.println("AdminBookingServlet: Database connection established");
            
            String sql = "SELECT sb.*, u.name as user_name, u.email as user_email " +
                        "FROM service_bookings sb " +
                        "JOIN users u ON sb.user_id = u.id " +
                        "ORDER BY sb.booking_date DESC";
            
            System.out.println("AdminBookingServlet: Executing SQL: " + sql);
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Booking booking = new Booking();
                        booking.setBookingId(rs.getInt("booking_id"));
                        booking.setUserName(rs.getString("user_name"));
                        booking.setUserEmail(rs.getString("user_email"));
                        booking.setServiceType(rs.getString("service_type"));
                        booking.setDeviceType(rs.getString("device_type"));
                        booking.setBookingDate(rs.getDate("booking_date").toString());
                        booking.setTimeSlot(rs.getString("time_slot"));
                        booking.setNotes(rs.getString("notes"));
                        booking.setStatus(rs.getString("status"));
                        bookings.add(booking);
                        System.out.println("AdminBookingServlet: Found booking - ID: " + booking.getBookingId());
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("AdminBookingServlet: SQL Error: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("AdminBookingServlet: Total bookings found: " + bookings.size());
        
        // Set content type to HTML
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        
        // Build HTML table
        StringBuilder html = new StringBuilder();
        html.append("<table class='table table-striped'>");
        html.append("<thead><tr>");
        html.append("<th>Booking ID</th>");
        html.append("<th>User</th>");
        html.append("<th>Service Type</th>");
        html.append("<th>Device Type</th>");
        html.append("<th>Date</th>");
        html.append("<th>Time Slot</th>");
        html.append("<th>Notes</th>");
        html.append("<th>Status</th>");
        html.append("<th>Actions</th>");
        html.append("</tr></thead><tbody>");
        
        if (bookings.isEmpty()) {
            html.append("<tr><td colspan='9' class='text-center'>No bookings found</td></tr>");
        } else {
            for (Booking booking : bookings) {
                html.append("<tr>");
                html.append("<td>").append(booking.getBookingId()).append("</td>");
                html.append("<td>").append(booking.getUserName()).append("<br>").append(booking.getUserEmail()).append("</td>");
                html.append("<td>").append(booking.getServiceType()).append("</td>");
                html.append("<td>").append(booking.getDeviceType()).append("</td>");
                html.append("<td>").append(booking.getBookingDate()).append("</td>");
                html.append("<td>").append(booking.getTimeSlot()).append("</td>");
                html.append("<td>").append(booking.getNotes() != null ? booking.getNotes() : "-").append("</td>");
                html.append("<td><span class='status-").append(booking.getStatus().toLowerCase()).append("'>")
                    .append(booking.getStatus()).append("</span></td>");
                html.append("<td>");
                
                if ("Pending".equals(booking.getStatus())) {
                    html.append("<form action='UpdateBookingStatusServlet' method='post' style='display:inline;'>");
                    html.append("<input type='hidden' name='bookingId' value='").append(booking.getBookingId()).append("'>");
                    html.append("<input type='hidden' name='status' value='Accepted'>");
                    html.append("<button type='submit' class='btn btn-success btn-sm'>Accept</button>");
                    html.append("</form>");
                    
                    html.append("<form action='UpdateBookingStatusServlet' method='post' style='display:inline;'>");
                    html.append("<input type='hidden' name='bookingId' value='").append(booking.getBookingId()).append("'>");
                    html.append("<input type='hidden' name='status' value='Rejected'>");
                    html.append("<button type='submit' class='btn btn-danger btn-sm'>Reject</button>");
                    html.append("</form>");
                } else {
                    html.append("-");
                }
                
                html.append("</td>");
                html.append("</tr>");
            }
        }
        
        html.append("</tbody></table>");
        
        response.getWriter().write(html.toString());
    }
    
    private static class Booking {
        private int bookingId;
        private String userName;
        private String userEmail;
        private String serviceType;
        private String deviceType;
        private String bookingDate;
        private String timeSlot;
        private String notes;
        private String status;
        
        // Getters and setters
        public int getBookingId() { return bookingId; }
        public void setBookingId(int bookingId) { this.bookingId = bookingId; }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getUserEmail() { return userEmail; }
        public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
        public String getServiceType() { return serviceType; }
        public void setServiceType(String serviceType) { this.serviceType = serviceType; }
        public String getDeviceType() { return deviceType; }
        public void setDeviceType(String deviceType) { this.deviceType = deviceType; }
        public String getBookingDate() { return bookingDate; }
        public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
        public String getTimeSlot() { return timeSlot; }
        public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
        public String getNotes() { return notes; }
        public void setNotes(String notes) { this.notes = notes; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
} 