CREATE TABLE IF NOT EXISTS notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    type VARCHAR(50) NOT NULL DEFAULT 'general',
    reference_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
); 