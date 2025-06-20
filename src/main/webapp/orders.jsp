<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.model.Order" %>
<%@ page import="com.mobilestore.dao.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.mobilestore.model.OrderItem" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.dao.FeedbackDAO" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
    FeedbackDAO feedbackDAO = new FeedbackDAO();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Orders - Mobile Store</title>
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
            padding: 2rem 0;
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

        .orders-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .page-header {
            text-align: left;
            margin-bottom: 2rem;
            background: var(--card-bg);
            padding: 1.5rem 2rem;
            border-radius: 1rem;
            box-shadow: var(--shadow-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-left {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .page-title {
            color: var(--primary-color);
            font-size: 2rem;
            font-weight: 600;
            margin: 0;
        }

        .page-subtitle {
            color: var(--text-light);
            opacity: 0.7;
            margin: 0;
            font-size: 0.95rem;
        }

        .header-right {
            display: flex;
            align-items: center;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 0.5rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            color: white;
        }

        .orders-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            padding: 0.5rem;
        }

        .order-card {
            background: var(--card-bg);
            border-radius: 0.75rem;
            box-shadow: var(--shadow-light);
            transition: all 0.3s ease;
            border: 1px solid var(--border-light);
            overflow: hidden;
            min-height: 380px;
        }

        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(79, 70, 229, 0.15);
        }

        .order-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 1.25rem;
            position: relative;
        }

        .order-id {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .order-date {
            font-size: 0.85rem;
            opacity: 0.9;
        }

        .order-status {
            position: absolute;
            top: 0.75rem;
            right: 0.75rem;
            padding: 0.5rem 1rem;
            border-radius: 1rem;
            font-size: 0.85rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-pending {
            background: #fef3c7;
            color: #d97706;
            border: none;
        }

        .status-processing {
            background: #e0e7ff;
            color: #4f46e5;
            border: none;
        }

        .status-shipped {
            background: #dbeafe;
            color: #2563eb;
            border: none;
        }

        .status-delivered {
            background: #dcfce7;
            color: #16a34a;
            border: none;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #dc2626;
            border: none;
        }

        .order-progress {
            margin: 1.5rem 0;
            padding: 0 1.5rem;
            position: relative;
            display: flex;
            justify-content: space-between;
        }

        .order-progress::before {
            content: '';
            position: absolute;
            top: 14px;
            left: 50px;
            right: 50px;
            height: 2px;
            background: #e5e7eb;
            z-index: 1;
        }

        .progress-step {
            position: relative;
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
        }

        .step-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            color: #9ca3af;
            position: relative;
            transition: all 0.3s ease;
        }

        .step-icon.active {
            background: var(--primary-color);
            color: white;
        }

        .step-label {
            font-size: 0.75rem;
            color: #6b7280;
            font-weight: 500;
            text-align: center;
            width: 80px;
        }

        .step-label.active {
            color: var(--primary-color);
            font-weight: 600;
        }

        .progress-step.active .step-icon::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 100%;
            height: 2px;
            background: var(--primary-color);
            transform: translateY(-50%);
            width: calc(100% - 30px);
            z-index: -1;
        }

        .order-content {
            padding: 1.5rem;
        }

        .order-amount {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--primary-color);
            margin: 1.5rem 0;
            padding: 0.5rem 0;
            border-bottom: 1px solid var(--border-light);
        }

        .order-info {
            margin-bottom: 1.5rem;
            padding: 0.5rem 0;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.25rem;
            font-size: 0.85rem;
        }

        .info-label {
            color: var(--text-light);
            opacity: 0.7;
        }

        .info-value {
            font-weight: 500;
        }

        .order-actions {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            margin-top: 1rem;
            justify-content: center;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .order-actions .btn {
            padding: 0.6rem 1.2rem;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            min-width: 140px;
            border: none;
            position: relative;
            overflow: hidden;
            background: var(--primary-color);
            color: white;
        }

        .order-actions .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.15);
        }

        .order-actions .btn i {
            font-size: 1rem;
            transition: transform 0.3s ease;
        }

        .order-actions .btn:hover i {
            transform: scale(1.1);
        }

        .order-actions .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(
                to right,
                transparent,
                rgba(255, 255, 255, 0.2),
                transparent
            );
            transition: left 0.5s ease;
        }

        .order-actions .btn:hover::before {
            left: 100%;
        }

        .action-button {
            flex: 1;
            padding: 0.6rem;
            font-size: 0.85rem;
            border: 1px solid #1f2937;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .action-button.primary {
            background: var(--primary-color);
            color: white;
            border: 1px solid var(--primary-color);
        }

        .action-button.primary:hover {
            background: var(--secondary-color);
            border-color: var(--secondary-color);
            transform: translateY(-2px);
        }

        .action-button.secondary {
            background: transparent;
            color: #1f2937;
            border: 1px solid #1f2937;
        }

        .action-button.secondary:hover {
            background: rgba(31, 41, 55, 0.05);
            transform: translateY(-2px);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: var(--card-bg);
            border-radius: 1rem;
            box-shadow: var(--shadow-light);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            color: var(--text-light);
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: var(--text-light);
            opacity: 0.7;
            margin-bottom: 2rem;
        }

        @media (max-width: 768px) {
            .orders-container {
                padding: 0 1rem;
            }

            .page-header {
                padding: 1.25rem;
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .header-right {
                width: 100%;
            }

            .back-button {
                width: 100%;
                justify-content: center;
            }

            .orders-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
                padding: 0;
            }

            .order-progress {
                padding: 0;
            }
        }

        .star-rating {
            color: #ffc107;
            font-size: 24px;
            cursor: pointer;
        }
        .star-rating i {
            margin-right: 5px;
        }
        .star-rating i:hover ~ i {
            color: #dee2e6;
        }
    </style>
