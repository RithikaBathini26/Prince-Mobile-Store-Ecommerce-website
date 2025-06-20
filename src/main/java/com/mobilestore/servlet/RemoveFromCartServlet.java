package com.mobilestore.servlet;

import com.mobilestore.dao.CartDAO;
import com.mobilestore.model.Cart;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
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
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            // Get the cart item for this product
            Cart cartItem = cartDAO.getCartItem(user.getId(), productId);
            
            if (cartItem != null) {
                if (cartDAO.removeFromCart(cartItem.getId())) {
                    request.setAttribute("message", "Item removed from cart successfully");
                } else {
                    request.setAttribute("error", "Failed to remove item from cart");
                }
            } else {
                request.setAttribute("error", "Item not found in cart");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid product ID");
        } catch (Exception e) {
            request.setAttribute("error", "Error removing from cart: " + e.getMessage());
        }
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
} 