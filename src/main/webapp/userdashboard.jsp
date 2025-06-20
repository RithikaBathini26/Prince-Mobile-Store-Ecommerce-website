<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>

<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

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
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Our Products - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .product-container {
            width: 100%;
            padding: 0 2rem;
            margin: 0;
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
        .products-title-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            padding: 3rem 0;
            margin-bottom: 2rem;
            color: white;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .products-title-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            transform: skewY(-4deg);
            transform-origin: top right;
        }

        .products-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }

        .products-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
            margin-bottom: 2rem;
            position: relative;
            z-index: 1;
        }

        .filter-section {
            position: relative;
            z-index: 2;
            padding-top: 1rem;
        }

        .filter-group {
            margin-bottom: 0;
        }

        .form-select {
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 0.75rem;
            font-size: 0.95rem;
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='white' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 16px 12px;
            padding-right: 2.5rem;
        }

        .form-select:focus {
            border-color: rgba(255, 255, 255, 0.5);
            box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.1);
            outline: none;
        }

        .form-select option {
            background-color: var(--primary-color);
            color: white;
        }

        @media (max-width: 768px) {
            .products-title {
                font-size: 2rem;
            }

            .products-subtitle {
                font-size: 1rem;
                padding: 0 1rem;
            }

            .filter-section {
                padding-top: 0.5rem;
            }

            .form-select {
                margin-bottom: 0.5rem;
            }
        }

        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --background-light: #f8f9fa;
            --text-light: #6b7280;
            --card-bg: #ffffff;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: white;
        }
        .btn-primary:disabled {
            background-color: var(--text-light);
            border-color: var(--text-light);
        }
    </style>
