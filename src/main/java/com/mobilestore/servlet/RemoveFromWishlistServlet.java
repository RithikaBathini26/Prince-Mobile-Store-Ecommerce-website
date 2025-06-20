package com.mobilestore.servlet;

import com.mobilestore.dao.WishlistDAO;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RemoveFromWishlistServlet")
public class RemoveFromWishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        wishlistDAO = new WishlistDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int wishlistId = Integer.parseInt(request.getParameter("wishlistId"));

            if (wishlistDAO.removeFromWishlist(wishlistId, user.getId())) {
                request.setAttribute("message", "Item removed from wishlist successfully!");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("error", "Failed to remove item from wishlist.");
            }

            response.sendRedirect("wishlist.jsp");

        } catch (Exception e) {
            request.setAttribute("error", "Error removing from wishlist: " + e.getMessage());
            request.getRequestDispatcher("wishlist.jsp").forward(request, response);
        }
    }
} 