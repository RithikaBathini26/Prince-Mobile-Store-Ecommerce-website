<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Product - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
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
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 1rem 2rem;
            background: #ffffff;
            border-radius: 0.5rem;
            box-shadow: var(--shadow-light);
        }

        .dashboard-header h2 {
            color: var(--primary-color);
            margin: 0;
            font-weight: 600;
            font-size: 2rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }

        .dashboard-header .btn-secondary {
            background: var(--primary-color);
            border: none;
            color: #ffffff;
            padding: 0.75rem 1.5rem;
        }

        .dashboard-header .btn-secondary:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        .form-container {
            background: var(--card-bg-light);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--shadow-light);
            transition: all 0.3s ease;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
        }

        .form-section {
            background: rgba(255, 255, 255, 0.5);
            padding: 1.5rem;
            border-radius: 0.75rem;
            border: 1px solid var(--border-light);
        }

        .form-section.full-width {
            grid-column: 1 / -1;
        }

        .form-header {
            margin-bottom: 2rem;
            text-align: center;
        }

        .form-header h2 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
        }

        .form-header p {
            color: var(--text-light);
            opacity: 0.7;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-group label {
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 0.5rem;
            display: block;
            font-size: 0.95rem;
        }

        .form-control {
            border: 2px solid var(--border-light);
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            width: 100%;
            background: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
        }

        .form-control:hover {
            border-color: var(--primary-color);
            background: #ffffff;
            box-shadow: 0 2px 4px rgba(79, 70, 229, 0.1);
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.2);
            background: #ffffff;
            outline: none;
        }

        .form-control::placeholder {
            color: #94a3b8;
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
            border-radius: 0.5rem 0 0 0.5rem;
            padding: 0 1rem;
            display: flex;
            align-items: center;
            font-weight: 500;
        }

        .input-group .form-control {
            padding-left: 3rem;
        }

        .input-group .form-control:hover {
            border-color: var(--primary-color);
        }

        .input-group .form-control:focus {
            border-color: var(--primary-color);
        }

        select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%234f46e5' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            padding-right: 2.5rem;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .custom-file {
            position: relative;
        }

        .custom-file-input {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .custom-file-label {
            display: block;
            padding: 0.75rem 1rem;
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid var(--border-light);
            border-radius: 0.5rem;
            color: var(--text-light);
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        .custom-file-label:hover {
            background: #ffffff;
            border-color: var(--primary-color);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
        }

        .btn-primary {
            background: var(--primary-color);
            border: none;
            color: white;
        }

        .btn-primary:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .btn-secondary {
            background: rgba(79, 70, 229, 0.1);
            border: 1px solid var(--border-light);
            color: var(--primary-color);
        }

        .btn-secondary:hover {
            background: rgba(79, 70, 229, 0.15);
            border-color: var(--primary-color);
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .container {
                padding: 1rem;
            }
            
            .dashboard-header {
                padding: 1rem;
            }
            
            .dashboard-header h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="dashboard-header" data-aos="fade-down">
            <h2>Add New Product</h2>
            <a href="adminProductManagement.jsp" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to Products
            </a>
        </div>

        <div class="form-container" data-aos="fade-up">
            <form action="products" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                
                <div class="form-grid">
                    <div class="form-section">
                        <div class="form-group">
                            <label for="name">Product Name</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <div class="form-group">
                            <label for="price">Price</label>
                            <div class="input-group">
                                <span class="input-group-text">₹</span>
                                <input type="number" class="form-control" id="price" name="price" step="0.01" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <div class="form-group">
                            <label for="category">Category</label>
                            <select class="form-control" id="category" name="category" required>
                                <option value="">Select Category</option>
                                <option value="Smartphone">Smartphone</option>
                                <option value="Tablet">Tablet</option>
                                <option value="Accessory">Accessory</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <div class="form-group">
                            <label for="stock">Stock Quantity</label>
                            <input type="number" class="form-control" id="stock" name="stock" required>
                        </div>
                    </div>
                    
                    <div class="form-section full-width">
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                        </div>
                    </div>
                    
                    <div class="form-section full-width">
                        <div class="form-group">
                            <label for="image">Product Image</label>
                            <div class="custom-file">
                                <input type="file" class="custom-file-input" id="image" name="image" required>
                                <label class="custom-file-label" for="image">Choose file</label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-plus-lg"></i> Add Product
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

        // Update custom file input label
        document.querySelector('.custom-file-input').addEventListener('change', function(e) {
            var fileName = e.target.files[0].name;
            var nextSibling = e.target.nextElementSibling;
            nextSibling.innerText = fileName;
        });
    </script>
</body>
</html> 