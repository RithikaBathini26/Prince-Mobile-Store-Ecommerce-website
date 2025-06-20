<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="com.mobilestore.dao.UserDAO" %>

<%@ page import="java.util.List" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    
    // Debug information
    System.out.println("Number of users fetched: " + (users != null ? users.size() : 0));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mobile Store - User Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
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
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }

        body.dark-mode {
            background: var(--background-dark);
            background-image: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: var(--text-dark);
        }

        body.dark-mode::before {
            background: linear-gradient(45deg, rgba(99, 102, 241, 0.1) 0%, rgba(79, 70, 229, 0.1) 100%);
        }

        .main-content {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .dashboard-header {
            background: var(--card-bg-light);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-light);
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: var(--shadow-light);
            margin-bottom: 2rem;
            transition: all 0.3s ease;
        }

        .dark-mode .dashboard-header {
            background: var(--card-bg-dark);
            border-color: var(--border-dark);
            box-shadow: var(--shadow-dark);
        }

        .controls-section {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 300px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 1px solid var(--border-light);
            border-radius: 0.5rem;
            background: var(--card-bg-light);
            color: var(--text-light);
            transition: all 0.3s ease;
        }

        .dark-mode .search-box input {
            background: var(--card-bg-dark);
            border-color: var(--border-dark);
            color: var(--text-dark);
        }

        .search-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--accent-color);
        }

        .filter-dropdown {
            min-width: 200px;
        }

        .filter-dropdown select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border-light);
            border-radius: 0.5rem;
            background: var(--card-bg-light);
            color: var(--text-light);
            transition: all 0.3s ease;
        }

        .dark-mode .filter-dropdown select {
            background: var(--card-bg-dark);
            border-color: var(--border-dark);
            color: var(--text-dark);
        }

        .users-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .user-card {
            background: var(--card-bg-light);
            border: 1px solid var(--border-light);
            border-radius: 1rem;
            padding: 1.5rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .dark-mode .user-card {
            background: var(--card-bg-dark);
            border-color: var(--border-dark);
        }

        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-light);
        }

        .dark-mode .user-card:hover {
            box-shadow: var(--shadow-dark);
        }

        .user-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .user-card:hover .user-avatar {
            transform: scale(1.1);
        }

        .user-info {
            margin-top: 1rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
            color: var(--text-light);
            transition: color 0.3s ease;
        }

        .dark-mode .info-item {
            color: var(--text-dark);
        }

        .info-item i {
            margin-right: 0.5rem;
            color: var(--accent-color);
        }

        .user-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            opacity: 0;
            transform: translateY(10px);
            transition: all 0.3s ease;
        }

        .user-card:hover .user-actions {
            opacity: 1;
            transform: translateY(0);
        }

        .action-btn {
            flex: 1;
            padding: 0.5rem;
            border: none;
            border-radius: 0.5rem;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .action-btn:hover {
            transform: translateY(-2px);
        }

        .btn-view { background: var(--accent-color); }
        .btn-edit { background: #10b981; }
        .btn-delete { background: #ef4444; }

        .theme-toggle {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: var(--shadow-light);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .dark-mode .theme-toggle {
            background: var(--accent-color);
            box-shadow: var(--shadow-dark);
        }

        .theme-toggle:hover {
            transform: scale(1.1);
        }

        .skeleton {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }

        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

        .skeleton-card {
            height: 300px;
            border-radius: 1rem;
            background: var(--card-bg-light);
        }

        .dark-mode .skeleton-card {
            background: var(--card-bg-dark);
        }

        @media (max-width: 768px) {
            .users-grid {
                grid-template-columns: 1fr;
            }
            
            .controls-section {
                flex-direction: column;
            }
            
            .search-box, .filter-dropdown {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="dashboard-header" data-aos="fade-down">
            <div class="d-flex justify-content-between align-items-center">
                <h1 class="welcome-text">User Management</h1>
                <a href="admindashboard.jsp" class="btn btn-primary">
                    <i class="bi bi-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success" role="alert" data-aos="fade-up">
                <i class="bi bi-check-circle-fill me-2"></i><%= message %>
            </div>
        <% } %>
        
        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-danger" role="alert" data-aos="fade-up">
                <i class="bi bi-exclamation-circle-fill me-2"></i><%= error %>
            </div>
        <% } %>

        <div class="controls-section" data-aos="fade-up">
            <div class="search-box">
                <i class="bi bi-search"></i>
                <input type="text" id="userSearch" placeholder="Search users..." onkeyup="searchUsers()">
            </div>
        </div>
        
        <div class="users-grid" id="usersGrid">
            <% if (users != null && !users.isEmpty()) {
                for (User user : users) { %>
                <div class="user-card" data-aos="fade-up" data-user-id="<%= user.getId() %>">
                    <div class="user-avatar">
                        <%= user.getName().charAt(0) %>
                    </div>
                    <div class="user-info">
                        <h3 class="user-name"><%= user.getName() %></h3>
                        <div class="info-item">
                            <i class="bi bi-person-fill"></i>
                            <span>ID: <%= user.getId() %></span>
                        </div>
                        <div class="info-item">
                            <i class="bi bi-envelope-fill"></i>
                            <span><%= user.getEmail() %></span>
                        </div>
                        <div class="info-item">
                            <i class="bi bi-telephone-fill"></i>
                            <span><%= user.getMobileNumber() %></span>
                        </div>
                    </div>
                </div>
            <% }
            } else { %>
                <div class="no-users" data-aos="fade-up">
                    <i class="bi bi-people"></i>
                    <h3>No Users Found</h3>
                    <p class="text-muted">There are no users registered in the system.</p>
                </div>
            <% } %>
        </div>
    </div>

    <button class="theme-toggle" onclick="toggleTheme()" title="Toggle Dark Mode">
        <i class="bi bi-moon-fill"></i>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true
        });

        // Theme Toggle
        function toggleTheme() {
            document.body.classList.toggle('dark-mode');
            const themeIcon = document.querySelector('.theme-toggle i');
            themeIcon.classList.toggle('bi-moon-fill');
            themeIcon.classList.toggle('bi-sun-fill');
        }

        // Search Functionality
        function searchUsers() {
            const input = document.getElementById('userSearch');
            const filter = input.value.toLowerCase();
            const userCards = document.querySelectorAll('.user-card');

            userCards.forEach(card => {
                const name = card.querySelector('.user-name').textContent.toLowerCase();
                const email = card.querySelector('.info-item:nth-child(2) span').textContent.toLowerCase();
                const mobile = card.querySelector('.info-item:nth-child(3) span').textContent.toLowerCase();
                
                if (name.includes(filter) || email.includes(filter) || mobile.includes(filter)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 1000,
            easing: 'ease-in-out',
            once: true,
            mirror: false
        });

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