package com.mobilestore.servlet;

import com.mobilestore.dao.OrderDAO;
import com.mobilestore.dao.UserDAO;
import com.mobilestore.model.Order;
import com.mobilestore.model.OrderItem;
import com.mobilestore.model.User;
import com.mobilestore.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/OrderManagementServlet")
public class OrderManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        // Check if admin is logged in
        if (admin == null) {
            response.sendRedirect("adminlogin.jsp");
            return;
        }

        try {
            // Get all orders with user information
            List<Order> orders = orderDAO.getAllOrders();
            
            // For each order, get order items
            for (Order order : orders) {
                List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(order.getId());
                order.setOrderItems(orderItems);
            }
            
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("ordermanagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading orders: " + e.getMessage());
            request.getRequestDispatcher("ordermanagement.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        // Check if admin is logged in
        if (admin == null) {
            response.sendRedirect("adminlogin.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            if (orderDAO.updateOrderStatus(orderId, status)) {
                request.setAttribute("message", "Order status updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update order status.");
            }
            
            response.sendRedirect("OrderManagementServlet");
            
        } catch (Exception e) {
            request.setAttribute("error", "Error updating order status: " + e.getMessage());
            request.getRequestDispatcher("ordermanagement.jsp").forward(request, response);
        }
    }
} 