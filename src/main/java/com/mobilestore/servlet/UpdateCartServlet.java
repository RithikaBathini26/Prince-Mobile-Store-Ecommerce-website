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

@WebServlet("/UpdateCartServlet")
public class UpdateCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
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
            String action = request.getParameter("action");
            
            // Get the cart item for this product
            Cart cartItem = cartDAO.getCartItem(user.getId(), productId);
            
            if (cartItem != null) {
                int currentQuantity = cartItem.getQuantity();
                int newQuantity = currentQuantity;
                
                if ("increase".equals(action)) {
                    // Check if product is in stock
                    int availableStock = productDAO.getProductById(productId).getStock();
                    if (currentQuantity < availableStock) {
                        newQuantity = currentQuantity + 1;
                    } else {
                        request.setAttribute("error", "Product is out of stock");
                        request.getRequestDispatcher("cart.jsp").forward(request, response);
                        return;
                    }
                } else if ("decrease".equals(action)) {
                    if (currentQuantity > 1) {
                        newQuantity = currentQuantity - 1;
                    } else {
                        request.setAttribute("error", "Minimum quantity is 1");
                        request.getRequestDispatcher("cart.jsp").forward(request, response);
                        return;
                    }
                }
                
                cartItem.setQuantity(newQuantity);
                if (cartDAO.updateCartItem(cartItem)) {
                    request.setAttribute("message", "Cart updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update cart");
                }
            } else {
                request.setAttribute("error", "Item not found in cart");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid product ID");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating cart: " + e.getMessage());
        }
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
} 