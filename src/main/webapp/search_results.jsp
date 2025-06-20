<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    List<Product> searchResults = (List<Product>) request.getAttribute("searchResults");
    String searchQuery = (String) request.getAttribute("searchQuery");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - PN MobileStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
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

        .search-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .search-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" stroke="white" stroke-width="2" fill="none" opacity="0.1"/></svg>') center/50px repeat;
            animation: slide 20s linear infinite;
            opacity: 0.1;
        }

        @keyframes slide {
            from { transform: translateX(0); }
            to { transform: translateX(100px); }
        }

        .product-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            height: 100%;
            overflow: hidden;
            position: relative;
        }

        .product-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 1;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(37, 99, 235, 0.2);
        }

        .product-image-container {
            height: 200px;
            overflow: hidden;
            position: relative;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-image {
            max-height: 180px;
            width: auto;
            object-fit: contain;
            transition: transform 0.5s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.1);
        }

        .product-details {
            padding: 1.5rem;
            position: relative;
            z-index: 2;
        }

        .product-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--primary-color);
        }

        .product-description {
            font-size: 0.9rem;
            color: var(--text-light);
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .product-price {
            color: var(--primary-color);
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }

        .product-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-cart {
            flex: 1;
            padding: 0.75rem;
            border-radius: 15px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-wishlist {
            width: 46px;
            height: 46px;
            padding: 0;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .btn-cart:hover, .btn-wishlist:hover {
            transform: translateY(-2px);
        }

        .no-results {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 2rem auto;
        }

        .no-results i {
            font-size: 5rem;
            color: var(--text-light);
            margin-bottom: 1.5rem;
        }

        .back-button {
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            transform: translateX(-5px);
        }

        .search-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-top: 1rem;
        }

        .search-tag {
            background: rgba(255, 255, 255, 0.1);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            backdrop-filter: blur(10px);
        }

        .results-count {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        /* Voice Search Styles */
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

        @media (max-width: 768px) {
            .search-header {
                padding: 2rem 0;
            }

            .product-card {
                margin-bottom: 1rem;
            }

            .product-image-container {
                height: 160px;
            }

            .product-details {
                padding: 1rem;
            }

            .product-title {
                font-size: 1.1rem;
            }

            .product-price {
                font-size: 1.25rem;
            }
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>
    
    <div class="search-header">
        <div class="container">
            <a href="home.jsp" class="back-button">
                <i class="bi bi-arrow-left"></i> Back to Home
            </a>
            <h1 class="mb-3">Search Results</h1>
            <div class="search-info">
                <div class="search-tag">
                    <i class="bi bi-search"></i> <%= searchQuery %>
                </div>
                <% if (searchResults != null) { %>
                    <div class="results-count">
                        <%= searchResults.size() %> results found
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <div class="container">
        <% if (searchResults != null && !searchResults.isEmpty()) { %>
            <div class="row g-4">
                <% for (Product product : searchResults) { %>
                    <div class="col-md-3" data-aos="fade-up">
                        <div class="product-card">
                            <div class="product-image-container">
                                <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="product-image">
                            </div>
                            <div class="product-details">
                                <h5 class="product-title"><%= product.getName() %></h5>
                                <p class="product-description"><%= product.getDescription() %></p>
                                <p class="product-price"><%= currencyFormat.format(product.getPrice()) %></p>
                                <div class="product-actions">
                                    <form action="CartServlet" method="POST" style="flex: 1;">
                                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                                        <input type="hidden" name="action" value="add">
                                        <button type="submit" class="btn btn-primary btn-cart">
                                            <i class="bi bi-cart-plus"></i>
                                            Add to Cart
                                        </button>
                                    </form>
                                    <form action="WishlistServlet" method="POST">
                                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                                        <input type="hidden" name="action" value="add">
                                        <button type="submit" class="btn btn-outline-primary btn-wishlist">
                                            <i class="bi bi-heart"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-results" data-aos="fade-up">
                <i class="bi bi-search"></i>
                <h2 class="mt-4">No Results Found</h2>
                <p class="text-muted">We couldn't find any products matching "<%= searchQuery %>"</p>
                <p class="text-muted mb-4">Try searching with different keywords or browse our categories.</p>
                <a href="home.jsp" class="btn btn-primary btn-lg">
                    <i class="bi bi-arrow-left"></i> Continue Shopping
                </a>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({
            duration: 800,
            offset: 100,
            once: true
        });

        // Voice Search Implementation
        document.addEventListener('DOMContentLoaded', function() {
            const voiceSearchBtn = document.getElementById('voiceSearchBtn');
            const searchInput = document.getElementById('searchInput');
            
            // Check if browser supports speech recognition
            if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
                const SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
                const recognition = new SpeechRecognition();
                
                recognition.continuous = false;
                recognition.interimResults = false;
                recognition.lang = 'en-US';

                voiceSearchBtn.addEventListener('click', function() {
                    if (voiceSearchBtn.classList.contains('listening')) {
                        recognition.stop();
                    } else {
                        recognition.start();
                        voiceSearchBtn.classList.add('listening');
                        voiceSearchBtn.querySelector('.voice-search-tooltip').textContent = 'Listening...';
                    }
                });

                recognition.onresult = function(event) {
                    const transcript = event.results[0][0].transcript;
                    searchInput.value = transcript;
                    voiceSearchBtn.classList.remove('listening');
                    voiceSearchBtn.querySelector('.voice-search-tooltip').textContent = 'Click to search by voice';
                    
                    // Auto submit the form after voice input
                    setTimeout(() => {
                        searchInput.form.submit();
                    }, 500);
                };

                recognition.onerror = function(event) {
                    console.error('Speech recognition error:', event.error);
                    voiceSearchBtn.classList.remove('listening');
                    voiceSearchBtn.querySelector('.voice-search-tooltip').textContent = 'Click to search by voice';
                };

                recognition.onend = function() {
                    voiceSearchBtn.classList.remove('listening');
                    voiceSearchBtn.querySelector('.voice-search-tooltip').textContent = 'Click to search by voice';
                };
            } else {
                voiceSearchBtn.style.display = 'none';
                console.log('Speech recognition not supported');
            }
        });
    </script>
</body>
</html> 