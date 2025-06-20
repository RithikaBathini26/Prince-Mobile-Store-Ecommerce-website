package com.mobilestore.servlet;

import com.mobilestore.dao.WishlistDAO;
import com.mobilestore.model.Wishlist;
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

@WebServlet("/addToWishlist")
public class AddToWishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AddToWishlistServlet.class.getName());
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        wishlistDAO = new WishlistDAO();
        logger.info("AddToWishlistServlet initialized");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            logger.warning("Attempt to add to wishlist without user session");
            request.setAttribute("error", "Please login first");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            logger.info(String.format("Adding to wishlist - User: %d, Product: %d", user.getId(), productId));

            // Check if product is already in wishlist
            if (wishlistDAO.isProductInWishlist(user.getId(), productId)) {
                // If product is already in wishlist, remove it (toggle functionality)
                logger.info(String.format("Product %d already in wishlist for user %d, removing", productId, user.getId()));
                if (wishlistDAO.removeFromWishlist(user.getId(), productId)) {
                    logger.info(String.format("Product %d removed from wishlist for user %d", productId, user.getId()));
                    request.setAttribute("message", "Product removed from wishlist.");
                    request.setAttribute("messageType", "success");
                    response.sendRedirect("wishlist.jsp");
                } else {
                    logger.warning(String.format("Failed to remove product %d from wishlist for user %d", productId, user.getId()));
                    request.setAttribute("error", "Failed to remove product from wishlist.");
                    request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                }
            } else {
                // Add to wishlist
                Wishlist wishlist = new Wishlist(user.getId(), productId);
                if (wishlistDAO.addToWishlist(wishlist)) {
                    logger.info(String.format("Product %d added to wishlist for user %d", productId, user.getId()));
                    request.setAttribute("message", "Product added to wishlist!");
                    request.setAttribute("messageType", "success");
                    response.sendRedirect("wishlist.jsp");
                } else {
                    logger.warning(String.format("Failed to add product %d to wishlist for user %d", productId, user.getId()));
                    request.setAttribute("error", "Failed to add product to wishlist.");
                    request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                }
            }
        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "Invalid product ID", e);
            request.setAttribute("error", "Invalid product ID.");
            request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing wishlist", e);
            request.setAttribute("error", "Error processing wishlist: " + e.getMessage());
            request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
        }
    }
} 