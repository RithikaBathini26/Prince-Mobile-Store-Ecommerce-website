package com.mobilestore.dao;

import com.mobilestore.model.Admin;
import com.mobilestore.util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {
    public Admin loginAdmin(String username, String password) {
        String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            System.out.println("Executing admin login query for username: " + username);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                System.out.println("Admin login successful for: " + username);
                return admin;
            } else {
                System.out.println("No admin found with username: " + username);
            }
            
        } catch (SQLException e) {
            System.err.println("Error in admin login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
} 