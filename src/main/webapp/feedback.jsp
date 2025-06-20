<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>
<%@ page import="com.mobilestore.dao.OrderDAO" %>
<%@ page import="com.mobilestore.model.Order" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String productId = request.getParameter("productId");
    String orderId = request.getParameter("orderId");
    
    // Validate required parameters
    if (productId == null || orderId == null || productId.trim().isEmpty() || orderId.trim().isEmpty()) {
        response.sendRedirect("orders.jsp");
        return;
    }

    Product product = null;
    Order order = null;
    
    try {
        ProductDAO productDAO = new ProductDAO();
        product = productDAO.getProductById(Integer.parseInt(productId));
        
        OrderDAO orderDAO = new OrderDAO();
        order = orderDAO.getOrderById(Integer.parseInt(orderId));
        
        // If either product or order is not found, redirect back
        if (product == null || order == null) {
            response.sendRedirect("orders.jsp");
            return;
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("orders.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit Feedback - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 20px;
        }
        .feedback-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .product-info {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 20px;
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
    <div class="feedback-container">
        <h2 class="mb-4">Submit Your Feedback</h2>
        
        <div class="product-info">
            <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="product-image">
            <div>
                <h4><%= product.getName() %></h4>
                <p class="text-muted">Order #<%= orderId %></p>
            </div>
        </div>

        <form action="FeedbackServlet" method="post">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="<%= productId %>">
            <input type="hidden" name="orderId" value="<%= orderId %>">
            
            <div class="mb-4">
                <label class="form-label">Rating</label>
                <div class="star-rating mb-2">
                    <i class="bi bi-star" data-rating="1" onclick="setRating(1)"></i>
                    <i class="bi bi-star" data-rating="2" onclick="setRating(2)"></i>
                    <i class="bi bi-star" data-rating="3" onclick="setRating(3)"></i>
                    <i class="bi bi-star" data-rating="4" onclick="setRating(4)"></i>
                    <i class="bi bi-star" data-rating="5" onclick="setRating(5)"></i>
                </div>
                <input type="hidden" name="rating" id="rating" required>
            </div>
            
            <div class="mb-4">
                <label for="comment" class="form-label">Your Feedback</label>
                <textarea class="form-control" id="comment" name="comment" rows="5" required 
                    placeholder="Please share your experience with this product..."></textarea>
            </div>
            
            <div class="d-flex gap-2">
                <a href="orders.jsp" class="btn btn-secondary">Back to Orders</a>
                <button type="submit" class="btn btn-primary">Submit Feedback</button>
            </div>
        </form>
    </div>

    <script>
        // Initialize rating as 0
        let currentRating = 0;

        function setRating(rating) {
            currentRating = rating;
            document.getElementById('rating').value = rating;
            updateStars();
        }

        function updateStars() {
            const stars = document.querySelectorAll('.star-rating i');
            stars.forEach((star, index) => {
                star.classList.remove('bi-star-fill', 'bi-star');
                star.classList.add(index < currentRating ? 'bi-star-fill' : 'bi-star');
            });
        }

        // Add form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            if (!currentRating) {
                e.preventDefault();
                alert('Please select a rating before submitting.');
                return false;
            }
            return true;
        });

        // Add hover effects
        const stars = document.querySelectorAll('.star-rating i');
        stars.forEach((star, index) => {
            star.addEventListener('mouseover', () => {
                stars.forEach((s, i) => {
                    s.classList.remove('bi-star-fill', 'bi-star');
                    s.classList.add(i <= index ? 'bi-star-fill' : 'bi-star');
                });
            });
            
            star.addEventListener('mouseout', () => {
                updateStars();
            });
        });
    </script>
</body>
</html> 