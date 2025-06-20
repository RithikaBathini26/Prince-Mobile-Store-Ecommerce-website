<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mobilestore.model.Contact" %>
<%@ page import="com.mobilestore.dao.ContactDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.mobilestore.model.Admin" %>
<%
    // Debug session info
    System.out.println("Session ID: " + session.getId());
    System.out.println("admin attribute: " + session.getAttribute("admin"));

    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        System.out.println("User is not admin, redirecting to login");
        response.sendRedirect("login.jsp");
        return;
    }

    System.out.println("User is admin, proceeding to get messages");
    
    // Get messages directly from DAO
    ContactDAO contactDAO = new ContactDAO();
    List<Contact> messages = contactDAO.getAllMessages();
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
    
    // Debug information
    System.out.println("Messages in JSP: " + (messages != null ? messages.size() : "null"));
    if (messages != null) {
        System.out.println("Messages list is not null");
        for (Contact msg : messages) {
            System.out.println("Message: " + msg.getId() + " - " + msg.getName() + " - " + msg.getEmail());
        }
    } else {
        System.out.println("Messages list is null");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>User Queries - Admin Dashboard</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Fontawesome icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- AOS CSS -->
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

        * {
            box-sizing: border-box;
            padding: 0;
            margin: 0;
            font-family: 'Poppins', sans-serif;
        }

        body {
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

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            padding: 20px;
            border-radius: 20px;
            box-shadow: var(--glass-shadow);
        }

        .header h1 {
            color: var(--text-primary);
            font-size: 2rem;
            margin: 0;
        }

        .back-btn {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(30, 64, 175, 0.2);
            color: white;
        }

        .queries-table {
            width: 100%;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            box-shadow: var(--glass-shadow);
            overflow: hidden;
        }

        .queries-table table {
            width: 100%;
            border-collapse: collapse;
        }

        .queries-table th,
        .queries-table td {
            padding: 20px;
            text-align: left;
            border-bottom: 1px solid var(--glass-border);
        }

        .queries-table th {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 1px;
        }

        .queries-table tr:hover {
            background: rgba(30, 64, 175, 0.02);
        }

        .message-cell {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .status-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .status-new {
            background: rgba(25, 118, 210, 0.1);
            color: #1976d2;
        }

        .status-read {
            background: rgba(56, 142, 60, 0.1);
            color: #388e3c;
        }

        .status-replied {
            background: rgba(245, 124, 0, 0.1);
            color: #f57c00;
        }

        .action-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            margin-right: 8px;
            color: white;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .view-btn {
            background: linear-gradient(45deg, #2196f3, #1976d2);
        }

        .reply-btn {
            background: linear-gradient(45deg, #4caf50, #388e3c);
        }

        .delete-btn {
            background: linear-gradient(45deg, #f44336, #d32f2f);
        }

        @media (max-width: 768px) {
            .queries-table {
                overflow-x: auto;
            }
            
            .container {
                padding: 15px;
            }

            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>
    <div class="container">
        <div class="header" data-aos="fade-down">
            <h1>User Queries</h1>
            <a href="admindashboard.jsp" class="back-btn">
                <i class="bi bi-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="queries-table" data-aos="fade-up">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Subject</th>
                        <th>Message</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (messages != null && !messages.isEmpty()) { %>
                        <% for (Contact message : messages) { %>
                            <tr>
                                <td><%= message.getId() %></td>
                                <td><%= message.getName() %></td>
                                <td><%= message.getEmail() %></td>
                                <td><%= message.getSubject() %></td>
                                <td class="message-cell"><%= message.getMessage() %></td>
                                <td><%= dateFormat.format(message.getSubmissionDate()) %></td>
                                <td>
                                    <button class="action-btn reply-btn" onclick='replyMessage("<%= message.getEmail() %>")'>
                                        <i class="bi bi-reply"></i> Reply
                                    </button>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 20px;">
                                No messages found
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- AOS JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 1000,
            easing: 'ease-in-out',
            once: true,
            mirror: false
        });

        function viewMessage(id) {
            Swal.fire({
                title: 'Message Details',
                text: 'View message details functionality will be implemented here',
                icon: 'info',
                background: 'var(--glass-bg)',
                backdrop: 'rgba(30, 64, 175, 0.1)',
                confirmButtonColor: 'var(--accent-color)'
            });
        }

        function replyMessage(email) {
            Swal.fire({
                title: 'Reply to Message',
                text: 'Reply functionality will be implemented here',
                icon: 'info',
                background: 'var(--glass-bg)',
                backdrop: 'rgba(30, 64, 175, 0.1)',
                confirmButtonColor: 'var(--accent-color)'
            });
        }

        function deleteMessage(id) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: 'var(--accent-color)',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, delete it!',
                background: 'var(--glass-bg)',
                backdrop: 'rgba(30, 64, 175, 0.1)'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire(
                        'Deleted!',
                        'The message has been deleted.',
                        'success'
                    );
                }
            });
        }
    </script>
</body>
</html> 