-- Dropping the table if it exists to prevent errors
DROP TABLE IF EXISTS students;

-- Create students table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    enrollment_date DATE
);

-- Insert Starting data

INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES
('Bob', 'Lovey', 'bobbylovey@gmail.com', '2023-09-01'),
('Bruce', 'Wayne', 'Batman@gmail.com', '2025-09-01'),
('Jim', 'Hopper', 'HawkinsSheriff@gmail.com', '2024-09-01');