</head>
<body>
    <!-- Toast Container -->
    <div class="toast-container">
        <div class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <!-- Products Title Section -->
    <section class="products-title-section">
        <div class="container-fluid">
            <h1 class="products-title">Our Products</h1>
            <p class="products-subtitle">Discover our extensive collection of premium mobile devices and accessories</p>
            
            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row g-3">
                    <div class="col-md-3">
                        <div class="filter-group">
                            <select class="form-select" id="categoryFilter">
                                <option value="">All Categories</option>
                                <option value="Smartphone">Smartphones</option>
                                <option value="Accessory">Accessories</option>
                                <option value="Tablet">Tablets</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="filter-group">
                            <select class="form-select" id="priceFilter">
                                <option value="">All Prices</option>
                                <option value="0-15000">Under ₹15,000</option>
                                <option value="15000-30000">₹15,000 - ₹30,000</option>
                                <option value="30000-50000">₹30,000 - ₹50,000</option>
                                <option value="50000-999999">Above ₹50,000</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="filter-group">
                            <select class="form-select" id="stockFilter">
                                <option value="">All Stock</option>
                                <option value="in-stock">In Stock</option>
                                <option value="low-stock">Low Stock</option>
                                <option value="out-of-stock">Out of Stock</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="filter-group">
                            <select class="form-select" id="sortFilter">
                                <option value="">Sort By</option>
                                <option value="price-low-high">Price: Low to High</option>
                                <option value="price-high-low">Price: High to Low</option>
                                <option value="name-asc">Name: A to Z</option>
                                <option value="name-desc">Name: Z to A</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="container-fluid">
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
            <% if (productList != null && !productList.isEmpty()) {
                for (Product product : productList) { %>
                <div class="col">
                    <div class="card product-card">
                        <img src="<%= product.getImageUrl() %>" class="card-img-top product-image" alt="<%= product.getName() %>">
                        <div class="card-body">
                            <h5 class="card-title product-title"><%= product.getName() %></h5>
                            <p class="card-text product-category"><%= product.getCategory() %></p>
                            <p class="card-text product-price"><%= currencyFormat.format(product.getPrice()) %></p>
                            <p class="card-text product-description"><%= product.getDescription() %></p>
                            
                            <% if (product.getStock() > 10) { %>
                                <p class="stock-info stock-available">In Stock (<%= product.getStock() %> available)</p>
                            <% } else if (product.getStock() > 0) { %>
                                <p class="stock-info stock-low">Low Stock (<%= product.getStock() %> left)</p>
                            <% } else { %>
                                <p class="stock-info stock-out">Out of Stock</p>
                            <% } %>
                            
                            <div class="action-buttons d-flex flex-column gap-2">
                                <div class="d-flex gap-2">
                                    <form action="addToCart" method="post" style="flex: 1;">
                                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                                        <div class="d-flex gap-2">
                                            <input type="number" name="quantity" value="1" min="1" max="<%= product.getStock() %>" class="form-control" style="width: 70px;">
                                            <button type="submit" class="btn btn-primary flex-grow-1" <%= product.getStock() == 0 ? "disabled" : "" %>>
                                                <i class="bi bi-cart-plus"></i> Add to Cart
                                            </button>
                                        </div>
                                    </form>
                                </div>
                                <div class="d-flex gap-2">
                                    <form action="addToWishlist" method="post" style="flex: 1;">
                                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="bi bi-heart"></i> Wishlist
                                        </button>
                                    </form>
                                    <a href="product_details.jsp?productId=<%= product.getId() %>" class="btn btn-primary" style="flex: 1;">
                                        <i class="bi bi-star"></i> View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            <% }
            } %>
        </div>
        
        <% if (productList == null || productList.isEmpty()) { %>
            <div class="alert alert-info mt-4">
                No products available at the moment.
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to show toast message
        function showToast(message, type) {
            const toast = document.querySelector('.toast');
            const toastBody = toast.querySelector('.toast-body');
            
            // Set message and type
            toastBody.textContent = message;
            toast.className = `toast align-items-center text-white border-0 ${type}`;
            
            // Show toast
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
        }

        // Filter functionality
        function filterProducts() {
            const category = document.getElementById('categoryFilter').value;
            const priceRange = document.getElementById('priceFilter').value;
            const stockStatus = document.getElementById('stockFilter').value;
            const sortBy = document.getElementById('sortFilter').value;

            const products = document.querySelectorAll('.product-card');
            products.forEach(product => {
                const productCategory = product.querySelector('.product-category').textContent;
                const productPrice = parseFloat(product.querySelector('.product-price').textContent.replace('₹', '').replace(',', ''));
                const stockInfo = product.querySelector('.stock-info').textContent;

                let showProduct = true;

                // Category filter
                if (category && productCategory !== category) {
                    showProduct = false;
                }

                // Price range filter
                if (priceRange) {
                    const [min, max] = priceRange.split('-').map(Number);
                    if (productPrice < min || productPrice > max) {
                        showProduct = false;
                    }
                }

                // Stock filter
                if (stockStatus) {
                    if (stockStatus === 'in-stock' && !stockInfo.includes('In Stock')) showProduct = false;
                    if (stockStatus === 'low-stock' && !stockInfo.includes('Low Stock')) showProduct = false;
                    if (stockStatus === 'out-of-stock' && !stockInfo.includes('Out of Stock')) showProduct = false;
                }

                product.closest('.col').style.display = showProduct ? '' : 'none';
            });

            // Sorting
            const productContainer = document.querySelector('.row');
            const productsArray = Array.from(products);
            
            if (sortBy) {
                productsArray.sort((a, b) => {
                    const priceA = parseFloat(a.querySelector('.product-price').textContent.replace('₹', '').replace(',', ''));
                    const priceB = parseFloat(b.querySelector('.product-price').textContent.replace('₹', '').replace(',', ''));
                    const nameA = a.querySelector('.product-title').textContent;
                    const nameB = b.querySelector('.product-title').textContent;

                    switch(sortBy) {
                        case 'price-low-high':
                            return priceA - priceB;
                        case 'price-high-low':
                            return priceB - priceA;
                        case 'name-asc':
                            return nameA.localeCompare(nameB);
                        case 'name-desc':
                            return nameB.localeCompare(nameA);
                        default:
                            return 0;
                    }
                });

                productsArray.forEach(product => {
                    productContainer.appendChild(product.closest('.col'));
                });
            }
        }

        // Add event listeners to filters
        document.getElementById('categoryFilter').addEventListener('change', filterProducts);
        document.getElementById('priceFilter').addEventListener('change', filterProducts);
        document.getElementById('stockFilter').addEventListener('change', filterProducts);
        document.getElementById('sortFilter').addEventListener('change', filterProducts);

        // Check for messages from servlets
        <% if (request.getAttribute("message") != null) { %>
            showToast("<%= request.getAttribute("message").toString().replace("\"", "\\\"") %>", 'bg-success');
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            showToast("<%= request.getAttribute("error").toString().replace("\"", "\\\"") %>", 'bg-danger');
        <% } %>
    </script>
</body>
</html> 