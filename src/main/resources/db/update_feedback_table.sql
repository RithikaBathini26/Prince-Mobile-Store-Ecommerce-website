-- Add new columns to the feedback table
ALTER TABLE feedback
ADD COLUMN type VARCHAR(10) DEFAULT 'review',
ADD COLUMN issue_type VARCHAR(20),
ADD COLUMN status VARCHAR(20) DEFAULT 'pending';

-- Update existing records to have type='review'
UPDATE feedback SET type = 'review' WHERE type IS NULL;

-- Add check constraints
ALTER TABLE feedback
ADD CONSTRAINT chk_feedback_type CHECK (type IN ('review', 'help')),
ADD CONSTRAINT chk_issue_type CHECK (issue_type IN ('defective', 'wrong', 'missing', 'damaged', 'other') OR issue_type IS NULL),
ADD CONSTRAINT chk_status CHECK (status IN ('pending', 'in_progress', 'resolved', 'closed')); 