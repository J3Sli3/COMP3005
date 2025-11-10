"""
Student Database Management System
This application is linked to a database and it performs CRUD ops
on a students table.

Author: Emmanuel Konate 101322259
Version: 1.0
"""

import psycopg2

#Database connection parameters
connection = psycopg2.connect(host="localhost", database="students_db", user = "postgres", password = "Your Password Here", port = "5432")

def getAllStudents():
    """
    This will retrieve and show all records from the students table
    """
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM students ORDER BY student_id;")
    students = cursor.fetchall()

    print("\n All Students:")
    for student in students:
        print(f"ID: {student[0]}, Name: {student[1]} {student[2]}, Email: {student[3]}, Date: {student[4]}")
    cursor.close()

def addStudent(first_name, last_name, email, enrollment_date):
    """
    Inserts a new student record to the students table
    """
    cursor = connection.cursor()
    query = "INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES (%s, %s, %s, %s);"
    cursor.execute(query, (first_name, last_name, email, enrollment_date))
    connection.commit()
    print(f"\nAdded student: {first_name} {last_name}")
    cursor.close()

def updateStudentEmail(student_id, new_email):
    """
    This updates the email address for a student with the specific student_id
    """
    cursor = connection.cursor()
    query = "UPDATE students SET email = %s WHERE student_id = %s;"
    cursor.execute(query, (new_email, student_id))
    connection.commit()
    print(f"\nUpdated email for student ID {student_id} to {new_email}")
    cursor.close()

def deleteStudent(student_id):
    """
    This deletes the record of the student with the specific student_id
    """
    cursor = connection.cursor()
    query = "DELETE FROM students WHERE student_id = %s;"
    cursor.execute(query, (student_id,))
    connection.commit()
    print(f"\nDeleted student ID {student_id}")
    cursor.close()

if __name__ == "__main__":
    print("=== Student Database Test ===")

    #Show all the students
    print("\n getAllStudents()")
    getAllStudents()
    input("\n Press Enter to continue to ADD op")

    #Add a new student
    print("\n addStudent()")
    addStudent("Emmanuel", "Konate", "esliemmanuelkonate@cmail.carleton.ca", "2025-11-08")
    getAllStudents()
    input("\n Press Enter to continue to UPDATE op")

    #update student email
    print("\n updateStudentEmail()")
    updateStudentEmail(1, "ILOVECOMP3005@Test.com")
    getAllStudents()
    input("\n Press Enter to continue to DELETE op")

    #Delete a student
    print("\n deleteStudent()")
    deleteStudent(4)
    getAllStudents()
    

    connection.close()
