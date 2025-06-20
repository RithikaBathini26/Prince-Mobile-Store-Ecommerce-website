package com.mobilestore.dao;

import com.mobilestore.model.Product;
import com.mobilestore.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class ProductDAO {
    private static final Logger logger = Logger.getLogger(ProductDAO.class.getName());
    private static final String INSERT_PRODUCT = "INSERT INTO products (name, price, description, image_url, category, stock) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PRODUCT = "UPDATE products SET name=?, price=?, description=?, image_url=?, category=?, stock=? WHERE id=?";
    private static final String DELETE_PRODUCT = "DELETE FROM products WHERE id=?";
    private static final String GET_ALL_PRODUCTS = "SELECT * FROM products";
    private static final String GET_PRODUCT_BY_ID = "SELECT * FROM products WHERE id=?";
    private static final String UPDATE_STOCK = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
    private static final String CHECK_STOCK = "SELECT stock FROM products WHERE id = ?";

    public ProductDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            logger.info("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "Failed to load MySQL JDBC Driver", e);
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        try {
            Connection conn = DatabaseUtil.getConnection();
            logger.info("Database connection established successfully");
            return conn;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to establish database connection", e);
            throw e;
        }
    }

    public boolean addProduct(Product product) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_PRODUCT)) {
            
            stmt.setString(1, product.getName());
            stmt.setDouble(2, product.getPrice());
            stmt.setString(3, product.getDescription());
            stmt.setString(4, product.getImageUrl());
            stmt.setString(5, product.getCategory());
            stmt.setInt(6, product.getStock());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProduct(Product product) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_PRODUCT)) {
            
            stmt.setString(1, product.getName());
            stmt.setDouble(2, product.getPrice());
            stmt.setString(3, product.getDescription());
            stmt.setString(4, product.getImageUrl());
            stmt.setString(5, product.getCategory());
            stmt.setInt(6, product.getStock());
            stmt.setInt(7, product.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProduct(int id) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_PRODUCT)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_PRODUCTS)) {
            
            logger.info("Executing query: " + GET_ALL_PRODUCTS);
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCategory(rs.getString("category"));
                product.setStock(rs.getInt("stock"));
                products.add(product);
                logger.info("Added product to list: " + product.getName());
            }
            
            logger.info("Total products retrieved: " + products.size());
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving products from database", e);
            e.printStackTrace();
        }
        return products;
    }

    public Product getProductById(int id) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_PRODUCT_BY_ID)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("id"));
                    product.setName(rs.getString("name"));
                    product.setDescription(rs.getString("description"));
                    product.setPrice(rs.getDouble("price"));
                    product.setImageUrl(rs.getString("image_url"));
                    product.setCategory(rs.getString("category"));
                    product.setStock(rs.getInt("stock"));
                    return product;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStock(int productId, int quantity) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_STOCK)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating stock for product " + productId, e);
            return false;
        }
    }

    public boolean checkStockAvailability(int productId, int quantity) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(CHECK_STOCK)) {
            
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int currentStock = rs.getInt("stock");
                    return currentStock >= quantity;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking stock for product " + productId, e);
        }
        return false;
    }

    public List<Product> searchProducts(String query) {
        List<Product> searchResults = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE LOWER(name) LIKE ? OR LOWER(description) LIKE ? OR LOWER(category) LIKE ?";
        
        logger.info("Starting product search with query: " + query);
        
        if (query == null || query.trim().isEmpty()) {
            logger.warning("Empty search query provided");
            return searchResults;
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            if (conn == null) {
                logger.severe("Failed to establish database connection");
                return searchResults;
            }
            
            stmt = conn.prepareStatement(sql);
            String searchPattern = "%" + query.toLowerCase() + "%";
            
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            logger.info("Executing search query: " + sql);
            logger.info("Search pattern: " + searchPattern);
            
            rs = stmt.executeQuery();
            int count = 0;
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCategory(rs.getString("category"));
                product.setStock(rs.getInt("stock"));
                searchResults.add(product);
                count++;
                logger.info("Found product: " + product.getName() + " (ID: " + product.getId() + ")");
            }
            
            logger.info("Search completed. Found " + count + " products matching the query: " + query);
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error executing search query: " + e.getMessage(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                logger.log(Level.WARNING, "Error closing database resources", e);
            }
        }
        
        return searchResults;
    }
} 