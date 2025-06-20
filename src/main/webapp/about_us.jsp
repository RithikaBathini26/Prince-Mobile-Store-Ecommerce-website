<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>About Us - PN MobileStore</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --background-light: #f8f9fa;
            --text-light: #6b7280;
            --card-bg: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: var(--background-light);
            line-height: 1.6;
        }

        .about-hero {
            position: relative;
            height: 60vh;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.9), rgba(30, 64, 175, 0.9)), url('https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/Shreyansh/BAU/Unrexc/D70978891_INWLD_BAU_Unrec_Uber_PC_Hero_3000x1200._CB594707876_.jpg');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            overflow: hidden;
        }

        .about-hero::before {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.3) 0%, transparent 70%);
            animation: pulse 4s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.3; }
            50% { transform: scale(1.2); opacity: 0.1; }
        }

        .hero-content {
            position: relative;
            z-index: 1;
            padding: 0 20px;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .hero-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        .about-section {
            position: relative;
            margin-top: -100px;
            padding: 0 20px;
            z-index: 2;
        }

        .about-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .about-card {
            background: var(--card-bg);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 3rem;
        }

        .section-title {
            color: var(--primary-color);
            font-size: 2rem;
            margin-bottom: 1.5rem;
            position: relative;
            padding-bottom: 1rem;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border-radius: 3px;
        }

        .value-card {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .value-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.15);
        }

        .value-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            color: white;
            font-size: 1.5rem;
        }

        .value-card h3 {
            color: var(--primary-color);
            font-size: 1.3rem;
            margin-bottom: 1rem;
        }

        .value-card p {
            color: var(--text-light);
            margin: 0;
        }

        .team-member {
            text-align: center;
            margin-bottom: 2rem;
        }

        .member-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            margin-bottom: 1.5rem;
            object-fit: cover;
            border: 3px solid var(--primary-color);
            padding: 5px;
        }

        .member-name {
            color: var(--primary-color);
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }

        .member-position {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .stats-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            padding: 4rem 0;
            color: white;
            margin: 3rem 0;
            border-radius: 20px;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* Store Location Styles */
        .store-location {
            background: var(--card-bg);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 3rem;
            overflow: hidden;
        }

        .location-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }

        .location-info {
            padding-right: 2rem;
        }

        .store-details {
            margin-top: 2rem;
        }

        .store-detail-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 1.5rem;
            padding: 1rem;
            background: rgba(37, 99, 235, 0.05);
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .store-detail-item:hover {
            transform: translateX(10px);
            background: rgba(37, 99, 235, 0.1);
        }

        .detail-icon {
            width: 45px;
            height: 45px;
            min-width: 45px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            margin-right: 1rem;
        }

        .detail-content h4 {
            color: var(--primary-color);
            font-size: 1.1rem;
            margin-bottom: 0.3rem;
        }

        .detail-content p {
            color: var(--text-light);
            font-size: 0.9rem;
            margin: 0;
        }

        .map-container {
            position: relative;
            height: 100%;
            min-height: 400px;
            border-radius: 15px;
            overflow: hidden;
        }

        .map-container iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        .store-hours {
            margin-top: 2rem;
            padding: 1.5rem;
            background: rgba(37, 99, 235, 0.05);
            border-radius: 12px;
        }

        .hours-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .hours-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem;
            border-bottom: 1px dashed rgba(37, 99, 235, 0.2);
        }

        .hours-item:last-child {
            border-bottom: none;
        }

        .day {
            color: var(--primary-color);
            font-weight: 500;
        }

        .time {
            color: var(--text-light);
        }

        .contact-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .action-btn {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 1rem;
            border: none;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .call-btn {
            background: var(--primary-color);
            color: white;
        }

        .direction-btn {
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary-color);
        }

        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.2);
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }

            .about-hero {
                height: 50vh;
            }

            .about-section {
                margin-top: -50px;
            }

            .about-card {
                padding: 2rem;
            }

            .stat-item {
                margin-bottom: 2rem;
            }

            .location-grid {
                grid-template-columns: 1fr;
            }

            .location-info {
                padding-right: 0;
            }

            .map-container {
                min-height: 300px;
            }

            .contact-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <section class="about-hero">
        <div class="hero-content">
            <h1 class="hero-title">About Us</h1>
            <p class="hero-subtitle">Discover our story, mission, and the team behind PN MobileStore</p>
        </div>
    </section>

    <!-- About Section -->
    <section class="about-section">
        <div class="about-container">
            <!-- Our Story -->
            <div class="about-card">
                <h2 class="section-title">Our Story</h2>
                <p class="mb-4">Founded in 2024, PN MobileStore has grown from a small local shop to one of the leading mobile device retailers in the region. Our journey began with a simple mission: to provide customers with high-quality mobile devices and exceptional service.</p>
                <p>Today, we continue to uphold these values while embracing innovation and staying at the forefront of mobile technology. Our commitment to customer satisfaction and technical excellence has earned us the trust of thousands of satisfied customers.</p>
            </div>

            <!-- Our Values -->
            <div class="about-card">
                <h2 class="section-title">Our Values</h2>
                <div class="row">
                    <div class="col-md-4">
                        <div class="value-card">
                            <div class="value-icon">
                                <i class="bi bi-star"></i>
                            </div>
                            <h3>Excellence</h3>
                            <p>We strive for excellence in everything we do, from product selection to customer service.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="value-card">
                            <div class="value-icon">
                                <i class="bi bi-shield-check"></i>
                            </div>
                            <h3>Trust</h3>
                            <p>Building and maintaining trust through transparency and honest business practices.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="value-card">
                            <div class="value-icon">
                                <i class="bi bi-heart"></i>
                            </div>
                            <h3>Customer First</h3>
                            <p>Our customers are at the heart of everything we do.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistics -->
            <div class="stats-section">
                <div class="container">
                    <div class="row">
                        <div class="col-md-3 col-6">
                            <div class="stat-item">
                                <div class="stat-number">5000+</div>
                                <div class="stat-label">Happy Customers</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="stat-item">
                                <div class="stat-number">1000+</div>
                                <div class="stat-label">Products Sold</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="stat-item">
                                <div class="stat-number">50+</div>
                                <div class="stat-label">Brand Partners</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="stat-item">
                                <div class="stat-number">24/7</div>
                                <div class="stat-label">Support</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Store Location -->
            <div class="store-location">
                <h2 class="section-title">Visit Our Store</h2>
                <div class="location-grid">
                    <div class="location-info">
                        <p class="mb-4">Experience our products firsthand and get expert advice from our team at our flagship store.</p>
                        
                        <div class="store-details">
                            <div class="store-detail-item">
                                <div class="detail-icon">
                                    <i class="bi bi-geo-alt"></i>
                                </div>
                                <div class="detail-content">
                                    <h4>Store Address</h4>
                                    <p>123 Tech Street, Digital City<br>Innovation State, 12345</p>
                                </div>
                            </div>

                            <div class="store-detail-item">
                                <div class="detail-icon">
                                    <i class="bi bi-telephone"></i>
                                </div>
                                <div class="detail-content">
                                    <h4>Contact Numbers</h4>
                                    <p>+1 (555) 123-4567<br>+1 (555) 987-6543</p>
                                </div>
                            </div>

                            <div class="store-detail-item">
                                <div class="detail-icon">
                                    <i class="bi bi-envelope"></i>
                                </div>
                                <div class="detail-content">
                                    <h4>Email Address</h4>
                                    <p>support@pnmobilestore.com<br>info@pnmobilestore.com</p>
                                </div>
                            </div>
                        </div>

                        <div class="store-hours">
                            <h4 class="mb-3">Store Hours</h4>
                            <div class="hours-grid">
                                <div class="hours-item">
                                    <span class="day">Monday - Friday</span>
                                    <span class="time">9:00 AM - 8:00 PM</span>
                                </div>
                                <div class="hours-item">
                                    <span class="day">Saturday</span>
                                    <span class="time">10:00 AM - 6:00 PM</span>
                                </div>
                                <div class="hours-item">
                                    <span class="day">Sunday</span>
                                    <span class="time">11:00 AM - 5:00 PM</span>
                                </div>
                            </div>
                        </div>

                        <div class="contact-actions">
                            <a href="tel:+15551234567" class="action-btn call-btn">
                                <i class="bi bi-telephone"></i>
                                Call Now
                            </a>
                            <a href="https://maps.google.com" target="_blank" class="action-btn direction-btn">
                                <i class="bi bi-geo"></i>
                                Get Directions
                            </a>
                        </div>
                    </div>

                    <div class="map-container">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d387193.30596698663!2d-74.25987368715491!3d40.69714941932609!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c24fa5d33f083b%3A0xc80b8f06e177fe62!2sNew%20York%2C%20NY%2C%20USA!5e0!3m2!1sen!2sin!4v1647627817165!5m2!1sen!2sin" 
                                allowfullscreen="" loading="lazy"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 