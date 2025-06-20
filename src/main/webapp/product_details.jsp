<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.*" %>
<%@ page import="com.mobilestore.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%!
    // Admin WhatsApp Configuration - Change this number to update admin's WhatsApp
    private static final String ADMIN_WHATSAPP_NUMBER = "917386005799"; // Format: country code + number without + or spaces
%>

<%
    // Get logged-in user details from session
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String customerPhone = loggedInUser.getMobileNumber(); // Get customer's phone number
    String customerName = loggedInUser.getName();   // Get customer's name
    
    // Remove any non-numeric characters from the phone number and ensure country code
    String adminPhone = "917386005799"; // Admin's number

    String productId = request.getParameter("productId");
    if (productId == null || productId.trim().isEmpty()) {
        response.sendRedirect("userdashboard");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    Product product = productDAO.getProductById(Integer.parseInt(productId));
    
    if (product == null) {
        response.sendRedirect("userdashboard");
        return;
    }

    List<Feedback> reviews = feedbackDAO.getProductFeedback(product.getId());
    double[] ratings = feedbackDAO.getProductRating(product.getId());
    double averageRating = ratings[0];
    int totalReviews = (int)ratings[1];

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
    
    // Admin's WhatsApp number
    final String ADMIN_WHATSAPP = "917386005799";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= product.getName() %> - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 20px;
        }
        .product-container {
            max-width: 1400px;
            margin: 0 auto;
        }
        .product-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }
        .product-header {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .product-details {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }
        .product-image-container {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            text-align: center;
        }
        .product-image {
            width: auto;
            height: auto;
            max-width: 300px;
            max-height: 300px;
            object-fit: contain;
            border-radius: 10px;
            margin: 0 auto;
        }
        .product-info {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .product-price {
            font-size: 2rem;
            font-weight: bold;
            color: #4f46e5;
            margin: 1rem 0;
        }
        .product-stock {
            font-size: 1.1rem;
            margin-bottom: 1rem;
        }
        .in-stock {
            color: #16a34a;
        }
        .out-of-stock {
            color: #dc2626;
        }
        .product-description {
            color: #4b5563;
            line-height: 1.6;
            margin: 1rem 0;
        }
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        .rating-summary {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            text-align: center;
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 2rem;
            align-items: center;
        }
        .rating-overview {
            text-align: center;
            padding-right: 2rem;
            border-right: 1px solid #e5e7eb;
        }
        .average-rating {
            font-size: 2.5rem;
            font-weight: bold;
            color: #4f46e5;
            line-height: 1;
            margin-bottom: 0.5rem;
        }
        .star-display {
            color: #ffc107;
            font-size: 1.25rem;
            margin: 0.5rem 0;
        }
        .total-reviews {
            color: #6b7280;
            font-size: 0.85rem;
        }
        .rating-bars {
            margin: 0;
        }
        .rating-bar {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin: 0.25rem 0;
        }
        .bar-label {
            min-width: 45px;
            font-size: 0.85rem;
            color: #6b7280;
        }
        .progress {
            flex-grow: 1;
            height: 6px;
        }
        .bar-count {
            min-width: 35px;
            text-align: right;
            color: #6b7280;
            font-size: 0.85rem;
        }
        .reviews-list {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            max-height: 800px;
            overflow-y: auto;
        }
        .reviews-list::-webkit-scrollbar {
            width: 8px;
        }
        .reviews-list::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }
        .reviews-list::-webkit-scrollbar-thumb {
            background: #c5c5c5;
            border-radius: 4px;
        }
        .reviews-list::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
        .review-card {
            border-bottom: 1px solid #e5e7eb;
            padding: 1.5rem 0;
        }
        .review-card:first-child {
            padding-top: 0;
        }
        .review-card:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .reviewer-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .reviewer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #4f46e5;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        .review-rating {
            color: #ffc107;
        }
        .review-date {
            color: #6b7280;
            font-size: 0.9rem;
        }
        .review-content {
            color: #1f2937;
            line-height: 1.6;
        }
        @media (max-width: 992px) {
            .product-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="product-container">
        <div class="product-grid">
            <!-- Left Column: Product Details -->
            <div class="product-details">
                <div class="product-image-container">
                    <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="product-image">
                </div>
                <div class="product-info">
                    <h1 class="h2 mb-2"><%= product.getName() %></h1>
                    <div class="product-price"><%= currencyFormat.format(product.getPrice()) %></div>
                    <div class="product-stock <%= product.getStock() > 0 ? "in-stock" : "out-of-stock" %>">
                        <i class="bi <%= product.getStock() > 0 ? "bi-check-circle-fill" : "bi-x-circle-fill" %>"></i>
                        <%= product.getStock() > 0 ? "In Stock (" + product.getStock() + " available)" : "Out of Stock" %>
                    </div>
                    <div class="product-description">
                        <%= product.getDescription() %>
                    </div>
                    <div class="action-buttons">
                        <form action="addToCart" method="post" style="flex: 1;">
                            <input type="hidden" name="productId" value="<%= product.getId() %>">
                            <div class="d-flex gap-2">
                                <input type="number" name="quantity" value="1" min="1" max="<%= product.getStock() %>" 
                                       class="form-control" style="width: 100px;" <%= product.getStock() == 0 ? "disabled" : "" %>>
                                <button type="submit" class="btn btn-primary flex-grow-1" <%= product.getStock() == 0 ? "disabled" : "" %>>
                                    <i class="bi bi-cart-plus"></i> Add to Cart
                                </button>
                            </div>
                        </form>
                        <form action="addToWishlist" method="post">
                            <input type="hidden" name="productId" value="<%= product.getId() %>">
                            <button type="submit" class="btn btn-outline-primary">
                                <i class="bi bi-heart"></i> Add to Wishlist
                            </button>
                        </form>
                        <script>
                            function openWhatsApp() {
                                // Message to be sent
                                var message = "Hi, this is <%= customerName %>. I would like to request a video call regarding the product: <%= product.getName() %> (ID: <%= product.getId() %>). Please schedule a video call demonstration.";
                                
                                // Encode the message for URL
                                var encodedMessage = encodeURIComponent(message);
                                
                                // Try to open in WhatsApp app first (mobile)
                                if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                                    window.location.href = "whatsapp://send?phone=<%= ADMIN_WHATSAPP_NUMBER %>&text=" + encodedMessage;
                                } else {
                                    // If not mobile, open in web WhatsApp
                                    window.open("https://web.whatsapp.com/send?phone=<%= ADMIN_WHATSAPP_NUMBER %>&text=" + encodedMessage, "_blank");
                                }
                            }
                        </script>
                        <button onclick="openWhatsApp()" class="btn btn-outline-success">
                            <i class="bi bi-whatsapp"></i> Request Video Call
                        </button>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="reviews-section">
                <!-- Rating Summary Section -->
                <div class="rating-summary">
                    <div class="rating-overview">
                        <div class="average-rating"><%= String.format("%.1f", averageRating) %></div>
                        <div class="star-display">
                            <% for(int i = 1; i <= 5; i++) { %>
                                <i class="bi <%= i <= averageRating ? "bi-star-fill" : (i <= averageRating + 0.5 ? "bi-star-half" : "bi-star") %>"></i>
                            <% } %>
                        </div>
                        <div class="total-reviews"><%= totalReviews %> reviews</div>
                    </div>

                    <div class="rating-bars">
                        <% 
                        Map<Integer, Integer> ratingDistribution = feedbackDAO.getRatingDistribution(product.getId());
                        for(int i = 5; i >= 1; i--) {
                            int count = ratingDistribution.getOrDefault(i, 0);
                            double percentage = totalReviews > 0 ? (count * 100.0 / totalReviews) : 0;
                        %>
                        <div class="rating-bar">
                            <div class="bar-label"><%= i %> ★</div>
                            <div class="progress">
                                <div class="progress-bar bg-primary" role="progressbar" 
                                     style="width: <%= percentage %>%" 
                                     aria-valuenow="<%= percentage %>" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100"></div>
                            </div>
                            <div class="bar-count"><%= count %></div>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Reviews List Section -->
                <div class="reviews-list">
                    <h3 class="mb-4">Customer Reviews</h3>
                    <% if(reviews != null && !reviews.isEmpty()) { 
                        for(Feedback review : reviews) {
                            if(review.getUser() != null) {
                    %>
                        <div class="review-card">
                            <div class="review-header">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">
                                        <%= review.getUser().getName().substring(0, 1).toUpperCase() %>
                                    </div>
                                    <div>
                                        <div class="fw-bold"><%= review.getUser().getName() %></div>
                                        <div class="review-date"><%= dateFormat.format(review.getCreatedAt()) %></div>
                                    </div>
                                </div>
                                <div class="review-rating">
                                    <% for(int i = 1; i <= 5; i++) { %>
                                        <i class="bi <%= i <= review.getRating() ? "bi-star-fill" : "bi-star" %>"></i>
                                    <% } %>
                                </div>
                            </div>
                            <div class="review-content">
                                <%= review.getComment() %>
                            </div>
                        </div>
                    <%      }
                        }
                    } else { %>
                        <div class="text-center py-5">
                            <i class="bi bi-chat-square-text h1 text-muted"></i>
                            <h3 class="mt-3">No Reviews Yet</h3>
                            <p class="text-muted">Be the first to review this product!</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>