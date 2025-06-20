<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.Admin" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mobilestore.util.DatabaseUtil" %>

<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }

    List<Map<String, String>> bookings = new ArrayList<>();
    try (Connection conn = DatabaseUtil.getConnection()) {
        String sql = "SELECT sb.*, u.name as user_name, u.email as user_email " +
                    "FROM service_bookings sb " +
                    "JOIN users u ON sb.user_id = u.id " +
                    "ORDER BY sb.booking_date DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> booking = new HashMap<>();
                    booking.put("bookingId", String.valueOf(rs.getInt("booking_id")));
                    booking.put("userName", rs.getString("user_name"));
                    booking.put("userEmail", rs.getString("user_email"));
                    booking.put("serviceType", rs.getString("service_type"));
                    booking.put("deviceType", rs.getString("device_type"));
                    booking.put("bookingDate", rs.getDate("booking_date").toString());
                    booking.put("timeSlot", rs.getString("time_slot"));
                    booking.put("notes", rs.getString("notes"));
                    booking.put("status", rs.getString("status"));
                    bookings.add(booking);
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Service Bookings Management - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #4338ca;
            --accent-color: #6366f1;
            --background-light: #f0f2f5;
            --background-dark: #1a1a1a;
            --text-light: #1e293b;
            --text-dark: #f8fafc;
            --card-bg-light: rgba(255, 255, 255, 0.9);
            --card-bg-dark: rgba(30, 41, 59, 0.9);
            --border-light: rgba(79, 70, 229, 0.1);
            --border-dark: rgba(255, 255, 255, 0.1);
            --shadow-light: 0 8px 32px rgba(79, 70, 229, 0.1);
            --shadow-dark: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--background-light);
            background-image: linear-gradient(135deg, #f0f2f5 0%, #e4e6eb 100%);
            min-height: 100vh;
            transition: background-color 0.3s ease;
            color: var(--text-light);
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, rgba(79, 70, 229, 0.1) 0%, rgba(99, 102, 241, 0.1) 100%);
            animation: gradientAnimation 15s ease infinite;
            z-index: -1;
        }

        @keyframes gradientAnimation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .page-header {
            background: #ffffff;
            padding: 30px;
            border-radius: 20px;
            box-shadow: var(--glass-shadow);
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-size: 2.2rem;
            color: var(--text-primary);
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header-actions h2 {
            color: var(--primary-color);
            margin: 0;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .bookings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }

        .booking-card {
            background: var(--card-bg-light);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-light);
        }

        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-light);
        }

        .booking-id {
            font-size: 0.9rem;
            color: var(--text-light);
            opacity: 0.7;
        }

        .booking-status {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
        }

        .status-accepted {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
        }

        .status-rejected {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
        }

        .booking-info {
            margin-bottom: 1rem;
        }

        .info-group {
            margin-bottom: 0.75rem;
        }

        .info-label {
            font-size: 0.8rem;
            color: var(--text-light);
            opacity: 0.7;
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-weight: 500;
            color: var(--text-light);
        }

        .user-info {
            background: rgba(79, 70, 229, 0.05);
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }

        .user-name {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.25rem;
        }

        .user-email {
            font-size: 0.9rem;
            color: var(--text-light);
            opacity: 0.7;
        }

        .booking-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border-light);
        }

        .booking-actions .btn {
            flex: 1;
        }

        .no-bookings {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
            background: var(--card-bg-light);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
        }

        .no-bookings i {
            font-size: 3rem;
            color: var(--accent-color);
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .bookings-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header" data-aos="fade-down">
            <h2 class="page-title">Service Bookings Management</h2>
            <a href="admindashboard.jsp" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        
        <% if (bookings.isEmpty()) { %>
            <div class="no-bookings" data-aos="fade-up">
                <i class="bi bi-calendar-x"></i>
                <h3>No Bookings Found</h3>
                <p class="text-muted">There are no service bookings in the system.</p>
            </div>
        <% } else { %>
            <div class="bookings-grid">
                <% for (Map<String, String> booking : bookings) { %>
                    <div class="booking-card" data-aos="fade-up">
                        <div class="booking-header">
                            <span class="booking-id">Booking #<%= booking.get("bookingId") %></span>
                            <span class="booking-status status-<%= booking.get("status").toLowerCase() %>">
                                <%= booking.get("status") %>
                            </span>
                        </div>
                        
                        <div class="user-info">
                            <div class="user-name"><%= booking.get("userName") %></div>
                            <div class="user-email"><%= booking.get("userEmail") %></div>
                        </div>

                        <div class="booking-info">
                            <div class="info-group">
                                <div class="info-label">Service Type</div>
                                <div class="info-value"><%= booking.get("serviceType") %></div>
                            </div>
                            <div class="info-group">
                                <div class="info-label">Device Type</div>
                                <div class="info-value"><%= booking.get("deviceType") %></div>
                            </div>
                            <div class="info-group">
                                <div class="info-label">Date & Time</div>
                                <div class="info-value">
                                    <%= booking.get("bookingDate") %> at <%= booking.get("timeSlot") %>
                                </div>
                            </div>
                            <% if (booking.get("notes") != null && !booking.get("notes").isEmpty()) { %>
                                <div class="info-group">
                                    <div class="info-label">Notes</div>
                                    <div class="info-value"><%= booking.get("notes") %></div>
                                </div>
                            <% } %>
                        </div>

                        <% if ("Pending".equals(booking.get("status"))) { %>
                            <div class="booking-actions">
                                <form action="UpdateBookingStatusServlet" method="post" style="flex: 1;">
                                    <input type="hidden" name="bookingId" value="<%= booking.get("bookingId") %>">
                                    <input type="hidden" name="status" value="Accepted">
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-check-lg"></i> Accept
                                    </button>
                                </form>
                                <form action="UpdateBookingStatusServlet" method="post" style="flex: 1;">
                                    <input type="hidden" name="bookingId" value="<%= booking.get("bookingId") %>">
                                    <input type="hidden" name="status" value="Rejected">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="bi bi-x-lg"></i> Reject
                                    </button>
                                </form>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true
        });
    </script>
</body>
</html> 