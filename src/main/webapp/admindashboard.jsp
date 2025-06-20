<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.mobilestore.model.Admin" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.util.DatabaseUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();

    // Get active orders and service bookings count directly from database
    int activeOrdersCount = 0;
    int serviceBookingsCount = 0;

    try (Connection conn = DatabaseUtil.getConnection()) {
        // Get active orders count
        String ordersSql = "SELECT COUNT(*) as count FROM orders WHERE status IN ('Processing', 'Pending')";
        try (PreparedStatement pstmt = conn.prepareStatement(ordersSql)) {
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    activeOrdersCount = rs.getInt("count");
                }
            }
        }

        // Get service bookings count
        String bookingsSql = "SELECT COUNT(*) as count FROM service_bookings WHERE status = 'Pending'";
        try (PreparedStatement pstmt = conn.prepareStatement(bookingsSql)) {
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    serviceBookingsCount = rs.getInt("count");
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // Store counts in session for future use
    session.setAttribute("activeOrdersCount", activeOrdersCount);
    session.setAttribute("serviceBookingsCount", serviceBookingsCount);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
    <style>
        :root {
            --primary-color: #1e40af;
            --secondary-color: #1e3a8a;
            --accent-color: #2563eb;
            --glass-bg: rgba(255, 255, 255, 0.9);
            --glass-border: rgba(30, 64, 175, 0.1);
            --glass-shadow: 0 8px 32px 0 rgba(30, 64, 175, 0.1);
            --text-primary: #1e3a8a;
            --text-secondary: #1e40af;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #ffffff;
            min-height: 100vh;
            overflow-x: hidden;
            color: var(--text-primary);
        }

        /* Animated Background */
        .animated-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: 
                radial-gradient(circle at 20% 20%, rgba(30, 64, 175, 0.03) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(37, 99, 235, 0.03) 0%, transparent 50%);
            animation: gradientShift 15s ease infinite;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 0%; }
            50% { background-position: 100% 100%; }
            100% { background-position: 0% 0%; }
        }

        /* Floating Elements */
        .floating-elements {
            position: fixed;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .floating-element {
            position: absolute;
            background: rgba(30, 64, 175, 0.03);
            border: 1px solid rgba(30, 64, 175, 0.1);
            border-radius: 50%;
            animation: float 20s infinite linear;
        }

        @keyframes float {
            0% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(100px, 100px) rotate(180deg); }
            100% { transform: translate(0, 0) rotate(360deg); }
        }

        .sidebar {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-right: 1px solid var(--glass-border);
            color: var(--text-primary);
            min-height: 100vh;
            padding: 20px;
            position: fixed;
            width: 280px;
            box-shadow: var(--glass-shadow);
        }

        .sidebar-header {
            padding: 20px 0;
            text-align: center;
            border-bottom: 1px solid var(--glass-border);
            margin-bottom: 20px;
        }

        .sidebar-header h3 {
            margin: 0;
            font-size: 1.8rem;
            color: var(--text-primary);
            text-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .nav-menu {
            list-style: none;
            padding: 0;
            margin: 20px 0;
        }

        .nav-item {
            margin: 15px 0;
        }

        .nav-link {
            color: var(--text-primary);
            text-decoration: none;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            border-radius: 12px;
            transition: all 0.3s ease;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
        }

        .nav-link:hover {
            background: rgba(30, 64, 175, 0.05);
            transform: translateX(10px);
            border-color: var(--accent-color);
        }

        .nav-link i {
            margin-right: 15px;
            font-size: 1.4rem;
            color: var(--accent-color);
        }

        .main-content {
            margin-left: 280px;
            padding: 30px;
        }

        .dashboard-header {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            padding: 30px;
            border-radius: 20px;
            box-shadow: var(--glass-shadow);
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }

        .welcome-text {
            font-size: 2.2rem;
            color: var(--text-primary);
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .dashboard-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            box-shadow: var(--glass-shadow);
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }

        .dashboard-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-15px) scale(1.02);
            border-color: var(--accent-color);
        }

        .dashboard-card:hover::before {
            opacity: 0.03;
        }

        .card-icon {
            font-size: 3rem;
            margin-bottom: 25px;
            color: var(--accent-color);
            position: relative;
            text-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .card-title {
            color: var(--text-primary);
            font-size: 1.6rem;
            margin-bottom: 20px;
            position: relative;
            text-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .card-text {
            color: var(--text-secondary);
            margin-bottom: 30px;
            position: relative;
            line-height: 1.8;
            font-size: 1.1rem;
        }

        .action-btn {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 12px 25px;
            border-radius: 12px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: none;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        .action-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.2);
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }

        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(30, 64, 175, 0.2);
        }

        .action-btn:hover::before {
            transform: translateX(0);
        }

        /* Stats Section */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: var(--accent-color);
            background: rgba(30, 64, 175, 0.02);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--accent-color);
            margin-bottom: 10px;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>
    <div class="floating-elements">
        <div class="floating-element" style="width: 100px; height: 100px; top: 20%; left: 10%;"></div>
        <div class="floating-element" style="width: 150px; height: 150px; top: 60%; left: 80%;"></div>
        <div class="floating-element" style="width: 80px; height: 80px; top: 40%; left: 40%;"></div>
    </div>
    
    <div class="sidebar">
        <div class="sidebar-header">
            <h3>Admin Panel</h3>
        </div>
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="admindashboard.jsp" class="nav-link">
                    <i class="bi bi-speedometer2"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="adminqueries.jsp" class="nav-link">
                    <i class="bi bi-envelope"></i>
                    <span>User Queries</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="users" class="nav-link">
                    <i class="bi bi-people"></i>
                    <span>User Management</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="adminProductManagement.jsp" class="nav-link">
                    <i class="bi bi-box"></i>
                    <span>Product Management</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="OrderManagementServlet" class="nav-link">
                    <i class="bi bi-cart"></i>
                    <span>Order Management</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="report.jsp" class="nav-link">
                    <i class="bi bi-graph-up"></i>
                    <span>Reports</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="AdminServiceBookings.jsp" class="nav-link">
                    <i class="bi bi-calendar-check"></i>
                    <span>Service Bookings</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="logout" class="nav-link">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </div>

    <div class="main-content">
        <div class="dashboard-header" data-aos="fade-down">
            <h2 class="welcome-text">Welcome, <%= admin.getUsername() %></h2>
        </div>

        <div class="stats-section" data-aos="fade-up">
            <div class="stat-card">
                <div class="stat-number"><%= products.size() %></div>
                <div class="stat-label">Total Products</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= activeOrdersCount %></div>
                <div class="stat-label">Active Orders</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= serviceBookingsCount %></div>
                <div class="stat-label">Service Bookings</div>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="100">
                <i class="bi bi-people card-icon"></i>
                <h3 class="card-title">User Management</h3>
                <p class="card-text">Manage user accounts, view user details, and handle user-related operations with ease.</p>
                <a href="users" class="action-btn">Manage Users</a>
            </div>

            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="200">
                <i class="bi bi-box card-icon"></i>
                <h3 class="card-title">Product Management</h3>
                <p class="card-text">Add, edit, or remove products from the store inventory with a user-friendly interface.</p>
                <a href="adminProductManagement.jsp" class="action-btn">Manage Products</a>
            </div>

            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="300">
                <i class="bi bi-cart card-icon"></i>
                <h3 class="card-title">Order Management</h3>
                <p class="card-text">View and process customer orders, update order status, and track deliveries.</p>
                <a href="OrderManagementServlet" class="action-btn">Manage Orders</a>
            </div>

            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="400">
                <i class="bi bi-graph-up card-icon"></i>
                <h3 class="card-title">Reports</h3>
                <p class="card-text">Generate and view detailed sales reports, user statistics, and business analytics.</p>
                <a href="report.jsp" class="action-btn">View Reports</a>
            </div>

            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="500">
                <i class="bi bi-calendar-check card-icon"></i>
                <h3 class="card-title">Service Bookings</h3>
                <p class="card-text">Manage and track service bookings, repairs, and maintenance schedules.</p>
                <a href="AdminServiceBookings.jsp" class="action-btn">View Bookings</a>
            </div>

            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="600">
                <i class="bi bi-envelope card-icon"></i>
                <h3 class="card-title">User Queries</h3>
                <p class="card-text">View and manage user messages and inquiries.</p>
                <a href="adminqueries.jsp" class="action-btn">View Queries</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 1000,
            easing: 'ease-in-out',
            once: true,
            mirror: false
        });

        // Auto-refresh stats every 30 seconds
        function refreshStats() {
            fetch('AdminDashboardStatsServlet')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(() => {
                    // Refresh only the stats section without reloading the page
                    fetch(window.location.href)
                        .then(response => response.text())
                        .then(html => {
                            const parser = new DOMParser();
                            const doc = parser.parseFromString(html, 'text/html');
                            
                            // Update stats numbers
                            const newStats = doc.querySelector('.stats-section');
                            const currentStats = document.querySelector('.stats-section');
                            if (newStats && currentStats) {
                                currentStats.innerHTML = newStats.innerHTML;
                            }
                        });
                })
                .catch(error => {
                    console.error('Error refreshing stats:', error);
                });
        }

        // Set up auto-refresh every 30 seconds
        setInterval(refreshStats, 30000);

        // Add floating elements dynamically
        function createFloatingElements() {
            const container = document.querySelector('.floating-elements');
            for (let i = 0; i < 5; i++) {
                const element = document.createElement('div');
                element.className = 'floating-element';
                element.style.width = Math.random() * 100 + 50 + 'px';
                element.style.height = element.style.width;
                element.style.top = Math.random() * 100 + '%';
                element.style.left = Math.random() * 100 + '%';
                element.style.animationDelay = Math.random() * 5 + 's';
                container.appendChild(element);
            }
        }

        createFloatingElements();
    </script>
</body>
</html>