</head>
<body>
    <div class="orders-container">
        <div class="page-header" data-aos="fade-down">
            <div class="header-left">
                <h1 class="page-title">Your Orders</h1>
                <p class="page-subtitle">Track and manage your orders</p>
            </div>
            <div class="header-right">
                <a href="userdashboard" class="back-button">
                    <i class="bi bi-arrow-left"></i>
                    Back to Home
                </a>
            </div>
        </div>

        <div class="orders-grid">
            <% if (orders != null && !orders.isEmpty()) { %>
                <% for (Order order : orders) { %>
                    <div class="order-card" data-aos="fade-up">
                        <div class="order-header">
                            <div class="order-id">Order #<%= order.getId() %></div>
                            <div class="order-date"><%= dateFormat.format(order.getOrderDate()) %></div>
                            <div class="order-status status-<%= order.getStatus().toLowerCase() %>">
                                <i class="bi bi-circle-fill"></i>
                                <%= order.getStatus() %>
                            </div>
                        </div>
                        <div class="order-content">
                            <% 
                                List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());
                                if (orderItems != null && !orderItems.isEmpty()) {
                                    for (OrderItem item : orderItems) {
                                        Product product = item.getProduct();
                                        if (product != null) {
                            %>
                                <div class="order-item">
                                    <div class="product-image">
                                        <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
                                    </div>
                                    <div class="product-details">
                                        <h5><%= product.getName() %></h5>
                                        <p>Quantity: <%= item.getQuantity() %></p>
                                        <p>Price: <%= currencyFormat.format(item.getPrice()) %></p>
                                        
                                        <div class="d-flex gap-2">
                                            <a href="feedback.jsp?productId=<%= product.getId() %>&orderId=<%= order.getId() %>" 
                                               class="btn btn-primary">
                                                <i class="bi bi-star-fill"></i> Give Feedback
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            <%      }
                                }
                            } %>
                            <div class="order-progress">
                                <div class="progress-step <%= order.getStatus().equalsIgnoreCase("PENDING") || order.getStatus().equalsIgnoreCase("PROCESSING") || order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">
                                    <div class="step-icon <%= order.getStatus().equalsIgnoreCase("PENDING") || order.getStatus().equalsIgnoreCase("PROCESSING") || order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">
                                        <i class="bi bi-cart-check"></i>
                                    </div>
                                    <div class="step-label <%= order.getStatus().equalsIgnoreCase("PENDING") || order.getStatus().equalsIgnoreCase("PROCESSING") || order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">Order Placed</div>
                                </div>
                                <div class="progress-step <%= order.getStatus().equalsIgnoreCase("PROCESSING") || order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">
                                    <div class="step-icon <%= order.getStatus().equalsIgnoreCase("PROCESSING") || order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">
                                        <i class="bi bi-gear"></i>
                                    </div>
                                    <div class="step-label <%= order.getStatus().equalsIgnoreCase("PROCESSING") || order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">Processing</div>
                                </div>
                                <div class="progress-step <%= order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">
                                    <div class="step-icon <%= order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">
                                        <i class="bi bi-truck"></i>
                                    </div>
                                    <div class="step-label <%= order.getStatus().equalsIgnoreCase("SHIPPED") || order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">Shipped</div>
                                </div>
                                <div class="progress-step <%= order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">
                                    <div class="step-icon <%= order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">
                                        <i class="bi bi-check-lg"></i>
                                    </div>
                                    <div class="step-label <%= order.getStatus().equalsIgnoreCase("DELIVERED") ? "active" : "" %>">Delivered</div>
                                </div>
                            </div>
                            <div class="order-amount">
                                <%= currencyFormat.format(order.getTotalAmount()) %>
                            </div>
                            <div class="order-info">
                                <div class="info-row">
                                    <span class="info-label">Shipping</span>
                                    <span class="info-value">Free</span>
                                </div>
                            </div>
                            <div class="order-actions">
                                <a href="feedback.jsp?productId=<%= orderItems != null && !orderItems.isEmpty() && orderItems.get(0).getProduct() != null ? orderItems.get(0).getProduct().getId() : order.getId() %>&orderId=<%= order.getId() %>" 
                                   class="btn">
                                    <i class="bi bi-star-fill"></i>
                                    Feedback
                                </a>
                                <a href="trackOrder.jsp?id=<%= order.getId() %>" class="btn">
                                    <i class="bi bi-truck"></i>
                                    Track
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-state">
                    <i class="bi bi-box-seam"></i>
                    <h3>No Orders Found</h3>
                    <p>You haven't placed any orders yet. Start shopping to see your orders here.</p>
                    <a href="userdashboard" class="action-button primary">
                        <i class="bi bi-cart"></i>
                        Start Shopping
                    </a>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Feedback Modal -->
    <div class="modal fade" id="feedbackModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Write a Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="FeedbackServlet" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" id="feedbackProductId">
                        <input type="hidden" name="orderId" id="feedbackOrderId">
                        <input type="hidden" name="referer" value="orders.jsp">
                        
                        <div class="mb-3">
                            <label class="form-label">Rating</label>
                            <div class="star-rating">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="bi bi-star" data-rating="<%= i %>" onclick="setRating(<%= i %>)"></i>
                                <% } %>
                            </div>
                            <input type="hidden" name="rating" id="rating" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Comment</label>
                            <textarea class="form-control" name="comment" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit Review</button>
                    </div>
                </form>
            </div>
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

        function goToFeedback(productId, orderId) {
            window.location.href = 'feedback.jsp?productId=' + productId + '&orderId=' + orderId;
        }

        function goToTrackOrder(orderId) {
            window.location.href = 'trackOrder.jsp?id=' + orderId;
        }

        function openFeedbackModal(productId, orderId) {
            document.getElementById('feedbackProductId').value = productId;
            document.getElementById('feedbackOrderId').value = orderId;
            new bootstrap.Modal(document.getElementById('feedbackModal')).show();
        }

        function setRating(rating) {
            document.getElementById('rating').value = rating;
            const stars = document.querySelectorAll('.star-rating i');
            stars.forEach((star, index) => {
                star.classList.remove('bi-star-fill', 'bi-star');
                star.classList.add(index < rating ? 'bi-star-fill' : 'bi-star');
            });
        }

        function openHelpModal(productId, orderId) {
            document.getElementById('helpProductId').value = productId;
            document.getElementById('helpOrderId').value = orderId;
            new bootstrap.Modal(document.getElementById('helpModal')).show();
        }
    </script>
</body>
</html>