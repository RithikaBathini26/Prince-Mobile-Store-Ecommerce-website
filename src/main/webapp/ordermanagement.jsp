<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.Order" %>
<%@ page import="com.mobilestore.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        .order-card {
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .order-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .order-items {
            padding: 15px;
        }
        .order-item {
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .order-item:last-child {
            border-bottom: none;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-processing {
            background-color: #cce5ff;
            color: #004085;
        }
        .status-shipped {
            background-color: #d4edda;
            color: #155724;
        }
        .status-delivered {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>

    <div class="container mt-4">
        <h2 class="mb-4">Order Management</h2>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <% 
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.US);
            
            if (orders != null && !orders.isEmpty()) {
                for (Order order : orders) {
        %>
            <div class="card order-card">
                <div class="order-header">
                    <div class="row">
                        <div class="col-md-6">
                            <h5>Order #<%= order.getId() %></h5>
                            <p class="mb-0">Customer: <%= order.getUser() != null ? order.getUser().getName() : "Unknown User" %></p>
                            <p class="mb-0">Date: <%= dateFormat.format(order.getOrderDate()) %></p>
                        </div>
                        <div class="col-md-6 text-end">
                            <form action="OrderManagementServlet" method="post" class="d-inline">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <select name="status" class="form-select d-inline-block w-auto" onchange="this.form.submit()">
                                    <option value="Pending" <%= order.getStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                                    <option value="Processing" <%= order.getStatus().equals("Processing") ? "selected" : "" %>>Processing</option>
                                    <option value="Shipped" <%= order.getStatus().equals("Shipped") ? "selected" : "" %>>Shipped</option>
                                    <option value="Delivered" <%= order.getStatus().equals("Delivered") ? "selected" : "" %>>Delivered</option>
                                    <option value="Cancelled" <%= order.getStatus().equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                                </select>
                            </form>
                            <span class="status-badge status-<%= order.getStatus().toLowerCase() %> ms-2">
                                <%= order.getStatus() %>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="order-items">
                    <% for (OrderItem item : order.getOrderItems()) { %>
                        <div class="order-item">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6><%= item.getProduct().getName() %></h6>
                                    <p class="mb-0">Quantity: <%= item.getQuantity() %></p>
                                </div>
                                <div class="col-md-6 text-end">
                                    <p class="mb-0">Price: <%= currencyFormat.format(item.getPrice()) %></p>
                                    <p class="mb-0">Total: <%= currencyFormat.format(item.getPrice() * item.getQuantity()) %></p>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    <div class="order-item">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Order Total</h6>
                            </div>
                            <div class="col-md-6 text-end">
                                <h6><%= currencyFormat.format(order.getTotalAmount()) %></h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <% 
                }
            } else {
        %>
            <div class="alert alert-info">
                No orders found.
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 