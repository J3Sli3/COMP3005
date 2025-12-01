-- Health and Fitness Club Management System
-- DML.sql It is a Sample data
-- Authors: Esli Emmanuel Konate and Joseph Dereje

-- We have to clear existing data already present to prevent errors
TRUNCATE TABLE Enrollments CASCADE;
TRUNCATE TABLE Bills CASCADE;
TRUNCATE TABLE HealthMetrics CASCADE;
TRUNCATE TABLE SessionsPossible CASCADE;
TRUNCATE TABLE Classes CASCADE;
TRUNCATE TABLE TrainerAvailability CASCADE;
TRUNCATE TABLE Equipment CASCADE;
TRUNCATE TABLE Trainers CASCADE;
TRUNCATE TABLE Members CASCADE;
TRUNCATE TABLE Rooms CASCADE;

-- Reset the Sequences
ALTER SEQUENCE members_member_id_seq RESTART WITH 1;
ALTER SEQUENCE trainers_trainer_id_seq RESTART WITH 1;
ALTER SEQUENCE rooms_room_id_seq RESTART WITH 1;
ALTER SEQUENCE equipment_equipment_id_seq RESTART WITH 1;
ALTER SEQUENCE traineravailability_availability_id_seq RESTART WITH 1;
ALTER SEQUENCE sessionspossible_session_id_seq RESTART WITH 1;
ALTER SEQUENCE classes_class_id_seq RESTART WITH 1;
ALTER SEQUENCE enrollments_enrollment_id_seq RESTART WITH 1;
ALTER SEQUENCE healthmetrics_metric_id_seq RESTART WITH 1;
ALTER SEQUENCE bills_bill_id_seq RESTART WITH 1;

-- Now we have to put rooms
INSERT INTO Rooms(room_name, room_type, capacity, equipment_available, status) VALUES
('Studio A', 'Studio', 20, 'Mirrors, Sound System, Yoga Mats', 'Available'),
('Studio B', 'Studio', 15, 'Mirrors, Sound System, Ballet Stands', 'Available'),
('Weight Room', 'Gym Floor', 30, 'Free Weights, Benches, Squat Racks', 'Available'),
('Cardio Room', 'Gym Floor', 25, 'Treadmills, Ellipticals, Bikes', 'Available'),
('Training Room 1', 'Training Room', 2, 'Personal Training Equipment', 'Available'),
('Training Room 2', 'Training Room', 2, 'Personal Training Equipment', 'Available'),
('Pool Zone', 'Pool', 15, 'Swimming Pool, Lane Dividers','Available');

-- Insert Members now
INSERT INTO Members (email, password, first_name, last_name, date_of_birth, gender, phone, address, emergency_contact,emergency_phone, fitness_goals, target_weight, target_body_fat) VALUES
('john.doe@email.com', 'password123', 'John', 'Doe', '1990-05-15', 'Male', '613-555-0101', '123 Main St, Ottawa, ON', 'Jane Doe', '613-555-0102', 'Lose weight and build muscle', 180.00, 15.00),
('jim.hopper@email.com', 'password123', 'Jim', 'Hopper', '1965-08-22', 'Male', '613-555-0103', '124 Vecna St, Hawkins, IN', 'Jane Hopper', '613-555-0106', 'Improve cardiovascular fitness', 365.00, 20.00),
('emma.wilson@email.com', 'password123', 'Emma', 'Wilson', '1992-11-30', 'Female', '613-555-0107', '327 Elm St, Ottawa, ON', 'Tom Wilson', '613-555-0108', 'General fitness and flexibility', 130.00, 22.00),
('alex.brown@email.com', 'password123', 'Alex', 'Brown', '1995-07-18', 'Other', '613-555-0109', '654 Maple Dr, Ottawa, ON', 'Pat Brown', '613-555-0124', 'Build strength and endurance', 190.00, 12.00),
('Dope.Mando@email.com', 'password123', 'Dope', 'Mando', '1995-08-20', 'Male', '613-555-0101', '235 Island Park Dr, Ottawa, ON', 'Meeka Nyla', '613-565-0110', 'Weight loss and toning', 160.00, 18.00),
('lisa.davis@email.com', 'password123', 'Lisa', 'Davis', '1987-02-28', 'Female', '613-555-0111', '927 Cedar Ln, Ottawa, ON', 'Mark Davis', '613-555-0112', 'Marathon training', 125.00, 19.00);

