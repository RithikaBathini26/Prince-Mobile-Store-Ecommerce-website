package com.mobilestore.servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.mobilestore.dao.ContactDAO;
import com.mobilestore.model.Contact;

@WebServlet("/admin/queries")
public class AdminQueriesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ContactDAO contactDAO;

    public void init() {
        contactDAO = new ContactDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        
        System.out.println("Admin status: " + isAdmin);
        
        if (isAdmin == null || !isAdmin) {
            System.out.println("User is not admin, redirecting to login");
            response.sendRedirect("adminlogin.jsp");
            return;
        }

        List<Contact> messages = contactDAO.getAllMessages();
        System.out.println("Messages retrieved in servlet: " + (messages != null ? messages.size() : "null"));
        
        request.setAttribute("messages", messages);
        request.getRequestDispatcher("/adminqueries.jsp").forward(request, response);
    }
} 