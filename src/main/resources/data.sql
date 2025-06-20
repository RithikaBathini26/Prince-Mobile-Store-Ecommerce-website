CREATE TABLE shipping_addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
); 

-- Sample service bookings
INSERT INTO service_bookings (user_id, service_type, device_type, booking_date, time_slot, notes, status) VALUES
(1, 'Screen Repair', 'iPhone 12', '2024-03-20', '10:00 AM - 12:00 PM', 'Cracked screen needs replacement', 'Pending'),
(2, 'Battery Replacement', 'Samsung Galaxy S21', '2024-03-21', '2:00 PM - 4:00 PM', 'Battery drains quickly', 'Pending'),
(3, 'Water Damage', 'OnePlus 9', '2024-03-22', '11:00 AM - 1:00 PM', 'Phone fell in water', 'Pending'); 