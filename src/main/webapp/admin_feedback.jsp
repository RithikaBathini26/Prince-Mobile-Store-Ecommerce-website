<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.Admin" %>
<%@ page import="com.mobilestore.model.Feedback" %>
<%@ page import="com.mobilestore.dao.FeedbackDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    List<Feedback> allFeedback = feedbackDAO.getAllFeedback();
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Product Reviews - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .star-rating {
            color: #ffc107;
        }
        .review-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #fff;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .review-meta {
            color: #6c757d;
            font-size: 0.9em;
        }
        .review-product {
            font-weight: bold;
            color: #0d6efd;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include your admin sidebar here -->
            <jsp:include page="admin_sidebar.jsp" />

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Manage Product Reviews</h1>
                </div>

                <% if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-success">
                        <%= request.getAttribute("message") %>
                    </div>
                <% } %>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Customer</th>
                                <th>Rating</th>
                                <th>Review</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allFeedback != null && !allFeedback.isEmpty()) { %>
                                <% for (Feedback feedback : allFeedback) { %>
                                    <tr>
                                        <td><%= feedback.getProduct().getName() %></td>
                                        <td><%= feedback.getUser().getName() %></td>
                                        <td>
                                            <div class="star-rating">
                                                <% for (int i = 1; i <= 5; i++) { %>
                                                    <i class="bi bi-star<%= (i <= feedback.getRating()) ? "-fill" : "" %>"></i>
                                                <% } %>
                                            </div>
                                        </td>
                                        <td><%= feedback.getComment() %></td>
                                        <td><%= dateFormat.format(feedback.getCreatedAt()) %></td>
                                        <td>
                                            <button class="btn btn-sm btn-danger" onclick="confirmDelete(<%= feedback.getId() %>)">
                                                <i class="bi bi-trash"></i> Delete
                                            </button>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } else { %>
                                <tr>
                                    <td colspan="6" class="text-center">No reviews found.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Delete Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this review? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <form action="FeedbackServlet" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="feedbackId" id="deleteFeedbackId">
                        <input type="hidden" name="referer" value="admin_feedback.jsp">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(feedbackId) {
            document.getElementById('deleteFeedbackId').value = feedbackId;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
</body>
</html> 