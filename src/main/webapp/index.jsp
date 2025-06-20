<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mobile Store - Your One-Stop Shop for Mobile Devices</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/8.4.5/swiper-bundle.min.css">
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

        /* Enhanced Hero Section */
        .hero-section {
            position: relative;
            overflow: hidden;
            padding: 100px 0;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .floating-mobiles {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            pointer-events: none;
        }

        .mobile {
            position: absolute;
            width: 100px;
            height: 200px;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>') center/contain no-repeat;
            opacity: 0.1;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(10px, -10px) rotate(5deg); }
            50% { transform: translate(0, -20px) rotate(0deg); }
            75% { transform: translate(-10px, -10px) rotate(-5deg); }
        }

        /* Enhanced Product Cards */
        .product-card {
            perspective: 1000px;
            height: 70000px; /* Match category item height */
            max-height:400px;
            width: 100%;
            max-width: 350px;
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            margin-bottom: 15px auto;
        }

        .product-inner {
            position: relative;
            width: 100%;
            height: 100%;
            transform-style: preserve-3d;
            transition: transform 0.8s;
        }

        .product-card:hover .product-inner {
            transform: rotateY(180deg);
        }

        .product-front, .product-back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            border-radius: 15px;
            overflow: hidden;
        }

        .product-front {
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 10px;
        }

        .product-back {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            transform: rotateY(180deg);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 15px;
        }

        .product-image {
        max-height: 220px;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.1);
        }

        .product-details {
            text-align: center;
            padding: 25px;
        }

        .product-details h4 {
            margin-bottom: 10px;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .product-details p {
            margin-bottom: 15px;
            opacity: 0.9;
            font-size: 0.9rem;
        }

        .product-features {
            list-style: none;
            padding: 0;
            margin: 0 0 15px 0;
        }

        .product-features li {
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .product-features li i {
            margin-right: 8px;
            color: var(--accent-color);
        }

        .product-price {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .product-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .product-actions .btn {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.9rem;
        }

        /* Dynamic Category Cards */
        .category-card {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
            transition: all 0.3s ease;
        }

        .category-card img {
            transition: transform 0.5s ease;
        }

        .category-card:hover img {
            transform: scale(1.1);
        }

        .category-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
            padding: 20px;
            color: white;
            transform: translateY(100%);
            transition: transform 0.3s ease;
        }

        .category-card:hover .category-overlay {
            transform: translateY(0);
        }

        /* Interactive Services Section */
        .service-card {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            background: var(--card-bg);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            height: 250px; /* Reduced height */
        }

        .service-icon {
            width: 60px; /* Reduced size */
            height: 60px;
            background: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 15px auto 10px;
        }

        .service-icon i {
            font-size: 1.5rem; /* Reduced icon size */
            color: white;
        }

        .service-content {
            padding: 10px;
            text-align: center;
            position: relative;
        }

        .service-content h4 {
            font-size: 1.1rem;
            margin-bottom: 8px;
        }

        .service-content p {
            font-size: 0.85rem;
            margin-bottom: 10px;
        }

        .service-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(37, 99, 235, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
            padding: 10px;
        }

        .service-card:hover .service-overlay {
            opacity: 1;
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        }

        /* Dynamic Newsletter Section */
        .newsletter-section {
            display: none;
        }

        .newsletter-section::before {
            display: none;
        }

        /* Enhanced Navigation */
        .navbar {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.9) !important;
        }

        .navbar-brand {
            font-weight: bold;
            color: #2563eb !important;
        }

        .navbar-brand i {
            color: #2563eb;
        }

        .nav-link {
            position: relative;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background: var(--primary-color);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .nav-link:hover::after {
            transform: scaleX(1);
        }

        /* Product Slider */
        .product-slider {
            padding: 20px 0;
        }

        .swiper-slide {
            height: auto;
        }

        /* Dynamic Footer */
        footer {
            position: relative;
            overflow: hidden;
        }

        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, rgba(255,255,255,0.1), transparent);
            transform: skewY(-3deg);
            transform-origin: top left;
        }

        /* Account Dropdown Styles */
        .dropdown-menu {
            border: none;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            border-radius: 0.5rem;
            padding: 0.5rem;
            min-width: 280px;
        }

        .dropdown-item {
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: all 0.2s ease;
        }

        .dropdown-item:hover {
            background-color: var(--primary-color);
            color: white;
        }

        .dropdown-item i {
            width: 1.25rem;
            text-align: center;
        }

        .dropdown-divider {
            margin: 0.5rem 0;
        }

        /* Cart Badge Animation */
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .badge {
            animation: pulse 2s infinite;
        }

        /* Account Icon Hover Effect */
        .nav-link i {
            transition: transform 0.2s ease;
        }

        .nav-link:hover i {
            transform: scale(1.1);
        }

        /* Hero Section Styles */
        .hero-image-container {
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        }

        .hero-image {
            transition: transform 0.3s ease;
        }

        .hero-image-container:hover .hero-image {
            transform: scale(1.05);
        }

        .floating-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            animation: float 3s ease-in-out infinite;
        }

        /* Trending Section Styles */
        .trending-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .trending-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        }

        .trending-image {
            position: relative;
            overflow: hidden;
        }

        .trending-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .trending-card:hover .trending-overlay {
            opacity: 1;
        }

        .trending-content {
            padding: 20px;
        }

        /* Features Section Styles */
        .feature-card {
            text-align: center;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            background: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        .feature-icon i {
            font-size: 2rem;
            color: white;
        }

        /* Add these new styles */
        .stats-counter {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            padding: 80px 0;
            position: relative;
            overflow: hidden;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            color: white;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-10px);
            background: rgba(255, 255, 255, 0.2);
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        /* Remove testimonial styles */
        .testimonial-section {
            display: none;
        }

        .testimonial-card {
            display: none;
        }

        .testimonial-image {
            display: none;
        }

        .product-showcase {
            position: relative;
            padding: 100px 0;
            background: #f8f9fa;
        }

        .showcase-card {
            perspective: 1000px;
            height: 400px;
        }

        .showcase-inner {
            position: relative;
            width: 100%;
            height: 100%;
            transform-style: preserve-3d;
            transition: transform 0.8s;
        }

        .showcase-card:hover .showcase-inner {
            transform: rotateY(180deg);
        }

        .showcase-front, .showcase-back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            border-radius: 20px;
            overflow: hidden;
        }

        .showcase-back {
            background: white;
            transform: rotateY(180deg);
            padding: 30px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* 4 items per row */
            gap: 20px;
            padding: 30px 0;
        }

        .category-item {
            position: relative;
            height: 250px; /* Reduced height */
            border-radius: 15px;
            overflow: hidden;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            margin-bottom: 15px;
        }

        .category-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        .category-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .category-content {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 15px;
            background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
            color: white;
            transform: translateY(100%);
            transition: transform 0.3s ease;
        }

        .category-item:hover .category-content {
            transform: translateY(0);
        }

        .category-item:hover img {
            transform: scale(1.1);
        }

        .category-content h4 {
            margin-bottom: 5px;
            font-size: 1.1rem;
        }

        .category-content p {
            margin: 0;
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .floating-mobiles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .mobile {
            position: absolute;
            width: 100px;
            height: 200px;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234f46e5"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>') center/contain no-repeat;
            opacity: 0.1;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(10px, -10px) rotate(5deg); }
            50% { transform: translate(0, -20px) rotate(0deg); }
            75% { transform: translate(-10px, -10px) rotate(-5deg); }
        }

        /* Update section spacing */
        .featured-products {
            padding: 40px 0;
        }

        .category-carousel {
            position: relative;
            padding: 10px 0;
            margin-bottom: 20px;
        }

        h2.text-center {
            margin-bottom: 30px !important;
        }

        .section-header {
            margin-bottom: 30px;
        }

        /* Update card spacing */
        .product-card {
            margin-bottom: 15px;
        }

        .category-item {
            margin-bottom: 15px;
        }

        /* Update grid spacing */
        .row.g-4 {
            gap: 15px !important;
        }

        /* Update Category Carousel Styles */
        .category-carousel {
            position: relative;
            padding: 10px 0;
            margin-bottom: 20px;
        }

        .category-slider {
            display: flex;
            gap: 20px;
            overflow-x: auto;
            scroll-behavior: smooth;
            padding: 10px;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: none; /* Firefox */
            -ms-overflow-style: none; /* IE and Edge */
        }

        .category-slider::-webkit-scrollbar {
            display: none; /* Chrome, Safari, Opera */
        }

        .category-item {
            flex: 0 0 250px; /* Fixed width for each item */
            height: 200px;
            border-radius: 12px;
            overflow: hidden;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .category-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        .category-content {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 12px;
            background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
            color: white;
            transform: translateY(100%);
            transition: transform 0.3s ease;
        }

        .category-item:hover .category-content {
            transform: translateY(0);
        }

        .category-content h4 {
            margin-bottom: 4px;
            font-size: 1rem;
        }

        .category-content p {
            margin: 0;
            font-size: 0.85rem;
            opacity: 0.9;
        }

        .carousel-controls {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 100%;
            display: flex;
            justify-content: space-between;
            padding: 0 20px;
        }

        .carousel-control {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .carousel-control:hover {
            background: white;
            transform: scale(1.1);
        }

        .carousel-control i {
            font-size: 1.2rem;
            color: var(--primary-color);
        }

        /* Add new styles for trending products and sidebar */
        .trending-heading {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 8px;
        }

        .product-card {
            border: 1px solid rgba(0, 0, 0, 0.1);
            text-align: center;
            padding: 15px;
            height: 100%;
            border-radius: 12px;
            background: var(--card-bg);
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .product-card img {
            height: 100px;
            object-fit: contain;
            margin-bottom: 10px;
        }

        .product-card h6 {
            color: var(--secondary-color);
            margin: 10px 0;
        }

        .product-card .text-danger {
            color: var(--primary-color) !important;
            font-weight: 600;
        }

        .product-card .btn-warning {
            background: var(--accent-color);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }

        .product-card .btn-warning:hover {
            background: var(--secondary-color);
            transform: scale(1.05);
        }

        .sidebar-box {
            background: var(--card-bg);
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
            border: 1px solid rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .sidebar-box h6 {
            color: var(--secondary-color);
            margin-bottom: 15px;
        }

        .sidebar-box img {
            width: 80px;
            border-radius: 50%;
            border: 3px solid var(--primary-color);
            padding: 3px;
            margin-bottom: 10px;
        }

        .sidebar-box small {
            color: var(--text-light);
        }

        .newsletter input {
            width: 100%;
            margin-bottom: 10px;
            border: 1px solid rgba(0, 0, 0, 0.1);
            padding: 8px 12px;
            border-radius: 6px;
        }

        .social-icons a {
            color: var(--primary-color) !important;
            margin: 0 5px;
            transition: all 0.3s ease;
        }

        .social-icons a:hover {
            color: var(--secondary-color) !important;
            transform: scale(1.2);
        }

        .trending-products-section {
            padding-top: 20px;
        }

        /* Add Product Counter Card Styles */
        .product-counter-card {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 12px;
            padding: 15px;
            color: white;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .counter-info h4 {
            margin: 0;
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .counter-number {
            font-size: 2rem;
            font-weight: bold;
            margin: 0;
            line-height: 1;
        }

        .counter-icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .counter-icon i {
            font-size: 1.5rem;
            color: white;
        }

        /* Flip Card Styles */
        .flip-card {
            background-color: transparent;
            width: 100%;
            height: 400px;
            perspective: 1000px;
            margin-bottom: 30px;
        }

        .flip-card-inner {
            position: relative;
            width: 100%;
            height: 100%;
            text-align: center;
            transition: transform 0.8s;
            transform-style: preserve-3d;
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
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .flip-card-front {
            background: white;
            padding: 2rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .flip-card-front img {
            max-width: 60%;
            max-height: 60%;
            object-fit: contain;
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease;
        }

        .flip-card:hover .flip-card-front img {
            transform: scale(1.1);
        }

        .flip-card-front h3 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
        }

        .flip-card-front .price {
            color: var(--text-light);
            font-size: 1.25rem;
            font-weight: 600;
        }

        .flip-card-back {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            transform: rotateY(180deg);
            padding: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .flip-card-back h4 {
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            color: white;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin: 0 0 2rem 0;
            text-align: left;
            width: 100%;
        }

        .feature-list li {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 1rem;
        }

        .feature-list li i {
            margin-right: 0.75rem;
            color: white;
            font-size: 1.1rem;
        }

        .flip-card-btn {
            background: white;
            color: var(--primary-color);
            padding: 0.75rem 2rem;
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

        /* Existing styles continue below */
        .navbar .nav-link:hover {
            color: var(--primary-color);
        }

        /* Search Form Styles */
        .navbar form .input-group {
            width: 300px;
        }

        .navbar form .form-control {
            border-radius: 20px 0 0 20px;
            border: 1px solid #dee2e6;
            padding: 0.5rem 1rem;
        }

        .navbar form .form-control:focus {
            box-shadow: none;
            border-color: var(--primary-color);
        }

        .navbar form .btn {
            border-radius: 0 20px 20px 0;
            padding: 0.5rem 1.25rem;
        }

        @media (max-width: 991.98px) {
            .navbar form {
                margin: 1rem 0;
                width: 100%;
            }
            
            .navbar form .input-group {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>
    
    <!-- Enhanced Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp" data-aos="fade-right">
                <i class="bi bi-phone"></i> PN MobileStore
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#services">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about_us.jsp">About Us</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="contact_us.jsp">Contact</a>
                    </li>
                </ul>
                <!-- Search Form -->
                <form action="SearchServlet" method="GET" class="d-flex me-auto">
                    <div class="input-group">
                        <input type="text" name="query" class="form-control" placeholder="Search products..." required>
                        <button class="btn btn-outline-primary" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>
                <div class="d-flex align-items-center">
                    <a href="login.jsp" class="btn btn-outline-primary me-2">
                        <i class="bi bi-box-arrow-in-right"></i> Login
                    </a>
                    <a href="register.jsp" class="btn btn-primary">
                        <i class="bi bi-person-plus"></i> Register
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section with 3D Effect -->
    <section class="hero-section">
        <div class="floating-mobiles">
            <div class="mobile mobile-right-1"></div>
            <div class="mobile mobile-right-2"></div>
            <div class="mobile mobile-left-1"></div>
            <div class="mobile mobile-left-2"></div>
            <div class="mobile mobile-top-1"></div>
            <div class="mobile mobile-top-2"></div>
        </div>
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 hero-content" data-aos="fade-right">
                    <h1 class="display-4 fw-bold mb-4">Discover the Future of Mobile Technology</h1>
                    <p class="lead mb-4">Experience cutting-edge smartphones, accessories, and services at unbeatable prices.</p>
                    <div class="d-flex gap-3">
                        <a href="products.jsp" class="btn btn-primary btn-lg">
                            <i class="bi bi-phone"></i> Shop Now
                        </a>
                        <a href="bookservice.jsp" class="btn btn-outline-light btn-lg">
                            <i class="bi bi-tools"></i> Book Service
                        </a>
                    </div>
                </div>
                <div class="col-lg-6" data-aos="fade-left">
                    <div class="hero-image-container">
                        <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" 
                             alt="Latest Mobile Devices" class="img-fluid hero-image">
                        <div class="floating-badge">
                            <span class="badge bg-primary">New Arrivals</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Update Featured Products Section -->
    <section id="featured-products" class="featured-products py-5">
        <div class="container">
            <div class="trending-heading p-2 mb-4 fw-bold" data-aos="fade-up">
                FEATURED PRODUCTS
            </div>
            <div class="row g-3">
                <div class="col-md-3" data-aos="fade-up">
                    <div class="product-card">
                        <div class="product-inner">
                            <div class="product-front">
                                <img src="https://images.unsplash.com/photo-1598327105666-5b89351aff97?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" 
                                     alt="Latest Smartphone" class="product-image">
                            </div>
                            <div class="product-back">
                                <div class="product-details">
                                    <h4>Latest Smartphone</h4>
                                    <p>Experience the future of mobile technology</p>
                                    <ul class="product-features">
                                        <li><i class="bi bi-camera"></i> 48MP Quad Camera</li>
                                        <li><i class="bi bi-battery-full"></i> 5000mAh Battery</li>
                                        <li><i class="bi bi-cpu"></i> Snapdragon 8 Gen 2</li>
                                        <li><i class="bi bi-display"></i> 6.7" AMOLED Display</li>
                                    </ul>
                                    <div class="product-price">₹49,999</div>
                                    <div class="product-actions">
                                        <a href="#" class="btn btn-light">View Details</a>
                                        <a href="#" class="btn btn-outline-light">Add to Cart</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="product-card">
                        <div class="product-inner">
                            <div class="product-front">
                                <img src="https://images.unsplash.com/photo-1579586337278-3befd40fd17a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" 
                                     alt="Premium Smart Watch" class="product-image">
                            </div>
                            <div class="product-back">
                                <div class="product-details">
                                    <h4>Premium Smart Watch</h4>
                                    <p>Stay connected in style</p>
                                    <ul class="product-features">
                                        <li><i class="bi bi-heart-pulse"></i> Health Monitoring</li>
                                        <li><i class="bi bi-battery-full"></i> 7-day Battery Life</li>
                                        <li><i class="bi bi-water"></i> Water Resistant</li>
                                        <li><i class="bi bi-phone"></i> Smart Notifications</li>
                                    </ul>
                                    <div class="product-price">₹24,999</div>
                                    <div class="product-actions">
                                        <a href="#" class="btn btn-light">View Details</a>
                                        <a href="#" class="btn btn-outline-light">Add to Cart</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="product-card">
                        <div class="product-inner">
                            <div class="product-front">
                                <img src="https://images.unsplash.com/photo-1606220588911-5117e04b8024?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" 
                                     alt="Wireless Earbuds" class="product-image">
                            </div>
                            <div class="product-back">
                                <div class="product-details">
                                    <h4>Wireless Earbuds</h4>
                                    <p>Premium sound quality</p>
                                    <ul class="product-features">
                                        <li><i class="bi bi-music-note"></i> Hi-Fi Sound</li>
                                        <li><i class="bi bi-battery-full"></i> 30hr Playtime</li>
                                        <li><i class="bi bi-ear"></i> Noise Cancellation</li>
                                        <li><i class="bi bi-water"></i> Sweat Resistant</li>
                                    </ul>
                                    <div class="product-price">₹12,999</div>
                                    <div class="product-actions">
                                        <a href="#" class="btn btn-light">View Details</a>
                                        <a href="#" class="btn btn-outline-light">Add to Cart</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="product-card">
                        <div class="product-inner">
                            <div class="product-front">
                                <img src="https://images.unsplash.com/photo-1585771724684-38269d6639fd?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" 
                                     alt="Power Bank" class="product-image">
                            </div>
                            <div class="product-back">
                                <div class="product-details">
                                    <h4>Fast Charging Power Bank</h4>
                                    <p>Never run out of power</p>
                                    <ul class="product-features">
                                        <li><i class="bi bi-lightning"></i> 100W Fast Charging</li>
                                        <li><i class="bi bi-battery-full"></i> 20000mAh Capacity</li>
                                        <li><i class="bi bi-phone"></i> Multiple Ports</li>
                                        <li><i class="bi bi-shield-check"></i> Safety Protection</li>
                                    </ul>
                                    <div class="product-price">₹2,999</div>
                                    <div class="product-actions">
                                        <a href="#" class="btn btn-light">View Details</a>
                                        <a href="#" class="btn btn-outline-light">Add to Cart</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Interactive Category Carousel -->
    <section id="categories" class="py-5">
        <div class="container">
            <div class="trending-heading p-2 mb-4 fw-bold" data-aos="fade-up">
                SHOP BY CATEGORY
            </div>
            <div class="category-carousel">
                <div class="category-slider">
                    <div class="category-item" data-aos="fade-up">
                        <img src="https://images.unsplash.com/photo-1598327105666-5b89351aff97?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" 
                             alt="iPhone 15 Pro">
                        <div class="category-content">
                            <h4>iPhone 15 Pro</h4>
                            <p>Starting from ₹1,29,900</p>
                        </div>
                    </div>
                    <div class="category-item" data-aos="fade-up" data-aos-delay="100">
                        <img src="https://images.unsplash.com/photo-1579586337278-3befd40fd17a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" 
                             alt="Samsung Galaxy S24">
                        <div class="category-content">
                            <h4>Samsung Galaxy S24</h4>
                            <p>Starting from ₹79,999</p>
                        </div>
                    </div>
                    <div class="category-item" data-aos="fade-up" data-aos-delay="200">
                        <img src="https://images.unsplash.com/photo-1606220588911-5117e04b8024?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" 
                             alt="OnePlus 12">
                        <div class="category-content">
                            <h4>OnePlus 12</h4>
                            <p>Starting from ₹64,999</p>
                        </div>
                    </div>
                    <div class="category-item" data-aos="fade-up" data-aos-delay="300">
                        <img src="https://images.unsplash.com/photo-1585771724684-38269d6639fd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" 
                             alt="Google Pixel 8">
                        <div class="category-content">
                            <h4>Google Pixel 8</h4>
                            <p>Starting from ₹75,999</p>
                        </div>
                    </div>
                    <div class="category-item" data-aos="fade-up" data-aos-delay="400">
                        <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" 
                             alt="Xiaomi 14 Pro">
                        <div class="category-content">
                            <h4>Xiaomi 14 Pro</h4>
                            <p>Starting from ₹59,999</p>
                        </div>
                    </div>
                    <div class="category-item" data-aos="fade-up" data-aos-delay="500">
                        <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" 
                             alt="Vivo X100 Pro">
                        <div class="category-content">
                            <h4>Vivo X100 Pro</h4>
                            <p>Starting from ₹69,999</p>
                        </div>
                    </div>
                    <div class="category-item" data-aos="fade-up" data-aos-delay="600">
                        <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" 
                             alt="OPPO Find X6">
                        <div class="category-content">
                            <h4>OPPO Find X6</h4>
                            <p>Starting from ₹54,999</p>
                        </div>
                    </div>
                    <div class="category-item" data-aos="fade-up" data-aos-delay="700">
                        <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" 
                             alt="Nothing Phone 2">
                        <div class="category-content">
                            <h4>Nothing Phone 2</h4>
                            <p>Starting from ₹44,999</p>
                        </div>
                    </div>
                </div>
                <div class="carousel-controls">
                    <div class="carousel-control prev">
                        <i class="bi bi-chevron-left"></i>
                    </div>
                    <div class="carousel-control next">
                        <i class="bi bi-chevron-right"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Add Trending Products and Sidebar Section -->
    <section class="trending-products-section py-5">
        <div class="container">
            <div class="row">
                <!-- Products -->
                <div class="col-lg-9">
                    <div class="trending-heading p-2 mb-4 fw-bold" data-aos="fade-up">
                        TRENDING PRODUCTS
                    </div>
                    <div class="row">
                        <!-- Product Cards -->
                        <div class="col-md-3 mb-4" data-aos="fade-up">
                            <div class="product-card">
                                <img src="https://images.unsplash.com/photo-1598327105666-5b89351aff97?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="iPhone 15 Pro">
                                <h6>iPhone 15 Pro</h6>
                                <p class="text-danger">₹1,29,900</p>
                                <button class="btn btn-warning btn-sm">Add To Cart</button>
                            </div>
                        </div>
                        <div class="col-md-3 mb-4" data-aos="fade-up" data-aos-delay="100">
                            <div class="product-card">
                                <img src="https://images.unsplash.com/photo-1579586337278-3befd40fd17a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Samsung Galaxy S24">
                                <h6>Samsung Galaxy S24</h6>
                                <p class="text-danger">₹79,999</p>
                                <button class="btn btn-warning btn-sm">Add To Cart</button>
                            </div>
                        </div>
                        <div class="col-md-3 mb-4" data-aos="fade-up" data-aos-delay="200">
                            <div class="product-card">
                                <img src="https://images.unsplash.com/photo-1606220588911-5117e04b8024?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="OnePlus 12">
                                <h6>OnePlus 12</h6>
                                <p class="text-danger">₹64,999</p>
                                <button class="btn btn-warning btn-sm">Add To Cart</button>
                            </div>
                        </div>
                        <div class="col-md-3 mb-4" data-aos="fade-up" data-aos-delay="300">
                            <div class="product-card">
                                <img src="https://images.unsplash.com/photo-1585771724684-38269d6639fd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Google Pixel 8">
                                <h6>Google Pixel 8</h6>
                                <p class="text-danger">₹75,999</p>
                                <button class="btn btn-warning btn-sm">Add To Cart</button>
                            </div>
                        </div>
                        <div class="col-md-3 mb-4" data-aos="fade-up" data-aos-delay="400">
                            <div class="product-card">
                                <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Xiaomi 14 Pro">
                                <h6>Xiaomi 14 Pro</h6>
                                <p class="text-danger">₹59,999</p>
                                <button class="btn btn-warning btn-sm">Add To Cart</button>
                            </div>
                        </div>
                        <div class="col-md-3 mb-4" data-aos="fade-up" data-aos-delay="500">
                            <div class="product-card">
                                <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Vivo X100 Pro">
                                <h6>Vivo X100 Pro</h6>
                                <p class="text-danger">₹69,999</p>
                                <button class="btn btn-warning btn-sm">Add To Cart</button>
                            </div>
                        </div>
                        <div class="col-md-3 mb-4" data-aos="fade-up" data-aos-delay="600">
                            <div class="product-card">
                                <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="OPPO Find X6">
                                <h6>OPPO Find X6</h6>
                                <p class="text-danger">₹54,999</p>
                                <button class="btn btn-warning btn-sm">Add To Cart</button>
                            </div>
                        </div>
                        <div class="col-md-3 mb-4" data-aos="fade-up" data-aos-delay="700">
                            <div class="product-card">
                                <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Nothing Phone 2">
                                <h6>Nothing Phone 2</h6>
                                <p class="text-danger">₹44,999</p>
                                <button class="btn btn-warning btn-sm">Add To Cart</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="col-lg-3">
                    <div class="sidebar-box" data-aos="fade-left">
                        <h6>OUR TESTIMONIAL</h6>
                        <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Testimonial">
                        <h6>STEPHAN ROBOT</h6>
                        <small class="text-muted">WEB DESIGNER</small>
                        <p class="mt-2">Duis faucibus enim vitae nunc molestie, nec facilisis arcu pulvinar nullam mattis nullam mattis.</p>
                    </div>
                    <div class="sidebar-box newsletter" data-aos="fade-left" data-aos-delay="100">
                        <h6>NEWSLETTER</h6>
                        <p>Join Our Mailing List</p>
                        <input type="email" placeholder="E-mail" class="form-control">
                        <button class="btn btn-warning btn-sm w-100 mt-2">Subscribe</button>
                        <div class="social-icons mt-3">
                            <a href="#"><i class="bi bi-facebook"></i></a>
                            <a href="#"><i class="bi bi-twitter"></i></a>
                            <a href="#"><i class="bi bi-instagram"></i></a>
                            <a href="#"><i class="bi bi-youtube"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Update Services Section -->
    <section id="services" class="services-section py-5">
        <div class="container">
            <div class="trending-heading p-2 mb-4 fw-bold" data-aos="fade-up">
                OUR SERVICES
            </div>
            <div class="row g-3">
                <div class="col-md-4" data-aos="fade-up">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="bi bi-tools"></i>
                        </div>
                        <div class="service-content">
                            <h4>Repair Services</h4>
                            <p>Professional repair services for all mobile devices</p>
                            <div class="service-overlay">
                                <a href="bookservice.jsp" class="btn btn-primary">Book Now</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <div class="service-content">
                            <h4>Warranty</h4>
                            <p>Extended warranty options for peace of mind</p>
                            <div class="service-overlay">
                                <a href="bookservice.jsp" class="btn btn-primary">Learn More</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="bi bi-truck"></i>
                        </div>
                        <div class="service-content">
                            <h4>Fast Delivery</h4>
                            <p>Quick and reliable shipping options</p>
                            <div class="service-overlay">
                                <a href="bookservice.jsp" class="btn btn-primary">Track Order</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Feature Products Section with Flip Effect -->
    <section class="feature-products py-5">
        <div class="container">
            <h2 class="text-center mb-5">Feature Products</h2>
            <div class="row g-4">
                <!-- Feature Product Card 1 -->
                <div class="col-lg-4 col-md-6">
                    <div class="flip-card">
                        <div class="flip-card-inner">
                            <div class="flip-card-front">
                                <img src="https://www.pngmart.com/files/22/iPhone-14-Pro-PNG-Photos.png" alt="iPhone 14 Pro">
                                <h3>iPhone 14 Pro</h3>
                                <p class="price">$999</p>
                            </div>
                            <div class="flip-card-back">
                                <h4>iPhone 14 Pro</h4>
                                <ul class="feature-list">
                                    <li><i class="bi bi-check-circle"></i> A16 Bionic Chip</li>
                                    <li><i class="bi bi-check-circle"></i> Pro Camera System</li>
                                    <li><i class="bi bi-check-circle"></i> Dynamic Island</li>
                                    <li><i class="bi bi-check-circle"></i> ProMotion Display</li>
                                </ul>
                                <a href="#" class="flip-card-btn">Learn More</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Feature Product Card 2 -->
                <div class="col-lg-4 col-md-6">
                    <div class="flip-card">
                        <div class="flip-card-inner">
                            <div class="flip-card-front">
                                <img src="https://www.pngmart.com/files/22/Samsung-Galaxy-S23-Ultra-PNG-Picture.png" alt="Samsung S23 Ultra">
                                <h3>Samsung S23 Ultra</h3>
                                <p class="price">$1199</p>
                            </div>
                            <div class="flip-card-back">
                                <h4>Samsung S23 Ultra</h4>
                                <ul class="feature-list">
                                    <li><i class="bi bi-check-circle"></i> Snapdragon 8 Gen 2</li>
                                    <li><i class="bi bi-check-circle"></i> 200MP Camera</li>
                                    <li><i class="bi bi-check-circle"></i> S Pen Support</li>
                                    <li><i class="bi bi-check-circle"></i> 5000mAh Battery</li>
                                </ul>
                                <a href="#" class="flip-card-btn">Learn More</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Feature Product Card 3 -->
                <div class="col-lg-4 col-md-6">
                    <div class="flip-card">
                        <div class="flip-card-inner">
                            <div class="flip-card-front">
                                <img src="https://www.pngmart.com/files/22/Nothing-Phone-1-PNG-HD-Isolated.png" alt="Nothing Phone">
                                <h3>Nothing Phone</h3>
                                <p class="price">$749</p>
                            </div>
                            <div class="flip-card-back">
                                <h4>Nothing Phone</h4>
                                <ul class="feature-list">
                                    <li><i class="bi bi-check-circle"></i> Glyph Interface</li>
                                    <li><i class="bi bi-check-circle"></i> Dual Camera</li>
                                    <li><i class="bi bi-check-circle"></i> OLED Display</li>
                                    <li><i class="bi bi-check-circle"></i> Wireless Charging</li>
                                </ul>
                                <a href="#" class="flip-card-btn">Learn More</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/8.4.5/swiper-bundle.min.js"></script>
    <script>
        // Initialize AOS
        AOS.init({
            duration: 1000,
            once: true
        });

        // Initialize Swiper
        new Swiper('.product-slider', {
            slidesPerView: 1,
            spaceBetween: 30,
            loop: true,
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: 2,
                },
                1024: {
                    slidesPerView: 3,
                },
            }
        });

        // Add floating animation to devices
        document.querySelectorAll('.mobile').forEach((device, index) => {
            device.style.animationDelay = `${index * 2}s`;
        });

        // Product Counter Animation
        function animateCounter(element) {
            const target = parseInt(element.getAttribute('data-count'));
            let count = 0;
            const duration = 2000; // 2 seconds
            const increment = target / (duration / 16); // 60fps

            function updateCount() {
                if (count < target) {
                    count += increment;
                    element.textContent = Math.min(Math.round(count), target);
                    requestAnimationFrame(updateCount);
                } else {
                    element.textContent = target;
                }
            }

            updateCount();
        }

        // Initialize counter when it comes into view
        const counterElement = document.querySelector('.counter-number');
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateCounter(entry.target);
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.5 });

        if (counterElement) {
            observer.observe(counterElement);
        }

        // Smooth scroll for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('href');
                const targetElement = document.querySelector(targetId);
                
                if (targetElement) {
                    window.scrollTo({
                        top: targetElement.offsetTop - 80,
                        behavior: 'smooth'
                    });
                    
                    document.querySelectorAll('.nav-link').forEach(link => {
                        link.classList.remove('active');
                    });
                    this.classList.add('active');
                }
            });
        });

        // Highlight active nav link on scroll
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('section[id]');
            const navLinks = document.querySelectorAll('.nav-link');
            
            let current = '';
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;
                if (pageYOffset >= sectionTop - 100) {
                    current = section.getAttribute('id');
                }
            });

            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === `#${current}`) {
                    link.classList.add('active');
                }
            });
        });

        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Add hover effect to dropdown items
        const dropdownItems = document.querySelectorAll('.dropdown-item');
        dropdownItems.forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateX(5px)';
            });
            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateX(0)';
            });
        });

        // Category Carousel Controls
        const slider = document.querySelector('.category-slider');
        const prevBtn = document.querySelector('.carousel-control.prev');
        const nextBtn = document.querySelector('.carousel-control.next');

        if (slider && prevBtn && nextBtn) {
            prevBtn.addEventListener('click', () => {
                slider.scrollBy({
                    left: -250,
                    behavior: 'smooth'
                });
            });

            nextBtn.addEventListener('click', () => {
                slider.scrollBy({
                    left: 250,
                    behavior: 'smooth'
                });
            });
        }
    </script>
</body>
</html> 