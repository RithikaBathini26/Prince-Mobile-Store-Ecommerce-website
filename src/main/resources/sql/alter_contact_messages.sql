-- Add user_id column to contact_messages table
ALTER TABLE contact_messages ADD COLUMN user_id INT;

-- Make user_id nullable since existing records won't have it
ALTER TABLE contact_messages MODIFY COLUMN user_id INT NULL;

-- Add foreign key constraint to users table
ALTER TABLE contact_messages ADD CONSTRAINT fk_contact_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL; 