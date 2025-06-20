<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.Admin" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>
<%@ page import="com.mobilestore.dao.OrderDAO" %>
<%@ page import="com.mobilestore.dao.CartDAO" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.model.Order" %>
<%@ page import="com.mobilestore.model.Cart" %>
<%@ page import="com.mobilestore.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    OrderDAO orderDAO = new OrderDAO();
    CartDAO cartDAO = new CartDAO();
    List<Product> products = productDAO.getAllProducts();
    List<Order> orders = orderDAO.getAllOrders();
    
    // Prepare data for product categories pie chart
    Map<String, Integer> categoryCount = new HashMap<>();
    for (Product product : products) {
        String category = product.getCategory();
        categoryCount.put(category, categoryCount.getOrDefault(category, 0) + 1);
    }
    
    // Prepare data for order status pie chart
    Map<String, Integer> statusCount = new HashMap<>();
    for (Order order : orders) {
        String status = order.getStatus();
        statusCount.put(status, statusCount.getOrDefault(status, 0) + 1);
    }
    
    // Prepare data for product availability pie chart
    int inStockCount = 0;
    int outOfStockCount = 0;
    for (Product product : products) {
        if (product.getStock() > 0) {
            inStockCount++;
        } else {
            outOfStockCount++;
        }
    }
    
    // Prepare data for sales performance by category
    Map<String, Double> categorySales = new HashMap<>();
    for (Order order : orders) {
        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());
        for (OrderItem item : orderItems) {
            Product product = productDAO.getProductById(item.getProductId());
            if (product != null) {
                String category = product.getCategory();
                double total = item.getQuantity() * item.getPrice();
                categorySales.put(category, categorySales.getOrDefault(category, 0.0) + total);
            }
        }
    }
    
    // Convert category sales data to JSON arrays
    String categoryLabels = "[";
    String categoryValues = "[";
    boolean first = true;
    for (Map.Entry<String, Double> entry : categorySales.entrySet()) {
        if (!first) {
            categoryLabels += ",";
            categoryValues += ",";
        }
        categoryLabels += "'" + entry.getKey() + "'";
        categoryValues += entry.getValue();
        first = false;
    }
    categoryLabels += "]";
    categoryValues += "]";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #4338ca;
            --accent-color: #6366f1;
            --background-light: #f0f2f5;
            --background-dark: #1a1a1a;
            --text-light: #1e293b;
            --text-dark: #f8fafc;
            --card-bg-light: rgba(255, 255, 255, 0.9);
            --card-bg-dark: rgba(30, 41, 59, 0.9);
            --border-light: rgba(79, 70, 229, 0.1);
            --border-dark: rgba(255, 255, 255, 0.1);
            --shadow-light: 0 8px 32px rgba(79, 70, 229, 0.1);
            --shadow-dark: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--background-light);
            background-image: linear-gradient(135deg, #f0f2f5 0%, #e4e6eb 100%);
            min-height: 100vh;
            transition: background-color 0.3s ease;
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

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
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

        .chart-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .chart-wrapper {
            background: var(--card-bg-light);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            transition: all 0.3s ease;
            height: 450px;
            display: flex;
            flex-direction: column;
        }

        .chart-wrapper:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-light);
        }

        .chart-wrapper h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-size: 1.2rem;
            font-weight: 600;
            text-align: center;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border-light);
        }

        .chart-canvas {
            flex: 1;
            min-height: 0;
            position: relative;
        }

        .chart-description {
            text-align: center;
            color: var(--text-light);
            opacity: 0.7;
            font-size: 0.9rem;
            margin-top: 1rem;
            font-style: italic;
        }

        .stock-lists {
            margin-top: 1rem;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }

        .in-stock-list, .out-of-stock-list {
            background: rgba(255, 255, 255, 0.5);
            padding: 1rem;
            border-radius: 0.75rem;
            border: 1px solid var(--border-light);
        }

        .in-stock-list h4, .out-of-stock-list h4 {
            color: var(--primary-color);
            margin-bottom: 0.75rem;
            font-size: 1rem;
            font-weight: 600;
        }

        .stock-lists ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
            max-height: 150px;
            overflow-y: auto;
        }

        .stock-lists li {
            padding: 0.5rem 0;
            border-bottom: 1px solid var(--border-light);
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .stock-lists li:last-child {
            border-bottom: none;
        }

        .in-stock-list {
            border-left: 4px solid #10b981;
        }

        .out-of-stock-list {
            border-left: 4px solid #ef4444;
        }

        .btn-primary {
            background: var(--primary-color);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .chart-container {
                grid-template-columns: 1fr;
            }

            .stock-lists {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header" data-aos="fade-down">
            <h2 class="page-title">Store Analytics Dashboard</h2>
            <a href="admindashboard.jsp" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        
        <div class="chart-container">
            <div class="chart-wrapper" data-aos="fade-up">
                <h3>Product Categories Distribution</h3>
                <div class="chart-canvas">
                    <canvas id="productCategoriesChart"></canvas>
                </div>
                <div class="chart-description">Distribution of products across different categories</div>
            </div>
            
            <div class="chart-wrapper" data-aos="fade-up" data-aos-delay="100">
                <h3>Order Status Distribution</h3>
                <div class="chart-canvas">
                    <canvas id="orderStatusChart"></canvas>
                </div>
                <div class="chart-description">Current status of all orders in the system</div>
            </div>
            
            <div class="chart-wrapper" data-aos="fade-up" data-aos-delay="200">
                <h3>Product Availability</h3>
                <div class="chart-canvas">
                    <canvas id="productAvailabilityChart"></canvas>
                </div>
                <div class="chart-description">Current stock status of all products</div>
                <div class="stock-lists">
                    <div class="in-stock-list">
                        <h4>In Stock Products</h4>
                        <ul>
                            <% for (Product product : products) { 
                                if (product.getStock() > 0) { %>
                                    <li><%= product.getName() %> - <%= product.getStock() %> units</li>
                                <% }
                            } %>
                        </ul>
                    </div>
                    <div class="out-of-stock-list">
                        <h4>Out of Stock Products</h4>
                        <ul>
                            <% for (Product product : products) { 
                                if (product.getStock() == 0) { %>
                                    <li><%= product.getName() %></li>
                                <% }
                            } %>
                        </ul>
                    </div>
                </div>
            </div>
            
            <div class="chart-wrapper" data-aos="fade-up" data-aos-delay="300">
                <h3>Sales Performance by Category</h3>
                <div class="chart-canvas">
                    <canvas id="salesPerformanceChart"></canvas>
                </div>
                <div class="chart-description">Total sales revenue by product category</div>
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

        // Debug data
        console.log('Category Count:', <%= categoryCount.keySet().stream().map(c -> "'" + c + "'").collect(java.util.stream.Collectors.joining(",")) %>);
        console.log('Category Values:', <%= categoryCount.values().stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(",")) %>);
        console.log('Status Count:', <%= statusCount.keySet().stream().map(s -> "'" + s + "'").collect(java.util.stream.Collectors.joining(",")) %>);
        console.log('Status Values:', <%= statusCount.values().stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(",")) %>);
        console.log('In Stock:', <%= inStockCount %>, 'Out of Stock:', <%= outOfStockCount %>);
        console.log('Category Labels:', <%= categoryLabels %>);
        console.log('Category Values:', <%= categoryValues %>);

        // Product Categories Chart
        const productCategoriesCtx = document.getElementById('productCategoriesChart');
        if (productCategoriesCtx) {
            new Chart(productCategoriesCtx.getContext('2d'), {
                type: 'pie',
                data: {
                    labels: [<% for (String cat : categoryCount.keySet()) { %>'<%= cat %>',<% } %>],
                    datasets: [{
                        data: [<% for (Integer count : categoryCount.values()) { %><%= count %>,<% } %>],
                        backgroundColor: ['#4f46e5', '#6366f1', '#818cf8', '#a5b4fc', '#c7d2fe']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { 
                        legend: { 
                            position: 'bottom',
                            labels: {
                                usePointStyle: true,
                                padding: 20,
                                font: {
                                    size: 12,
                                    weight: 'bold'
                                }
                            }
                        },
                        tooltip: {
                            enabled: true,
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            cornerRadius: 8,
                            displayColors: true,
                            callbacks: {
                                label: function(context) {
                                    return `${context.label}: ${context.raw} items`;
                                }
                            }
                        }
                    },
                    animation: {
                        duration: 2000,
                        easing: 'easeInOutQuart',
                        onProgress: function(animation) {
                            animation.chart.update('none');
                        },
                        delay: function(context) {
                            return context.datasetIndex * 200;
                        }
                    },
                    transitions: {
                        active: {
                            animation: {
                                duration: 400
                            }
                        },
                        hover: {
                            animation: {
                                duration: 200
                            }
                        }
                    },
                    hover: {
                        mode: 'nearest',
                        intersect: true,
                        animationDuration: 200
                    }
                }
            });
        }

        // Order Status Chart
        const orderStatusCtx = document.getElementById('orderStatusChart');
        if (orderStatusCtx) {
            new Chart(orderStatusCtx.getContext('2d'), {
                type: 'pie',
                data: {
                    labels: [<% for (String status : statusCount.keySet()) { %>'<%= status %>',<% } %>],
                    datasets: [{
                        data: [<% for (Integer count : statusCount.values()) { %><%= count %>,<% } %>],
                        backgroundColor: ['#10b981', '#f59e0b', '#ef4444', '#6366f1']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { 
                        legend: { 
                            position: 'bottom',
                            labels: {
                                usePointStyle: true,
                                padding: 20,
                                font: {
                                    size: 12,
                                    weight: 'bold'
                                }
                            }
                        },
                        tooltip: {
                            enabled: true,
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            cornerRadius: 8,
                            displayColors: true,
                            callbacks: {
                                label: function(context) {
                                    return `${context.label}: ${context.raw} orders`;
                                }
                            }
                        }
                    },
                    animation: {
                        duration: 2000,
                        easing: 'easeInOutQuart',
                        onProgress: function(animation) {
                            animation.chart.update('none');
                        },
                        delay: function(context) {
                            return context.datasetIndex * 200;
                        }
                    },
                    transitions: {
                        active: {
                            animation: {
                                duration: 400
                            }
                        },
                        hover: {
                            animation: {
                                duration: 200
                            }
                        }
                    },
                    hover: {
                        mode: 'nearest',
                        intersect: true,
                        animationDuration: 200
                    }
                }
            });
        }

        // Product Availability Chart
        const productAvailabilityCtx = document.getElementById('productAvailabilityChart');
        if (productAvailabilityCtx) {
            new Chart(productAvailabilityCtx.getContext('2d'), {
                type: 'pie',
                data: {
                    labels: ['In Stock', 'Out of Stock'],
                    datasets: [{
                        data: [<%= inStockCount %>, <%= outOfStockCount %>],
                        backgroundColor: ['#10b981', '#ef4444']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { 
                        legend: { 
                            position: 'bottom',
                            labels: {
                                usePointStyle: true,
                                padding: 20,
                                font: {
                                    size: 12,
                                    weight: 'bold'
                                }
                            }
                        },
                        tooltip: {
                            enabled: true,
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            cornerRadius: 8,
                            displayColors: true,
                            callbacks: {
                                label: function(context) {
                                    return `${context.label}: ${context.raw} products`;
                                }
                            }
                        }
                    },
                    animation: {
                        duration: 2000,
                        easing: 'easeInOutQuart',
                        onProgress: function(animation) {
                            animation.chart.update('none');
                        },
                        delay: function(context) {
                            return context.datasetIndex * 200;
                        }
                    },
                    transitions: {
                        active: {
                            animation: {
                                duration: 400
                            }
                        },
                        hover: {
                            animation: {
                                duration: 200
                            }
                        }
                    },
                    hover: {
                        mode: 'nearest',
                        intersect: true,
                        animationDuration: 200
                    }
                }
            });
        }

        // Sales Performance Chart
        const salesPerformanceCtx = document.getElementById('salesPerformanceChart');
        if (salesPerformanceCtx) {
            new Chart(salesPerformanceCtx.getContext('2d'), {
                type: 'bar',
                data: {
                    labels: <%= categoryLabels %>,
                    datasets: [{
                        label: 'Sales Amount',
                        data: <%= categoryValues %>,
                        backgroundColor: '#4f46e5'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { 
                        legend: { 
                            display: false 
                        },
                        tooltip: {
                            enabled: true,
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            cornerRadius: 8,
                            displayColors: true,
                            callbacks: {
                                label: function(context) {
                                    return `Sales: ₹${context.raw}`;
                                }
                            }
                        }
                    },
                    scales: { 
                        y: { 
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.1)',
                                drawBorder: false
                            },
                            ticks: {
                                callback: function(value) {
                                    return '₹' + value;
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    },
                    animation: {
                        duration: 2000,
                        easing: 'easeInOutQuart',
                        onProgress: function(animation) {
                            animation.chart.update('none');
                        },
                        delay: function(context) {
                            return context.datasetIndex * 200;
                        }
                    },
                    transitions: {
                        active: {
                            animation: {
                                duration: 400
                            }
                        },
                        hover: {
                            animation: {
                                duration: 200
                            }
                        }
                    },
                    hover: {
                        mode: 'nearest',
                        intersect: true,
                        animationDuration: 200
                    }
                }
            });
        }
    </script>
</body>
</html> 