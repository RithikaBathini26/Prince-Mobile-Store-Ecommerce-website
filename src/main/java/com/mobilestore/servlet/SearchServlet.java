package com.mobilestore.servlet;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mobilestore.model.Product;
import com.mobilestore.dao.ProductDAO;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;
    private static final Logger logger = Logger.getLogger(SearchServlet.class.getName());

    public void init() {
        productDAO = new ProductDAO();
        logger.info("SearchServlet initialized");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String query = request.getParameter("query");
        logger.info("Received search query: " + query);
        
        if (query != null && !query.trim().isEmpty()) {
            logger.info("Processing search query: " + query);
            
            // Search for products
            List<Product> searchResults = productDAO.searchProducts(query);
            logger.info("Found " + (searchResults != null ? searchResults.size() : 0) + " results");
            
            // Set the results as request attribute
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("searchQuery", query);
            
            // Forward to the search results page
            logger.info("Forwarding to search_results.jsp");
            request.getRequestDispatcher("search_results.jsp").forward(request, response);
        } else {
            logger.warning("Empty search query, redirecting to home.jsp");
            response.sendRedirect("home.jsp");
        }
    }
} 