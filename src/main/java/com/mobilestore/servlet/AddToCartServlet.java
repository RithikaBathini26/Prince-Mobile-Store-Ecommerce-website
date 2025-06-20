package com.mobilestore.servlet;

import com.mobilestore.dao.CartDAO;
import com.mobilestore.dao.ProductDAO;
import com.mobilestore.model.Cart;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AddToCartServlet.class.getName());
    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
        logger.info("AddToCartServlet initialized");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            logger.warning("Attempt to add to cart without user session");
            request.setAttribute("error", "Please login first");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = request.getParameter("quantity") != null ? 
                          Integer.parseInt(request.getParameter("quantity")) : 1;

            logger.info(String.format("Adding to cart - User: %d, Product: %d, Quantity: %d", 
                       user.getId(), productId, quantity));

            // Check stock availability
            if (!productDAO.checkStockAvailability(productId, quantity)) {
                logger.warning(String.format("Insufficient stock for product %d, requested quantity: %d", 
                             productId, quantity));
                request.setAttribute("error", "Sorry, the requested quantity is not available in stock.");
                request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                return;
            }

            // Check if product is already in cart
            Cart existingCartItem = cartDAO.getCartItem(user.getId(), productId);
            
            if (existingCartItem != null) {
                // Check if new total quantity is available in stock
                int newQuantity = existingCartItem.getQuantity() + quantity;
                if (!productDAO.checkStockAvailability(productId, newQuantity)) {
                    logger.warning(String.format("Total quantity exceeds stock - Product: %d, Total Quantity: %d", 
                                 productId, newQuantity));
                    request.setAttribute("error", "Sorry, the requested total quantity exceeds available stock.");
                    request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                    return;
                }
                
                // Update quantity if item exists
                existingCartItem.setQuantity(newQuantity);
                if (cartDAO.updateCartItem(existingCartItem)) {
                    logger.info(String.format("Cart updated - User: %d, Product: %d, New Quantity: %d", 
                              user.getId(), productId, newQuantity));
                    request.setAttribute("message", "Cart updated successfully!");
                    request.setAttribute("messageType", "success");
                    response.sendRedirect("cart.jsp");
                } else {
                    logger.warning(String.format("Failed to update cart - User: %d, Product: %d", 
                                 user.getId(), productId));
                    request.setAttribute("error", "Failed to update cart.");
                    request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                }
            } else {
                // Add new item to cart
                Cart cartItem = new Cart();
                cartItem.setUserId(user.getId());
                cartItem.setProductId(productId);
                cartItem.setQuantity(quantity);
                
                if (cartDAO.addToCart(cartItem)) {
                    logger.info(String.format("New item added to cart - User: %d, Product: %d, Quantity: %d", 
                              user.getId(), productId, quantity));
                    request.setAttribute("message", "Product added to cart successfully!");
                    request.setAttribute("messageType", "success");
                    response.sendRedirect("cart.jsp");
                } else {
                    logger.warning(String.format("Failed to add new item to cart - User: %d, Product: %d", 
                                 user.getId(), productId));
                    request.setAttribute("error", "Failed to add product to cart.");
                    request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                }
            }
        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "Invalid quantity or product ID", e);
            request.setAttribute("error", "Invalid quantity or product ID.");
            request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error adding to cart", e);
            request.setAttribute("error", "Error adding to cart: " + e.getMessage());
            request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
        }
    }
} 