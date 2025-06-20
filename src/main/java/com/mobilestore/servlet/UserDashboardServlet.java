package com.mobilestore.servlet;

import com.mobilestore.model.User;
import com.mobilestore.dao.ProductDAO;
import com.mobilestore.model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/userdashboard")
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;
    private static final Logger logger = Logger.getLogger(UserDashboardServlet.class.getName());

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        logger.info("UserDashboardServlet initialized");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            logger.warning("No user found in session, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }

        logger.info("User found in session: " + user.getName());

        try {
            // Get all products from database
            List<Product> products = productDAO.getAllProducts();
            logger.info("Retrieved " + (products != null ? products.size() : 0) + " products from database");
            
            if (products != null && !products.isEmpty()) {
                request.setAttribute("productList", products);
                logger.info("Products set in request attribute");
            } else {
                logger.warning("No products found in database");
                request.setAttribute("error", "No products available at the moment");
            }
            
            // Forward to user dashboard
            request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading products", e);
            request.setAttribute("error", "Error loading products: " + e.getMessage());
            request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
