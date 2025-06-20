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
    <title>Shopping Cart - Mobile Store</title>
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

        .accessory-earphones {
            width: 80px; height: 80px;
            top: 10%; left: 45%;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><path d="M12 24C12 17.3726 17.3726 12 24 12C30.6274 12 36 17.3726 36 24" stroke="%234f46e5" stroke-width="3" stroke-linecap="round"/><rect x="8" y="24" width="8" height="12" rx="4" fill="%234f46e5"/><rect x="32" y="24" width="8" height="12" rx="4" fill="%234f46e5"/></svg>');
            animation: accessoryFloat1 20s ease-in-out infinite;
        }

        .accessory-charger {
            width: 70px; height: 70px;
            bottom: 12%; right: 40%;
            background-image: url('data:image/svg+xml;utf8,<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="48" height="48" fill="none"/><rect x="16" y="18" width="16" height="16" rx="4" fill="%234f46e5"/><rect x="20" y="10" width="2" height="8" rx="1" fill="%234f46e5"/><rect x="26" y="10" width="2" height="8" rx="1" fill="%234f46e5"/></svg>');
            animation: accessoryFloat2 22s ease-in-out infinite;
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
            animation: accessoryFloat4 21s ease-in-out infinite;
        }

        @keyframes accessoryFloat1 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(15px, -20px) rotate(8deg); }
            50% { transform: translate(0, -40px) rotate(0deg); }
            75% { transform: translate(-15px, -20px) rotate(-8deg); }
        }

        @keyframes accessoryFloat2 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(-20px, 15px) rotate(-8deg); }
            50% { transform: translate(-40px, 0) rotate(0deg); }
            75% { transform: translate(-20px, -15px) rotate(8deg); }
        }

        @keyframes accessoryFloat3 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(25px, 0) rotate(5deg); }
            50% { transform: translate(50px, 0) rotate(0deg); }
            75% { transform: translate(25px, 0) rotate(-5deg); }
        }

        @keyframes accessoryFloat4 {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(0, -25px) rotate(-5deg); }
            50% { transform: translate(0, -50px) rotate(0deg); }
            75% { transform: translate(0, -25px) rotate(5deg); }
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

        .cart-container {
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

        .cart-item {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .cart-item:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-light);
        }

        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 0.5rem;
            border: 1px solid var(--border-light);
        }

        .quantity-btn {
            background: var(--primary-color);
            border: none;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .quantity-btn:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        .remove-btn {
            background: #ef4444;
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .remove-btn:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }

        .checkout-btn {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 1rem 2rem;
            border-radius: 0.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
        }

        .checkout-btn:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .empty-cart {
            text-align: center;
            padding: 3rem;
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
        }

        .empty-cart i {
            font-size: 4rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .cart-container {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1rem;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
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

    <div class="cart-container">
        <div class="page-header" data-aos="fade-down">
            <h2 class="page-title">Your Cart</h2>
            <a href="userdashboard" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Back to Home
            </a>
        </div>

        <% if (cartItems == null || cartItems.isEmpty()) { %>
            <div class="empty-cart" data-aos="fade-up">
                <i class="bi bi-cart-x"></i>
                <h3>Your cart is empty</h3>
                <p class="text-muted">Looks like you haven't added any items to your cart yet.</p>
                <a href="userdashboard" class="btn btn-primary mt-3">
                    <i class="bi bi-arrow-left me-2"></i>Continue Shopping
                </a>
            </div>
        <% } else { %>
            <% for (Cart item : cartItems) {
                Product product = productDAO.getProductById(item.getProductId());
                if (product != null) { %>
                    <div class="cart-item" data-aos="fade-up">
                        <div class="row align-items-center">
                            <div class="col-md-2 text-center">
                                <img src="<%= product.getImageUrl() != null ? request.getContextPath() + "/" + product.getImageUrl() : request.getContextPath() + "/images/default-product.svg" %>" 
                                     class="product-image" alt="<%= product.getName() %>">
                            </div>
                            <div class="col-md-4">
                                <h5><%= product.getName() %></h5>
                                <p class="text-muted"><%= product.getCategory() %></p>
                            </div>
                            <div class="col-md-3 d-flex align-items-center gap-2">
                                <form action="UpdateCartServlet" method="post" class="d-flex align-items-center gap-2">
                                    <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                                    <input type="hidden" name="action" value="decrease">
                                    <button type="submit" class="quantity-btn">−</button>
                                </form>
                                <span><%= item.getQuantity() %></span>
                                <form action="UpdateCartServlet" method="post" class="d-flex align-items-center gap-2">
                                    <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                                    <input type="hidden" name="action" value="increase">
                                    <button type="submit" class="quantity-btn">+</button>
                                </form>
                            </div>
                            <div class="col-md-2 fw-bold">
                                ₹<%= currencyFormat.format(product.getPrice() * item.getQuantity()) %>
                            </div>
                            <div class="col-md-1 text-end">
                                <form action="RemoveFromCartServlet" method="post" class="d-inline">
                                    <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                                    <button type="submit" class="remove-btn" onclick="return confirm('Remove this item from cart?')">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } 
            } %>

            <div class="text-end mt-4" data-aos="fade-up">
                <h4>Total: ₹<%= currencyFormat.format(totalAmount) %></h4>
                <button class="checkout-btn" onclick="window.location.href='proceedToCheckout.jsp'">
                    <i class="bi bi-credit-card-fill me-2"></i>Proceed to Checkout
                </button>
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
