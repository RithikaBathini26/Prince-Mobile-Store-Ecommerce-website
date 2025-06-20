<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>
<%@ page import="com.mobilestore.dao.CartDAO" %>
<%@ page import="com.mobilestore.dao.WishlistDAO" %>

<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.mobilestore.model.Notification" %>
<%@ page import="com.mobilestore.dao.NotificationDAO" %>

<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get products from request attribute set by UserDashboardServlet
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
    String error = (String) request.getAttribute("error");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    
    // Get cart and wishlist counts
    CartDAO cartDAO = new CartDAO();
    WishlistDAO wishlistDAO = new WishlistDAO();
    int cartCount = cartDAO.getCartItemCount(user.getId());
    int wishlistCount = wishlistDAO.getWishlistItemCount(user.getId());
%>

<!DOCTYPE html><html><head>    <meta charset="UTF-8">    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>MobileStore - Online Mobile Shopping</title>    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --background-light: #f8f9fa;
            --text-light: #6b7280;
            --card-bg: #ffffff;
            --nav-bg: rgba(255, 255, 255, 0.9);
            --nav-text: #1e293b;
            --nav-hover: #2563eb;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
            background: var(--background-light);
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

        /* Enhanced Navigation */
        .navbar {
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            background: var(--nav-bg) !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .navbar-brand {
            font-weight: bold;
            color: var(--primary-color) !important;
        }

        .nav-link {
            color: var(--nav-text) !important;
            position: relative;
            transition: color 0.3s ease;
            font-weight: 500;
        }

        .nav-link:hover {
            color: var(--nav-hover) !important;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 50%;
            background-color: var(--nav-hover);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::after {
            width: 100%;
        }

        .dropdown-menu {
            border: none;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            border-radius: 0.5rem;
            background: var(--nav-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }

        .dropdown-item {
            color: var(--nav-text);
            transition: all 0.3s ease;
            padding: 0.75rem 1.5rem;
        }

        .dropdown-item:hover {
            background-color: rgba(37, 99, 235, 0.1);
            color: var(--nav-hover);
            transform: translateX(5px);
        }

        .dropdown-item i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

            /* Search Form Styles */
    .navbar .input-group {
        width: 300px;
        position: relative;
        margin-right: 30px;
    }

    .navbar .form-control {
        border-radius: 20px 0 0 20px;
        border: 1px solid #dee2e6;
        padding: 0.5rem 1rem;
        padding-right: 50px;
        background: rgba(255, 255, 255, 0.9);
    }

    .navbar .form-control:focus {
        box-shadow: none;
        border-color: var(--primary-color);
    }

    .voice-search-btn {
        background: none;
        border: none;
        color: var(--primary-color);
        cursor: pointer;
        padding: 0.5rem;
        border-radius: 50%;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        position: absolute;
        right: 50px;
        top: 50%;
        transform: translateY(-50%);
        z-index: 10;
        width: 32px;
        height: 32px;
    }

    .voice-search-btn:hover {
        background: rgba(37, 99, 235, 0.1);
    }

    .voice-search-btn.listening {
        animation: pulse 1.5s infinite;
        background: rgba(37, 99, 235, 0.1);
    }

    @keyframes pulse {
        0% { transform: translateY(-50%) scale(1); }
        50% { transform: translateY(-50%) scale(1.1); }
        100% { transform: translateY(-50%) scale(1); }
    }

    .navbar form .btn-outline-primary {
        border-radius: 0 20px 20px 0;
        border: 1px solid var(--primary-color);
        margin-left: -1px;
        padding: 0.5rem 1.25rem;
        background: transparent;
        color: var(--primary-color);
        min-width: 45px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .navbar form .btn-outline-primary:hover {
        background: var(--primary-color);
        color: white;
    }

    @media (max-width: 991.98px) {
        .navbar .input-group {
            width: 100%;
        }
        
        .navbar form {
            margin: 1rem 0;
            width: 100%;
        }
        }

        /* Rest of your existing styles */
        .product-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .header {
            background-color: #1a237e;
            color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .welcome {
            font-size: 20px;
        }
        .nav-buttons {
            display: flex;
            gap: 15px;
        }
        .nav-btn {
            background-color: #0d47a1;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        .nav-btn:hover {
            background-color: #1565c0;
        }
        .product-card {
            height: 100%;
            transition: transform 0.3s;
            border: none;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .product-image {
            height: 200px;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
        }
        .product-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin: 1rem 0;
            color: #333;
        }
        .product-category {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .product-price {
            color: #1a237e;
            font-weight: bold;
            font-size: 1.1rem;
            margin: 0.5rem 0;
        }
        .product-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            height: 60px;
            overflow: hidden;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }
        .btn-cart {
            background-color: #4CAF50;
            color: white;
            flex: 1;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-wishlist {
            background-color: #f44336;
            color: white;
            flex: 1;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-cart:hover {
            background-color: #45a049;
        }
        .btn-wishlist:hover {
            background-color: #d32f2f;
        }
        .stock-info {
            font-size: 0.8rem;
            color: #666;
            margin-top: 5px;
        }
        .stock-available {
            color: #4CAF50;
        }
        .stock-low {
            color: #ff9800;
        }
        .stock-out {
            color: #f44336;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }

        .hero-section {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.05) 0%, rgba(99, 102, 241, 0.05) 100%);
            min-height: 600px;
            padding: 60px 0;
            margin-bottom: 0;
            position: relative;
            overflow: hidden;
        }

        /* Animated Background Elements */
        .animated-circles .circle {
            position: absolute;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            opacity: 0.1;
            animation: pulse 10s infinite;
        }

        .circle-1 {
            width: 300px;
            height: 300px;
            top: -150px;
            left: -150px;
        }

        .circle-2 {
            width: 500px;
            height: 500px;
            bottom: -250px;
            right: -250px;
            animation-delay: -3s;
        }

        .circle-3 {
            width: 200px;
            height: 200px;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation-delay: -6s;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.1; }
            50% { transform: scale(1.2); opacity: 0.15; }
        }

        .floating-elements {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            pointer-events: none;
        }

        .floating-elements .element {
            position: absolute;
            color: var(--primary-color);
            opacity: 0.1;
            animation: floatElement 15s infinite linear;
        }

        .floating-elements .element:nth-child(1) { font-size: 2rem; top: 20%; left: 10%; animation-delay: -2s; }
        .floating-elements .element:nth-child(2) { font-size: 1.5rem; top: 60%; left: 20%; animation-delay: -4s; }
        .floating-elements .element:nth-child(3) { font-size: 2.5rem; top: 30%; right: 15%; animation-delay: -6s; }
        .floating-elements .element:nth-child(4) { font-size: 1.8rem; top: 70%; right: 25%; animation-delay: -8s; }
        .floating-elements .element:nth-child(5) { font-size: 2.2rem; top: 40%; left: 50%; animation-delay: -10s; }

        @keyframes floatElement {
            0% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(10px, -10px) rotate(90deg); }
            50% { transform: translate(0, -20px) rotate(180deg); }
            75% { transform: translate(-10px, -10px) rotate(270deg); }
            100% { transform: translate(0, 0) rotate(360deg); }
        }

        /* Enhanced Welcome Text */
        .welcome-text-container {
            position: relative;
            z-index: 2;
        }

        .text-gradient {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
        }

        .text-gradient-subtle {
            background: linear-gradient(45deg, #1a365d, #2563eb);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
        }

        .typewriter {
            border-right: 3px solid var(--primary-color);
            animation: blink 0.7s step-end infinite;
            padding-right: 5px;
        }

        @keyframes blink {
            from, to { border-color: transparent }
            50% { border-color: var(--primary-color); }
        }

        /* Feature Badges */
        .feature-badges {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .feature-badges .badge {
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary-color);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .feature-badges .badge:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
        }

        /* Enhanced Buttons */
        .btn-glow {
            position: relative;
            overflow: hidden;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            z-index: 1;
        }

        .btn-glow::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.3) 0%, transparent 70%);
            transform: rotate(0deg);
            animation: rotateBg 4s linear infinite;
            z-index: -1;
        }

        @keyframes rotateBg {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .btn-hover-float {
            transition: transform 0.3s ease;
        }

        .btn-hover-float:hover {
            transform: translateY(-5px);
        }

        /* Enhanced 3D Scene */
        .scene3d {
            perspective: 1000px;
            transform-style: preserve-3d;
            position: relative;
        }

        .floating-phones {
            position: relative;
            height: 400px;
            transform-style: preserve-3d;
            animation: rotateScene 20s infinite linear;
        }

        @keyframes rotateScene {
            0% { transform: rotateY(0deg); }
            100% { transform: rotateY(360deg); }
        }

        .floating-phone {
            position: absolute;
            max-height: 350px;
            filter: drop-shadow(0 20px 30px rgba(0, 0, 0, 0.2));
            transition: all 0.3s ease;
            transform-style: preserve-3d;
        }

        .phone-1 {
            left: 10%;
            top: 50%;
            transform: translateY(-50%) translateZ(50px) rotate(-15deg);
            animation: float1 6s ease-in-out infinite;
        }

        .phone-2 {
            right: 10%;
            top: 50%;
            transform: translateY(-50%) translateZ(-50px) rotate(15deg);
            animation: float2 6s ease-in-out infinite 1s;
        }

        .reflection {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: linear-gradient(to bottom, transparent, rgba(255,255,255,0.1));
            transform: rotateX(90deg);
        }

        /* Enhanced Stat Cards */
        .stat-card.interactive {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .stat-icon-wrapper {
            position: relative;
            width: 80px;
            height: 80px;
            margin: 0 auto 1rem;
        }

        .stat-icon {
            position: relative;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: var(--primary-color);
            z-index: 2;
        }

        .stat-icon-ring {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: 2px solid var(--primary-color);
            border-radius: 50%;
            animation: ringPulse 2s infinite;
        }

        @keyframes ringPulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.2); opacity: 0.5; }
            100% { transform: scale(1); opacity: 1; }
        }

        .stat-hover-effect {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.1) 0%, transparent 70%);
            transform: translate(-50%, -50%);
            transition: all 0.5s ease;
            border-radius: 50%;
            opacity: 0;
        }

        .stat-card.interactive:hover {
            transform: translateY(-10px);
        }

        .stat-card.interactive:hover .stat-hover-effect {
            width: 200%;
            height: 200%;
            opacity: 1;
        }

        .rating-stars {
            color: #ffd700;
            margin-top: 0.5rem;
        }

        /* Counter Animation */
        .counter {
            transition: all 0.3s ease;
        }

        /* Quick Actions Styles */
        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .quick-action-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            text-decoration: none;
            color: var(--text-light);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .quick-action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            color: var(--primary-color);
        }

        .quick-action-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 1;
        }

        .quick-action-card:hover::before {
            opacity: 0.05;
        }

        .quick-action-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
            position: relative;
            z-index: 2;
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .quick-action-card h4 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
            position: relative;
            z-index: 2;
        }

        .quick-action-card p {
            margin: 0.5rem 0 0;
            font-size: 0.9rem;
            opacity: 0.8;
            position: relative;
            z-index: 2;
        }

        /* Featured Categories Styles */
        .featured-categories {
            padding-top: 2rem;
        }

        .section-header text-center mb-5 {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--text-light);
            font-weight: 600;
        }

        .category-slider {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            padding: 1rem 0;
        }

        .category-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .category-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
            position: relative;
            z-index: 2;
        }

        .category-card h3 {
            margin: 0;
            font-size: 1.2rem;
            color: var(--text-light);
            font-weight: 600;
            position: relative;
            z-index: 2;
        }

        .item-count {
            display: block;
            font-size: 0.9rem;
            color: var(--text-light);
            opacity: 0.8;
            margin-top: 0.5rem;
            position: relative;
            z-index: 2;
        }

        .category-hover {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: radial-gradient(circle, var(--primary-color) 0%, transparent 70%);
            transform: translate(-50%, -50%);
            opacity: 0;
            transition: all 0.5s ease;
        }

        .category-card:hover .category-hover {
            width: 200%;
            height: 200%;
            opacity: 0.1;
        }

        @media (max-width: 768px) {
            .quick-actions-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .category-slider {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .quick-actions-grid {
                grid-template-columns: 1fr;
            }

            .category-slider {
                grid-template-columns: 1fr;
            }
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            padding: 1rem;
        }

        .category-card-modern {
            position: relative;
            height: 320px;
            border-radius: 20px;
            overflow: hidden;
            cursor: pointer;
            background: white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .category-card-modern:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }

        .category-content {
            position: relative;
            z-index: 2;
            padding: 2rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            background: linear-gradient(180deg, rgba(255,255,255,0.9) 0%, rgba(255,255,255,0.8) 100%);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .category-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            opacity: 0.1;
            transition: all 0.3s ease;
        }

        .category-card-modern:nth-child(1) .category-bg {
            background-image: url('https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/Shreyansh/BAU/Unrexc/D70978891_INWLD_BAU_Unrec_Uber_PC_Hero_3000x1200._CB594707876_.jpg');
        }

        .category-card-modern:nth-child(2) .category-bg {
            background-image: url('https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/CatPage/SubNav/230x300/Tablets._CB572850637_.jpg');
        }

        .category-card-modern:nth-child(3) .category-bg {
            background-image: url('https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/CatPage/SubNav/230x300/Accessories._CB572850637_.jpg');
        }

        .category-card-modern:nth-child(4) .category-bg {
            background-image: url('https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/CatPage/SubNav/230x300/Wearables._CB572850637_.jpg');
        }

        .icon-wrapper {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .icon-wrapper i {
            font-size: 1.8rem;
            color: white;
        }

        .category-card-modern h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--primary-color);
        }

        .category-card-modern p {
            color: var(--text-light);
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .item-count {
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary-color);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .hover-content {
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.3s ease;
        }

        .category-card-modern:hover .hover-content {
            opacity: 1;
            transform: translateY(0);
        }

        .quick-links {
            list-style: none;
            padding: 0;
            margin: 0 0 1rem 0;
        }

        .quick-links li {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }

        .quick-links li:hover {
            color: var(--primary-color);
            transform: translateX(5px);
        }

        .explore-btn {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .explore-btn:hover {
            gap: 1rem;
            color: var(--secondary-color);
        }

        .text-gradient {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
        }

        @media (max-width: 768px) {
            .category-grid {
                grid-template-columns: 1fr;
            }

            .category-card-modern {
                height: 280px;
            }
        }

        .flip-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            padding: 1rem;
        }

        .flip-card {
            background-color: transparent;
            width: 100%;
            height: 300px;
            perspective: 1000px;
        }

        .flip-card-inner {
            position: relative;
            width: 100%;
            height: 100%;
            text-align: center;
            transition: transform 0.8s;
            transform-style: preserve-3d;
            cursor: pointer;
        }

        .flip-card:hover .flip-card-inner {
            transform: rotateY(180deg);
        }

        .flip-card-front, .flip-card-back {
            position: absolute;
            width: 100%;
            height: 100%;
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .flip-card-front {
            background: white;
            color: var(--primary-color);
        }

        .flip-card-back {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            transform: rotateY(180deg);
        }

        .icon-wrapper {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease;
        }

        .icon-wrapper i {
            font-size: 2rem;
            color: white;
        }

        .flip-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .flip-card h4 {
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            color: white;
        }

        .item-count {
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary-color);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .flip-hint {
            position: absolute;
            bottom: 1rem;
            left: 0;
            right: 0;
            font-size: 0.8rem;
            color: var(--text-light);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin: 0 0 1.5rem 0;
            text-align: left;
            width: 100%;
        }

        .feature-list li {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.8rem;
            font-size: 1rem;
        }

        .feature-list li i {
            font-size: 1.2rem;
        }

        .flip-card-btn {
            background: white;
            color: var(--primary-color);
            padding: 0.8rem 2rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .flip-card-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .flip-cards-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
            }

            .flip-card {
                height: 280px;
            }
        }

        /* Category Icons Section */
        .category-icons {
            padding: 2rem 0;
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 0.95));
            border-radius: 20px;
            margin: 0;
        }

        .category-icon-item {
            text-align: center;
            padding: 1rem;
            transition: all 0.3s ease;
        }

        .category-icon-item:hover {
            transform: translateY(-5px);
        }

        .category-icon-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin: 0 auto 1rem;
            background: white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .category-icon-circle img {
            width: 60%;
            height: 60%;
            object-fit: contain;
            transition: all 0.3s ease;
        }

        .category-icon-item:hover .category-icon-circle img {
            transform: scale(1.1);
        }

        .category-icon-count {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }

        /* Service Boxes Section */
        .service-boxes {
            padding: 2rem 0;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.05) 0%, rgba(99, 102, 241, 0.05) 100%);
            border-radius: 20px;
            margin: 0;
        }

        .service-box {
            display: flex;
            align-items: center;
            text-align: left;
            padding: 1.5rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            gap: 1.5rem;
        }

        .service-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .service-icon {
            flex-shrink: 0;
            width: 50px;
            height: 50px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .service-icon i {
            font-size: 1.5rem;
            color: white;
        }

        .service-content {
            flex-grow: 1;
        }

        .service-title {
            font-size: 1.1rem;
            color: var(--primary-color);
            margin-bottom: 0.25rem;
            font-weight: 600;
        }

        .service-text {
            color: var(--text-light);
            font-size: 0.9rem;
            margin: 0;
        }

        @media (max-width: 768px) {
            .service-box {
                padding: 1rem;
                gap: 1rem;
            }
            
            .service-icon {
                width: 40px;
                height: 40px;
            }

            .service-icon i {
                font-size: 1.2rem;
            }
        }

        /* Image Slider Styles */
        .slider-section {
            padding: 2rem 0;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.02) 0%, rgba(99, 102, 241, 0.02) 100%);
            overflow: hidden;
            position: relative;
        }

        .split-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            min-height: 600px;
        }

        .slider-container {
            position: relative;
            height: 100%;
            overflow: hidden;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .slider {
            position: relative;
            width: 100%;
            height: 100%;
        }

        .slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 0.5s ease;
            overflow: hidden;
        }

        .slide.active {
            opacity: 1;
        }

        .slide-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to right, rgba(0,0,0,0.5), rgba(0,0,0,0.2));
        }

        .slide-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .slide-content {
            position: absolute;
            bottom: 0;
            left: 0;
            padding: 2rem;
            color: white;
            z-index: 2;
        }

        .slide-title {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }

        .slide-description {
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
            opacity: 0.9;
        }

        .slide-button {
            display: inline-flex;
            align-items: center;
            padding: 0.8rem 1.5rem;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .slide-button:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            color: white;
        }

        .slider-nav {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 3;
        }

        .slider-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: rgba(255,255,255,0.5);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .slider-dot.active {
            background: white;
            transform: scale(1.2);
        }

        .slider-arrows {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            transform: translateY(-50%);
            display: flex;
            justify-content: space-between;
            padding: 0 20px;
            z-index: 3;
        }

        .slider-arrow {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .slider-arrow i {
            color: white;
            font-size: 1.5rem;
        }

        .slider-arrow:hover {
            background: rgba(255,255,255,0.3);
            transform: scale(1.1);
        }

        /* Featured Products Grid */
        .featured-products-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            grid-template-rows: repeat(3, 1fr);
            gap: 0.75rem;
            height: 100%;
        }

        .featured-product {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            background: white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .featured-product-img {
            width: 100%;
            height: 60%;
            object-fit: contain;
            padding: 0.5rem;
            transition: all 0.3s ease;
        }

        .featured-product-content {
            padding: 0.75rem;
            background: white;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .featured-product-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.25rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .featured-product-price {
            font-size: 1rem;
            font-weight: 700;
            color: #2c3e50;
        }

        @media (max-width: 992px) {
            .split-container {
                grid-template-columns: 1fr;
                min-height: auto;
            }

            .slider-container {
                height: 400px;
            }

            .featured-products-grid {
                grid-template-columns: repeat(3, 1fr);
                grid-template-rows: repeat(3, 1fr);
                height: auto;
                min-height: 800px;
            }
        }

        @media (max-width: 768px) {
            .featured-products-grid {
                grid-template-columns: repeat(2, 1fr);
                grid-template-rows: repeat(5, 1fr);
                gap: 1rem;
            }
        }

        @media (max-width: 480px) {
            .featured-products-grid {
                grid-template-columns: 1fr;
                grid-template-rows: repeat(9, 1fr);
            }
        }

        /* New Arrivals Heading */
        .new-arrivals-heading {
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary-color);
            position: relative;
            margin: 0;
            text-align: left;
            line-height: 1.2;
        }

        .heading-underline {
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 60px;
            height: 3px;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border-radius: 2px;
        }

        @media (max-width: 768px) {
            .new-arrivals-heading {
                font-size: 1.75rem;
            }
        }

        /* Why Us Section Styles */
        .why-us-section {
            display: none;
        }

        @media (max-width: 768px) {
            .why-us-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .why-us-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Explore Products Section Styles */
        .explore-products {
            background: #fff;
            position: relative;
            overflow: hidden;
        }

        .explore-header {
            position: relative;
        }

        .explore-title {
            color: #1a1a1a;
            margin-bottom: 1rem;
        }

        .explore-subtitle {
            max-width: 600px;
            line-height: 1.6;
        }

        .popular-products {
            background: rgba(255, 255, 255, 0.9);
            padding: 1.5rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        .avatar-group {
            display: flex;
            align-items: center;
        }

        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid #fff;
            margin-right: -10px;
            object-fit: cover;
            background: #fff;
        }

        .avatar-more {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary-color);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            text-decoration: none;
        }

        .view-all {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: gap 0.3s ease;
        }

        .view-all:hover {
            gap: 0.8rem;
        }

        .explore-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .banner-card {
            grid-column: span 6;
            height: 300px;
            border-radius: 24px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
        }

        .banner-card.purple {
            background: linear-gradient(45deg, #818cf8, #6366f1);
        }

        .banner-card.yellow {
            background: linear-gradient(45deg, #fbbf24, #f59e0b);
        }

        .banner-content {
            color: #fff;
            position: relative;
            z-index: 2;
            max-width: 60%;
        }

        .banner-content h3 {
            font-size: 1.8rem;
            margin-bottom: 1.5rem;
        }

        .banner-btn {
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
            padding: 0.8rem 1.5rem;
            border-radius: 25px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .banner-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            gap: 0.8rem;
            color: #fff;
        }

        .banner-img {
            position: absolute;
            right: -50px;
            bottom: -50px;
            height: 120%;
            transform: rotate(-15deg);
            transition: transform 0.3s ease;
        }

        .banner-card:hover .banner-img {
            transform: rotate(-10deg) scale(1.05);
        }

        .product-card {
            grid-column: span 6;
            background: #fff;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-5px);
        }

        .product-img-wrapper {
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
        }

        .product-img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-img {
            transform: scale(1.05);
        }

        .product-card h4 {
            font-size: 1rem;
            margin-bottom: 0.5rem;
            color: #1a1a1a;
        }

        .price-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: var(--primary-color);
            color: #fff;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
        }

        .feature-card {
            grid-column: span 6;
            background: #f8fafc;
            border-radius: 16px;
            padding: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 200px;
        }

        .feature-card.dark {
            background: #1a1a1a;
            color: #fff;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .feature-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: gap 0.3s ease;
        }

        .feature-btn.light {
            color: #fff;
        }

        .feature-btn:hover {
            gap: 0.8rem;
        }

        .category-filter {
            display: flex;
            gap: 1rem;
            overflow-x: auto;
            padding: 0.5rem 0;
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        .category-filter::-webkit-scrollbar {
            display: none;
        }

        .filter-chip {
            background: none;
            border: 1px solid #e5e7eb;
            padding: 0.5rem 1.5rem;
            border-radius: 25px;
            color: #6b7280;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .filter-chip:hover, .filter-chip.active {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: #fff;
        }

        @media (max-width: 992px) {
            .banner-card {
                grid-column: span 12;
            }

            .product-card {
                grid-column: span 6;
            }

            .feature-card {
                grid-column: span 12;
            }
        }

        @media (max-width: 768px) {
            .product-card {
                grid-column: span 12;
            }

            .banner-img {
                right: -100px;
            }
        }

        /* Featured Products Row Styles */
        .featured-products-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            padding: 1rem 0;
        }

        .featured-product-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
            height: 400px;
            cursor: pointer;
        }

        .featured-product-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }

        .product-image {
            height: 250px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.05), rgba(99, 102, 241, 0.05));
            transition: all 0.3s ease;
        }

        .product-image img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .featured-product-card:hover .product-image img {
            transform: scale(1.1);
        }

        .product-details {
            padding: 1.5rem;
            background: white;
            transition: all 0.3s ease;
        }

        .featured-product-card:hover .product-details {
            transform: translateY(-10px);
        }

        .product-details h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .product-specs {
            font-size: 0.9rem;
            color: var(--text-light);
            margin-bottom: 1rem;
        }

        .product-specs p {
            margin-bottom: 0.5rem;
        }

        .product-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .shop-now-btn {
            width: 100%;
            padding: 0.75rem;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .shop-now-btn:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        @media (max-width: 992px) {
            .featured-products-row {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .featured-products-row {
                grid-template-columns: 1fr;
            }
        }

        /* Mixed Size Products Grid Styles */
        .mixed-products-section {
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 0.95));
        }

        .mixed-products-row {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .mixed-product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
        }

        .mixed-product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }

        /* Large Product Card */
        .mixed-product-card.large {
            flex: 0 0 60%;
            display: flex;
            height: 100%;
        }

        .mixed-product-card.large .product-image {
            flex: 0 0 50%;
            padding: 2rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.05), rgba(99, 102, 241, 0.05));
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .mixed-product-card.large .product-details {
            flex: 0 0 50%;
            padding: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        /* Small Products Container */
        .mixed-product-small-container {
            flex: 0 0 40%;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            height: 400px;
        }

        .mixed-product-card.small {
            flex: 1;
            display: flex;
            height: calc(50% - 0.75rem);
        }

        .mixed-product-card.small .product-image {
            flex: 0 0 40%;
            padding: 1rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.05), rgba(99, 102, 241, 0.05));
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .mixed-product-card.small .product-details {
            flex: 0 0 60%;
            padding: 1rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        /* Medium Product Card */
        .mixed-product-card.medium {
            flex: 1;
            height: 300px;
        }

        .mixed-product-card.medium .product-image {
            height: 60%;
            padding: 1.5rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.05), rgba(99, 102, 241, 0.05));
        }

        .mixed-product-card.medium .product-details {
            height: 40%;
            padding: 1.5rem;
        }

        /* Common Product Elements */
        .product-image {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-image img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .mixed-product-card:hover .product-image img {
            transform: scale(1.1);
        }

        .product-category {
            font-size: 0.9rem;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.5rem;
        }

        .product-description {
            font-size: 0.9rem;
            color: var(--text-light);
            margin: 1rem 0;
        }

        @media (max-width: 992px) {
            .mixed-products-row {
                flex-direction: column;
            }

            .mixed-product-card.large {
                height: auto;
                flex-direction: column;
            }

            .mixed-product-small-container {
                flex-direction: row;
            }

            .mixed-product-card.small {
                height: 250px;
                flex-direction: column;
            }

            .mixed-product-card.medium {
                height: 350px;
            }
        }

        @media (max-width: 768px) {
            .mixed-product-small-container {
                flex-direction: column;
            }

            .mixed-product-card.small {
                height: 300px;
            }
        }

        /* Small Products Grid Styles */
        .small-products-section {
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.98));
            padding: 2rem 0;
        }

        .small-products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 1.5rem;
            padding: 1rem 0;
        }

        .small-product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            cursor: pointer;
            height: 280px;
            display: flex;
            flex-direction: column;
        }

        .small-product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .small-product-card .product-image-wrapper {
            position: relative;
            height: 65%;
            overflow: hidden;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.03), rgba(99, 102, 241, 0.03));
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem;
        }

        .small-product-card .product-image {
            width: 100%;
            height: 100%;
            object-fit: contain;
            transition: transform 0.3s ease;
            padding: 0.5rem;
        }

        .small-product-card:hover .product-image {
            transform: scale(1.1);
        }

        .small-product-card .product-details {
            padding: 0.75rem;
            text-align: center;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            background: white;
        }

        .small-product-card .product-category {
            font-size: 0.75rem;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.25rem;
        }

        .small-product-card .product-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: #1a1a1a;
            margin: 0.25rem 0;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.2;
        }

        .small-product-card .product-price {
            font-size: 1rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-top: 0.5rem;
        }

        .small-product-card .product-stock {
            font-size: 0.75rem;
            color: var(--text-light);
            margin-top: 0.25rem;
        }

        .small-product-card .product-stock.in-stock {
            color: #10b981;
        }

        .small-product-card .product-stock.low-stock {
            color: #f59e0b;
        }

        .small-product-card .product-stock.out-stock {
            color: #ef4444;
        }

        @media (max-width: 1200px) {
            .small-products-grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .small-products-grid {
                grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                gap: 1rem;
            }

            .small-product-card {
                height: 240px;
            }

            .small-product-card .product-image-wrapper {
                height: 60%;
            }

            .small-product-card .product-details {
                padding: 0.5rem;
            }

            .small-product-card .product-title {
                font-size: 0.85rem;
                -webkit-line-clamp: 2;
            }
        }

        /* Product Carousel Styles */
        .carousel-section {
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.98));
            padding: 2rem 0;
        }

        .product-carousel {
            padding: 1rem 0;
        }

        .carousel-product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            margin: 1rem;
            height: 300px;
        }

        .carousel-product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .carousel-product-card .product-image {
            height: 65%;
            padding: 1.5rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.03), rgba(99, 102, 241, 0.03));
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .carousel-product-card .product-image img {
            max-width: 80%;
            max-height: 80%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .carousel-product-card:hover .product-image img {
            transform: scale(1.1);
        }

        .carousel-product-card .product-details {
            padding: 1rem;
            text-align: center;
        }

        .carousel-product-card .product-category {
            font-size: 0.8rem;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.25rem;
        }

        .carousel-product-card h4 {
            font-size: 1.1rem;
            color: #1a1a1a;
            margin: 0.5rem 0;
        }

        .carousel-product-card .product-price {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        /* Owl Carousel Custom Navigation */
        .owl-nav button {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            border-radius: 50% !important;
            background: white !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1) !important;
            color: var(--primary-color) !important;
            font-size: 1.5rem !important;
            transition: all 0.3s ease;
        }

        .owl-nav button:hover {
            background: var(--primary-color) !important;
            color: white !important;
        }

        .owl-prev {
            left: -20px;
        }

        .owl-next {
            right: -20px;
        }

        .owl-dots {
            margin-top: 1rem;
        }

        .owl-dot span {
            background: #e5e7eb !important;
            transition: all 0.3s ease;
        }

        .owl-dot.active span {
            background: var(--primary-color) !important;
        }

        /* Quick Picks Slider Styles */
        .quick-picks-slider {
            padding: 2rem 0;
        }
        
        .quick-picks-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
            position: relative;
        }
        
        .quick-picks-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 3px;
            background: var(--primary-color);
            border-radius: 2px;
        }

        .owl-carousel .product-card {
            margin: 10px;
        }

        .owl-nav {
            position: absolute;
            top: 50%;
            width: 100%;
            transform: translateY(-50%);
            display: flex;
            justify-content: space-between;
            pointer-events: none;
            padding: 0 20px;
        }

        .owl-prev, .owl-next {
            width: 40px;
            height: 40px;
            background: var(--primary-color) !important;
            border-radius: 50% !important;
            display: flex !important;
            align-items: center;
            justify-content: center;
            color: white !important;
            pointer-events: auto;
            transition: all 0.3s ease;
            opacity: 0.7;
        }

        .owl-prev:hover, .owl-next:hover {
            background: var(--secondary-color) !important;
            opacity: 1;
        }

        .owl-dots {
            margin-top: 20px;
            text-align: center;
        }

        .owl-dot span {
            width: 10px;
            height: 10px;
            margin: 5px;
            background: var(--text-light) !important;
            display: block;
            transition: all 0.3s ease;
            border-radius: 30px;
        }

        .owl-dot.active span {
            background: var(--primary-color) !important;
            width: 20px;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .owl-nav {
                padding: 0 10px;
            }
            
            .owl-prev, .owl-next {
                width: 35px;
                height: 35px;
            }
        }

        /* Default product image styles */
        .product-image-container {
            position: relative;
            overflow: hidden;
            height: 200px;
            background: linear-gradient(45deg, #f3f4f6, #e5e7eb);
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-image.default {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .product-image-container:hover .product-image {
            transform: scale(1.1);
        }

        /* Add this to your existing styles */
        .voice-search-btn {
            background: none;
            border: none;
            color: var(--primary-color);
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 50%;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            position: absolute;
            right: 60px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
        }

        .voice-search-btn:hover {
            background: rgba(37, 99, 235, 0.1);
        }

        .voice-search-btn.listening {
            animation: pulse 1.5s infinite;
            background: rgba(37, 99, 235, 0.1);
        }

        @keyframes pulse {
            0% { transform: translateY(-50%) scale(1); }
            50% { transform: translateY(-50%) scale(1.1); }
            100% { transform: translateY(-50%) scale(1); }
        }

        .voice-search-tooltip {
            position: absolute;
            bottom: -40px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.3s ease;
            white-space: nowrap;
        }

        .voice-search-btn:hover .voice-search-tooltip {
            opacity: 1;
        }

        /* Search form styles */
        .input-group {
            position: relative;
            display: flex;
            flex-wrap: nowrap;
        }
        
        .category-select {
            max-width: 150px;
            border-radius: 20px 0 0 20px;
            border: 1px solid #dee2e6;
            border-right: none;
            padding: 0.5rem 1rem;
            background-color: #f8f9fa;
        }
        
        .form-control {
            border-radius: 0;
            border: 1px solid #dee2e6;
            padding: 0.5rem 1rem;
        }
        
        .btn-outline-primary {
            border-radius: 0 20px 20px 0;
            border: 1px solid var(--primary-color);
        }

        /* Search form styles */
        .input-group {
            position: relative;
        }
        
        .form-control {
            border-radius: 20px 0 0 20px;
            border: 1px solid #dee2e6;
            padding: 0.5rem 1rem;
            padding-right: 40px; /* Space for voice button */
        }
        
        .btn-outline-primary {
            border-radius: 0 20px 20px 0;
            border: 1px solid var(--primary-color);
        }

        /* Voice search button styles */
        .voice-search-btn {
            position: absolute;
            right: 50px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            padding: 0.25rem;
            color: var(--primary-color);
            border: none;
            background: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .voice-search-btn:hover {
            color: var(--secondary-color);
        }

        .voice-search-btn.listening {
            color: #dc3545;
        }

        .voice-search-btn .voice-pulse {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background-color: currentColor;
            opacity: 0;
            transform: scale(1);
            pointer-events: none;
        }

        .voice-search-btn.listening .voice-pulse {
            animation: pulse 1.5s ease-out infinite;
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
                opacity: 0.15;
            }
            100% {
                transform: scale(2);
                opacity: 0;
            }
        }

        /* Toast notification for voice search */
        .voice-toast {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 30px;
            font-size: 0.9rem;
            z-index: 1000;
            display: none;
            align-items: center;
            gap: 0.5rem;
        }

        .voice-toast.show {
            display: flex;
            animation: slideUp 0.3s ease forwards;
        }

        @keyframes slideUp {
            from {
                transform: translate(-50%, 100%);
                opacity: 0;
            }
            to {
                transform: translate(-50%, 0);
                opacity: 1;
            }
        }

        /* Search form styles */
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .form-control {
            border-radius: 20px 0 0 20px;
            border: 1px solid #dee2e6;
            padding: 0.5rem 1rem;
            padding-right: 40px;
        }
        
        .voice-search-wrapper {
            position: absolute;
            right: 45px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 3;
        }
        
        .voice-search-btn {
            background: none;
            border: none;
            color: var(--primary-color);
            padding: 0.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            opacity: 0.7;
        }
        
        .voice-search-btn:hover {
            opacity: 1;
            color: var(--primary-color);
        }
        
        .voice-search-btn.listening {
            color: #dc3545;
            animation: pulse 1.5s infinite;
        }
        
        .btn-outline-primary {
            border-radius: 0 20px 20px 0;
            border: 1px solid var(--primary-color);
            margin-left: -1px;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }
        
        /* Toast notification */
        #voiceSearchToast {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            display: none;
            z-index: 1000;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
</head>
<body>
    <div class="animated-bg"></div>
    
    <!-- Toast Container -->
    <div class="toast-container">
        <div class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <!-- Enhanced Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand" href="userdashboard" data-aos="fade-right">
                <i class="bi bi-phone"></i> PN MobileStore
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="userdashboard">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="bookservices.jsp">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about_us.jsp">About Us</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <!-- Search Form -->
                    <form action="SearchServlet" method="GET" class="d-flex me-3">
                        <div class="input-group">
                            <input type="text" name="query" id="searchInput" class="form-control" placeholder="Search products..." required>
                            <button type="button" id="voiceSearchBtn" class="voice-search-btn" title="Search by voice">
                                <i class="bi bi-mic"></i>
                                <span class="voice-search-tooltip">Click to search by voice</span>
                            </button>
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </form>
                    <!-- Cart Icon -->
                    <div class="nav-item me-3">
                        <a href="cart.jsp" class="nav-link position-relative">
                            <i class="bi bi-cart fs-4"></i>
                            <% if (cartCount > 0) { %>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    <%= cartCount %>
                                </span>
                            <% } %>
                        </a>
                    </div>

                    <!-- Wishlist Icon -->
                    <div class="nav-item me-3">
                        <a href="wishlist.jsp" class="nav-link position-relative">
                            <i class="bi bi-heart fs-4"></i>
                            <% if (wishlistCount > 0) { %>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    <%= wishlistCount %>
                                </span>
                            <% } %>
                        </a>
                    </div>
                    <!-- Notifications Icon -->
                    <div class="dropdown me-3">
                        <a href="#" class="nav-link position-relative" id="notificationsDropdown" role="button" 
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-bell fs-4"></i>
                            <% 
                            NotificationDAO notificationDAO = new NotificationDAO();
                            int unreadCount = notificationDAO.getUnreadCount(user.getId());
                            if (unreadCount > 0) { 
                            %>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="notificationBadge">
                                    <%= unreadCount %>
                                </span>
                            <% } %>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end notification-dropdown" 
                             style="width: 300px; max-height: 400px; overflow-y: auto;">
                            <div id="notificationsList">
                                <!-- Notifications will be loaded here by JavaScript -->
                            </div>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item text-center" href="notifications">View All Notifications</a>
                        </div>
                    </div>
                    <div class="dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" id="accountDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle fs-4"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="accountDropdown">
                            <li>
                                <div class="px-4 py-3">
                                    <p class="mb-0 fw-bold">Welcome, <%= user.getName() %></p>
                                </div>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="userprofile.jsp"><i class="bi bi-person"></i>My Profile</a></li>
                            <li><a class="dropdown-item" href="orders.jsp"><i class="bi bi-bag"></i>My Orders</a></li>
                            <li><a class="dropdown-item" href="chatbot.jsp"><i class="bi bi-chat-dots"></i>Chatbot</a></li>
                            <li><a class="dropdown-item" href="userServiceBookings.jsp"><i class="bi bi-tools"></i>Service Bookings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="contact_us.jsp"><i class="bi bi-question-circle"></i>Help & Support</a></li>
                            <li><a class="dropdown-item text-danger" href="logout"><i class="bi bi-box-arrow-right"></i>Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Enhanced Creative Hero Section -->
    <section class="hero-section py-5 position-relative overflow-hidden">
        <!-- Animated Background Elements -->
        <div class="animated-circles">
            <div class="circle circle-1"></div>
            <div class="circle circle-2"></div>
            <div class="circle circle-3"></div>
        </div>
        <div class="floating-elements">
            <i class="bi bi-phone-fill element"></i>
            <i class="bi bi-headphones element"></i>
            <i class="bi bi-smartwatch element"></i>
            <i class="bi bi-tablet element"></i>
            <i class="bi bi-speaker element"></i>
        </div>

        <div class="container position-relative">
            <!-- Welcome Message with Typewriter Effect -->
            <div class="row align-items-center">
                <div class="col-lg-6" data-aos="fade-right">
                    <div class="welcome-text-container">
                        <h1 class="display-4 fw-bold text-gradient mb-3">
                            Welcome Back,<br>
                            <span class="typewriter"><%= user.getName() %>!</span>
                        </h1>
                        <p class="lead mb-4 text-gradient-subtle">Your personal gateway to the latest tech innovations</p>
                        <div class="feature-badges mb-4">
                            <span class="badge">Premium Devices</span>
                            <span class="badge">Expert Support</span>
                            <span class="badge">Fast Delivery</span>
                        </div>
                        <div class="d-flex gap-3 mb-5">
                            <a href="#featured-products" class="btn btn-primary btn-lg btn-glow">
                                <i class="bi bi-phone"></i> Explore Phones
                                <span class="btn-particles"></span>
                            </a>
                            <a href="bookservices.jsp" class="btn btn-outline-primary btn-lg btn-hover-float">
                                <i class="bi bi-tools"></i> Book Service
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 position-relative" data-aos="fade-left">
                    <div class="scene3d">
                        <div class="floating-phones">
                            <img src="https://www.pngmart.com/files/15/Apple-iPhone-12-PNG-Picture.png" alt="Phone 1" class="floating-phone phone-1">
                            <img src="https://www.pngmart.com/files/22/iPhone-14-Pro-PNG-Picture.png" alt="Phone 2" class="floating-phone phone-2">
                        </div>
                        <div class="reflection"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Category Icons Section -->
    <section class="category-icons">
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-6" data-aos="fade-up">
                    <div class="category-icon-item">
                        <div class="category-icon-circle">
                            <img src="https://www.pngmart.com/files/22/iPhone-14-Pro-Max-PNG-Photos.png" alt="Phones">
                        </div>
                        <h4>Phones</h4>
                        <div class="category-icon-count">23 products</div>
                    </div>
                </div>
                <div class="col-md-3 col-6" data-aos="fade-up" data-aos-delay="100">
                    <div class="category-icon-item">
                        <div class="category-icon-circle">
                            <img src="https://www.pngmart.com/files/22/Apple-Watch-Ultra-PNG-Isolated-Pic.png" alt="Smartwatches">
                        </div>
                        <h4>Smartwatches</h4>
                        <div class="category-icon-count">18 products</div>
                    </div>
                </div>
                <div class="col-md-3 col-6" data-aos="fade-up" data-aos-delay="200">
                    <div class="category-icon-item">
                        <div class="category-icon-circle">
                            <img src="https://www.pngmart.com/files/6/Beats-By-Dr-Dre-Headphone-PNG-Transparent.png" alt="Headphones">
                        </div>
                        <h4>Headphones</h4>
                        <div class="category-icon-count">15 products</div>
                    </div>
                </div>
                <div class="col-md-3 col-6" data-aos="fade-up" data-aos-delay="300">
                    <div class="category-icon-item">
                        <div class="category-icon-circle">
                            <img src="https://www.pngmart.com/files/7/Computer-Mouse-PNG-Transparent-Image.png" alt="Accessories">
                        </div>
                        <h4>Accessories</h4>
                        <div class="category-icon-count">20 products</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Service Boxes Section -->
    <section class="service-boxes">
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-6 mb-4" data-aos="fade-up">
                    <div class="service-box">
                        <div class="service-icon">
                            <i class="bi bi-truck"></i>
                        </div>
                        <div class="service-content">
                            <h5 class="service-title">Free Shipping</h5>
                            <p class="service-text">Order above $1000</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="service-box">
                        <div class="service-icon">
                            <i class="bi bi-arrow-repeat"></i>
                        </div>
                        <div class="service-content">
                            <h5 class="service-title">Return & Refund</h5>
                            <p class="service-text">Money Back Guarantee</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="service-box">
                        <div class="service-icon">
                            <i class="bi bi-tag"></i>
                        </div>
                        <div class="service-content">
                            <h5 class="service-title">Member Discount</h5>
                            <p class="service-text">On every Order</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="service-box">
                        <div class="service-icon">
                            <i class="bi bi-headset"></i>
                        </div>
                        <div class="service-content">
                            <h5 class="service-title">Customer Support</h5>
                            <p class="service-text">Every Time Call Support</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Explore Products Section -->
    <section class="explore-products py-5">
        <div class="container">
            <div class="explore-header mb-4">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <h2 class="explore-title display-6 fw-bold">EXPLORE PRODUCTS</h2>
                        <p class="explore-subtitle text-muted">Discover our curated collection of premium products designed to enhance your lifestyle.</p>
                    </div>
                    <div class="col-lg-4">
                        <div class="popular-products">
                            <h6 class="mb-3">Popular Products</h6>
                            <div class="avatar-group mb-2">
                                <img src="https://www.pngmart.com/files/22/iPhone-14-Pro-PNG-Photos.png" alt="Product 1" class="avatar">
                                <img src="https://www.pngmart.com/files/22/Samsung-Galaxy-S23-Ultra-PNG-Picture.png" alt="Product 2" class="avatar">
                                <img src="https://www.pngmart.com/files/22/Nothing-Phone-1-PNG-HD-Isolated.png" alt="Product 3" class="avatar">
                                <a href="#" class="avatar-more">+5</a>
                            </div>
                            <a href="#" class="view-all">View All <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="explore-grid">
                <!-- Banner Cards -->
                <div class="banner-card purple">
                    <div class="banner-content">
                        <h3>Love the tech you're in</h3>
                        <a href="#" class="banner-btn">View All <i class="bi bi-arrow-right"></i></a>
                    </div>
                    <img src="https://www.pngmart.com/files/22/iPhone-14-Pro-PNG-Photos.png" alt="Banner 1" class="banner-img">
                </div>

                <div class="banner-card yellow">
                    <div class="banner-content">
                        <h3>Discover amazing gadgets</h3>
                        <a href="#" class="banner-btn">Shop Now <i class="bi bi-arrow-right"></i></a>
                    </div>
                    <img src="https://www.pngmart.com/files/22/Samsung-Galaxy-S23-Ultra-PNG-Picture.png" alt="Banner 2" class="banner-img">
                </div>

                <!-- Product Cards -->
                <div class="product-card">
                    <div class="product-img-wrapper">
                        <img src="https://www.pngmart.com/files/6/Beats-By-Dr-Dre-Headphone-PNG-Transparent.png" alt="Premium Headphones" class="product-img">
                    </div>
                    <h4>Premium Headphones</h4>
                    <div class="price-badge">$299</div>
                </div>

                <div class="product-card">
                    <div class="product-img-wrapper">
                        <img src="https://tse4.mm.bing.net/th?id=OIP.dHIxUjDWeG8bV60imHOxiQHaD0&pid=Api&P=0&h=180" alt="Smart Watch" class="product-img">
                    </div>
                    <h4>Smart Watch Ultra</h4>
                    <div class="price-badge">$799</div>
                </div>
            </div>

            <!-- Category Filter -->
            <div class="category-filter">
                <button class="filter-chip active">All</button>
                <button class="filter-chip">Phones</button>
                <button class="filter-chip">Tablets</button>
                <button class="filter-chip">Laptops</button>
                <button class="filter-chip">Accessories</button>
                <button class="filter-chip">Wearables</button>
                <button class="filter-chip">Audio</button>
                <button class="filter-chip">Gaming</button>
            </div>
        </div>
    </section>

    <!-- New Arrivals Heading -->
    <div class="container">
        <div class="row">
            <div class="col-12">
                <h2 class="new-arrivals-heading">
                    Explore New Arrivals
                    <div class="heading-underline"></div>
                </h2>
            </div>
        </div>
    </div>

    <!-- Image Slider Section -->
    <section class="slider-section">
        <div class="container">
            <div class="split-container">
                <!-- Left Side - Slider -->
                <div class="slider-container">
                    <div class="slider">
                        <div class="slide active">
                            <div class="slide-overlay"></div>
                            <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/Shreyansh/BAU/Unrexc/D70978891_INWLD_BAU_Unrec_Uber_PC_Hero_3000x1200._CB594707876_.jpg" class="slide-image" alt="Latest Smartphones">
                            <div class="slide-content">
                                <h2 class="slide-title">Discover Latest Smartphones</h2>
                                <p class="slide-description">Experience cutting-edge technology with our premium selection of smartphones.</p>
                                <a href="#" class="slide-button">Shop Now <i class="bi bi-arrow-right ms-2"></i></a>
                            </div>
                        </div>
                        <div class="slide">
                            <div class="slide-overlay"></div>
                            <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/Samsung/SamsungBAU/S24Series/Launch/D111827450_INWLD_Samsung_S24Series_Launch_PC_Hero_3000x1200._CB584595639_.jpg" class="slide-image" alt="Premium Accessories">
                            <div class="slide-content">
                                <h2 class="slide-title">Premium Accessories</h2>
                                <p class="slide-description">Enhance your mobile experience with our curated collection of accessories.</p>
                                <a href="#" class="slide-button">Explore More <i class="bi bi-arrow-right ms-2"></i></a>
                            </div>
                        </div>
                        <div class="slide">
                            <div class="slide-overlay"></div>
                            <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/CatPage/RevampNew/NewLaunches/D111827450_WLD_BAU_Category_page_PC_Hero_3000x1200._CB584595639_.jpg" class="slide-image" alt="Special Offers">
                            <div class="slide-content">
                                <h2 class="slide-title">Special Offers</h2>
                                <p class="slide-description">Don't miss out on our exclusive deals and discounts on top brands.</p>
                                <a href="#" class="slide-button">View Deals <i class="bi bi-arrow-right ms-2"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="slider-nav">
                        <div class="slider-dot active"></div>
                        <div class="slider-dot"></div>
                        <div class="slider-dot"></div>
                    </div>
                    <div class="slider-arrows">
                        <div class="slider-arrow prev">
                            <i class="bi bi-chevron-left"></i>
                        </div>
                        <div class="slider-arrow next">
                            <i class="bi bi-chevron-right"></i>
                        </div>
                    </div>
                </div>

                <!-- Right Side - Featured Products Grid -->
                <div class="featured-products-grid">
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/22/iPhone-14-Pro-PNG-Photos.png" alt="iPhone 14 Pro" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">iPhone 14 Pro</h3>
                            <div class="featured-product-price">$999</div>
                        </div>
                    </div>
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/22/Samsung-Galaxy-S23-Ultra-PNG-Picture.png" alt="Samsung S23 Ultra" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">Samsung S23 Ultra</h3>
                            <div class="featured-product-price">$1199</div>
                        </div>
                    </div>
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/22/Nothing-Phone-1-PNG-HD-Isolated.png" alt="Nothing Phone" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">Nothing Phone</h3>
                            <div class="featured-product-price">$749</div>
                        </div>
                    </div>
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/22/OnePlus-11-5G-PNG-Photos.png" alt="OnePlus 11" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">OnePlus 11</h3>
                            <div class="featured-product-price">$699</div>
                        </div>
                    </div>
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/15/Apple-iPhone-12-PNG-Picture.png" alt="iPhone 12" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">iPhone 12</h3>
                            <div class="featured-product-price">$599</div>
                        </div>
                    </div>
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/22/Xiaomi-13-Pro-PNG-Photo.png" alt="Xiaomi 13 Pro" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">Xiaomi 13 Pro</h3>
                            <div class="featured-product-price">$899</div>
                        </div>
                    </div>
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/22/Google-Pixel-7-Pro-PNG-Image.png" alt="Google Pixel 7 Pro" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">Google Pixel 7 Pro</h3>
                            <div class="featured-product-price">$899</div>
                        </div>
                    </div>
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/22/Vivo-X90-Pro-PNG-Pic.png" alt="Vivo X90 Pro" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">Vivo X90 Pro</h3>
                            <div class="featured-product-price">$799</div>
                        </div>
                    </div>
                    <div class="featured-product">
                        <img src="https://www.pngmart.com/files/22/OPPO-Find-X6-Pro-PNG-File.png" alt="OPPO Find X6 Pro" class="featured-product-img">
                        <div class="featured-product-content">
                            <h3 class="featured-product-title">OPPO Find X6 Pro</h3>
                            <div class="featured-product-price">$849</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Bootstrap JS and other scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Featured Products Row -->
    <section class="featured-row py-5">
        <div class="container">
            <h2 class="new-arrivals-heading mb-4">
                Trending Products
                <div class="heading-underline"></div>
            </h2>
            <div class="featured-products-row">
                <!-- Product Card 1 -->
                <div class="featured-product-card">
                    <div class="product-image">
                        <img src="https://www.pngmart.com/files/22/iPhone-14-Pro-PNG-Photos.png" alt="iPhone 14 Pro">
                    </div>
                    <div class="product-details">
                        <h3>iPhone 14 Pro</h3>
                        <div class="product-specs">
                            <p>• 6.1-inch Super Retina XDR display</p>
                            <p>• A16 Bionic chip</p>
                            <p>• Pro camera system</p>
                        </div>
                        <div class="product-price">$999</div>
                        <button class="shop-now-btn">Shop Now</button>
                    </div>
                </div>

                <!-- Product Card 2 -->
                <div class="featured-product-card">
                    <div class="product-image">
                        <img src="https://www.pngmart.com/files/22/Samsung-Galaxy-S23-Ultra-PNG-Picture.png" alt="Samsung S23 Ultra">
                    </div>
                    <div class="product-details">
                        <h3>Samsung S23 Ultra</h3>
                        <div class="product-specs">
                            <p>• 6.8-inch Dynamic AMOLED</p>
                            <p>• Snapdragon 8 Gen 2</p>
                            <p>• 200MP Camera System</p>
                        </div>
                        <div class="product-price">$1199</div>
                        <button class="shop-now-btn">Shop Now</button>
                    </div>
                </div>

                <!-- Product Card 3 -->
                <div class="featured-product-card">
                    <div class="product-image">
                        <img src="https://www.pngmart.com/files/22/Nothing-Phone-1-PNG-HD-Isolated.png" alt="Nothing Phone">
                    </div>
                    <div class="product-details">
                        <h3>Nothing Phone</h3>
                        <div class="product-specs">
                            <p>• 6.55-inch OLED display</p>
                            <p>• Snapdragon 778G+</p>
                            <p>• Glyph Interface</p>
                        </div>
                        <div class="product-price">$749</div>
                        <button class="shop-now-btn">Shop Now</button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Mixed Size Products Grid -->
    <section class="mixed-products-section py-5">
        <div class="container">
            <h2 class="new-arrivals-heading mb-4">
                Discover More
                <div class="heading-underline"></div>
            </h2>
            
            <!-- Products Row -->
            <div class="mixed-products-row">
                <!-- Large Product Card -->
                <div class="mixed-product-card large">
                    <div class="product-image">
                        <img src="https://www.pngmart.com/files/22/iPhone-14-Pro-PNG-Photos.png" alt="iPhone 14 Pro Max">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Flagship</span>
                        <h3>iPhone 14 Pro Max</h3>
                        <p class="product-description">Experience the ultimate iPhone with revolutionary features.</p>
                        <div class="product-price">$1099</div>
                        <button class="shop-now-btn">Shop Now</button>
                    </div>
                </div>
                
                <!-- Right Side Product Cards -->
                <div class="mixed-product-small-container">
                    <div class="mixed-product-card small">
                        <div class="product-image">
                            <img src="https://www.pngmart.com/files/22/Samsung-Galaxy-S23-Ultra-PNG-Picture.png" alt="Samsung S23">
                        </div>
                        <div class="product-details">
                            <span class="product-category">Premium</span>
                            <h3>Samsung S23</h3>
                            <div class="product-price">$999</div>
                            <button class="shop-now-btn">Shop Now</button>
                        </div>
                    </div>
                    <div class="mixed-product-card small">
                        <div class="product-image">
                            <img src="https://www.pngmart.com/files/22/Nothing-Phone-1-PNG-HD-Isolated.png" alt="Nothing Phone">
                        </div>
                        <div class="product-details">
                            <span class="product-category">Innovation</span>
                            <h3>Nothing Phone</h3>
                            <div class="product-price">$749</div>
                            <button class="shop-now-btn">Shop Now</button>
                        </div>
                    </div>
                </div>
            </div>
            

        </div>
    </section>

    <!-- Small Products Grid -->
    <section class="small-products-section py-5">
        <div class="container">
            <h2 class="new-arrivals-heading mb-4">
                Quick Picks
                <div class="heading-underline"></div>
            </h2>
            
            <div class="small-products-grid">
                <!-- Small Product Card 1 -->
                <div class="small-product-card">
                    <div class="product-image">
                        <img src="https://tse4.mm.bing.net/th?id=OIP.QjxbU5DcwRMLQMeykctPHQHaHa&pid=Api&P=0&h=180" alt="Apple Watch Ultra">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Wearable</span>
                        <h4>Apple Watch Ultra</h4>
                        <div class="product-price">$799</div>
                    </div>
                </div>

                <!-- Small Product Card 2 -->
                <div class="small-product-card">
                    <div class="product-image">
                        <img src="https://tse3.mm.bing.net/th?id=OIP.Oeu9K29QzYN7eDnLrjgTzQHaHa&pid=Api&P=0&h=180" alt="Beats Studio">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Audio</span>
                        <h4>Beats Studio</h4>
                        <div class="product-price">$349</div>
                    </div>
                </div>

                <!-- Small Product Card 3 -->
                <div class="small-product-card">
                    <div class="product-image">
                        <img src="https://tse1.mm.bing.net/th?id=OIP.cvtJztN8mxPhqsEJSHiGmQHaHa&pid=Api&P=0&h=180" alt="AirPods Pro">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Audio</span>
                        <h4>AirPods Pro</h4>
                        <div class="product-price">$249</div>
                    </div>
                </div>

                <!-- Small Product Card 4 -->
                <div class="small-product-card">
                    <div class="product-image">
                        <img src="https://tse1.mm.bing.net/th?id=OIP.4pwe_IjizaJLDqaSHEc29gHaF6&pid=Api&P=0&h=180" alt="Galaxy Watch 5">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Wearable</span>
                        <h4>Galaxy Watch 5</h4>
                        <div class="product-price">$449</div>
                    </div>
                </div>

                <!-- Small Product Card 5 -->
                <div class="small-product-card">
                    <div class="product-image">
                        <img src="https://tse4.mm.bing.net/th?id=OIP.tFJjE5pZWEJZDBeu0P-zkgHaEL&pid=Api&P=0&h=180" alt="JBL Speaker">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Audio</span>
                        <h4>JBL Flip 6</h4>
                        <div class="product-price">$129</div>
                    </div>
                </div>

                <!-- Small Product Card 6 -->
                <div class="small-product-card">
                    <div class="product-image">
                        <img src="https://tse2.mm.bing.net/th?id=OIP.3UdP-eJjIyLb-y0vh3MmagHaHa&pid=Api&P=0&h=180" alt="Galaxy Buds">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Audio</span>
                        <h4>Galaxy Buds 2 Pro</h4>
                        <div class="product-price">$229</div>
                    </div>
                </div>

                <!-- Small Product Card 7 -->
                <div class="small-product-card">
                    <div class="product-image">
                        <img src="https://tse3.mm.bing.net/th?id=OIP.uhaC4J4h8MGXtLQsNekPFgHaGL&pid=Api&P=0&h=180" alt="Magic Mouse">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Accessory</span>
                        <h4>Boat Earphones</h4>
                        <div class="product-price">$99</div>
                    </div>
                </div>

                <!-- Small Product Card 8 -->
                <div class="small-product-card">
                    <div class="product-image">
                        <img src="https://tse2.mm.bing.net/th?id=OIP.rfA0Z1q7NXmwIRk5LDu9uwHaHa&pid=Api&P=0&h=180" alt="Gaming Mouse">
                    </div>
                    <div class="product-details">
                        <span class="product-category">Gaming</span>
                        <h4>Gaming Mouse</h4>
                        <div class="product-price">$79</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <style>
        /* Small Products Grid Styles */
        .small-products-section {
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.98));
            padding: 2rem 0;
        }

        .small-products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1.5rem;
            padding: 1rem 0;
        }

        .small-product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            cursor: pointer;
            height: 250px;
            display: flex;
            flex-direction: column;
        }

        .small-product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .small-product-card .product-image {
            height: 60%;
            padding: 1rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.03), rgba(99, 102, 241, 0.03));
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .small-product-card .product-image img {
            max-width: 80%;
            max-height: 80%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .small-product-card:hover .product-image img {
            transform: scale(1.1);
        }

        .small-product-card .product-details {
            padding: 1rem;
            text-align: center;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .small-product-card .product-category {
            font-size: 0.8rem;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.25rem;
        }

        .small-product-card h4 {
            font-size: 1rem;
            color: #1a1a1a;
            margin: 0.5rem 0;
        }

        .small-product-card .product-price {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .small-products-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 1rem;
            }

            .small-product-card {
                height: 220px;
            }
        }

        /* Product Carousel Styles */
        .carousel-section {
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.98));
            padding: 2rem 0;
        }

        .product-carousel {
            padding: 1rem 0;
        }

        .carousel-product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            margin: 1rem;
            height: 300px;
        }

        .carousel-product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .carousel-product-card .product-image {
            height: 65%;
            padding: 1.5rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.03), rgba(99, 102, 241, 0.03));
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .carousel-product-card .product-image img {
            max-width: 80%;
            max-height: 80%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .carousel-product-card:hover .product-image img {
            transform: scale(1.1);
        }

        .carousel-product-card .product-details {
            padding: 1rem;
            text-align: center;
        }

        .carousel-product-card .product-category {
            font-size: 0.8rem;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.25rem;
        }

        .carousel-product-card h4 {
            font-size: 1.1rem;
            color: #1a1a1a;
            margin: 0.5rem 0;
        }

        .carousel-product-card .product-price {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        /* Owl Carousel Custom Navigation */
        .owl-nav button {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            border-radius: 50% !important;
            background: white !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1) !important;
            color: var(--primary-color) !important;
            font-size: 1.5rem !important;
            transition: all 0.3s ease;
        }

        .owl-nav button:hover {
            background: var(--primary-color) !important;
            color: white !important;
        }

        .owl-prev {
            left: -20px;
        }

        .owl-next {
            right: -20px;
        }

        .owl-dots {
            margin-top: 1rem;
        }

        .owl-dot span {
            background: #e5e7eb !important;
            transition: all 0.3s ease;
        }

        .owl-dot.active span {
            background: var(--primary-color) !important;
        }

        /* Quick Picks Slider Styles */
        .quick-picks-slider {
            padding: 2rem 0;
        }
        
        .quick-picks-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
            position: relative;
        }
        
        .quick-picks-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 3px;
            background: var(--primary-color);
            border-radius: 2px;
        }

        .owl-carousel .product-card {
            margin: 10px;
        }

        .owl-nav {
            position: absolute;
            top: 50%;
            width: 100%;
            transform: translateY(-50%);
            display: flex;
            justify-content: space-between;
            pointer-events: none;
            padding: 0 20px;
        }

        .owl-prev, .owl-next {
            width: 40px;
            height: 40px;
            background: var(--primary-color) !important;
            border-radius: 50% !important;
            display: flex !important;
            align-items: center;
            justify-content: center;
            color: white !important;
            pointer-events: auto;
            transition: all 0.3s ease;
            opacity: 0.7;
        }

        .owl-prev:hover, .owl-next:hover {
            background: var(--secondary-color) !important;
            opacity: 1;
        }

        .owl-dots {
            margin-top: 20px;
            text-align: center;
        }

        .owl-dot span {
            width: 10px;
            height: 10px;
            margin: 5px;
            background: var(--text-light) !important;
            display: block;
            transition: all 0.3s ease;
            border-radius: 30px;
        }

        .owl-dot.active span {
            background: var(--primary-color) !important;
            width: 20px;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .owl-nav {
                padding: 0 10px;
            }
            
            .owl-prev, .owl-next {
                width: 35px;
                height: 35px;
            }
        }

        /* Default product image styles */
        .product-image-container {
            position: relative;
            overflow: hidden;
            height: 200px;
            background: linear-gradient(45deg, #f3f4f6, #e5e7eb);
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-image.default {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .product-image-container:hover .product-image {
            transform: scale(1.1);
        }

        /* Add this to your existing styles */
        .voice-search-btn {
            background: none;
            border: none;
            color: var(--primary-color);
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 50%;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            position: absolute;
            right: 60px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
        }

        .voice-search-btn:hover {
            background: rgba(37, 99, 235, 0.1);
        }

        .voice-search-btn.listening {
            animation: pulse 1.5s infinite;
            background: rgba(37, 99, 235, 0.1);
        }

        @keyframes pulse {
            0% { transform: translateY(-50%) scale(1); }
            50% { transform: translateY(-50%) scale(1.1); }
            100% { transform: translateY(-50%) scale(1); }
        }

        .voice-search-tooltip {
            position: absolute;
            bottom: -40px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.3s ease;
            white-space: nowrap;
        }

        .voice-search-btn:hover .voice-search-tooltip {
            opacity: 1;
        }

        /* Search form styles */
        .input-group {
            position: relative;
            display: flex;
            flex-wrap: nowrap;
        }
        
        .category-select {
            max-width: 150px;
            border-radius: 20px 0 0 20px;
            border: 1px solid #dee2e6;
            border-right: none;
            padding: 0.5rem 1rem;
            background-color: #f8f9fa;
        }
        
        .form-control {
            border-radius: 0;
            border: 1px solid #dee2e6;
            padding: 0.5rem 1rem;
        }
        
        .btn-outline-primary {
            border-radius: 0 20px 20px 0;
            border: 1px solid var(--primary-color);
        }

        /* Search form styles */
        .input-group {
            position: relative;
        }
        
        .form-control {
            border-radius: 20px 0 0 20px;
            border: 1px solid #dee2e6;
            padding: 0.5rem 1rem;
            padding-right: 40px; /* Space for voice button */
        }
        
        .btn-outline-primary {
            border-radius: 0 20px 20px 0;
            border: 1px solid var(--primary-color);
        }

        /* Voice search button styles */
        .voice-search-btn {
            position: absolute;
            right: 50px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            padding: 0.25rem;
            color: var(--primary-color);
            border: none;
            background: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .voice-search-btn:hover {
            color: var(--secondary-color);
        }

        .voice-search-btn.listening {
            color: #dc3545;
        }

        .voice-search-btn .voice-pulse {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background-color: currentColor;
            opacity: 0;
            transform: scale(1);
            pointer-events: none;
        }

        .voice-search-btn.listening .voice-pulse {
            animation: pulse 1.5s ease-out infinite;
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
                opacity: 0.15;
            }
            100% {
                transform: scale(2);
                opacity: 0;
            }
        }

        /* Toast notification for voice search */
        .voice-toast {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 30px;
            font-size: 0.9rem;
            z-index: 1000;
            display: none;
            align-items: center;
            gap: 0.5rem;
        }

        .voice-toast.show {
            display: flex;
            animation: slideUp 0.3s ease forwards;
        }

        @keyframes slideUp {
            from {
                transform: translate(-50%, 100%);
                opacity: 0;
            }
            to {
                transform: translate(-50%, 0);
                opacity: 1;
            }
        }

        /* Search form styles */
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .form-control {
            border-radius: 20px 0 0 20px;
            border: 1px solid #dee2e6;
            padding: 0.5rem 1rem;
            padding-right: 40px;
        }
        
        .voice-search-wrapper {
            position: absolute;
            right: 45px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 3;
        }
        
        .voice-search-btn {
            background: none;
            border: none;
            color: var(--primary-color);
            padding: 0.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            opacity: 0.7;
        }
        
        .voice-search-btn:hover {
            opacity: 1;
            color: var(--primary-color);
        }
        
        .voice-search-btn.listening {
            color: #dc3545;
            animation: pulse 1.5s infinite;
        }
        
        .btn-outline-primary {
            border-radius: 0 20px 20px 0;
            border: 1px solid var(--primary-color);
            margin-left: -1px;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }
        
        /* Toast notification */
        #voiceSearchToast {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            display: none;
            z-index: 1000;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>


    <style>
        /* Small Products Grid Styles */
        .small-products-section {
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.98));
            padding: 2rem 0;
        }

        .small-products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1.5rem;
            padding: 1rem 0;
        }

        .small-product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            cursor: pointer;
            height: 250px;
            display: flex;
            flex-direction: column;
        }

        .small-product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .small-product-card .product-image {
            height: 60%;
            padding: 1rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.03), rgba(99, 102, 241, 0.03));
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .small-product-card .product-image img {
            max-width: 80%;
            max-height: 80%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .small-product-card:hover .product-image img {
            transform: scale(1.1);
        }

        .small-product-card .product-details {
            padding: 1rem;
            text-align: center;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .small-product-card .product-category {
            font-size: 0.8rem;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.25rem;
        }

        .small-product-card h4 {
            font-size: 1rem;
            color: #1a1a1a;
            margin: 0.5rem 0;
        }

        .small-product-card .product-price {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .small-products-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 1rem;
            }

            .small-product-card {
                height: 220px;
            }
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 800,
            once: true
        });

        // Function to show toast message
        function showToast(message, type) {
            const toast = document.querySelector('.toast');
            const toastBody = toast.querySelector('.toast-body');
            
            // Set message and type
            toastBody.textContent = message;
            toast.className = 'toast align-items-center text-white border-0 ' + type;
            
            // Show toast
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
        }

        // Check for messages from servlets
        <% if (request.getAttribute("message") != null) { %>
            showToast('<%= request.getAttribute("message") %>', 'bg-success');
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            showToast('<%= request.getAttribute("error") %>', 'bg-danger');
        <% } %>

        // Counter Animation with Intersection Observer
        const counterObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const counter = entry.target;
                    const target = parseInt(counter.getAttribute('data-target'));
                    const duration = 2000;
                    const step = target / (duration / 16);
                    let current = 0;

                    const updateCounter = () => {
                        current += step;
                        if (current < target) {
                            counter.textContent = Math.round(current);
                            requestAnimationFrame(updateCounter);
                        } else {
                            counter.textContent = target;
                        }
                    };

                    updateCounter();
                    counterObserver.unobserve(counter);
                }
            });
        }, {
            threshold: 0.5
        });

        // Observe all counters
        document.querySelectorAll('.counter').forEach(counter => {
            counterObserver.observe(counter);
        });

        // GSAP ScrollTrigger Animations
        gsap.registerPlugin(ScrollTrigger);

        const whyUsCards = document.querySelectorAll('.why-us-card');
        whyUsCards.forEach((card, index) => {
            gsap.from(card, {
                scrollTrigger: {
                    trigger: card,
                    start: "top bottom-=100",
                    toggleActions: "play none none reverse"
                },
                y: 50,
                opacity: 0,
                duration: 0.8,
                delay: index * 0.1
            });
        });

        // GSAP Animations for Explore Products Section
        gsap.from('.explore-header', {
            scrollTrigger: {
                trigger: '.explore-header',
                start: 'top bottom-=100',
                toggleActions: 'play none none reverse'
            },
            y: 50,
            opacity: 0,
            duration: 0.8
        });

        gsap.from('.banner-card', {
            scrollTrigger: {
                trigger: '.explore-grid',
                start: 'top bottom-=100',
                toggleActions: 'play none none reverse'
            },
            y: 50,
            opacity: 0,
            duration: 0.8,
            stagger: 0.2
        });

        gsap.from('.product-card', {
            scrollTrigger: {
                trigger: '.explore-grid',
                start: 'top bottom-=100',
                toggleActions: 'play none none reverse'
            },
            y: 50,
            opacity: 0,
            duration: 0.8,
            stagger: 0.2
        });

        gsap.from('.filter-chip', {
            scrollTrigger: {
                trigger: '.category-filter',
                start: 'top bottom-=50',
                toggleActions: 'play none none reverse'
            },
            y: 20,
            opacity: 0,
            duration: 0.5,
            stagger: 0.1
        });
    </script>

    <!-- Promo Banners Section -->
    <div class="container my-5">
        <div class="row">
            <!-- Left Vertical Promo -->
            <div class="col-md-3 mb-4">
                <div class="promo-vertical">
                    <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/Samsung/SamsungBAU/S24Series/Launch/D111827450_INWLD_Samsung_S24Series_Launch_PC_Hero_3000x1200._CB584595639_.jpg" alt="Samsung S24 Launch">
                    <div class="promo-content">
                        <h4>Samsung S24 Series</h4>
                        <p>Pre-order Now</p>
                    </div>
                </div>
            </div>

            <!-- Center Horizontal Promos -->
            <div class="col-md-6 mb-4 d-flex flex-column gap-4">
                <div class="promo-horizontal">
                    <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/Shreyansh/BAU/Unrexc/D70978891_INWLD_BAU_Unrec_Uber_PC_Hero_3000x1200._CB594707876_.jpg" alt="iPhone 15 Series">
                    <div class="promo-content">
                        <h4>iPhone 15 Series</h4>
                        <p>Dynamic Island for All</p>
                    </div>
                </div>
                <div class="promo-horizontal">
                    <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/CatPage/RevampNew/NewLaunches/D111827450_WLD_BAU_Category_page_PC_Hero_3000x1200._CB584595639_.jpg" alt="OnePlus 12">
                    <div class="promo-content">
                        <h4>OnePlus 12</h4>
                        <p>Flagship Killer Returns</p>
                    </div>
                </div>
            </div>

            <!-- Right Vertical Promo -->
            <div class="col-md-3 mb-4">
                <div class="promo-vertical">
                    <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/CatPage/SubNav/230x300/Wearables._CB572850637_.jpg" alt="Smart Wearables">
                    <div class="promo-content">
                        <h4>Smart Wearables</h4>
                        <p>Starting at $199</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Promo Banners Styles */
        .promo-vertical,
        .promo-horizontal {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .promo-vertical {
            height: 400px;
        }

        .promo-horizontal {
            height: 190px;
        }

        .promo-vertical:hover,
        .promo-horizontal:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .promo-vertical img,
        .promo-horizontal img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .promo-vertical:hover img,
        .promo-horizontal:hover img {
            transform: scale(1.05);
        }

        .promo-content {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 1.5rem;
            background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
            color: white;
            text-align: left;
        }

        .promo-content h4 {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .promo-content p {
            font-size: 0.9rem;
            margin: 0;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .promo-vertical {
                height: 300px;
            }

            .promo-horizontal {
                height: 150px;
            }

            .promo-content {
                padding: 1rem;
            }

            .promo-content h4 {
                font-size: 1rem;
            }

            .promo-content p {
                font-size: 0.8rem;
            }
        }
    </style>

    <!-- Footer Section -->
    <footer class="footer-section">
        <div class="container">
            <div class="row">
                <!-- Left Side - Features -->
                <div class="col-lg-4">
                    <div class="footer-features">
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="bi bi-piggy-bank"></i>
                            </div>
                            <div class="feature-content">
                                <h4>Great Saving</h4>
                                <p>Save big with our exclusive deals and discounts on premium devices</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="bi bi-truck"></i>
                            </div>
                            <div class="feature-content">
                                <h4>Free Delivery</h4>
                                <p>Enjoy free shipping on all orders above $999 across the country</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="bi bi-headset"></i>
                            </div>
                            <div class="feature-content">
                                <h4>24x7 Support</h4>
                                <p>Our dedicated team is here to help you anytime, anywhere</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="bi bi-arrow-repeat"></i>
                            </div>
                            <div class="feature-content">
                                <h4>Money Back</h4>
                                <p>100% money-back guarantee if you're not satisfied with our service</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Side - Main Footer Content -->
                <div class="col-lg-8">
                    <div class="footer-main">
                        <!-- Brand Section -->
                        <div class="footer-brand mb-5">
                            <h3><i class="bi bi-phone"></i> PN MobileStore</h3>
                            <p>Your one-stop destination for premium mobile devices and accessories. We bring you the latest technology with unmatched service quality.</p>
                        </div>

                        <!-- Footer Links -->
                        <div class="row">
                            <div class="col-md-4 mb-4 mb-md-0">
                                <h5>Your Account</h5>
                                <ul class="footer-links">
                                    <li><a href="#">About Us</a></li>
                                    <li><a href="#">Account</a></li>
                                    <li><a href="#">Payment</a></li>
                                    <li><a href="#">Sales</a></li>
                                </ul>
                            </div>
                            <div class="col-md-4 mb-4 mb-md-0">
                                <h5>Products</h5>
                                <ul class="footer-links">
                                    <li><a href="#">Delivery</a></li>
                                    <li><a href="#">Track Order</a></li>
                                    <li><a href="#">New Product</a></li>
                                    <li><a href="#">Old Product</a></li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <h5>Contact Us</h5>
                                <ul class="footer-contact">
                                    <li>
                                        <i class="bi bi-geo-alt"></i>
                                        <span>123 Tech Street, Digital City<br>Innovation State, 12345</span>
                                    </li>
                                    <li>
                                        <i class="bi bi-telephone"></i>
                                        <span>+1 (555) 123-4567</span>
                                    </li>
                                    <li>
                                        <i class="bi bi-envelope"></i>
                                        <span>support@pnmobilestore.com</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer Bottom -->
            <div class="footer-bottom">
                <div class="row align-items-center">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <p class="mb-0">&copy; 2024 PN MobileStore. All rights reserved.</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <div class="social-links">
                            <a href="#"><i class="bi bi-facebook"></i></a>
                            <a href="#"><i class="bi bi-twitter"></i></a>
                            <a href="#"><i class="bi bi-instagram"></i></a>
                            <a href="#"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <style>
        /* Footer Styles */
        .footer-section {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.03), rgba(99, 102, 241, 0.03));
            padding: 3rem 0 1.5rem;
            margin-top: 3rem;
            border-top: 2px solid var(--primary-color);
        }

        /* Feature Items */
        .footer-features {
            padding-right: 1.5rem;
            border-right: 1px solid rgba(37, 99, 235, 0.2);
            height: 100%;
        }

        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 1.25rem;
            padding: 1rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.7);
            border-radius: 15px;
        }

        .feature-item:hover {
            transform: translateX(5px);
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.1);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            min-width: 60px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin-right: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
        }

        .feature-item:hover .feature-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 6px 15px rgba(37, 99, 235, 0.25);
        }

        .feature-content {
            flex: 1;
        }

        .feature-content h4 {
            color: var(--primary-color);
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .feature-content p {
            color: var(--text-light);
            font-size: 0.9rem;
            line-height: 1.5;
            margin: 0;
            opacity: 0.9;
        }

        /* Footer Brand */
        .footer-brand {
            margin-bottom: 1.5rem;
        }

        .footer-brand h3 {
            color: var(--primary-color);
            margin-bottom: 0.75rem;
            font-size: 1.3rem;
        }

        .footer-brand p {
            color: var(--text-light);
            font-size: 0.9rem;
            line-height: 1.5;
        }

        /* Footer Links */
        .footer-links {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .footer-links li {
            margin-bottom: 0.5rem;
        }

        .footer-links a {
            color: var(--text-light);
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
            font-size: 0.9rem;
        }

        .footer-links a:hover {
            color: var(--primary-color);
            transform: translateX(5px);
        }

        /* Footer Contact */
        .footer-contact {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .footer-contact li {
            display: flex;
            align-items: center;
            margin-bottom: 0.75rem;
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .footer-contact i {
            color: var(--primary-color);
            margin-right: 0.75rem;
            font-size: 1rem;
        }

        /* Section Headings */
        .footer-main h5 {
            color: var(--primary-color);
            font-size: 1rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        /* Footer Bottom */
        .footer-bottom {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(37, 99, 235, 0.2);
        }

        .footer-bottom p {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .social-links a {
            color: var(--primary-color);
            font-size: 1.1rem;
            margin-left: 1rem;
            transition: all 0.3s ease;
            opacity: 0.8;
        }

        .social-links a:hover {
            opacity: 1;
            transform: translateY(-3px);
            display: inline-block;
        }

        @media (max-width: 992px) {
            .footer-features {
                border-right: none;
                border-bottom: 1px solid rgba(37, 99, 235, 0.2);
                padding-right: 0;
                padding-bottom: 1.5rem;
                margin-bottom: 1.5rem;
            }

            .feature-item:hover {
                transform: translateX(0);
            }
        }

        @media (max-width: 768px) {
            .footer-section {
                padding: 2rem 0 1rem;
            }

            .feature-item {
                padding: 0.5rem;
            }

            .social-links a {
                margin-left: 0.75rem;
            }
        }
    </style>

   

    <!-- Initialize Owl Carousel -->
    <script>
        $(document).ready(function(){
            $('.quick-picks-carousel').owlCarousel({
                loop: true,
                margin: 20,
                nav: true,
                dots: true,
                autoplay: true,
                autoplayTimeout: 5000,
                autoplayHoverPause: true,
                navText: [
                    "<i class='bi bi-chevron-left'></i>",
                    "<i class='bi bi-chevron-right'></i>"
                ],
                responsive: {
                    0: {
                        items: 1
                    },
                    576: {
                        items: 2
                    },
                    768: {
                        items: 3
                    },
                    992: {
                        items: 4
                    }
                }
            });
        });
    </script>

    <!-- Add this before the closing body tag -->
    <script>
        // Create toast element for voice search status
        const voiceToast = document.createElement('div');
        voiceToast.className = 'voice-toast';
        document.body.appendChild(voiceToast);

        // Voice Search Implementation
document.addEventListener('DOMContentLoaded', function() {
    const voiceSearchBtn = document.getElementById('voiceSearchBtn');
    const searchInput = document.getElementById('searchInput');
    const voiceToast = document.getElementById('voiceToast');
    const voiceToastText = document.getElementById('voiceToastText');
    
    // Check if browser supports speech recognition
    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
        const SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
        const recognition = new SpeechRecognition();
        
        recognition.continuous = true; // Keep listening even after interim results
        recognition.interimResults = true; // Show interim results
        recognition.lang = 'en-US';

        voiceSearchBtn.addEventListener('click', function() {
            if (voiceSearchBtn.classList.contains('listening')) {
                recognition.stop();
                voiceToastText.textContent = 'Stopped listening';
                setTimeout(() => voiceToast.classList.remove('show'), 1000);
            } else {
                searchInput.value = ''; // Clear previous input
                recognition.start();
                voiceSearchBtn.classList.add('listening');
                voiceToast.classList.add('show');
                voiceToastText.textContent = 'Listening...';
                console.log('Started listening...');
            }
        });

        recognition.onstart = function() {
            console.log('Voice recognition started');
            voiceToastText.textContent = 'Listening...';
        };

        recognition.onresult = function(event) {
            console.log('Got speech result:', event.results);
            let interimTranscript = '';
            let finalTranscript = '';

            for (let i = event.resultIndex; i < event.results.length; i++) {
                const transcript = event.results[i][0].transcript;
                if (event.results[i].isFinal) {
                    finalTranscript += transcript;
                    console.log('Final transcript:', finalTranscript);
                } else {
                    interimTranscript += transcript;
                    console.log('Interim transcript:', interimTranscript);
                }
            }

            // Update the search input with either final or interim results
            searchInput.value = finalTranscript || interimTranscript;
            
            if (finalTranscript) {
                voiceToastText.textContent = 'Got it! Searching...';
                recognition.stop();
                setTimeout(() => {
                    searchInput.form.submit();
                }, 1000);
            } else {
                voiceToastText.textContent = 'Listening: ' + interimTranscript;
            }
        };

        recognition.onerror = function(event) {
            console.error('Speech recognition error:', event.error);
            voiceSearchBtn.classList.remove('listening');
            voiceToast.classList.add('show');
            
            let errorMessage = 'Error: ';
            switch(event.error) {
                case 'no-speech':
                    errorMessage += 'No speech detected';
                    break;
                case 'aborted':
                    errorMessage += 'Recognition aborted';
                    break;
                case 'audio-capture':
                    errorMessage += 'No microphone detected';
                    break;
                case 'network':
                    errorMessage += 'Network error occurred';
                    break;
                case 'not-allowed':
                    errorMessage += 'Microphone access denied';
                    break;
                default:
                    errorMessage += event.error;
            }
            
            voiceToastText.textContent = errorMessage;
            console.error(errorMessage);
            
            setTimeout(() => {
                voiceToast.classList.remove('show');
            }, 3000);
        };

        recognition.onend = function() {
            console.log('Voice recognition ended');
            voiceSearchBtn.classList.remove('listening');
            if (!searchInput.value) {
                voiceToastText.textContent = 'No speech detected. Try again?';
                setTimeout(() => {
                    voiceToast.classList.remove('show');
                }, 2000);
            }
        };
    } else {
        voiceSearchBtn.style.display = 'none';
        console.log('Speech recognition not supported');
    }
        });
    </script>

    <style>
        /* Small Products Grid Styles */
        .small-products-section {
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.98));
            padding: 2rem 0;
        }

        .small-products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1.5rem;
            padding: 1rem 0;
        }

        .small-product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            cursor: pointer;
            height: 250px;
            display: flex;
            flex-direction: column;
        }

        .small-product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .small-product-card .product-image {
            height: 60%;
            padding: 1rem;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.03), rgba(99, 102, 241, 0.03));
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .small-product-card .product-image img {
            max-width: 80%;
            max-height: 80%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .small-product-card:hover .product-image img {
            transform: scale(1.1);
        }

        .small-product-card .product-details {
            padding: 1rem;
            text-align: center;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .small-product-card .product-category {
            font-size: 0.8rem;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.25rem;
        }

        .small-product-card h4 {
            font-size: 1rem;
            color: #1a1a1a;
            margin: 0.5rem 0;
        }

        .small-product-card .product-price {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .small-products-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 1rem;
            }

            .small-product-card {
                height: 220px;
            }
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 800,
            once: true
        });

        // Function to show toast message
        function showToast(message, type) {
            const toast = document.querySelector('.toast');
            const toastBody = toast.querySelector('.toast-body');
            
            // Set message and type
            toastBody.textContent = message;
            toast.className = 'toast align-items-center text-white border-0 ' + type;
            
            // Show toast
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
        }

        // Check for messages from servlets
        <% if (request.getAttribute("message") != null) { %>
            showToast('<%= request.getAttribute("message") %>', 'bg-success');
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            showToast('<%= request.getAttribute("error") %>', 'bg-danger');
        <% } %>

        // Counter Animation with Intersection Observer
        const counterObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const counter = entry.target;
                    const target = parseInt(counter.getAttribute('data-target'));
                    const duration = 2000;
                    const step = target / (duration / 16);
                    let current = 0;

                    const updateCounter = () => {
                        current += step;
                        if (current < target) {
                            counter.textContent = Math.round(current);
                            requestAnimationFrame(updateCounter);
                        } else {
                            counter.textContent = target;
                        }
                    };

                    updateCounter();
                    counterObserver.unobserve(counter);
                }
            });
        }, {
            threshold: 0.5
        });

        // Observe all counters
        document.querySelectorAll('.counter').forEach(counter => {
            counterObserver.observe(counter);
        });

        // GSAP ScrollTrigger Animations
        gsap.registerPlugin(ScrollTrigger);

        const whyUsCards = document.querySelectorAll('.why-us-card');
        whyUsCards.forEach((card, index) => {
            gsap.from(card, {
                scrollTrigger: {
                    trigger: card,
                    start: "top bottom-=100",
                    toggleActions: "play none none reverse"
                },
                y: 50,
                opacity: 0,
                duration: 0.8,
                delay: index * 0.1
            });
        });

        // GSAP Animations for Explore Products Section
        gsap.from('.explore-header', {
            scrollTrigger: {
                trigger: '.explore-header',
                start: 'top bottom-=100',
                toggleActions: 'play none none reverse'
            },
            y: 50,
            opacity: 0,
            duration: 0.8
        });

        gsap.from('.banner-card', {
            scrollTrigger: {
                trigger: '.explore-grid',
                start: 'top bottom-=100',
                toggleActions: 'play none none reverse'
            },
            y: 50,
            opacity: 0,
            duration: 0.8,
            stagger: 0.2
        });

        gsap.from('.product-card', {
            scrollTrigger: {
                trigger: '.explore-grid',
                start: 'top bottom-=100',
                toggleActions: 'play none none reverse'
            },
            y: 50,
            opacity: 0,
            duration: 0.8,
            stagger: 0.2
        });

        gsap.from('.filter-chip', {
            scrollTrigger: {
                trigger: '.category-filter',
                start: 'top bottom-=50',
                toggleActions: 'play none none reverse'
            },
            y: 20,
            opacity: 0,
            duration: 0.5,
            stagger: 0.1
        });
    </script>

    <!-- Promo Banners Section -->
    <div class="container my-5">
        <div class="row">
            <!-- Left Vertical Promo -->
            <div class="col-md-3 mb-4">
                <div class="promo-vertical">
                    <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/Samsung/SamsungBAU/S24Series/Launch/D111827450_INWLD_Samsung_S24Series_Launch_PC_Hero_3000x1200._CB584595639_.jpg" alt="Samsung S24 Launch">
                    <div class="promo-content">
                        <h4>Samsung S24 Series</h4>
                        <p>Pre-order Now</p>
                    </div>
                </div>
            </div>

            <!-- Center Horizontal Promos -->
            <div class="col-md-6 mb-4 d-flex flex-column gap-4">
                <div class="promo-horizontal">
                    <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/Shreyansh/BAU/Unrexc/D70978891_INWLD_BAU_Unrec_Uber_PC_Hero_3000x1200._CB594707876_.jpg" alt="iPhone 15 Series">
                    <div class="promo-content">
                        <h4>iPhone 15 Series</h4>
                        <p>Dynamic Island for All</p>
                    </div>
                </div>
                <div class="promo-horizontal">
                    <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/CatPage/RevampNew/NewLaunches/D111827450_WLD_BAU_Category_page_PC_Hero_3000x1200._CB584595639_.jpg" alt="OnePlus 12">
                    <div class="promo-content">
                        <h4>OnePlus 12</h4>
                        <p>Flagship Killer Returns</p>
                    </div>
                </div>
            </div>

            <!-- Right Vertical Promo -->
            <div class="col-md-3 mb-4">
                <div class="promo-vertical">
                    <img src="https://images-eu.ssl-images-amazon.com/images/G/31/img23/Wireless/CatPage/SubNav/230x300/Wearables._CB572850637_.jpg" alt="Smart Wearables">
                    <div class="promo-content">
                        <h4>Smart Wearables</h4>
                        <p>Starting at $199</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Promo Banners Styles */
        .promo-vertical,
        .promo-horizontal {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .promo-vertical {
            height: 400px;
        }

        .promo-horizontal {
            height: 190px;
        }

        .promo-vertical:hover,
        .promo-horizontal:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .promo-vertical img,
        .promo-horizontal img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .promo-vertical:hover img,
        .promo-horizontal:hover img {
            transform: scale(1.05);
        }

        .promo-content {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 1.5rem;
            background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
            color: white;
            text-align: left;
        }

        .promo-content h4 {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .promo-content p {
            font-size: 0.9rem;
            margin: 0;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .promo-vertical {
                height: 300px;
            }

            .promo-horizontal {
                height: 150px;
            }

            .promo-content {
                padding: 1rem;
            }

            .promo-content h4 {
                font-size: 1rem;
            }

            .promo-content p {
                font-size: 0.8rem;
            }
        }
    </style>

    <!-- Footer Section -->
    <footer class="footer-section">
        <div class="container">
            <div class="row">
                <!-- Left Side - Features -->
                <div class="col-lg-4">
                    <div class="footer-features">
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="bi bi-piggy-bank"></i>
                            </div>
                            <div class="feature-content">
                                <h4>Great Saving</h4>
                                <p>Save big with our exclusive deals and discounts on premium devices</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="bi bi-truck"></i>
                            </div>
                            <div class="feature-content">
                                <h4>Free Delivery</h4>
                                <p>Enjoy free shipping on all orders above $999 across the country</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="bi bi-headset"></i>
                            </div>
                            <div class="feature-content">
                                <h4>24x7 Support</h4>
                                <p>Our dedicated team is here to help you anytime, anywhere</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="bi bi-arrow-repeat"></i>
                            </div>
                            <div class="feature-content">
                                <h4>Money Back</h4>
                                <p>100% money-back guarantee if you're not satisfied with our service</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Side - Main Footer Content -->
                <div class="col-lg-8">
                    <div class="footer-main">
                        <!-- Brand Section -->
                        <div class="footer-brand mb-5">
                            <h3><i class="bi bi-phone"></i> PN MobileStore</h3>
                            <p>Your one-stop destination for premium mobile devices and accessories. We bring you the latest technology with unmatched service quality.</p>
                        </div>

                        <!-- Footer Links -->
                        <div class="row">
                            <div class="col-md-4 mb-4 mb-md-0">
                                <h5>Your Account</h5>
                                <ul class="footer-links">
                                    <li><a href="#">About Us</a></li>
                                    <li><a href="#">Account</a></li>
                                    <li><a href="#">Payment</a></li>
                                    <li><a href="#">Sales</a></li>
                                </ul>
                            </div>
                            <div class="col-md-4 mb-4 mb-md-0">
                                <h5>Products</h5>
                                <ul class="footer-links">
                                    <li><a href="#">Delivery</a></li>
                                    <li><a href="#">Track Order</a></li>
                                    <li><a href="#">New Product</a></li>
                                    <li><a href="#">Old Product</a></li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <h5>Contact Us</h5>
                                <ul class="footer-contact">
                                    <li>
                                        <i class="bi bi-geo-alt"></i>
                                        <span>123 Tech Street, Digital City<br>Innovation State, 12345</span>
                                    </li>
                                    <li>
                                        <i class="bi bi-telephone"></i>
                                        <span>+1 (555) 123-4567</span>
                                    </li>
                                    <li>
                                        <i class="bi bi-envelope"></i>
                                        <span>support@pnmobilestore.com</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer Bottom -->
            <div class="footer-bottom">
                <div class="row align-items-center">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <p class="mb-0">&copy; 2024 PN MobileStore. All rights reserved.</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <div class="social-links">
                            <a href="#"><i class="bi bi-facebook"></i></a>
                            <a href="#"><i class="bi bi-twitter"></i></a>
                            <a href="#"><i class="bi bi-instagram"></i></a>
                            <a href="#"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <style>
        /* Footer Styles */
        .footer-section {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.03), rgba(99, 102, 241, 0.03));
            padding: 3rem 0 1.5rem;
            margin-top: 3rem;
            border-top: 2px solid var(--primary-color);
        }

        /* Feature Items */
        .footer-features {
            padding-right: 1.5rem;
            border-right: 1px solid rgba(37, 99, 235, 0.2);
            height: 100%;
        }

        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 1.25rem;
            padding: 1rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.7);
            border-radius: 15px;
        }

        .feature-item:hover {
            transform: translateX(5px);
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.1);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            min-width: 60px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin-right: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
        }

        .feature-item:hover .feature-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 6px 15px rgba(37, 99, 235, 0.25);
        }

        .feature-content {
            flex: 1;
        }

        .feature-content h4 {
            color: var(--primary-color);
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .feature-content p {
            color: var(--text-light);
            font-size: 0.9rem;
            line-height: 1.5;
            margin: 0;
            opacity: 0.9;
        }

        /* Footer Brand */
        .footer-brand {
            margin-bottom: 1.5rem;
        }

        .footer-brand h3 {
            color: var(--primary-color);
            margin-bottom: 0.75rem;
            font-size: 1.3rem;
        }

        .footer-brand p {
            color: var(--text-light);
            font-size: 0.9rem;
            line-height: 1.5;
        }

        /* Footer Links */
        .footer-links {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .footer-links li {
            margin-bottom: 0.5rem;
        }

        .footer-links a {
            color: var(--text-light);
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
            font-size: 0.9rem;
        }

        .footer-links a:hover {
            color: var(--primary-color);
            transform: translateX(5px);
        }

        /* Footer Contact */
        .footer-contact {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .footer-contact li {
            display: flex;
            align-items: center;
            margin-bottom: 0.75rem;
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .footer-contact i {
            color: var(--primary-color);
            margin-right: 0.75rem;
            font-size: 1rem;
        }

        /* Section Headings */
        .footer-main h5 {
            color: var(--primary-color);
            font-size: 1rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        /* Footer Bottom */
        .footer-bottom {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(37, 99, 235, 0.2);
        }

        .footer-bottom p {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .social-links a {
            color: var(--primary-color);
            font-size: 1.1rem;
            margin-left: 1rem;
            transition: all 0.3s ease;
            opacity: 0.8;
        }

        .social-links a:hover {
            opacity: 1;
            transform: translateY(-3px);
            display: inline-block;
        }

        @media (max-width: 992px) {
            .footer-features {
                border-right: none;
                border-bottom: 1px solid rgba(37, 99, 235, 0.2);
                padding-right: 0;
                padding-bottom: 1.5rem;
                margin-bottom: 1.5rem;
            }

            .feature-item:hover {
                transform: translateX(0);
            }
        }

        @media (max-width: 768px) {
            .footer-section {
                padding: 2rem 0 1rem;
            }

            .feature-item {
                padding: 0.5rem;
            }

            .social-links a {
                margin-left: 0.75rem;
            }
        }
    </style>

   

    <!-- Initialize Owl Carousel -->
    <script>
        $(document).ready(function(){
            $('.quick-picks-carousel').owlCarousel({
                loop: true,
                margin: 20,
                nav: true,
                dots: true,
                autoplay: true,
                autoplayTimeout: 5000,
                autoplayHoverPause: true,
                navText: [
                    "<i class='bi bi-chevron-left'></i>",
                    "<i class='bi bi-chevron-right'></i>"
                ],
                responsive: {
                    0: {
                        items: 1
                    },
                    576: {
                        items: 2
                    },
                    768: {
                        items: 3
                    },
                    992: {
                        items: 4
                    }
                }
            });
        });
    </script>

    <!-- Add this before the closing body tag -->
    <script>
        // Create toast element for voice search status
        const voiceToast = document.createElement('div');
        voiceToast.className = 'voice-toast';
        document.body.appendChild(voiceToast);

        // Voice Search Implementation
document.addEventListener('DOMContentLoaded', function() {
    const voiceSearchBtn = document.getElementById('voiceSearchBtn');
    const searchInput = document.getElementById('searchInput');
    const voiceToast = document.getElementById('voiceToast');
    const voiceToastText = document.getElementById('voiceToastText');
    
    // Check if browser supports speech recognition
    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
        const SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
        const recognition = new SpeechRecognition();
        
        recognition.continuous = true; // Keep listening even after interim results
        recognition.interimResults = true; // Show interim results
        recognition.lang = 'en-US';

        voiceSearchBtn.addEventListener('click', function() {
            if (voiceSearchBtn.classList.contains('listening')) {
                recognition.stop();
                voiceToastText.textContent = 'Stopped listening';
                setTimeout(() => voiceToast.classList.remove('show'), 1000);
            } else {
                searchInput.value = ''; // Clear previous input
                recognition.start();
                voiceSearchBtn.classList.add('listening');
                voiceToast.classList.add('show');
                voiceToastText.textContent = 'Listening...';
                console.log('Started listening...');
            }
        });

        recognition.onstart = function() {
            console.log('Voice recognition started');
            voiceToastText.textContent = 'Listening...';
        };

        recognition.onresult = function(event) {
            console.log('Got speech result:', event.results);
            let interimTranscript = '';
            let finalTranscript = '';

            for (let i = event.resultIndex; i < event.results.length; i++) {
                const transcript = event.results[i][0].transcript;
                if (event.results[i].isFinal) {
                    finalTranscript += transcript;
                    console.log('Final transcript:', finalTranscript);
                } else {
                    interimTranscript += transcript;
                    console.log('Interim transcript:', interimTranscript);
                }
            }

            // Update the search input with either final or interim results
            searchInput.value = finalTranscript || interimTranscript;
            
            if (finalTranscript) {
                voiceToastText.textContent = 'Got it! Searching...';
                recognition.stop();
                setTimeout(() => {
                    searchInput.form.submit();
                }, 1000);
            } else {
                voiceToastText.textContent = 'Listening: ' + interimTranscript;
            }
        };

        recognition.onerror = function(event) {
            console.error('Speech recognition error:', event.error);
            voiceSearchBtn.classList.remove('listening');
            voiceToast.classList.add('show');
            
            let errorMessage = 'Error: ';
            switch(event.error) {
                case 'no-speech':
                    errorMessage += 'No speech detected';
                    break;
                case 'aborted':
                    errorMessage += 'Recognition aborted';
                    break;
                case 'audio-capture':
                    errorMessage += 'No microphone detected';
                    break;
                case 'network':
                    errorMessage += 'Network error occurred';
                    break;
                case 'not-allowed':
                    errorMessage += 'Microphone access denied';
                    break;
                default:
                    errorMessage += event.error;
            }
            
            voiceToastText.textContent = errorMessage;
            console.error(errorMessage);
            
            setTimeout(() => {
                voiceToast.classList.remove('show');
            }, 3000);
        };

        recognition.onend = function() {
            console.log('Voice recognition ended');
            voiceSearchBtn.classList.remove('listening');
            if (!searchInput.value) {
                voiceToastText.textContent = 'No speech detected. Try again?';
                setTimeout(() => {
                    voiceToast.classList.remove('show');
                }, 2000);
            }
        };
    } else {
        voiceSearchBtn.style.display = 'none';
        console.log('Speech recognition not supported');
    }
        });
    </script>

    <style>
        .notification-dropdown {
            padding: 0;
        }
        .notification-item {
            padding: 10px 15px;
            border-bottom: 1px solid #eee;
            white-space: normal;
        }
        .notification-item:hover {
            background-color: #f8f9fa;
        }
        .notification-item.unread {
            background-color: #e8f4fd;
        }
        .notification-item.unread:hover {
            background-color: #d8eaf9;
        }
        .notification-item p {
            margin: 0;
            font-size: 0.875rem;
        }
        .notification-item small {
            font-size: 0.75rem;
        }
    </style>

    <script>
         // Function to format date
     function formatDate(date) {
         const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
         const d = new Date(date);
         return months[d.getMonth()] + ' ' + d.getDate() + ', ' + d.getFullYear();
     }

     // Function to load notifications
     function loadNotifications() {
         var xhr = new XMLHttpRequest();
         xhr.open('GET', 'notifications?action=list', true);
         xhr.onreadystatechange = function() {
             if (xhr.readyState === 4 && xhr.status === 200) {
                 var notificationsList = document.getElementById('notificationsList');
                 var lines = xhr.responseText.trim().split('\n');
                 var unreadCount = parseInt(lines[0]);
                 var notifications = [];
                 
                 // Parse notifications from remaining lines
                 for (var i = 1; i < lines.length; i++) {
                     var parts = lines[i].split('|');
                     if (parts.length === 4) {
                         notifications.push({
                             id: parseInt(parts[0]),
                             message: parts[1],
                             read: parts[2] === 'true',
                             createdAt: parts[3]
                         });
                     }
                 }
                 
                 // Clear existing notifications
                 notificationsList.innerHTML = '';
                 
                 if (notifications.length > 0) {
                     // Show only the latest 5 notifications
                     notifications.slice(0, 5).forEach(function(notification) {
                         var itemDiv = document.createElement('div');
                         itemDiv.className = 'dropdown-item notification-item' + (notification.read ? '' : ' unread');
                         itemDiv.setAttribute('data-notification-id', notification.id);
                         
                         var html = '<div class="d-flex w-100 justify-content-between">' +
                                  '<small class="text-muted">' + notification.createdAt + '</small>' +
                                  '</div>' +
                                  '<p class="mb-1">' + notification.message + '</p>';
                         
                         itemDiv.innerHTML = html;
                         
                         if (!notification.read) {
                             itemDiv.onclick = function() {
                                 markAsRead(notification.id);
                             };
                         }
                         
                         notificationsList.appendChild(itemDiv);
                     });
                 } else {
                     notificationsList.innerHTML = '<div class="dropdown-item text-muted text-center">No notifications</div>';
                 }
                 
                 // Update badge count
                 var badge = document.getElementById('notificationBadge');
                 if (unreadCount > 0) {
                     if (!badge) {
                         badge = document.createElement('span');
                         badge.id = 'notificationBadge';
                         badge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger';
                         document.getElementById('notificationsDropdown').appendChild(badge);
                     }
                     badge.textContent = unreadCount;
                 } else if (badge) {
                     badge.remove();
                 }
             }
         };
         xhr.send();
     }

     // Function to mark notification as read
     function markAsRead(notificationId) {
         var xhr = new XMLHttpRequest();
         xhr.open('POST', 'notifications', true);
         xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
         xhr.onreadystatechange = function() {
             if (xhr.readyState === 4 && xhr.status === 200) {
                 loadNotifications(); // Refresh notifications after marking as read
             }
         };
         xhr.send('action=markAsRead&id=' + notificationId);
     }

     // Load notifications when page loads
     document.addEventListener('DOMContentLoaded', loadNotifications);

     // Check for new notifications every 30 seconds
     setInterval(loadNotifications, 30000);
    </script>

    <!-- Notification Scripts -->
    <script>
    // Function to load notifications
    function loadNotifications() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'notifications?action=list', true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var notificationsList = document.getElementById('notificationsList');
                var lines = xhr.responseText.trim().split('\n');
                var unreadCount = parseInt(lines[0]);
                var notifications = [];
                
                // Parse notifications from remaining lines
                for (var i = 1; i < lines.length; i++) {
                    var parts = lines[i].split('|');
                    if (parts.length === 4) {
                        notifications.push({
                            id: parseInt(parts[0]),
                            message: parts[1],
                            read: parts[2] === 'true',
                            createdAt: parts[3]
                        });
                    }
                }
                
                // Clear existing notifications
                notificationsList.innerHTML = '';
                
                if (notifications.length > 0) {
                    // Show only the latest 5 notifications
                    notifications.slice(0, 5).forEach(function(notification) {
                        var itemDiv = document.createElement('div');
                        itemDiv.className = 'dropdown-item notification-item' + (notification.read ? '' : ' unread');
                        itemDiv.setAttribute('data-notification-id', notification.id);
                        
                        var html = '<div class="d-flex w-100 justify-content-between">' +
                            '<small class="text-muted">' + notification.createdAt + '</small>' +
                            '</div>' +
                            '<p class="mb-1">' + notification.message + '</p>';
                        
                        itemDiv.innerHTML = html;
                        
                        if (!notification.read) {
                            itemDiv.onclick = function() {
                                markAsRead(notification.id);
                            };
                        }
                        
                        notificationsList.appendChild(itemDiv);
                    });
                } else {
                    notificationsList.innerHTML = '<div class="dropdown-item text-muted text-center">No notifications</div>';
                }
                
                // Update badge count
                var badge = document.getElementById('notificationBadge');
                if (unreadCount > 0) {
                    if (!badge) {
                        badge = document.createElement('span');
                        badge.id = 'notificationBadge';
                        badge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger';
                        document.getElementById('notificationsDropdown').appendChild(badge);
                    }
                    badge.textContent = unreadCount;
                } else if (badge) {
                    badge.remove();
                }
            }
        };
        xhr.send();
    }

    // Function to mark notification as read
    function markAsRead(notificationId) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'notifications', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                loadNotifications(); // Refresh notifications after marking as read
            }
        };
        xhr.send('action=markAsRead&id=' + notificationId);
    }

    // Load notifications when page loads
    document.addEventListener('DOMContentLoaded', loadNotifications);

    // Check for new notifications every 30 seconds
    setInterval(loadNotifications, 30000);
    </script>

    <!-- Notification Styles -->
    <style>
    .notification-dropdown {
        padding: 0;
        border: none;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    }

    .notification-item {
        padding: 1rem;
        border-bottom: 1px solid #eee;
        white-space: normal;
        transition: background-color 0.3s;
        cursor: pointer;
    }

    .notification-item:hover {
        background-color: #f8f9fa;
    }

    .notification-item.unread {
        background-color: #e8f4fd;
    }

    .notification-item.unread:hover {
        background-color: #d8eaf9;
    }

    .notification-item p {
        margin: 0;
        color: #333;
    }

    .notification-item small {
        color: #6c757d;
    }
    </style>
    </body>
</html> 