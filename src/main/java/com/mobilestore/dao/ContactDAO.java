package com.mobilestore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import com.mobilestore.model.Contact;
import com.mobilestore.util.DatabaseUtil;

public class ContactDAO {
    public boolean saveContact(Contact contact) {
        String sql = "INSERT INTO contact_messages (user_id, name, email, subject, message, submission_date) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, contact.getUserId());
            statement.setString(2, contact.getName());
            statement.setString(3, contact.getEmail());
            statement.setString(4, contact.getSubject());
            statement.setString(5, contact.getMessage());
            statement.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: " + contact.getUserId() + ", " + contact.getName() + ", " + contact.getEmail());
            
            int rowsInserted = statement.executeUpdate();
            System.out.println("Rows inserted: " + rowsInserted);
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.err.println("Error saving contact: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Contact> getAllMessages() {
        List<Contact> messages = new ArrayList<>();
        String sql = "SELECT * FROM contact_messages ORDER BY submission_date DESC";
        
        System.out.println("Starting to retrieve messages...");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            System.out.println("Database connection established");
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                System.out.println("Executing SQL query: " + sql);
                
                try (ResultSet resultSet = statement.executeQuery()) {
                    System.out.println("Query executed, processing results...");
                    
                    while (resultSet.next()) {
                        Contact contact = new Contact();
                        contact.setId(resultSet.getInt("id"));
                        contact.setUserId(resultSet.getInt("user_id"));
                        contact.setName(resultSet.getString("name"));
                        contact.setEmail(resultSet.getString("email"));
                        contact.setSubject(resultSet.getString("subject"));
                        contact.setMessage(resultSet.getString("message"));
                        contact.setSubmissionDate(resultSet.getTimestamp("submission_date"));
                        messages.add(contact);
                        
                        System.out.println("Retrieved message: " + contact.getId() + " - " + contact.getName() + " - " + contact.getEmail());
                    }
                }
            }
            
            System.out.println("Total messages retrieved: " + messages.size());
        } catch (SQLException e) {
            System.err.println("Error retrieving messages: " + e.getMessage());
            e.printStackTrace();
        }
        return messages;
    }
} 