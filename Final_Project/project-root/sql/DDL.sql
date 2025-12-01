-- This is a Health and Fitness Club Management System
-- Authors: Esli Emmanuel Konate and Joseph Dereje
-- Course: COMP3005


-- Drop the views and functions if they already exist
DROP VIEW IF EXISTS member_dashboard;
DROP TRIGGER IF EXISTS update_session_bill ON SessionsPossible;
DROP TRIGGER IF EXISTS manage_class_enrollment ON Enrollments;
DROP FUNCTION IF EXISTS create_session_bill();
DROP FUNCTION IF EXISTS update_class_enrollment() CASCADE;
DROP INDEX IF EXISTS index_session_datetime;
-- We drop the tables if they already exist
DROP TABLE IF EXISTS Enrollments CASCADE;
DROP TABLE IF EXISTS Bills CASCADE;
DROP TABLE IF EXISTS HealthMetrics CASCADE;
DROP TABLE IF EXISTS SessionsPossible CASCADE;
DROP TABLE IF EXISTS Classes CASCADE;
DROP TABLE IF EXISTS TrainerAvailability CASCADE;
DROP TABLE IF EXISTS Trainers CASCADE;
DROP TABLE IF EXISTS Members CASCADE;
DROP TABLE IF EXISTS Rooms CASCADE;
DROP TABLE IF EXISTS Equipment CASCADE;


DROP ROLE IF EXISTS member_role;
CREATE ROLE member_role;
DROP ROLE IF EXISTS trainer_role;
CREATE ROLE trainer_role;
DROP ROLE IF EXISTS admin_role;
CREATE ROLE admin_role;

-- Now we will create the tables
CREATE TABLE Members (
    member_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    phone VARCHAR(20),
    address TEXT,
    emergency_contact VARCHAR(100),
    emergency_phone VARCHAR(20),
    registration_date DATE DEFAULT CURRENT_DATE,
    membership_stat VARCHAR(20) DEFAULT 'Active' CHECK (membership_stat IN ('Active', 'Inactive', 'Suspended')),
    fitness_goals TEXT,
    target_weight DECIMAL(5,2),
    target_body_fat Decimal (5,2)
);

-- Now the trainers table

CREATE Table Trainers (
    trainer_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    certification TEXT,
    Phone VARCHAR(20),
    hire_date DATE DEFAULT CURRENT_DATE,
    hourly_rate DECIMAL(10, 2) DEFAULT 50.00,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Break'))
);

-- Now Rooms Table

CREATE TABLE Rooms(
    room_id SERIAL PRIMARY KEY,
    room_name VARCHAR(100) NOT NULL,
    room_type VARCHAR(50) CHECK (room_type IN ('Studio', 'Gym Floor', 'Pool', 'Training Room')),
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    equipment_available TEXT,
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Reparations', 'Occupied'))
);

-- Equipment Table now
Create Table Equipment(
    equipment_id SERIAL PRIMARY KEY,
    equipment_name VARCHAR(100) NOT NULL,
    equipment_type VARCHAR(50),
    room_id INTEGER REFERENCES Rooms(room_id),
    purchase_date DATE,
    last_reparation DATE,
    next_reparation DATE,
    status VARCHAR(20) DEFAULT 'Working' CHECK (status IN ('Working', 'Under Reparations', 'Not Working'))
);

-- TrainerAvailability now

CREATE TABLE TrainerAvailability(
    availability_id SERIAL PRIMARY KEY,
    trainer_id INTEGER NOT NULL REFERENCES Trainers(trainer_id) ON DELETE CASCADE,
    day_of_week VARCHAR(10) CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    start_time TIME NOT NULL, 
    end_time TIME NOT NULL,
    repeats BOOLEAN DEFAULT TRUE,
    -- IF IT DOES NOT REPEAT
    specific_date DATE, 
    CONSTRAINT CHECK_TIME CHECK (end_time > start_time),
    CONSTRAINT unique_trainer_slot UNIQUE (trainer_id, day_of_week, start_time, end_time)
);

-- Now sessions table
CREATE TABLE SessionsPossible (
    session_id  SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES Members(member_id) ON DELETE CASCADE,
    trainer_id INTEGER NOT NULL REFERENCES Trainers(trainer_id),
    room_id INTEGER REFERENCES Rooms(room_id),
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'Finished', 'Cancelled', 'No-Show')),
    session_type VARCHAR(50) DEFAULT 'Personal Training',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_session_time CHECK (end_time > start_time),
    CONSTRAINT no_double_booking_member UNIQUE (member_id, session_date, start_time),
    CONSTRAINT no_double_booking_trainer UNIQUE (trainer_id, session_date, start_time),
    CONSTRAINT no_double_booking_room UNIQUE (room_id, session_date, start_time)
);