-- Insert the trainers
INSERT INTO Trainers (email, password, first_name, last_name, specialization, certification, phone, hourly_rate) VALUES
('trainer.bob@fitclub.com', 'trainer123', 'Bob', 'Anderson', 'Weight Training', 'ACE Certified Personal Trainer', '613-555-0201', 75.00),
('trainer.alice@fitclub.com', 'trainer123', 'Alice', 'Martinez', 'Yoga and Pilates', 'Pilates Association Certified', '613-555-0202', 65.00),
('trainer.chris@fitclub.com', 'trainer123', 'Chris', 'Thompson','Cardio and HIIT', 'CrossFit Certified', '613-555-0203', 70.00),
('trainer.diana@fitclub.com', 'trainer123', 'Diana', 'Lee', 'Swimming','Aquatics Certification', '613-555-0204', 80.00);

-- Insert Equipment Now
INSERT INTO Equipment (equipment_name, equipment_type, room_id, purchase_date, last_reparation, next_reparation, status) VALUES
('Treadmill #1', 'Cardio', 4, '2023-01-15', '2024-10-01', '2025-01-01', 'Working'),
('Treadmill #2', 'Cardio', 4, '2023-01-15', '2024-10-01', '2025-01-01', 'Working'),
('Elliptical #1', 'Cardio', 4, '2023-03-20', '2024-09-15', '2024-12-15', 'Working'),
('Bench Press', 'Strength', 3, '2022-06-10', '2024-08-20', '2024-11-20', 'Working'),
('Squat Rack #1', 'Strength', 3, '2022-06-10', '2024-08-20', '2024-11-20', 'Working'),
('Dumbbells Set', 'Free Weights', 3, '2022-01-01', '2024-07-01', '2025-01-01', 'Working'),
('Rowing Machine', 'Cardio', 4, '2023-08-15', '2024-11-01', '2025-02-01', 'Under Reparations'),
('Yoga Mats (Set of 20)', 'Floor Accessories', 1, '2024-01-01', NULL, '2025-01-01', 'Working');

