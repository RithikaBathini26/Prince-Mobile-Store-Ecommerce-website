<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.Product" %>
<%@ page import="com.mobilestore.dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<%
    String productId = request.getParameter("id");
    ProductDAO productDAO = new ProductDAO();
    Product product = productDAO.getProductById(Integer.parseInt(productId));
    List<Product> products = productDAO.getAllProducts();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - Mobile Store</title>
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
            position: relative;
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

        .main-content {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
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

        .form-container {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--glass-shadow);
            position: relative;
            overflow: hidden;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            color: var(--text-primary);
            font-weight: 600;
            margin-bottom: 10px;
            display: block;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.95);
            border: 2px solid var(--glass-border);
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
            width: 100%;
            color: var(--text-primary);
        }

        .form-control:hover {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.2);
            outline: none;
            background: #ffffff;
        }

        .input-group {
            position: relative;
        }

        .input-group-text {
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 12px 0 0 12px;
            padding: 0 15px;
            display: flex;
            align-items: center;
            font-weight: 500;
        }

        .input-group .form-control {
            padding-left: 45px;
        }

        .form-select {
            background: rgba(255, 255, 255, 0.95);
            border: 2px solid var(--glass-border);
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
            width: 100%;
            cursor: pointer;
            color: var(--text-primary);
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%231e40af' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }

        .form-select:hover {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .form-select:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.2);
            outline: none;
            background-color: #ffffff;
        }

        .current-image {
            margin-top: 15px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 12px;
            border: 1px solid var(--glass-border);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
        }

        .current-image img {
            max-width: 200px;
            border-radius: 8px;
            margin-top: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--glass-border);
        }

        .form-text {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-top: 8px;
            opacity: 0.8;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(30, 64, 175, 0.2);
            background: linear-gradient(45deg, var(--secondary-color), var(--primary-color));
        }

        .btn-secondary {
            background: rgba(30, 64, 175, 0.1);
            border: 1px solid var(--glass-border);
            color: var(--primary-color);
        }

        .btn-secondary:hover {
            background: rgba(30, 64, 175, 0.15);
            border-color: var(--primary-color);
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(30, 64, 175, 0.1);
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            justify-content: flex-end;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .page-header {
                padding: 20px;
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .page-title {
                font-size: 1.8rem;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>
    
    <div class="main-content">
        <div class="page-header" data-aos="fade-down">
            <h1 class="page-title">Edit Product</h1>
            <a href="adminProductManagement.jsp" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to Products
            </a>
        </div>

        <div class="form-container" data-aos="fade-up">
            <form action="products" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= product.getId() %>">
                
                <div class="form-grid">
                    <div class="form-section">
                        <label for="name" class="form-label">Product Name</label>
                        <input type="text" class="form-control" id="name" name="name" 
                               value="<%= product.getName() %>" required>
                    </div>
                    
                    <div class="form-section">
                        <label for="price" class="form-label">Price</label>
                        <div class="input-group">
                            <span class="input-group-text">₹</span>
                            <input type="number" class="form-control" id="price" name="price" 
                                   value="<%= product.getPrice() %>" step="0.01" required>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-select" id="category" name="category" required>
                            <option value="Smartphone" <%= product.getCategory().equals("Smartphone") ? "selected" : "" %>>Smartphone</option>
                            <option value="Tablet" <%= product.getCategory().equals("Tablet") ? "selected" : "" %>>Tablet</option>
                            <option value="Accessory" <%= product.getCategory().equals("Accessory") ? "selected" : "" %>>Accessory</option>
                        </select>
                    </div>
                    
                    <div class="form-section">
                        <label for="stock" class="form-label">Stock Quantity</label>
                        <input type="number" class="form-control" id="stock" name="stock" 
                               value="<%= product.getStock() %>" required>
                    </div>
                    
                    <div class="form-section full-width">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" 
                                  rows="4" required><%= product.getDescription() %></textarea>
                    </div>
                    
                    <div class="form-section full-width">
                        <label for="image" class="form-label">Product Image</label>
                        <input type="file" class="form-control" id="image" name="image">
                        <div class="current-image">
                            <small class="form-text">Current image:</small>
                            <img src="<%= product.getImageUrl() %>" alt="Current product image" class="mt-2">
                        </div>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save"></i> Update Product
                    </button>
                </div>
            </form>
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