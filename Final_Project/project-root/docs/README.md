Health and Fitness Club Management System

COMP 3005: Final Project
Authors: Esli Emmanuel Konate and Joseph Dereje

-----------------------------------------------------------------------------------------------
Project Description

A comprehensive database system to manage health and fitness club’s operations. It includes member registration, personal training sessions, group fitness classes, trainer scheduling, equipment maintenance, room bookings, and billing.
-----------------------------------------------------------------------------------------------

Video Demonstration

System Requirements

PostgreSQL 12+
Python 3.8+
psycopg2-binary

Installation Instructions

Install Python requirements

	Pip install psycopg2-binary

Database Setup
1. Open pgAdmin
2. Create new database: fitness_club
3. Open Query Tool
4. Run DDL.sql to create a schema
5. Run DML.sql to populate with sample data







Configure the connection to Database
	

In fitness_app.py, update the connection infos
	
		dbname=”fitness_club”
		user=”postgres” // here input your PostgreSQL username
		password=”password” // here input your PostgreSQL password
		host3=”localhost”
		port =”5432”
3. Run the Application

	python fitness_app.py

Features:

4 Member Functions 

User Registration: Create new member account with unique email.
Profile management: Update fitness goals and log health metrics.
Dashboard View: View personal stats, upcoming sessions, and balance.
PT Session Booking: Schedule personal training sessions.

2 Trainer Functions 

Set Availability: Sets working hours and availability.
Member Search: Look up member profiles by name.

4 Admin Functions

Room Booking Management: View and manage facility bookings.
Equipment Maintenance: Track and update status of equipments
Class Schedule Management: Create and manage group fitness classes
Payment Processing: Handle member billing and payments

-----------------------------------------------------------------------------------------------

Constraints:

No double-booking 
Automatic billing for sessions
Class enrollment capacity management
No conflicts in terms of trainer availabilities

Technologies Used

PostgreSQL (Database)
Python 3 (Application Logic)
Psycopg2 (Connect to Database)
SQL (DDL, DML, Queries)