-- Insert the Trainer Availability 
INSERT INTO TrainerAvailability (trainer_id, day_of_week, start_time, end_time, repeats) VALUES
-- This is Bob's availability for Weight Training
(1, 'Monday', '09:00', '17:00', true),
(1, 'Tuesday', '09:00', '17:00', true),
(1, 'Wednesday', '09:00', '17:00', true),
(1, 'Thursday', '09:00', '17:00', true),
(1, 'Friday', '09:00', '14:00', true),
-- This is Alice's availability for Yoga Class
(2, 'Monday', '06:00', '12:00', true),
(2, 'Tuesday', '06:00', '12:00', true),
(2, 'Wednesday', '16:00', '20:00', true),
(2, 'Thursday', '06:00', '12:00', true),
(2, 'Saturday', '08:00', '12:00', true),
-- This is Chris's availability for Cardio class
(3, 'Monday', '14:00', '21:00', true),
(3, 'Tuesday', '14:00', '21:00', true),
(3, 'Wednesday', '09:00', '17:00', true),
(3, 'Friday', '14:00', '21:00', true),
(3, 'Saturday', '09:00', '15:00', true),
-- This is Diana's availability for swimming class
(4, 'Monday', '14:00', '21:00', true),
(4, 'Tuesday', '14:00', '21:00', true),
(4, 'Wednesday', '09:00', '17:00', true),
(4, 'Friday', '14:00', '21:00', true),
(4, 'Saturday', '09:00', '15:00', true);
-- Now we have to insert for personal training sessions 
INSERT INTO SessionsPossible(member_id, trainer_id, room_id, session_date, start_time, end_time, status, notes) VALUES
-- This will be John's sessions with Bob
(1, 1, 5, '2024-11-25', '10:00', '11:00', 'Scheduled', 'Focus on upper body strength'),
(1, 1, 5, '2024-11-27', '10:00', '11:00', 'Scheduled', 'Leg day workout'),
(1, 1, 5, '2024-11-20', '10:00', '11:00', 'Finished', 'Initial assessment and goal setting'),
-- jims sessions with Alice
(2, 2, 6, '2024-11-26', '07:00', '08:00', 'Scheduled', 'Morning yoga flow'),
(2, 2, 6, '2024-11-19', '07:00', '08:00', 'Finished', 'Flexibility assessment'),
-- emma's sessions with Chris
(3, 3, 5, '2024-11-25', '15:00', '16:00', 'Scheduled', 'HIIT training'),
(3, 3, 5, '2024-11-22', '15:00', '16:00', 'Finished', 'Cardio endurance test'),
-- Alex's sessions
(4, 2, 6, '2024-11-28', '09:00', '10:00', 'Scheduled', 'Pilates core workout'),
-- This is a cancelled session
(5, 1, 5, '2024-11-21', '14:00', '15:00', 'Cancelled', 'Member was sick');

