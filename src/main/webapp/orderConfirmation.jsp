<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.dao.OrderDAO" %>
<%@ page import="com.mobilestore.dao.ShippingAddressDAO" %>
<%@ page import="com.mobilestore.model.Order" %>
<%@ page import="com.mobilestore.model.ShippingAddress" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer orderId = (Integer) session.getAttribute("orderId");
    if (orderId == null) {
        response.sendRedirect("userdashboard");
        return;
    }

    OrderDAO orderDAO = new OrderDAO();
    ShippingAddressDAO shippingAddressDAO = new ShippingAddressDAO();
    
    Order order = orderDAO.getOrderById(orderId);
    ShippingAddress shippingAddress = shippingAddressDAO.getShippingAddressByOrderId(orderId);
    
    if (order == null || shippingAddress == null) {
        response.sendRedirect("userdashboard");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - Mobile Store</title>
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

        @keyframes gradientAnimation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .floating-elements {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
            overflow: hidden;
        }

        .floating-element {
            position: absolute;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            opacity: 0.08;
            filter: blur(0.5px);
        }

        .floating-mobile {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>');
        }

        .floating-accessory {
            opacity: 0.10;
            filter: blur(0.3px);
        }

        .floating-earphones {
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><path d="M12 24C12 17.3726 17.3726 12 24 12C30.6274 12 36 17.3726 36 24" stroke="%234f46e5" stroke-width="3" stroke-linecap="round"/><rect x="8" y="24" width="8" height="12" rx="4" fill="%234f46e5"/><rect x="32" y="24" width="8" height="12" rx="4" fill="%234f46e5"/></svg>');
        }

        .floating-charger {
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><rect x="16" y="18" width="16" height="16" rx="4" fill="%234f46e5"/><rect x="20" y="10" width="2" height="8" rx="1" fill="%234f46e5"/><rect x="26" y="10" width="2" height="8" rx="1" fill="%234f46e5"/></svg>');
        }

        .float-animation-1 {
            animation: float1 15s ease-in-out infinite;
        }

        .float-animation-2 {
            animation: float2 12s ease-in-out infinite;
        }

        .float-animation-3 {
            animation: float3 18s ease-in-out infinite;
        }

        .float-animation-4 {
            animation: float4 14s ease-in-out infinite;
        }

        @keyframes float1 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(20px, -20px) rotate(5deg); }
            50% { transform: translate(0, -40px) rotate(0deg); }
            75% { transform: translate(-20px, -20px) rotate(-5deg); }
        }

        @keyframes float2 {
            0%, 100% { transform: translate(0, 0) rotate(0deg) scale(1); }
            25% { transform: translate(-20px, 20px) rotate(-5deg) scale(1.1); }
            50% { transform: translate(0, 40px) rotate(0deg) scale(1); }
            75% { transform: translate(20px, 20px) rotate(5deg) scale(0.9); }
        }

        @keyframes float3 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(8deg); }
            66% { transform: translate(-30px, -30px) rotate(-8deg); }
        }

        @keyframes float4 {
            0%, 100% { transform: translate(0, 0) rotate(0deg) scale(1); }
            33% { transform: translate(-30px, 30px) rotate(-8deg) scale(1.1); }
            66% { transform: translate(30px, 30px) rotate(8deg) scale(0.9); }
        }

        .confirmation-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: var(--card-bg);
            border-radius: 20px;
            box-shadow: var(--shadow-light);
            position: relative;
            z-index: 1;
        }

        .success-icon {
            color: #28a745;
            font-size: 4rem;
            text-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
        }

        .card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            transition: all 0.3s ease;
            margin-bottom: 1.5rem;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-light);
        }

        .card-header {
            background: transparent;
            border-bottom: 2px solid var(--border-light);
            padding: 1.5rem;
        }

        .card-header h4 {
            color: var(--primary-color);
            margin: 0;
            font-weight: 600;
        }

        .card-body {
            padding: 1.5rem;
        }

        .btn-primary {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 1rem 2rem;
            border-radius: 0.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .badge {
            font-size: 0.9rem;
            padding: 0.5rem 0.8rem;
        }

        @media (max-width: 768px) {
            .confirmation-container {
                padding: 1.5rem;
                margin: 1rem;
            }
            
            .success-icon {
                font-size: 3rem;
            }
        }
    </style>
</head>
<body>
    <div class="floating-elements">
        <div class="floating-element floating-mobile" style="width: 250px; height: 500px; top: 5%; left: 5%;" class="float-animation-1"></div>
        <div class="floating-element floating-mobile" style="width: 200px; height: 400px; top: 20%; right: 8%;" class="float-animation-2"></div>
        <div class="floating-element floating-accessory floating-earphones" style="width: 80px; height: 80px; top: 10%; left: 45%;" class="float-animation-3"></div>
        <div class="floating-element floating-accessory floating-charger" style="width: 70px; height: 70px; bottom: 12%; right: 40%;" class="float-animation-4"></div>
    </div>
    
    <div class="confirmation-container" data-aos="fade-up">
        <div class="text-center mb-4">
            <i class="bi bi-check-circle-fill success-icon"></i>
            <h2 class="mt-3">Order Placed Successfully!</h2>
            <p class="text-muted">Thank you for your purchase</p>
        </div>

        <div class="card">
            <div class="card-header">
                <h4><i class="bi bi-receipt"></i> Order Details</h4>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <strong>Order ID:</strong>
                        <p><%= order.getId() %></p>
                    </div>
                    <div class="col-md-6">
                        <strong>Order Date:</strong>
                        <p><%= order.getOrderDate() %></p>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <strong>Total Amount:</strong>
                        <p><%= order.getTotalAmount() %></p>
                    </div>
                    <div class="col-md-6">
                        <strong>Order Status:</strong>
                        <p><span class="badge bg-primary"><%= order.getStatus() %></span></p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h4><i class="bi bi-truck"></i> Shipping Information</h4>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <strong>Full Name:</strong>
                        <p><%= shippingAddress.getFullName() %></p>
                    </div>
                    <div class="col-md-6">
                        <strong>Phone:</strong>
                        <p><%= shippingAddress.getPhone() %></p>
                    </div>
                </div>
                
                <div class="row mb-3">
                    <div class="col-12">
                        <strong>Address:</strong>
                        <p>
                            <%= shippingAddress.getAddress() %><br>
                            <%= shippingAddress.getCity() %>, <%= shippingAddress.getState() %> <%= shippingAddress.getZipCode() %>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center">
            <a href="userdashboard" class="btn btn-primary">
                <i class="bi bi-house"></i> Return to Dashboard
            </a>
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