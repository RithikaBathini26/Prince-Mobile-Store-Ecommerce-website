package com.mobilestore.servlet;

import com.mobilestore.dao.CartDAO;
import com.mobilestore.dao.OrderDAO;
import com.mobilestore.dao.ProductDAO;
import com.mobilestore.dao.ShippingAddressDAO;
import com.mobilestore.model.Cart;
import com.mobilestore.model.Order;
import com.mobilestore.model.OrderItem;
import com.mobilestore.model.Product;
import com.mobilestore.model.ShippingAddress;
import com.mobilestore.model.User;
import com.mobilestore.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private ShippingAddressDAO shippingAddressDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        shippingAddressDAO = new ShippingAddressDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("PlaceOrderServlet: doPost method called");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            System.out.println("PlaceOrderServlet: User not logged in, redirecting to login page");
            response.sendRedirect("login.jsp");
            return;
        }

        Connection conn = null;
        try {
            // Start transaction
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            System.out.println("PlaceOrderServlet: Starting order placement process for user: " + user.getId());
            
            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String zipCode = request.getParameter("zipCode");
            String phone = request.getParameter("phone");
            String paymentMethod = request.getParameter("paymentMethod");

            // Get cart items
            List<Cart> cartItems = cartDAO.getCartItemsByUserId(user.getId());
            if (cartItems == null || cartItems.isEmpty()) {
                System.out.println("PlaceOrderServlet: No cart items found for user: " + user.getId());
                request.setAttribute("error", "Your cart is empty.");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // Check stock availability for all items
            for (Cart item : cartItems) {
                if (!productDAO.checkStockAvailability(item.getProductId(), item.getQuantity())) {
                    Product product = productDAO.getProductById(item.getProductId());
                    request.setAttribute("error", "Insufficient stock for product: " + product.getName());
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;
                }
            }

            // Calculate total amount
            double totalAmount = 0;
            for (Cart item : cartItems) {
                Product product = productDAO.getProductById(item.getProductId());
                if (product != null) {
                    totalAmount += item.getQuantity() * product.getPrice();
                }
            }
            System.out.println("PlaceOrderServlet: Total amount calculated: " + totalAmount);

            // Create order object
            Order order = new Order();
            order.setUserId(user.getId());
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));
            order.setTotalAmount(totalAmount);
            order.setStatus("Pending");

            // Save order to database
            System.out.println("PlaceOrderServlet: Attempting to save order...");
            int orderId = orderDAO.addOrder(order);
            System.out.println("PlaceOrderServlet: Order saved with ID: " + orderId);

            if (orderId > 0) {
                try {
                    // Add order items and reduce stock
                    for (Cart item : cartItems) {
                        Product product = productDAO.getProductById(item.getProductId());
                        
                        // Create order item
                        OrderItem orderItem = new OrderItem();
                        orderItem.setOrderId(orderId);
                        orderItem.setProductId(item.getProductId());
                        orderItem.setQuantity(item.getQuantity());
                        orderItem.setPrice(product.getPrice());
                        
                        // Save order item
                        if (!orderDAO.addOrderItem(orderItem)) {
                            throw new SQLException("Failed to save order item");
                        }
                        
                        // Update product stock
                        if (!productDAO.updateStock(item.getProductId(), item.getQuantity())) {
                            throw new SQLException("Failed to update stock for product: " + product.getName());
                        }
                    }

                    // Create shipping address
                    ShippingAddress shippingAddress = new ShippingAddress();
                    shippingAddress.setUserId(user.getId());
                    shippingAddress.setOrderId(orderId);
                    shippingAddress.setFullName(fullName);
                    shippingAddress.setAddress(address);
                    shippingAddress.setCity(city);
                    shippingAddress.setState(state);
                    shippingAddress.setZipCode(zipCode);
                    shippingAddress.setPhone(phone);
                    shippingAddress.setDefault(true);

                    // Save shipping address
                    System.out.println("PlaceOrderServlet: Attempting to save shipping address...");
                    int shippingAddressId = shippingAddressDAO.addShippingAddress(shippingAddress);
                    System.out.println("PlaceOrderServlet: Shipping address saved with ID: " + shippingAddressId);

                    if (shippingAddressId > 0) {
                        // Clear the cart after successful order
                        System.out.println("PlaceOrderServlet: Clearing cart for user: " + user.getId());
                        cartDAO.clearCart(user.getId());

                        // Commit transaction
                        conn.commit();

                        // Set order ID in session for confirmation page
                        session.setAttribute("orderId", orderId);
                        System.out.println("PlaceOrderServlet: Order ID set in session: " + orderId);
                        
                        // Redirect to order confirmation page
                        System.out.println("PlaceOrderServlet: Redirecting to orderconfirmation.jsp");
                        response.sendRedirect(request.getContextPath() + "/orderConfirmation.jsp");
                        return;
                    } else {
                        throw new SQLException("Failed to save shipping address");
                    }
                } catch (Exception e) {
                    // Rollback transaction
                    if (conn != null) {
                        try {
                            conn.rollback();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        }
                    }
                    System.out.println("PlaceOrderServlet: Error processing order: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Error processing order: " + e.getMessage());
                    request.getRequestDispatcher("proceedToCheckout.jsp").forward(request, response);
                    return;
                }
            } else {
                System.out.println("PlaceOrderServlet: Failed to save order");
                request.setAttribute("error", "Failed to place order. Please try again.");
                request.getRequestDispatcher("proceedToCheckout.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            // Rollback transaction
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.out.println("PlaceOrderServlet: Error occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your order: " + e.getMessage());
            request.getRequestDispatcher("proceedToCheckout.jsp").forward(request, response);
            return;
        } finally {
            // Reset auto-commit and close connection
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
} 