-- NOW Creation of Classes Table

CREATE TABLE Classes(
    class_id SERIAL PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    description TEXT,
    trainer_id INTEGER NOT NULL REFERENCES Trainers(trainer_id),
    room_id INTEGER NOT NULL REFERENCES Rooms(room_id),
    class_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    max_capacity INTEGER NOT NULL CHECK (max_capacity > 0),
    current_enrollment INTEGER DEFAULT 0 CHECK (current_enrollment >= 0),
    status VARCHAR(20) DEFAULT  'Open' CHECK (status IN ('Open', 'Full', 'Cancelled', 'Finished')),
    price DECIMAL(10,2) DEFAULT(20.00),
    CONSTRAINT check_class_time CHECK (end_time > start_time),
    CONSTRAINT check_enrollment CHECK (current_enrollment <= max_capacity),
    CONSTRAINT unique_class_schedule UNIQUE (room_id, class_date, start_time)
);

-- Now Enrollments table

CREATE TABLE Enrollments(
    enrollment_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES Members(member_id) ON DELETE CASCADE,
    class_id INTEGER NOT NULL REFERENCES Classes(class_id) ON DELETE CASCADE,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attendance_status VARCHAR(20) DEFAULT 'Registered' CHECK (attendance_status IN ('Registered', 'Attended', 'Absent', 'Cancelled')),
    CONSTRAINT unique_enrollment UNIQUE (member_id, class_id)
);

-- Now HealthMetrics Table

CREATE TABLE HealthMetrics(
    metric_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES Members(member_id) ON DELETE CASCADE,
    measurement_date DATE NOT NULL DEFAULT CURRENT_DATE,
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    body_fat_percentage DECIMAL (5,2),
    muscle_mass DECIMAL(5,2),
    bmi DECIMAL(5,2),
    heart_rate INTEGER,
    blood_Pressure VARCHAR(20),
    notes TEXT,
    recorded_by VARCHAR(50) DEFAULT 'Self',
    CONSTRAINT unique_Daily_metric UNIQUE (member_id, measurement_date)
);

-- Bills Table now
CREATE TABLE Bills(
    bill_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES Members(member_id) ON DELETE CASCADE,
    bill_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE DEFAULT (CURRENT_DATE + INTERVAL '14 days'),
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    amount_paid DECIMAL(10, 2) DEFAULT 0 CHECK (amount_paid >= 0),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Paid', 'Partially', 'Overdue', 'Cancelled')),
    description TEXT,
    payment_method VARCHAR(50) CHECK (payment_method IN ('Cash', 'Credit Card', 'Debit Card', 'Bank Transfer', NULL)),
    payment_date DATE,
    CONSTRAINT check_payment CHECK (amount_paid <= total_amount)
);

-- Creating of Indexes for Performance I made 4 here
CREATE INDEX index_session_datetime ON SessionsPossible(session_date, start_time);
CREATE INDEX index_class_datetime ON Classes(class_date, start_time);
CREATE INDEX index_member_email ON Members(email);
CREATE INDEX index_health_metrix_member ON HealthMetrics(member_id, measurement_date DESC);

-- Creation of View for Member Dashboard
CREATE OR REPLACE VIEW member_dashboard AS 
SELECT
    m.member_id,
    m.first_name || ' ' || m.last_name AS full_name,
    m.fitness_goals,
    m.target_weight,
    -- now this is to see the most recent metrics
    hm.weight AS current_weight,
    hm.body_fat_percentage AS current_body_fat,
    hm.bmi AS current_bmi,
    hm.measurement_date AS last_measurement_date,
    -- Now we can calculate the goal progress
    CASE
        WHEN m.target_weight IS NOT NULL AND hm.weight IS NOT NULL THEN ROUND (((m.target_weight - hm.weight) / m.target_weight * 100), 2)
        ELSE NULL
        END AS weight_progress_percent,
        -- this is for next sessions
        (SELECT COUNT(*) FROM SessionsPossible s
        WHERE s.member_id = m.member_id
        AND s.session_date >= CURRENT_DATE
        AND s.status = 'Scheduled') AS upcoming_Sessions,
        -- Classes Enrolled in 
        (SELECT COUNT(*) FROM Enrollments e
        JOIN Classes c ON e.class_id = c.class_id
        WHERE e.member_id = m.member_id
        AND c.class_date >= CURRENT_DATE
        AND e.attendance_status = 'Registered') AS enrolled_classes,

        -- Sessions the member has completed for the month

        (Select COUNT(*) FROM SessionsPossible s
        WHERE s.member_id = m.member_id
        AND s.status = 'Finished'
        AND DATE_PART('month', s.session_date) = DATE_PART('month', CURRENT_DATE)
        AND DATE_PART('year', s.session_date) = DATE_PART('year', CURRENT_DATE)) AS sessions_went_this_month,

        -- Check the Balance

        (SELECT COALESCE(SUM(total_amount - amount_paid), 0)
        FROM Bills bill
        WHERE bill.member_id = m.member_id
        AND bill.status IN ('Pending', 'Partially')) AS outstanding_balance
        FROM Members m
        LEFT JOIN LATERAL (
            SELECT * FROM HealthMetrics hm2
            WHERE hm2.member_id = m.member_id
            ORDER BY measurement_date DESC
            LIMIT 1
        ) hm on true;

