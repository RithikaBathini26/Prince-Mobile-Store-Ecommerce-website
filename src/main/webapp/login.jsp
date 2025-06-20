<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f8fafc, #e2e8f0);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 100%;
            max-width: 1000px;
            display: flex;
            min-height: 600px;
        }

        .login-image {
            flex: 1;
            background: url('https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') center/cover;
            position: relative;
            display: none;
        }

        .login-image::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            opacity: 0.8;
        }

        .login-form {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-floating {
            margin-bottom: 20px;
        }

        .form-floating input {
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            padding: 15px;
            transition: all 0.3s ease;
        }

        .form-floating input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(37, 99, 235, 0.1);
        }

        .form-select {
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            padding: 15px;
            transition: all 0.3s ease;
            height: 58px;
        }

        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(37, 99, 235, 0.1);
        }

        .btn-login {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }

        .social-login {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .social-btn {
            flex: 1;
            padding: 10px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .social-btn:hover {
            background: #f8fafc;
            transform: translateY(-2px);
        }

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 20px 0;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }

        .divider span {
            padding: 0 10px;
            color: #64748b;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
        }

        .register-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        @media (min-width: 768px) {
            .login-image {
                display: block;
            }
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .shake {
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
    </style>
</head>
<body>
    <div class="login-container fade-in">
        <div class="login-image"></div>
        <div class="login-form">
            <h2 class="text-center mb-4">Welcome Back!</h2>
            <p class="text-center text-muted mb-4">Sign in to continue to your account</p>

            <form action="LoginServlet" method="post">
                <div class="form-floating mb-3">
                    <select class="form-select" id="role" name="role" required onchange="toggleLoginField()">
                        <option value="user">User</option>
                        <option value="admin">Admin</option>
                    </select>
                    <label for="role">Login As</label>
                </div>
                <div class="form-floating" id="emailField">
                    <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com">
                    <label for="email">Email address</label>
                </div>
                <div class="form-floating" id="usernameField" style="display: none;">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Username">
                    <label for="username">Username</label>
                </div>
                <div class="form-floating">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                    <label for="password">Password</label>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember">
                        <label class="form-check-label" for="remember">Remember me</label>
                    </div>
                    <a href="#" class="text-decoration-none">Forgot password?</a>
                </div>
                <button type="submit" class="btn btn-login w-100 mb-4">Sign In</button>
            </form>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <div class="divider">
                <span>or continue with</span>
            </div>

            <div class="social-login">
                <button class="social-btn">
                    <i class="bi bi-google"></i>
                    <span>Google</span>
                </button>
                <button class="social-btn">
                    <i class="bi bi-facebook"></i>
                    <span>Facebook</span>
                </button>
            </div>

            <div class="register-link">
                Don't have an account? <a href="register.jsp">Sign up</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleLoginField() {
            const role = document.getElementById('role').value;
            const emailField = document.getElementById('emailField');
            const usernameField = document.getElementById('usernameField');
            const emailInput = document.getElementById('email');
            const usernameInput = document.getElementById('username');

            if (role === 'admin') {
                emailField.style.display = 'none';
                usernameField.style.display = 'block';
                emailInput.removeAttribute('required');
                usernameInput.setAttribute('required', '');
            } else {
                emailField.style.display = 'block';
                usernameField.style.display = 'none';
                emailInput.setAttribute('required', '');
                usernameInput.removeAttribute('required', '');
            }
        }

        // Call on page load to set initial state
        document.addEventListener('DOMContentLoaded', toggleLoginField);

        // Add animation to form elements
        document.querySelectorAll('.form-floating input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('fade-in');
            });
        });

        // Handle form submission
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            // Create form data object
            const formData = new FormData();
            formData.append('email', email);
            formData.append('password', password);
            
            // Send login request
            fetch('login', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Redirect to user dashboard on successful login
                    window.location.href = 'home.jsp';
                } else {
                    // Show error message
                    alert(data.message || 'Login failed. Please check your credentials.');
                    this.classList.add('shake');
                    setTimeout(() => this.classList.remove('shake'), 500);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            });
        });
    </script>
</body>
</html> 