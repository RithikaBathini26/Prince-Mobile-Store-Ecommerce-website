package com.mobilestore.servlet;

import com.mobilestore.dao.ProductDAO;
import com.mobilestore.dao.NotificationDAO;
import com.mobilestore.model.Product;
import com.mobilestore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private NotificationDAO notificationDAO;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        notificationDAO = new NotificationDAO();
        // Create upload directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            try {
                // Always fetch fresh data from database
                List<Product> products = productDAO.getAllProducts();
                request.setAttribute("productList", products);
                
                // Check if request is from user dashboard
                String referer = request.getHeader("referer");
                if (referer != null && referer.contains("userdashboard")) {
                    request.getRequestDispatcher("/userdashboard.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/userdashboard.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error loading products: " + e.getMessage());
                request.getRequestDispatcher("/userdashboard.jsp").forward(request, response);
            }
        } else if (action.equals("edit")) {
            // Display edit form
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("product", productDAO.getProductById(id));
            request.getRequestDispatcher("editProduct.jsp").forward(request, response);
        } else if (action.equals("new")) {
            // Display add product form
            request.getRequestDispatcher("addProduct.jsp").forward(request, response);
        } else if (action.equals("delete")) {
            // Handle product deletion
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (productDAO.deleteProduct(id)) {
                    request.setAttribute("message", "Product deleted successfully!");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("error", "Failed to delete product.");
                }
                response.sendRedirect("adminProductManagement.jsp");
            } catch (Exception e) {
                request.setAttribute("error", "Error deleting product: " + e.getMessage());
                response.sendRedirect("adminProductManagement.jsp");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action.equals("add")) {
            // Handle new product addition
            try {
                // Get form data
                String name = request.getParameter("name");
                String brand = request.getParameter("brand");
                double price = Double.parseDouble(request.getParameter("price"));
                String description = request.getParameter("description");
                String category = request.getParameter("category");
                int stock = Integer.parseInt(request.getParameter("stock"));
                
                // Handle file upload
                Part filePart = request.getPart("image");
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                
                // Create product object
                Product product = new Product();
                product.setName(name);
                product.setPrice(price);
                product.setDescription(description);
                product.setCategory(category);
                product.setStock(stock);
                product.setImageUrl(UPLOAD_DIR + "/" + fileName);
                
                // Add product to database
                if (productDAO.addProduct(product)) {
                    request.setAttribute("message", "Product added successfully!");
                    request.setAttribute("messageType", "success");
                    
                    // Send notification to all users
                    HttpSession session = request.getSession();
                    Integer adminId = (Integer) session.getAttribute("userId");
                    String notificationMessage = "New product added: " + name;
                    if (brand != null && !brand.trim().isEmpty()) {
                        notificationMessage += " by " + brand;
                    }
                    notificationDAO.addNotificationForAllUsers(notificationMessage, adminId != null ? adminId : 0);
                    
                    // Get fresh product list from database
                    List<Product> products = productDAO.getAllProducts();
                    request.setAttribute("productList", products);
                    
                    // Forward to appropriate page
                    String referer = request.getHeader("referer");
                    if (referer != null && referer.contains("userdashboard")) {
                        request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("adminProductManagement.jsp");
                    }
                } else {
                    request.setAttribute("error", "Failed to add product.");
                    response.sendRedirect("adminProductManagement.jsp");
                }
                
            } catch (Exception e) {
                request.setAttribute("error", "Error adding product: " + e.getMessage());
                response.sendRedirect("adminProductManagement.jsp");
            }
        } else if (action.equals("update")) {
            // Handle product update
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                String description = request.getParameter("description");
                String category = request.getParameter("category");
                int stock = Integer.parseInt(request.getParameter("stock"));
                
                Product product = new Product();
                product.setId(id);
                product.setName(name);
                product.setPrice(price);
                product.setDescription(description);
                product.setCategory(category);
                product.setStock(stock);
                
                // Handle image update if a new image is provided
                Part filePart = request.getPart("image");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                    String filePath = uploadPath + File.separator + fileName;
                    filePart.write(filePath);
                    product.setImageUrl(UPLOAD_DIR + "/" + fileName);
                }
                
                if (productDAO.updateProduct(product)) {
                    request.setAttribute("message", "Product updated successfully!");
                    request.setAttribute("messageType", "success");
                    
                    // Get fresh product list from database
                    List<Product> products = productDAO.getAllProducts();
                    request.setAttribute("productList", products);
                    
                    // Forward to appropriate page
                    String referer = request.getHeader("referer");
                    if (referer != null && referer.contains("userdashboard")) {
                        request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("adminProductManagement.jsp");
                    }
                } else {
                    request.setAttribute("error", "Failed to update product.");
                    response.sendRedirect("adminProductManagement.jsp");
                }
                
            } catch (Exception e) {
                request.setAttribute("error", "Error updating product: " + e.getMessage());
                response.sendRedirect("adminProductManagement.jsp");
            }
        } else if (action.equals("delete")) {
            // Handle product deletion
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (productDAO.deleteProduct(id)) {
                    request.setAttribute("message", "Product deleted successfully!");
                    request.setAttribute("messageType", "success");
                    
                    // Get fresh product list from database
                    List<Product> products = productDAO.getAllProducts();
                    request.setAttribute("productList", products);
                    
                    // Forward to appropriate page
                    String referer = request.getHeader("referer");
                    if (referer != null && referer.contains("userdashboard")) {
                        request.getRequestDispatcher("userdashboard.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("adminProductManagement.jsp");
                    }
                } else {
                    request.setAttribute("error", "Failed to delete product.");
                    response.sendRedirect("adminProductManagement.jsp");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error deleting product: " + e.getMessage());
                response.sendRedirect("adminProductManagement.jsp");
            }
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
} 