-- Now we create the function which will trigger for automatic billing whenever a session is booked
CREATE OR REPLACE FUNCTION create_session_bill()
RETURNS TRIGGER AS $$
DECLARE 
    trainer_rate DECIMAL(10, 2);
    session_duration DECIMAL(5, 2);
BEGIN
    -- The bill will only be created when a new session was scheduled
    if NEW.status = 'Scheduled' AND TG_OP = 'INSERT' THEN
    -- we get the trainer's hourly rate for calculations
    SELECT hourly_rate INTO trainer_rate
    FROM Trainers
    WHERE trainer_id = NEW.trainer_id;

    -- now we calculate the length of the session in hours
    session_duration := EXTRACT(EPOCH FROM (NEW.end_time - NEW.start_time)) / 3600;
    -- now we make the bill for the session
    INSERT INTO Bills (member_id, total_amount, description)
    VALUES (
        NEW.member_id, trainer_rate * session_duration, 'Personal Training Session with Trainer #' || NEW.trainer_id || ' on ' || new.session_date || ' at ' || new.start_time
    );
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- now we create the trigger
CREATE TRIGGER update_session_bill
AFTER INSERT ON SessionsPossible
FOR EACH ROW
EXECUTE FUNCTION create_session_bill();

-- Add another trigger to update the count of class enrollment
CREATE OR REPLACE FUNCTION update_class_enrollment()
RETURNS TRIGGER AS $$
BEGIN 
IF TG_OP = 'INSERT' THEN
UPDATE Classes
SET current_enrollment = current_enrollment + 1
WHERE class_id = NEW.class_id;

-- now we check if class is full
UPDATE Classes
SET status = 'Full'
WHERE class_id = NEW.class_id
AND current_enrollment >= max_capacity;
ELSIF TG_OP = 'DELETE' OR (TG_OP = 'UPDATE' AND NEW.attendance_status = 'CANCELLED') THEN
UPDATE Classes
SET current_enrollment = current_enrollment - 1
WHERE class_id = COALESCE(OLD.class_id, NEW.class_id);

-- Now We reopen the class if there is still space available
UPDATE Classes
SET status = 'Open'
WHERE class_id = COALESCE(OLD.class_id, NEW.class_id)
AND current_enrollment < max_capacity
AND class_date >= CURRENT_DATE;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Give the right permissions for the role and give select, insert or update on members to member_Role
-- Gives select on classes, trainers, rooms to member_role,
-- gives Select, insert, update, delete on sessions to trainer_role
-- gives all on all tables in schema public to admin_role
CREATE TRIGGER manage_class_enrollment
AFTER INSERT OR DELETE OR UPDATE OF attendance_status ON Enrollments
FOR EACH ROW
EXECUTE FUNCTION update_class_enrollment();



-- permissions
GRANT SELECT, INSERT, UPDATE ON Members TO member_role;
GRANT SELECT ON Classes, Trainers, Rooms TO member_role;
GRANT SELECT, INSERT ON Enrollments TO member_role;
GRANT SELECT, INSERT ON HealthMetrics TO member_role;
GRANT SELECT ON Bills TO member_role;
GRANT SELECT, INSERT ON SessionsPossible TO member_role;

GRANT SELECT ON Members TO trainer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON SessionsPossible TO trainer_role;
GRANT SELECT, INSERT, UPDATE ON TrainerAvailability TO trainer_role;
GRANT SELECT ON Classes, Rooms, Equipment TO trainer_role;

GRANT ALL ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO admin_role;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO admin_role;


