-- Check if table exists
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'mobilestore' 
AND table_name = 'contact_messages';

-- Create table if it doesn't exist
CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert a test message if table is empty
INSERT INTO contact_messages (name, email, subject, message)
SELECT 'Test User', 'test@example.com', 'Test Subject', 'This is a test message'
WHERE NOT EXISTS (SELECT 1 FROM contact_messages); 