<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mobilestore.util.DatabaseUtil" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, String>> bookings = new ArrayList<>();
    try (Connection conn = DatabaseUtil.getConnection()) {
        String sql = "SELECT * FROM service_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, user.getId());
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> booking = new HashMap<>();
                    booking.put("bookingId", String.valueOf(rs.getInt("booking_id")));
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
    <title>My Service Bookings - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #4338ca;
            --accent-color: #6366f1;
            --background-light: #f0f2f5;
            --text-light: #1e293b;
            --card-bg: rgba(255, 255, 255, 0.9);
            --border-light: rgba(79, 70, 229, 0.1);
            --shadow-light: 0 8px 32px rgba(79, 70, 229, 0.1);
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--background-light);
            background-image: linear-gradient(135deg, #f0f2f5 0%, #e4e6eb 100%);
            min-height: 100vh;
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

        .floating-mobiles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
            overflow: hidden;
        }

        .mobile {
            position: absolute;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            opacity: 0.08;
            filter: blur(0.5px);
        }

        .accessory {
            position: absolute;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            opacity: 0.10;
            filter: blur(0.3px);
            z-index: -1;
        }

        @keyframes float1 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(20px, -15px) rotate(5deg); }
            50% { transform: translate(0, -30px) rotate(0deg); }
            75% { transform: translate(-20px, -15px) rotate(-5deg); }
        }

        @keyframes float2 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(-15px, 20px) rotate(-5deg); }
            50% { transform: translate(0, 40px) rotate(0deg); }
            75% { transform: translate(15px, 20px) rotate(5deg); }
        }

        @keyframes float3 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(15px, -20px) rotate(3deg); }
            50% { transform: translate(30px, 0) rotate(0deg); }
            75% { transform: translate(15px, 20px) rotate(-3deg); }
        }

        @keyframes float4 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(-20px, 15px) rotate(-3deg); }
            50% { transform: translate(-40px, 0) rotate(0deg); }
            75% { transform: translate(-20px, -15px) rotate(3deg); }
        }

        @keyframes float5 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(0, 25px) rotate(2deg); }
            50% { transform: translate(0, 50px) rotate(0deg); }
            75% { transform: translate(0, 25px) rotate(-2deg); }
        }

        .mobile-right-1 { right: 0; top: 10%; width: 90px; height: 180px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 15s ease-in-out infinite; }
        .mobile-right-2 { right: 0; top: 40%; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 18s ease-in-out infinite; }
        .mobile-left-1 { left: 0; top: 20%; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 16s ease-in-out infinite; }
        .mobile-left-2 { left: 0; top: 60%; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float4 14s ease-in-out infinite; }
        .mobile-top-1 { left: 20%; top: 0; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float5 17s ease-in-out infinite; }
        .mobile-top-2 { left: 60%; top: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 19s ease-in-out infinite; }
        .mobile-bottom-1 { left: 30%; bottom: 0; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 16s ease-in-out infinite; }
        .mobile-bottom-2 { left: 70%; bottom: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 15s ease-in-out infinite; }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }

        .page-header {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            color: var(--primary-color);
            font-size: 2rem;
            margin: 0;
            font-weight: 600;
        }

        .bookings-table {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--shadow-light);
        }

        .booking-card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-light);
        }

        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-light);
        }

        .booking-id {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .status-accepted {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .status-rejected {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .detail-item {
            margin-bottom: 0.5rem;
        }

        .detail-label {
            font-size: 0.9rem;
            color: var(--text-light);
            opacity: 0.7;
            margin-bottom: 0.25rem;
        }

        .detail-value {
            font-weight: 500;
            color: var(--text-light);
        }

        .btn-primary {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .btn-secondary {
            background: var(--accent-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .no-bookings {
            text-align: center;
            padding: 3rem;
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            box-shadow: var(--shadow-light);
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
            
            .page-header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .booking-details {
                grid-template-columns: 1fr;
            }
        }

        @keyframes gradientAnimation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
    </style>
</head>
<body>
    <div class="floating-mobiles">
        <!-- Accessories -->
        <div class="accessory accessory-earphones"></div>
        <div class="accessory accessory-charger"></div>
        <div class="accessory accessory-watch"></div>
        <div class="accessory accessory-case"></div>
        <!-- More mobiles at borders -->
        <div class="mobile mobile-right-1"></div>
        <div class="mobile mobile-right-2"></div>
        <div class="mobile mobile-left-1"></div>
        <div class="mobile mobile-left-2"></div>
        <div class="mobile mobile-top-1"></div>
        <div class="mobile mobile-top-2"></div>
        <div class="mobile mobile-bottom-1"></div>
        <div class="mobile mobile-bottom-2"></div>
    </div>

    <div class="container">
        <div class="page-header" data-aos="fade-down">
            <h2 class="page-title">My Service Bookings</h2>
            <div>
                <a href="home.jsp" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>
        
        <div class="bookings-table" data-aos="fade-up">
            <% if (bookings.isEmpty()) { %>
                <div class="no-bookings">
                    <i class="bi bi-calendar-x"></i>
                    <h4>No bookings found</h4>
                    <p class="text-muted">You haven't made any service bookings yet.</p>
                    <a href="bookservice.jsp" class="btn btn-primary mt-3">
                        <i class="bi bi-calendar-plus"></i> Book a Service
                    </a>
                </div>
            <% } else { %>
                <% for (Map<String, String> booking : bookings) { %>
                    <div class="booking-card">
                        <div class="booking-header">
                            <span class="booking-id">Booking #<%= booking.get("bookingId") %></span>
                            <span class="status-<%= booking.get("status").toLowerCase() %>">
                                <%= booking.get("status") %>
                            </span>
                        </div>
                        <div class="booking-details">
                            <div class="detail-item">
                                <div class="detail-label">Service Type</div>
                                <div class="detail-value"><%= booking.get("serviceType") %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Device Type</div>
                                <div class="detail-value"><%= booking.get("deviceType") %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Date</div>
                                <div class="detail-value"><%= booking.get("bookingDate") %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Time Slot</div>
                                <div class="detail-value"><%= booking.get("timeSlot") %></div>
                            </div>
                            <% if (booking.get("notes") != null && !booking.get("notes").isEmpty()) { %>
                                <div class="detail-item">
                                    <div class="detail-label">Notes</div>
                                    <div class="detail-value"><%= booking.get("notes") %></div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
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