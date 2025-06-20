<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="java.util.*" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Service - Mobile Store</title>
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

        /* Accessory SVG backgrounds */
        .accessory {
            position: absolute;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            opacity: 0.10;
            filter: blur(0.3px);
            z-index: -1;
        }

        /* Enhanced floating animations */
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

        /* Updated mobile styles with enhanced animations */
        .mobile-right-1 { right: 0; top: 10%; width: 90px; height: 180px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 15s ease-in-out infinite; }
        .mobile-right-2 { right: 0; top: 40%; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 18s ease-in-out infinite; }
        .mobile-left-1 { left: 0; top: 20%; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 16s ease-in-out infinite; }
        .mobile-left-2 { left: 0; top: 60%; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float4 14s ease-in-out infinite; }
        .mobile-top-1 { left: 20%; top: 0; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float5 17s ease-in-out infinite; }
        .mobile-top-2 { left: 60%; top: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 19s ease-in-out infinite; }
        .mobile-bottom-1 { left: 30%; bottom: 0; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 16s ease-in-out infinite; }
        .mobile-bottom-2 { left: 70%; bottom: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 15s ease-in-out infinite; }

        .booking-container {
            max-width: 900px;
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

        .booking-form {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-light);
        }

        .form-control, .form-select {
            padding: 0.75rem;
            border-radius: 0.5rem;
            border: 1px solid var(--border-light);
            background: rgba(255, 255, 255, 0.9);
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(79, 70, 229, 0.25);
        }

        .form-label {
            font-weight: 500;
            color: var(--text-light);
            margin-bottom: 0.5rem;
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

        .btn-info {
            background: var(--accent-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-info:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .bookings-table {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--shadow-light);
        }

        .table {
            margin-top: 1rem;
        }

        .table th {
            background-color: rgba(79, 70, 229, 0.05);
            font-weight: 600;
            color: var(--text-light);
        }

        @media (max-width: 768px) {
            .booking-container {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1rem;
            }
            
            .page-title {
                font-size: 1.5rem;
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

    <div class="booking-container">
        <div class="page-header" data-aos="fade-down">
            <h2 class="page-title">Book Repair Service</h2>
            <a href="userServiceBookings.jsp" class="btn btn-info">
                <i class="bi bi-list-check"></i> View My Bookings
            </a>
        </div>
        
        <div class="booking-form" data-aos="fade-up">
            <form action="ServiceBookingServlet" method="post">
                <div class="mb-3">
                    <label for="serviceType" class="form-label">Service Type</label>
                    <select class="form-select" id="serviceType" name="serviceType" required>
                        <option value="">Select Service Type</option>
                        <option value="Screen Replacement">Screen Replacement</option>
                        <option value="Battery Replacement">Battery Replacement</option>
                        <option value="Camera Repair">Camera Repair</option>
                        <option value="Water Damage Repair">Water Damage Repair</option>
                        <option value="Software Issues">Software Issues</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="deviceType" class="form-label">Device Type</label>
                    <input type="text" class="form-control" id="deviceType" name="deviceType" 
                           placeholder="e.g., iPhone 12, Samsung Galaxy S21" required>
                </div>
                
                <div class="mb-3">
                    <label for="bookingDate" class="form-label">Preferred Date</label>
                    <input type="date" class="form-control" id="bookingDate" name="bookingDate" required>
                </div>
                
                <div class="mb-3">
                    <label for="timeSlot" class="form-label">Time Slot</label>
                    <select class="form-select" id="timeSlot" name="timeSlot" required>
                        <option value="">Select Time Slot</option>
                        <option value="10:00 AM - 12:00 PM">10:00 AM - 12:00 PM</option>
                        <option value="12:00 PM - 2:00 PM">12:00 PM - 2:00 PM</option>
                        <option value="2:00 PM - 4:00 PM">2:00 PM - 4:00 PM</option>
                        <option value="4:00 PM - 6:00 PM">4:00 PM - 6:00 PM</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="notes" class="form-label">Additional Notes</label>
                    <textarea class="form-control" id="notes" name="notes" rows="3" 
                              placeholder="Any specific issues or requirements..."></textarea>
                </div>
                
                <div class="text-center">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-calendar-check"></i> Book Service
                    </button>
                </div>
            </form>
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