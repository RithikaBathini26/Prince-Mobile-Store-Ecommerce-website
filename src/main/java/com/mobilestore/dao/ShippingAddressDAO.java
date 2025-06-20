package com.mobilestore.dao;

import com.mobilestore.model.ShippingAddress;
import com.mobilestore.util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ShippingAddressDAO {
    public int addShippingAddress(ShippingAddress address) {
        String sql = "INSERT INTO shipping_addresses (user_id, order_id, full_name, address, city, state, zip_code, phone, is_default) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            System.out.println("Attempting to insert shipping address with values:");
            System.out.println("User ID: " + address.getUserId());
            System.out.println("Order ID: " + address.getOrderId());
            System.out.println("Full Name: " + address.getFullName());
            System.out.println("Address: " + address.getAddress());
            System.out.println("City: " + address.getCity());
            System.out.println("State: " + address.getState());
            System.out.println("Zip Code: " + address.getZipCode());
            System.out.println("Phone: " + address.getPhone());
            System.out.println("Is Default: " + address.isDefault());
            
            pstmt.setInt(1, address.getUserId());
            pstmt.setInt(2, address.getOrderId());
            pstmt.setString(3, address.getFullName());
            pstmt.setString(4, address.getAddress());
            pstmt.setString(5, address.getCity());
            pstmt.setString(6, address.getState());
            pstmt.setString(7, address.getZipCode());
            pstmt.setString(8, address.getPhone());
            pstmt.setBoolean(9, address.isDefault());
            
            System.out.println("Executing SQL: " + sql);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Rows affected by insert: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int id = generatedKeys.getInt(1);
                        System.out.println("Shipping address inserted successfully with ID: " + id);
                        return id;
                    } else {
                        System.err.println("No generated keys returned after successful insert");
                        return -1;
                    }
                }
            } else {
                System.err.println("No rows were affected by the insert");
                return -1;
            }
            
        } catch (SQLException e) {
            System.err.println("SQL Error adding shipping address: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("SQL Query: " + sql);
            e.printStackTrace();
            return -1;
        }
    }

    public boolean updateShippingAddress(ShippingAddress address) {
        String sql = "UPDATE shipping_addresses SET full_name = ?, address = ?, city = ?, " +
                    "state = ?, zip_code = ?, phone = ?, is_default = ?, order_id = ? WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, address.getFullName());
            pstmt.setString(2, address.getAddress());
            pstmt.setString(3, address.getCity());
            pstmt.setString(4, address.getState());
            pstmt.setString(5, address.getZipCode());
            pstmt.setString(6, address.getPhone());
            pstmt.setBoolean(7, address.isDefault());
            pstmt.setInt(8, address.getOrderId());
            pstmt.setInt(9, address.getId());
            pstmt.setInt(10, address.getUserId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteShippingAddress(int addressId, int userId) {
        String sql = "DELETE FROM shipping_addresses WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, addressId);
            pstmt.setInt(2, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public ShippingAddress getShippingAddressById(int addressId, int userId) {
        String sql = "SELECT * FROM shipping_addresses WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, addressId);
            pstmt.setInt(2, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ShippingAddress address = new ShippingAddress();
                    address.setId(rs.getInt("id"));
                    address.setUserId(rs.getInt("user_id"));
                    address.setOrderId(rs.getInt("order_id"));
                    address.setFullName(rs.getString("full_name"));
                    address.setAddress(rs.getString("address"));
                    address.setCity(rs.getString("city"));
                    address.setState(rs.getString("state"));
                    address.setZipCode(rs.getString("zip_code"));
                    address.setPhone(rs.getString("phone"));
                    address.setDefault(rs.getBoolean("is_default"));
                    return address;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ShippingAddress> getShippingAddressesByUserId(int userId) {
        List<ShippingAddress> addresses = new ArrayList<>();
        String sql = "SELECT * FROM shipping_addresses WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ShippingAddress address = new ShippingAddress();
                    address.setId(rs.getInt("id"));
                    address.setUserId(rs.getInt("user_id"));
                    address.setOrderId(rs.getInt("order_id"));
                    address.setFullName(rs.getString("full_name"));
                    address.setAddress(rs.getString("address"));
                    address.setCity(rs.getString("city"));
                    address.setState(rs.getString("state"));
                    address.setZipCode(rs.getString("zip_code"));
                    address.setPhone(rs.getString("phone"));
                    address.setDefault(rs.getBoolean("is_default"));
                    addresses.add(address);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return addresses;
    }

    public ShippingAddress getDefaultShippingAddress(int userId) {
        String sql = "SELECT * FROM shipping_addresses WHERE user_id = ? AND is_default = true";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ShippingAddress address = new ShippingAddress();
                    address.setId(rs.getInt("id"));
                    address.setUserId(rs.getInt("user_id"));
                    address.setOrderId(rs.getInt("order_id"));
                    address.setFullName(rs.getString("full_name"));
                    address.setAddress(rs.getString("address"));
                    address.setCity(rs.getString("city"));
                    address.setState(rs.getString("state"));
                    address.setZipCode(rs.getString("zip_code"));
                    address.setPhone(rs.getString("phone"));
                    address.setDefault(rs.getBoolean("is_default"));
                    return address;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public ShippingAddress getShippingAddressByOrderId(int orderId) {
        String sql = "SELECT * FROM shipping_addresses WHERE order_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ShippingAddress address = new ShippingAddress();
                    address.setId(rs.getInt("id"));
                    address.setUserId(rs.getInt("user_id"));
                    address.setOrderId(rs.getInt("order_id"));
                    address.setFullName(rs.getString("full_name"));
                    address.setAddress(rs.getString("address"));
                    address.setCity(rs.getString("city"));
                    address.setState(rs.getString("state"));
                    address.setZipCode(rs.getString("zip_code"));
                    address.setPhone(rs.getString("phone"));
                    address.setDefault(rs.getBoolean("is_default"));
                    return address;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
} 