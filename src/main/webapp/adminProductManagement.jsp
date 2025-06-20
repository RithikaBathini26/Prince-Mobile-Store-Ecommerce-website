<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.Admin" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>
<%@ page import="com.mobilestore.model.Product" %>
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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management - Mobile Store</title>
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

        .page-header {
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-size: 2.2rem;
            color: var(--text-primary);
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 0;
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            padding: 12px 25px;
            border-radius: 12px;
            color: white;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(30, 64, 175, 0.2);
            background: linear-gradient(45deg, var(--secondary-color), var(--primary-color));
        }

        .products-table {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            box-shadow: var(--glass-shadow);
            overflow: hidden;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background: rgba(30, 64, 175, 0.05);
            color: var(--text-primary);
            font-weight: 600;
            border-bottom: 1px solid var(--glass-border);
            padding: 15px 20px;
        }

        .table tbody td {
            padding: 15px 20px;
            vertical-align: middle;
            border-bottom: 1px solid var(--glass-border);
            color: var(--text-secondary);
        }

        .table tbody tr:hover {
            background: rgba(30, 64, 175, 0.02);
        }

        .btn-action {
            padding: 8px 15px;
            border-radius: 8px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .btn-edit {
            background: rgba(30, 64, 175, 0.1);
            color: var(--primary-color);
            border: 1px solid var(--glass-border);
        }

        .btn-delete {
            background: rgba(220, 38, 38, 0.1);
            color: #dc2626;
            border: 1px solid rgba(220, 38, 38, 0.2);
        }

        .btn-action:hover {
            transform: translateY(-2px);
        }

        .btn-edit:hover {
            background: rgba(30, 64, 175, 0.15);
            border-color: var(--primary-color);
        }

        .btn-delete:hover {
            background: rgba(220, 38, 38, 0.15);
            border-color: #dc2626;
        }

        .product-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid var(--glass-border);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-active {
            background: rgba(34, 197, 94, 0.1);
            color: #16a34a;
            border: 1px solid rgba(34, 197, 94, 0.2);
        }

        .status-inactive {
            background: rgba(156, 163, 175, 0.1);
            color: #6b7280;
            border: 1px solid rgba(156, 163, 175, 0.2);
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>
    
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
        <div class="animated-bg"></div>
        <div class="page-header" data-aos="fade-down">
            <h1 class="page-title">Product Management</h1>
            <div class="action-buttons">
                <a href="addProduct.jsp" class="btn btn-primary">
                    <i class="bi bi-plus-lg"></i> Add New Product
                </a>
            </div>
        </div>

        <div class="products-table" data-aos="fade-up">
            <table class="table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Product product : products) { %>
                    <tr>
                        <td>
                            <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="product-image">
                        </td>
                        <td><%= product.getName() %></td>
                        <td>$<%= String.format("%.2f", product.getPrice()) %></td>
                        <td><%= product.getStock() %></td>
                        <td>
                            <span class="status-badge <%= product.getStock() > 0 ? "status-active" : "status-inactive" %>">
                                <%= product.getStock() > 0 ? "In Stock" : "Out of Stock" %>
                            </span>
                        </td>
                        <td>
                            <div class="d-flex gap-2">
                                <a href="editProduct.jsp?id=<%= product.getId() %>" class="btn btn-action btn-edit">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="products?action=delete&id=<%= product.getId() %>" class="btn btn-action btn-delete" 
                                   onclick="return confirm('Are you sure you want to delete this product?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
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
    </script>
</body>
</html> 