-- Now I add the Group Fitness Classes
INSERT INTO Classes(class_name, description, trainer_id, room_id, class_date, start_time, end_time, max_capacity, current_enrollment, price) VALUES
-- Coming Classes
('Morning Yoga', 'Start your day with exciting yoga flow', 2, 1, '2024-11-26', '06:30', '07:30', 20, 0, 15.00),
('HIIT Blast', 'High-intensity interval training for maximum results', 3, 1, '2024-11-26', '18:00', '19:00', 15, 0, 20.00),
('Strength Training 101', 'Learn proper form for compound lifts', 1, 3, '2024-11-27', '17:00', '18:30', 10, 0, 25.00),
('Aqua Aerobics', 'Low-impact water workout', 4, 7, '2024-11-28', '11:00', '12:00', 12, 0, 18.00),
('Weekend Warriors', 'Total body workout to kickstart your weekend', 3, 1, '2024-11-30', '10:00', '11:00', 20, 0, 20.00),
-- classes that have occured in the past
('Power Yoga', 'Advanced yoga practice', 2, 1, '2024-11-19', '18:00', '19:30', 15, 0, 20.00),
('Cardio Dance', 'Fun dance-based cardio workout', 3, 2, '2024-11-20', '19:00', '20:00', 15, 0, 15.00);
--now we have to update the enrollments for previous classes
UPDATE Classes SET status = 'Finished' WHERE class_date < CURRENT_DATE;
--now we have to Insert enrollments 
INSERT INTO Enrollments (member_id, class_id, attendance_status) VALUES
--enrollments for future classes
(1, 1, 'Registered'), 
(2, 1, 'Registered'),  
(4, 1, 'Registered'), 
(1, 2, 'Registered'),  
(3, 2, 'Registered'),  
(5, 2, 'Registered'), 
(1, 3, 'Registered'),  
(3, 3, 'Registered'),
(2, 4, 'Registered'),  
(4, 4, 'Registered'),  
(6, 4, 'Registered'), 
-- now for previous class enrollments
(1, 6, 'Attended'),    
(2, 6, 'Attended'),    
(4, 6, 'Attended'),    
(3, 7, 'Attended'),   
(5, 7, 'Absent');   
--Now I insert the Health Metrics
INSERT INTO HealthMetrics (member_id, measurement_date, weight, height, body_fat_percentage, muscle_mass, bmi, heart_rate, blood_pressure) VALUES
-- John's metrics 
(1, '2024-11-01', 195.5, 70.0, 22.5, 155.0, 28.1, 72, '120/80'),
(1, '2024-11-15', 192.0, 70.0, 21.0, 156.5, 27.6, 68, '118/78'),
--jims metrics
(2, '2024-11-01', 145.0, 65.0, 24.0, 110.0, 24.1, 65, '110/70'),
(2, '2024-11-10', 143.5, 65.0, 23.5, 110.5, 23.9, 63, '110/70'),
(2, '2024-11-20', 142.0, 65.0, 23.0, 111.0, 23.6, 62, '108/68'),
--emmas metrics
(3, '2024-11-05', 185.0, 72.0, 15.0, 157.0, 25.1, 70, '125/82'),
(3, '2024-11-19', 187.0, 72.0, 14.5, 159.0, 25.4, 68, '122/80'),
--Alex's metrics
(4, '2024-11-01', 135.0, 64.0, 25.0, 101.0, 23.2, 66, '115/75'),
(4, '2024-11-18', 133.0, 64.0, 24.0, 102.0, 22.8, 64, '112/72'),
--Dope's metrics
(5, '2024-11-12', 165.0, 68.0, 20.0, 132.0, 25.1, 75, '118/76'),
--Lisa's metrics
(6, '2024-11-08', 128.0, 63.0, 21.0, 101.0, 22.7, 60, '105/65');
--Insert the bills now
INSERT INTO Bills(member_id, bill_date, total_amount, amount_paid, status, description, payment_method, payment_date) VALUES
--these are the paid memberships
(1, '2024-11-01', 100.00, 100.00, 'Paid', 'Monthly Membership - November 2024', 'Credit Card', '2024-11-01'),
(2, '2024-11-01', 100.00, 100.00, 'Paid', 'Monthly Membership - November 2024', 'Credit Card', '2024-11-01'),
(3, '2024-11-01', 100.00, 100.00, 'Paid', 'Monthly Membership - November 2024', 'Debit Card', '2024-11-02'),
(4, '2024-11-01', 100.00, 100.00, 'Paid', 'Monthly Membership - November 2024', 'Credit Card', '2024-11-01'),
(5, '2024-11-01', 100.00, 50.00, 'Partially', 'Monthly Membership - November 2024', 'Cash', '2024-11-05'),
--This is personal training session fees
(1, '2024-11-20', 75.00, 75.00, 'Paid', 'Personal Training Session - Finished', 'Credit Card', '2024-11-20'),
(2, '2024-11-19', 65.00, 65.00, 'Paid', 'Personal Training Session - Finished', 'Credit Card', '2024-11-19'),
(3, '2024-11-22', 70.00, 0.00, 'Pending', 'Personal Training Session - Finished', NULL, NULL),
--these are the class fees
(1, '2024-11-19', 20.00, 20.00, 'Paid', 'Power Yoga Class', 'Credit Card', '2024-11-19'),
(3, '2024-11-20', 15.00, 15.00, 'Paid', 'Cardio Dance Class', 'Cash', '2024-11-20');


-- Now we add an admin user
INSERT INTO Members (email, password, first_name, last_name, date_of_birth, gender, phone, membership_stat) VALUES
('admin@fitclub.com', 'admin123', 'Admin', 'User', '1980-01-01', 'Other', '613-555-0000', 'Active');
--now we have to test insertin
SELECT 'Members' as table_name, COUNT(*) as count FROM Members
UNION ALL
SELECT 'Trainers', COUNT(*) FROM Trainers
UNION ALL
SELECT 'SessionsPossible', COUNT(*) FROM SessionsPossible
UNION ALL
SELECT 'Classes', COUNT(*) FROM Classes
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM Enrollments
UNION ALL
SELECT 'HealthMetrics', COUNT(*) FROM HealthMetrics
UNION ALL
SELECT 'Bills', COUNT(*) FROM Bills;