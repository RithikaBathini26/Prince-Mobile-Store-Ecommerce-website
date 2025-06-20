<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.model.ShippingAddress" %>
<%@ page import="com.mobilestore.dao.ShippingAddressDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Profile - PN MobileStore</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Animate.css -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --background-light: #f8f9fa;
            --text-light: #6b7280;
            --card-bg: #ffffff;
        }

        body {
            background: var(--background-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated Background */
        .animated-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: linear-gradient(45deg, #f3f4f6, #e5e7eb);
            opacity: 0.5;
        }

        .animated-bg::before {
            content: '';
            position: absolute;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, var(--primary-color) 0%, transparent 50%);
            animation: rotate 20s linear infinite;
            opacity: 0.1;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Floating Shapes */
        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
        }

        .shape {
            position: absolute;
            background: var(--primary-color);
            border-radius: 50%;
            opacity: 0.1;
            animation: floatAnimation 20s infinite linear;
        }

        .shape:nth-child(1) { top: 10%; left: 10%; width: 100px; height: 100px; animation-delay: 0s; }
        .shape:nth-child(2) { top: 20%; right: 20%; width: 150px; height: 150px; animation-delay: -5s; }
        .shape:nth-child(3) { bottom: 30%; left: 30%; width: 80px; height: 80px; animation-delay: -10s; }
        .shape:nth-child(4) { bottom: 10%; right: 10%; width: 120px; height: 120px; animation-delay: -15s; }

        @keyframes floatAnimation {
            0% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(100px, 100px) rotate(90deg); }
            50% { transform: translate(0, 200px) rotate(180deg); }
            75% { transform: translate(-100px, 100px) rotate(270deg); }
            100% { transform: translate(0, 0) rotate(360deg); }
        }

        .profile-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
            position: relative;
            z-index: 1;
        }

        .profile-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 4rem 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(37, 99, 235, 0.2);
            animation: fadeInDown 1s;
        }

        .profile-header-content {
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .profile-avatar-wrapper {
            position: relative;
        }

        .profile-avatar {
            width: 150px;
            height: 150px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3.5rem;
            color: var(--primary-color);
            border: 4px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .profile-info {
            flex: 1;
        }

        .profile-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1.5rem;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        .address-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .profile-name {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 0;
            color: var(--text-light);
        }

        .profile-email {
            opacity: 0.9;
            font-size: 1.1rem;
        }

        .profile-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
            animation: fadeInUp 1s;
        }

        .profile-card:hover {
            transform: translateY(-5px);
        }

        .card-title {
            color: var(--primary-color);
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            position: relative;
            padding-bottom: 0.5rem;
        }

        .card-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: var(--primary-color);
            border-radius: 3px;
        }

        .info-item {
            padding: 1.5rem;
            background: rgba(37, 99, 235, 0.05);
            border-radius: 12px;
            transition: all 0.3s ease;
            border: 1px solid rgba(37, 99, 235, 0.1);
        }

        .info-item:hover {
            transform: translateY(-3px);
            background: rgba(37, 99, 235, 0.1);
            border-color: var(--primary-color);
        }

        .info-label {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-value {
            color: #1a1a1a;
            font-size: 1.1rem;
            font-weight: 500;
        }

        .address-card {
            border: 1px solid rgba(37, 99, 235, 0.2);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .address-card:hover {
            border-color: var(--primary-color);
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.1);
            transform: translateY(-3px);
        }

        .address-type {
            display: inline-block;
            padding: 0.25rem 1rem;
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary-color);
            border-radius: 20px;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            font-weight: 500;
        }

        .address-details {
            color: #1a1a1a;
            margin-bottom: 1rem;
            line-height: 1.6;
        }

        .address-actions {
            display: flex;
            gap: 1rem;
        }

        .btn-edit {
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2);
        }

        .add-address {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            border: 2px dashed rgba(37, 99, 235, 0.3);
            border-radius: 12px;
            color: var(--primary-color);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            gap: 0.5rem;
        }

        .add-address:hover {
            border-color: var(--primary-color);
            background: rgba(37, 99, 235, 0.05);
            transform: translateY(-3px);
        }

        .add-address i {
            font-size: 1.5rem;
            transition: transform 0.3s ease;
        }

        .add-address:hover i {
            transform: rotate(90deg);
        }

        .btn-light {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-light:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .btn-light i {
            font-size: 1.1rem;
        }

        @media (max-width: 768px) {
            .profile-header {
                padding: 2rem 1.5rem;
            }

            .profile-header-content {
                flex-direction: column;
                text-align: center;
            }

            .d-flex {
                flex-direction: column;
                gap: 1rem;
            }

            .btn-light {
                width: 100%;
                justify-content: center;
            }

            .profile-avatar {
                width: 120px;
                height: 120px;
                font-size: 3rem;
                margin: 0 auto;
            }

            .profile-stats {
                justify-content: center;
            }

            .profile-name {
                font-size: 2rem;
            }

            .profile-email {
                justify-content: center;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .address-grid {
                grid-template-columns: 1fr;
            }

            .address-actions {
                flex-direction: column;
            }

            .btn-edit {
                width: 100%;
                justify-content: center;
            }
        }

        /* Toast Styles */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }

        .toast {
            background: white;
            border-radius: 8px;
            padding: 1rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 0.5rem;
            animation: slideInRight 0.3s ease;
        }

        @keyframes slideInRight {
            from { transform: translateX(100%); }
            to { transform: translateX(0); }
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get user's shipping addresses
        ShippingAddressDAO addressDAO = new ShippingAddressDAO();
        List<ShippingAddress> addresses = addressDAO.getShippingAddressesByUserId(user.getId());
    %>

    <!-- Toast Container -->
    <div class="toast-container"></div>

    <!-- Animated Background -->
    <div class="animated-bg"></div>
    
    <!-- Floating Shapes -->
    <div class="floating-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <div class="profile-container">
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="profile-header-content">
                <div class="profile-avatar-wrapper">
                    <div class="profile-avatar">
                        <i class="bi bi-person"></i>
                    </div>
                </div>
                <div class="profile-info">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h1 class="profile-name"><%= user.getName() %></h1>
                        <a href="home.jsp" class="btn btn-light">
                            <i class="bi bi-arrow-left"></i> Back to Home
                        </a>
                    </div>
                    <p class="profile-email"><i class="bi bi-envelope"></i> <%= user.getEmail() %></p>
                    <div class="profile-stats">
                        <div class="stat-item">
                            <div class="stat-value">12</div>
                            <div class="stat-label">Orders</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">5</div>
                            <div class="stat-label">Wishlisted</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">3</div>
                            <div class="stat-label">Reviews</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Personal Information -->
        <div class="profile-card">
            <h2 class="card-title">
                <i class="bi bi-person-badge"></i>
                Personal Information
            </h2>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">
                        <i class="bi bi-person"></i>
                        Full Name
                    </div>
                    <div class="info-value"><%= user.getName() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">
                        <i class="bi bi-envelope"></i>
                        Email Address
                    </div>
                    <div class="info-value"><%= user.getEmail() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">
                        <i class="bi bi-phone"></i>
                        Phone Number
                    </div>
                    <div class="info-value"><%= user.getMobileNumber() != null ? user.getMobileNumber() : "Not provided" %></div>
                </div>
            </div>
        </div>

        <!-- Shipping Addresses -->
        <div class="profile-card">
            <h2 class="card-title">
                <i class="bi bi-geo-alt"></i>
                Shipping Addresses
            </h2>
            <div class="address-grid">
                <% if (addresses != null && !addresses.isEmpty()) { 
                    for (ShippingAddress address : addresses) { %>
                    <div class="address-card">
                        <span class="address-type"><%= address.isDefault() ? "Default Address" : "Additional Address" %></span>
                        <p class="address-details">
                            <%= address.getFullName() %><br>
                            <%= address.getAddress() %><br>
                            <%= address.getCity() %>, <%= address.getState() %> <%= address.getZipCode() %><br>
                            Phone: <%= address.getPhone() %>
                        </p>
                        <div class="address-actions">
                            <button class="btn-edit btn-primary" onclick="editAddress(<%= address.getId() %>)">
                                <i class="bi bi-pencil"></i> Edit
                            </button>
                            <% if (!address.isDefault()) { %>
                            <button class="btn-edit btn-outline" onclick="deleteAddress(<%= address.getId() %>)">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                            <% } %>
                        </div>
                    </div>
                <% } 
                } %>
                <div class="add-address" onclick="addNewAddress()">
                    <i class="bi bi-plus-circle"></i>
                    <div class="add-address-text">
                        <h4>Add New Address</h4>
                        <p>Click to add a new shipping address</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function showToast(message, type = 'success') {
            const toast = document.createElement('div');
            toast.className = 'toast ' + (type === 'success' ? 'bg-success' : 'bg-danger') + ' text-white';
            toast.innerHTML = '<div class="toast-body">' + message + '</div>';
            document.querySelector('.toast-container').appendChild(toast);
            setTimeout(() => toast.remove(), 3000);
        }

        function editAddress(addressId) {
            // Implement address editing functionality
            window.location.href = 'editAddress.jsp?id=' + addressId;
        }

        function deleteAddress(addressId) {
            if (confirm('Are you sure you want to delete this address?')) {
                // Implement address deletion functionality
                fetch('deleteAddress?id=' + addressId, { method: 'POST' })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showToast('Address deleted successfully');
                            location.reload();
                        } else {
                            showToast('Failed to delete address', 'error');
                        }
                    });
            }
        }

        function addNewAddress() {
            // Implement add new address functionality
            window.location.href = 'addAddress.jsp';
        }
    </script>
</body>
</html> 