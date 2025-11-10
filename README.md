Python application for CRUD operations on PostgreSQL students table.

How to setup
-----------------------------------------------------------------------------

1. Install Python Package


pip install psycopg2-binary


2. Create Database in pgAdmin

2.1: Open pgAdmin

2.2: Create new database: students_db

2.3: Open Query Tool and run schema.sql


3. Setup Database Connection

In student_manager.py change for your credentials:

	user = YOUR_USERNAME
	password = YOUR_PASSWORD

4. Run the Application

	python student_manager.py
===========================================================================
Functions:


	- there is getAllStudents() shows all student record
	- addStudent(first_name,last_name, email, enrollment_date) adds new 	student

	- updateStudentEmail(student_id,new_mail) updates student email
	- deleteStudent(student_id) deletes student record.

Video:

The video shows:

	1. Database setup with data in pgAdmin.
	2. Running each function in the application.
	3. Verifies changes in pgAdmin after INSERT, UPDATE, DELETE ops.
