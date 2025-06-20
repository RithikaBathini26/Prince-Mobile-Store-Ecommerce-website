package com.mobilestore.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.mobilestore.dao.UserDAO;
import com.mobilestore.model.User;
import com.mobilestore.dao.AdminDAO;
import com.mobilestore.model.Admin;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private AdminDAO adminDAO;

    public void init() {
        userDAO = new UserDAO();
        adminDAO = new AdminDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        try {
            if ("admin".equals(role)) {
                // Handle admin login with username
                String username = request.getParameter("username");
                Admin admin = adminDAO.loginAdmin(username, password);
                if (admin != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("admin", admin);
                    session.setAttribute("adminId", admin.getId());
                    session.setAttribute("adminName", admin.getUsername());
                    response.sendRedirect("admindashboard.jsp");
                } else {
                    request.setAttribute("error", "Invalid admin credentials!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // Handle user login with email
                String email = request.getParameter("email");
                User user = userDAO.loginUser(email, password);
                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("userId", user.getId());
                    session.setAttribute("userName", user.getName());
                    response.sendRedirect("home.jsp");
                } else {
                    request.setAttribute("error", "Invalid email or password");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred during login");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
} 