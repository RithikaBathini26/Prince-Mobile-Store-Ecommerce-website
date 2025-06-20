package com.mobilestore.servlet;

import com.mobilestore.dao.FeedbackDAO;
import com.mobilestore.model.Feedback;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                handleAddFeedback(request, response, user);
                break;
            case "update":
                handleUpdateFeedback(request, response, user);
                break;
            case "delete":
                handleDeleteFeedback(request, response, user);
                break;
            case "help":
                handleHelpRequest(request, response, user);
                break;
            default:
                response.sendRedirect("orders.jsp");
        }
    }

    private void handleAddFeedback(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        if (feedbackDAO.hasUserReviewed(user.getId(), productId, orderId)) {
            request.setAttribute("error", "You have already reviewed this product for this order.");
            request.getRequestDispatcher("orders.jsp").forward(request, response);
            return;
        }

        Feedback feedback = new Feedback();
        feedback.setUserId(user.getId());
        feedback.setProductId(productId);
        feedback.setOrderId(orderId);
        feedback.setRating(rating);
        feedback.setComment(comment);

        int feedbackId = feedbackDAO.addFeedback(feedback);
        
        if (feedbackId > 0) {
            request.setAttribute("message", "Thank you for your feedback!");
        } else {
            request.setAttribute("error", "Failed to submit feedback. Please try again.");
        }
        
        String referer = request.getParameter("referer");
        response.sendRedirect(referer != null ? referer : "orders.jsp");
    }

    private void handleUpdateFeedback(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
        
        if (feedback == null || feedback.getUserId() != user.getId()) {
            request.setAttribute("error", "Invalid feedback update request.");
            request.getRequestDispatcher("orders.jsp").forward(request, response);
            return;
        }

        feedback.setRating(rating);
        feedback.setComment(comment);

        if (feedbackDAO.updateFeedback(feedback)) {
            request.setAttribute("message", "Feedback updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update feedback. Please try again.");
        }
        
        String referer = request.getParameter("referer");
        response.sendRedirect(referer != null ? referer : "orders.jsp");
    }

    private void handleDeleteFeedback(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));

        if (feedbackDAO.deleteFeedback(feedbackId, user.getId())) {
            request.setAttribute("message", "Feedback deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete feedback. Please try again.");
        }
        
        String referer = request.getParameter("referer");
        response.sendRedirect(referer != null ? referer : "orders.jsp");
    }

    private void handleHelpRequest(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String issueType = request.getParameter("issueType");
        String description = request.getParameter("description");

        Feedback feedback = new Feedback();
        feedback.setUserId(user.getId());
        feedback.setProductId(productId);
        feedback.setOrderId(orderId);
        feedback.setType("help");
        feedback.setIssueType(issueType);
        feedback.setComment(description);
        feedback.setStatus("pending");
        feedback.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        int feedbackId = feedbackDAO.addFeedback(feedback);
        
        if (feedbackId > 0) {
            request.setAttribute("message", "Your help request has been submitted. We will get back to you soon.");
        } else {
            request.setAttribute("error", "Failed to submit help request. Please try again.");
        }
        
        response.sendRedirect("orders.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String productId = request.getParameter("productId");
        
        if (productId != null) {
            response.sendRedirect("product_details.jsp?productId=" + productId);
        } else {
            response.sendRedirect("home.jsp");
        }
    }
} 