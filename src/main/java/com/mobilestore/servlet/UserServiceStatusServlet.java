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

import com.mobilestore.model.User;
import com.mobilestore.util.DatabaseUtil;

@WebServlet("/UserServiceStatusServlet")
public class UserServiceStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT sb.*, sa.full_name, sa.address, sa.city, sa.state, sa.zip_code, sa.phone " +
                        "FROM service_bookings sb " +
                        "LEFT JOIN shipping_addresses sa ON sb.user_id = sa.user_id " +
                        "WHERE sb.user_id = ? ORDER BY sb.booking_date DESC";
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, user.getId());
                
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Booking booking = new Booking();
                        booking.setBookingId(rs.getInt("booking_id"));
                        booking.setServiceType(rs.getString("service_type"));
                        booking.setDeviceType(rs.getString("device_type"));
                        booking.setBookingDate(rs.getDate("booking_date").toString());
                        booking.setTimeSlot(rs.getString("time_slot"));
                        booking.setStatus(rs.getString("status"));
                        
                        // Add shipping address details
                        booking.setFullName(rs.getString("full_name"));
                        booking.setAddress(rs.getString("address"));
                        booking.setCity(rs.getString("city"));
                        booking.setState(rs.getString("state"));
                        booking.setZipCode(rs.getString("zip_code"));
                        booking.setPhone(rs.getString("phone"));
                        
                        bookings.add(booking);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving bookings");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Build JSON manually
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < bookings.size(); i++) {
            Booking booking = bookings.get(i);
            json.append("{")
                .append("\"bookingId\":").append(booking.getBookingId()).append(",")
                .append("\"serviceType\":\"").append(escapeJson(booking.getServiceType())).append("\",")
                .append("\"deviceType\":\"").append(escapeJson(booking.getDeviceType())).append("\",")
                .append("\"bookingDate\":\"").append(escapeJson(booking.getBookingDate())).append("\",")
                .append("\"timeSlot\":\"").append(escapeJson(booking.getTimeSlot())).append("\",")
                .append("\"status\":\"").append(escapeJson(booking.getStatus())).append("\",")
                .append("\"fullName\":\"").append(escapeJson(booking.getFullName())).append("\",")
                .append("\"address\":\"").append(escapeJson(booking.getAddress())).append("\",")
                .append("\"city\":\"").append(escapeJson(booking.getCity())).append("\",")
                .append("\"state\":\"").append(escapeJson(booking.getState())).append("\",")
                .append("\"zipCode\":\"").append(escapeJson(booking.getZipCode())).append("\",")
                .append("\"phone\":\"").append(escapeJson(booking.getPhone())).append("\"")
                .append("}");
            if (i < bookings.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        
        response.getWriter().write(json.toString());
    }
    
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
    
    private static class Booking {
        private int bookingId;
        private String serviceType;
        private String deviceType;
        private String bookingDate;
        private String timeSlot;
        private String status;
        private String fullName;
        private String address;
        private String city;
        private String state;
        private String zipCode;
        private String phone;
        
        // Getters and setters
        public int getBookingId() { return bookingId; }
        public void setBookingId(int bookingId) { this.bookingId = bookingId; }
        public String getServiceType() { return serviceType; }
        public void setServiceType(String serviceType) { this.serviceType = serviceType; }
        public String getDeviceType() { return deviceType; }
        public void setDeviceType(String deviceType) { this.deviceType = deviceType; }
        public String getBookingDate() { return bookingDate; }
        public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
        public String getTimeSlot() { return timeSlot; }
        public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        public String getAddress() { return address; }
        public void setAddress(String address) { this.address = address; }
        public String getCity() { return city; }
        public void setCity(String city) { this.city = city; }
        public String getState() { return state; }
        public void setState(String state) { this.state = state; }
        public String getZipCode() { return zipCode; }
        public void setZipCode(String zipCode) { this.zipCode = zipCode; }
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
    }
} 