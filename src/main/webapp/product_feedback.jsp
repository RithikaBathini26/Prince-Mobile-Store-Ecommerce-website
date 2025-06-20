<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobilestore.model.Feedback" %>
<%@ page import="com.mobilestore.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User currentUser = (User) session.getAttribute("user");
    List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("productFeedback");
    double averageRating = (Double) request.getAttribute("averageRating");
    int totalReviews = (Integer) request.getAttribute("totalReviews");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Reviews</title>
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
        .review-date {
            color: #6c757d;
            font-size: 0.9em;
        }
        .review-actions {
            display: flex;
            gap: 10px;
        }
        .rating-summary {
            text-align: center;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .average-rating {
            font-size: 48px;
            font-weight: bold;
            color: #0d6efd;
        }
        .total-reviews {
            color: #6c757d;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="rating-summary">
            <div class="average-rating">
                <%= String.format("%.1f", averageRating) %>
                <span class="star-rating">
                    <% for (int i = 1; i <= 5; i++) { %>
                        <i class="bi bi-star<%= (i <= averageRating) ? "-fill" : (i <= averageRating + 0.5) ? "-half" : "" %>"></i>
                    <% } %>
                </span>
            </div>
            <div class="total-reviews">
                Based on <%= totalReviews %> review<%= totalReviews != 1 ? "s" : "" %>
            </div>
        </div>

        <h2 class="mb-4">Customer Reviews</h2>

        <% if (feedbackList != null && !feedbackList.isEmpty()) { %>
            <% for (Feedback feedback : feedbackList) { %>
                <div class="review-card">
                    <div class="review-header">
                        <div>
                            <h5 class="mb-0"><%= feedback.getUser().getName() %></h5>
                            <div class="star-rating">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="bi bi-star<%= (i <= feedback.getRating()) ? "-fill" : "" %>"></i>
                                <% } %>
                            </div>
                        </div>
                        <div class="review-date">
                            <%= dateFormat.format(feedback.getCreatedAt()) %>
                        </div>
                    </div>
                    <p class="mb-2"><%= feedback.getComment() %></p>
                    
                    <% if (currentUser != null && currentUser.getId() == feedback.getUserId()) { %>
                        <div class="review-actions">
                            <button class="btn btn-sm btn-outline-primary" onclick="editFeedback(<%= feedback.getId() %>)">
                                <i class="bi bi-pencil"></i> Edit
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick="deleteFeedback(<%= feedback.getId() %>)">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </div>
                    <% } %>
                </div>
            <% } %>
        <% } else { %>
            <div class="alert alert-info">
                No reviews yet. Be the first to review this product!
            </div>
        <% } %>
    </div>

    <!-- Edit Feedback Modal -->
    <div class="modal fade" id="editFeedbackModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="FeedbackServlet" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="feedbackId" id="editFeedbackId">
                        <input type="hidden" name="referer" value="product_feedback.jsp">
                        
                        <div class="mb-3">
                            <label class="form-label">Rating</label>
                            <div class="star-rating">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="bi bi-star" data-rating="<%= i %>" onclick="setRating(<%= i %>)"></i>
                                <% } %>
                            </div>
                            <input type="hidden" name="rating" id="editRating" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Comment</label>
                            <textarea class="form-control" name="comment" id="editComment" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteFeedbackModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Delete Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this review?
                </div>
                <div class="modal-footer">
                    <form action="FeedbackServlet" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="feedbackId" id="deleteFeedbackId">
                        <input type="hidden" name="referer" value="product_feedback.jsp">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editFeedback(feedbackId) {
            document.getElementById('editFeedbackId').value = feedbackId;
            // You would typically load the existing rating and comment here via AJAX
            new bootstrap.Modal(document.getElementById('editFeedbackModal')).show();
        }

        function deleteFeedback(feedbackId) {
            document.getElementById('deleteFeedbackId').value = feedbackId;
            new bootstrap.Modal(document.getElementById('deleteFeedbackModal')).show();
        }

        function setRating(rating) {
            document.getElementById('editRating').value = rating;
            const stars = document.querySelectorAll('.star-rating i');
            stars.forEach((star, index) => {
                star.classList.remove('bi-star-fill', 'bi-star');
                star.classList.add(index < rating ? 'bi-star-fill' : 'bi-star');
            });
        }
    </script>
</body>
</html> 