<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.dao.CartDAO" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>
<%@ page import="com.mobilestore.model.Cart" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    CartDAO cartDAO = new CartDAO();
    ProductDAO productDAO = new ProductDAO();
    List<Cart> cartItems = cartDAO.getCartItemsByUserId(user.getId());
    
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    double totalAmount = 0;
    for (Cart item : cartItems) {
        Product product = productDAO.getProductById(item.getProductId());
        if (product != null) {
            totalAmount += item.getQuantity() * product.getPrice();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Mobile Store</title>
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

        /* Border Mobiles */
        .border-mobile {
            position: absolute;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            opacity: 0.12;
            filter: blur(0.3px);
            z-index: -1;
        }

        .border-mobile-1 {
            width: 120px;
            height: 240px;
            top: 0;
            left: 0;
            transform: translate(-50%, -50%) rotate(-15deg);
            animation: borderFloat1 20s ease-in-out infinite;
        }

        .border-mobile-2 {
            width: 100px;
            height: 200px;
            top: 0;
            right: 0;
            transform: translate(50%, -50%) rotate(15deg);
            animation: borderFloat2 18s ease-in-out infinite;
        }

        .border-mobile-3 {
            width: 90px;
            height: 180px;
            bottom: 0;
            left: 0;
            transform: translate(-50%, 50%) rotate(15deg);
            animation: borderFloat3 22s ease-in-out infinite;
        }

        .border-mobile-4 {
            width: 110px;
            height: 220px;
            bottom: 0;
            right: 0;
            transform: translate(50%, 50%) rotate(-15deg);
            animation: borderFloat4 19s ease-in-out infinite;
        }

        /* Corner Mobiles */
        .corner-mobile {
            position: absolute;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            opacity: 0.1;
            filter: blur(0.4px);
            z-index: -1;
        }

        .corner-mobile-1 {
            width: 80px;
            height: 160px;
            top: 20%;
            left: 0;
            transform: translateX(-50%) rotate(-10deg);
            animation: cornerFloat1 15s ease-in-out infinite;
        }

        .corner-mobile-2 {
            width: 70px;
            height: 140px;
            top: 20%;
            right: 0;
            transform: translateX(50%) rotate(10deg);
            animation: cornerFloat2 17s ease-in-out infinite;
        }

        .corner-mobile-3 {
            width: 85px;
            height: 170px;
            bottom: 20%;
            left: 0;
            transform: translateX(-50%) rotate(10deg);
            animation: cornerFloat3 16s ease-in-out infinite;
        }

        .corner-mobile-4 {
            width: 75px;
            height: 150px;
            bottom: 20%;
            right: 0;
            transform: translateX(50%) rotate(-10deg);
            animation: cornerFloat4 18s ease-in-out infinite;
        }

        .mobile-1 {
            width: 250px;
            height: 500px;
            top: 5%;
            left: 5%;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>');
            animation: float1 15s ease-in-out infinite;
        }

        .mobile-2 {
            width: 200px;
            height: 400px;
            top: 20%;
            right: 8%;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>');
            animation: float2 12s ease-in-out infinite;
        }

        .mobile-3 {
            width: 180px;
            height: 360px;
            bottom: 15%;
            left: 12%;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>');
            animation: float3 18s ease-in-out infinite;
        }

        .mobile-4 {
            width: 220px;
            height: 440px;
            bottom: 8%;
            right: 10%;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>');
            animation: float4 14s ease-in-out infinite;
        }

        .mobile-5 {
            width: 150px;
            height: 300px;
            top: 40%;
            left: 20%;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>');
            animation: float5 16s ease-in-out infinite;
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

        @keyframes float5 {
            0%, 100% { transform: translate(0, 0) rotate(0deg) scale(1); }
            25% { transform: translate(15px, -15px) rotate(3deg) scale(1.05); }
            50% { transform: translate(0, -30px) rotate(0deg) scale(1); }
            75% { transform: translate(-15px, -15px) rotate(-3deg) scale(0.95); }
        }

        @keyframes borderFloat1 {
            0%, 100% { transform: translate(-50%, -50%) rotate(-15deg); }
            50% { transform: translate(-30%, -70%) rotate(-25deg); }
        }

        @keyframes borderFloat2 {
            0%, 100% { transform: translate(50%, -50%) rotate(15deg); }
            50% { transform: translate(30%, -70%) rotate(25deg); }
        }

        @keyframes borderFloat3 {
            0%, 100% { transform: translate(-50%, 50%) rotate(15deg); }
            50% { transform: translate(-30%, 70%) rotate(25deg); }
        }

        @keyframes borderFloat4 {
            0%, 100% { transform: translate(50%, 50%) rotate(-15deg); }
            50% { transform: translate(30%, 70%) rotate(-25deg); }
        }

        @keyframes cornerFloat1 {
            0%, 100% { transform: translateX(-50%) rotate(-10deg); }
            50% { transform: translateX(-30%) rotate(-20deg); }
        }

        @keyframes cornerFloat2 {
            0%, 100% { transform: translateX(50%) rotate(10deg); }
            50% { transform: translateX(30%) rotate(20deg); }
        }

        @keyframes cornerFloat3 {
            0%, 100% { transform: translateX(-50%) rotate(10deg); }
            50% { transform: translateX(-30%) rotate(20deg); }
        }

        @keyframes cornerFloat4 {
            0%, 100% { transform: translateX(50%) rotate(-10deg); }
            50% { transform: translateX(30%) rotate(-20deg); }
        }

        .checkout-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }

        .page-header {
            background: #ffffff;
            padding: 30px;
            border-radius: 20px;
            box-shadow: var(--shadow-light);
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-size: 2.2rem;
            color: var(--primary-color);
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            transition: all 0.3s ease;
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

        .form-control, .form-select {
            border: 2px solid var(--border-light);
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(79, 70, 229, 0.25);
        }

        .form-control[readonly] {
            background-color: rgba(79, 70, 229, 0.05);
        }

        .cart-item {
            padding: 1rem;
            border-bottom: 1px solid var(--border-light);
            transition: all 0.3s ease;
        }

        .cart-item:hover {
            background-color: rgba(79, 70, 229, 0.05);
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

        .alert {
            border-radius: 0.5rem;
            border: none;
            background: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
        }

        .alert a {
            color: var(--secondary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .alert a:hover {
            text-decoration: underline;
        }

        #upiSection {
            background-color: rgba(79, 70, 229, 0.05);
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-top: 1rem;
        }

        #qrcode-container {
            background: white;
            padding: 1rem;
            border-radius: 0.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: inline-block;
        }

        .is-valid {
            border-color: #198754 !important;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='M2.3 6.73L.6 4.53c-.4-1.04.46-1.4 1.1-.8l1.1 1.4 3.4-3.8c.6-.63 1.6-.27 1.2.7l-4 4.6c-.43.5-.8.4-1.1.1z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(0.375em + 0.1875rem) center;
            background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
        }

        .is-invalid {
            border-color: #dc3545 !important;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(0.375em + 0.1875rem) center;
            background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
        }

        @media (max-width: 768px) {
            .checkout-container {
                padding: 1rem;
            }
            
            .page-header {
                padding: 20px;
            }
            
            .page-title {
                font-size: 1.8rem;
            }
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
        .accessory-earphones {
            width: 80px; height: 80px;
            top: 10%; left: 45%;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><path d="M12 24C12 17.3726 17.3726 12 24 12C30.6274 12 36 17.3726 36 24" stroke="%234f46e5" stroke-width="3" stroke-linecap="round"/><rect x="8" y="24" width="8" height="12" rx="4" fill="%234f46e5"/><rect x="32" y="24" width="8" height="12" rx="4" fill="%234f46e5"/></svg>');
            animation: accessoryFloat1 14s ease-in-out infinite;
        }
        .accessory-charger {
            width: 70px; height: 70px;
            bottom: 12%; right: 40%;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><rect x="16" y="18" width="16" height="16" rx="4" fill="%234f46e5"/><rect x="20" y="10" width="2" height="8" rx="1" fill="%234f46e5"/><rect x="26" y="10" width="2" height="8" rx="1" fill="%234f46e5"/></svg>');
            animation: accessoryFloat2 16s ease-in-out infinite;
        }
        .accessory-watch {
            width: 60px; height: 60px;
            top: 50%; left: 0;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><circle cx="24" cy="24" r="10" stroke="%234f46e5" stroke-width="3"/><rect x="20" y="6" width="8" height="6" rx="2" fill="%234f46e5"/><rect x="20" y="36" width="8" height="6" rx="2" fill="%234f46e5"/></svg>');
            animation: accessoryFloat3 18s ease-in-out infinite;
        }
        .accessory-case {
            width: 65px; height: 65px;
            bottom: 50%; right: 0;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><rect x="14" y="10" width="20" height="28" rx="6" stroke="%234f46e5" stroke-width="3"/><rect x="20" y="36" width="8" height="2" rx="1" fill="%234f46e5"/></svg>');
            animation: accessoryFloat4 15s ease-in-out infinite;
        }
        @keyframes accessoryFloat1 { 0%,100%{transform:translateY(0);} 50%{transform:translateY(-20px);} }
        @keyframes accessoryFloat2 { 0%,100%{transform:translateY(0);} 50%{transform:translateY(20px);} }
        @keyframes accessoryFloat3 { 0%,100%{transform:translateX(0);} 50%{transform:translateX(20px);} }
        @keyframes accessoryFloat4 { 0%,100%{transform:translateX(0);} 50%{transform:translateX(-20px);} }

        /* More mobiles at borders */
        .mobile-right-1 { right: 0; top: 10%; width: 90px; height: 180px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 13s ease-in-out infinite; }
        .mobile-right-2 { right: 0; top: 40%; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 11s ease-in-out infinite; }
        .mobile-left-1 { left: 0; top: 20%; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 12s ease-in-out infinite; }
        .mobile-left-2 { left: 0; top: 60%; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float4 10s ease-in-out infinite; }
        .mobile-top-1 { left: 20%; top: 0; width: 70px; height: 140px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float5 14s ease-in-out infinite; }
        .mobile-top-2 { left: 60%; top: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float1 13s ease-in-out infinite; }
        .mobile-bottom-1 { left: 30%; bottom: 0; width: 80px; height: 160px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float2 12s ease-in-out infinite; }
        .mobile-bottom-2 { left: 70%; bottom: 0; width: 60px; height: 120px; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>'); animation: float3 11s ease-in-out infinite; }
    </style>
</head>
<body>
    <div class="floating-mobiles">
        <div class="mobile mobile-1"></div>
        <div class="mobile mobile-2"></div>
        <div class="mobile mobile-3"></div>
        <div class="mobile mobile-4"></div>
        <div class="mobile mobile-5"></div>
        
        <!-- Border reflection mobiles -->
        <div class="border-mobile border-mobile-1"></div>
        <div class="border-mobile border-mobile-2"></div>
        <div class="border-mobile border-mobile-3"></div>
        <div class="border-mobile border-mobile-4"></div>
        
        <!-- Corner reflection mobiles -->
        <div class="corner-mobile corner-mobile-1"></div>
        <div class="corner-mobile corner-mobile-2"></div>
        <div class="corner-mobile corner-mobile-3"></div>
        <div class="corner-mobile corner-mobile-4"></div>
        <!-- More mobiles at borders -->
        <div class="mobile mobile-right-1"></div>
        <div class="mobile mobile-right-2"></div>
        <div class="mobile mobile-left-1"></div>
        <div class="mobile mobile-left-2"></div>
        <div class="mobile mobile-top-1"></div>
        <div class="mobile mobile-top-2"></div>
        <div class="mobile mobile-bottom-1"></div>
        <div class="mobile mobile-bottom-2"></div>
        <!-- Accessories -->
        <div class="accessory accessory-earphones"></div>
        <div class="accessory accessory-charger"></div>
        <div class="accessory accessory-watch"></div>
        <div class="accessory accessory-case"></div>
    </div>
    <div class="checkout-container">
        <div class="page-header" data-aos="fade-down">
            <h2 class="page-title">Checkout</h2>
            <a href="cart.jsp" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Back to Cart
            </a>
        </div>
        
        <div class="row">
            <div class="col-md-8" data-aos="fade-right">
                <div class="card mb-4">
                    <div class="card-header">
                        <h4><i class="bi bi-truck"></i> Shipping Information</h4>
                    </div>
                    <div class="card-body">
                        <form action="PlaceOrderServlet" method="post">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                           value="<%= user.getName()%>" required readonly>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="<%= user.getEmail() %>" required readonly>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="city" class="form-label">City</label>
                                    <input type="text" class="form-control" id="city" name="city" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="state" class="form-label">State</label>
                                    <input type="text" class="form-control" id="state" name="state" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="zipCode" class="form-label">ZIP Code</label>
                                    <input type="text" class="form-control" id="zipCode" name="zipCode" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="paymentMethod" class="form-label">Payment Method</label>
                                <input type="text" class="form-control" id="paymentMethod" name="paymentMethod" value="UPI" readonly>
                            </div>
                            
                            <div class="mb-4" id="upiSection">
                                <div class="text-center mb-3">
                                    <div id="qrcode-container">
                                        <!-- QR Code will be displayed here -->
                                        <img src="https://svrtechnologies.com/wp-content/uploads/upi-scanner-01-284x300.webp" alt="UPI QR Code" style="max-width: 200px;">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="upiNumber" class="form-label">Enter UPI Transaction Number</label>
                                    <input type="text" class="form-control" id="upiNumber" name="upiNumber" required>
                                    <div class="form-text">Please enter the UPI transaction number after payment</div>
                                </div>
                            </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4" data-aos="fade-left">
                <div class="card">
                    <div class="card-header">
                        <h4><i class="bi bi-cart-check"></i> Order Summary</h4>
                    </div>
                    <div class="card-body">
                        <% if (cartItems != null && !cartItems.isEmpty()) { %>
                            <% for (Cart item : cartItems) { 
                                Product product = productDAO.getProductById(item.getProductId());
                                if (product != null) { %>
                                    <div class="cart-item">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6><%= product.getName() %></h6>
                                                <small class="text-muted">Qty: <%= item.getQuantity() %></small>
                                            </div>
                                            <div>
                                                <%= currencyFormat.format(item.getQuantity() * product.getPrice()) %>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            <% } %>
                            
                            <hr>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <span><%= currencyFormat.format(totalAmount) %></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Shipping:</span>
                                <span>Free</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-3">
                                <strong>Total:</strong>
                                <strong><%= currencyFormat.format(totalAmount) %></strong>
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-check-circle"></i> Place Order
                            </button>
                        <% } else { %>
                            <div class="alert">
                                <i class="bi bi-info-circle"></i> Your cart is empty. 
                                <a href="userdashboard">Continue shopping</a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
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

        // Store multiple valid UPI transaction numbers
        const validUpiNumbers = [
            "UPI123456789",
            "UPI987654321",
            "UPI456789123",
            "UPI789123456",
            "UPI321654987"
        ];
        
        // Get DOM elements
        const upiNumberInput = document.getElementById('upiNumber');
        const placeOrderButton = document.querySelector('button[type="submit"]');
        
        // Initially disable the place order button
        placeOrderButton.disabled = true;
        
        // Add event listener for UPI number input
        upiNumberInput.addEventListener('input', function() {
            const enteredUpiNumber = this.value.trim();
            
            // Check if the entered UPI number matches any of the valid numbers
            const isValid = validUpiNumbers.includes(enteredUpiNumber);
            
            // Enable/disable button based on validation
            placeOrderButton.disabled = !isValid;
            
            // Add visual feedback
            if (isValid) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
                // Store the validated UPI number in a hidden input
                if (!document.getElementById('validatedUpiNumber')) {
                    const hiddenInput = document.createElement('input');
                    hiddenInput.type = 'hidden';
                    hiddenInput.id = 'validatedUpiNumber';
                    hiddenInput.name = 'validatedUpiNumber';
                    this.parentNode.appendChild(hiddenInput);
                }
                document.getElementById('validatedUpiNumber').value = enteredUpiNumber;
            } else {
                this.classList.remove('is-valid');
                this.classList.add('is-invalid');
                if (document.getElementById('validatedUpiNumber')) {
                    document.getElementById('validatedUpiNumber').value = '';
                }
            }
        });

        // Add form submission validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const enteredUpiNumber = upiNumberInput.value.trim();
            if (!validUpiNumbers.includes(enteredUpiNumber)) {
                e.preventDefault();
                alert('Please enter a valid UPI transaction number');
            }
        });
    </script>
</body>
</html> 