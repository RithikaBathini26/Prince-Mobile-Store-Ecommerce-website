package com.mobilestore.servlet;

import com.mobilestore.dao.UserDAO;
import com.mobilestore.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/users")
public class UserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        System.out.println("UserManagementServlet initialized");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("UserManagementServlet doGet called");
        
        HttpSession session = request.getSession();
        // Check if admin is logged in
        if (session.getAttribute("admin") == null) {
            System.out.println("No admin found in session, redirecting to admin dashboard");
            response.sendRedirect("admindashboard.jsp");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("Action parameter: " + action);
        
        if (action == null) {
            // Display all users
            System.out.println("Fetching all users");
            List<User> users = userDAO.getAllUsers();
            System.out.println("Number of users fetched from database: " + (users != null ? users.size() : 0));
            
            request.setAttribute("users", users);
            System.out.println("Forwarding to usermanagement.jsp");
            request.getRequestDispatcher("usermanagement.jsp").forward(request, response);
        } else if (action.equals("delete")) {
            // Handle user deletion
            int userId = Integer.parseInt(request.getParameter("id"));
            System.out.println("Deleting user with ID: " + userId);
            if (userDAO.deleteUser(userId)) {
                request.setAttribute("message", "User deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete user");
            }
            response.sendRedirect("users");
        }
    }
} 