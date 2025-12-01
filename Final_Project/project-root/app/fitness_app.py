"""
This is Health and Fitness Club Management System
There are 10 functions in it
Authors: Esli Emmanuel Konate and Joseph Dereje
"""
import psycopg2
from datetime import datetime, timedelta
import sys
class FitnessClubSystem:
    def __init__(self):
        """Setup database connection"""
        try:
            self.conn = psycopg2.connect(
                dbname="fitness_club", user= "postgres", password="password",host="localhost",port="5432")
            self.cursor = self.conn.cursor()
            print("We are connected to the database")
        except Exception as e:
            print(f"We failed to connect to the database {e}")
            sys.exit(1)

    # Member Functions 

    def member_registration(self):
        """
        Function 1: User Registration
        print("\n Member Regisration:")
        """
        try:
            #get the necessary fields only
            email = input("Email: ")
            password = input("Password: ")
            first_name = input("First Name: ")
            last_name = input("Last Name: ")
            dob = input("Date of Birth (YYYY-MM-DD): ")
            gender = input("Gender (Male/Female/Other): ")
            phone = input("Phone: ")

            #now we insert the member
            self.cursor.execute(""" INSERT INTO MEMBERS (email, password, first_name, last_name, date_of_birth, gender, phone) 
                                VALUES (%s, %s, %s, %s, %s, %s, %s)
                                RETURNING member_id""", (email, password, first_name, last_name, dob, gender, phone))
            member_id = self.cursor.fetchone()[0]
            self.conn.commit()
            print(f"The registration was successful! Member ID: {member_id}")
            return True
        
        except Exception as e:
            self.conn.rollback()
            print(f"Registration has failed: {e}")
            return False
        
    def update_profile(self):
        """Function 2: Update personal info and fitness goals"""
        print("Update Profile:")
        try: 
            member_id = int(input("Member ID: "))
            print("\n1. Update fitness goals")
            print("\n2. Add health metrics")
            choice = input("Choice: ")

            if choice == '1':
                goals = input("Fitness goals: ")
                target_weight = input("Target weight (or press Enter to skip): ")
                if target_weight:
                    target_weight = float(target_weight) 
                else:
                    None
                self.cursor.execute("""
                                    UPDATE Members 
                                    Set Fitness_goals = %s, target_weight = %s
                                    WHERE member_id = %s
                                    """, (goals, target_weight, member_id))
                self.conn.commit()
                print("The Objectives/Goals have been updated")

            elif choice == '2':
                weight = float(input("Weight: "))
                heart_rate = int(input("Heart rate: "))
                date = input("Date (YYYY-MM-DD) or Enter for today: ")
                if date:
                    date = date
                else: 
                    date = 'CURRENT_DATE'

                self.cursor.execute("""
                                    INSERT INTO HealthMetrics (member_id, weight, heart_rate, measurement_date)
                                    VALUES (%s, %s, %s, %s)
                                    """, (member_id, weight, heart_rate, date if date != 'CURRENT_DATE' else datetime.now().date()))
                self.conn.commit()
                print("Metrics were added!")
                return True
        except Exception as e:
            self.conn.rollback()
            print(f"Update has failed: {e}")
            return False
        
    def view_dashboard(self):
        """Function 3: Show member stats using the view"""
        print("\n Member Dashboard")
        try:
            member_id = int(input("Member ID: "))

            #we have to use the view we have created
            self.cursor.execute("""
                                SELECT full_name, fitness_goals, target_weight, current_weight, upcoming_sessions, enrolled_classes, outstanding_balance
                                FROM member_dashboard
                                WHERE member_id = %s
                                """, (member_id,))
            data = self.cursor.fetchone()
            if data:
                print(f"\n {data[0]}")
                print(f"\nGoals: {data[1] or 'Not set'}")
                print(f"\nTarget Weight: {data[2] or 'Not set'}")
                print(f"\nCurrent Weight: {data[3] or 'No data'}")
                print(f"\nUpcoming Sessions: {data[4]}")
                print(f"\nClasses Enrolled: {data[5]}")
                print(f"\nBalance: {data[6]}$")
            else:
                print("Member was not found")

            return True
        except Exception as e:
            print(f"There was an error while loading the dashboard: {e}")
            return False
        
    def schedule_personal_training(self):
        """Function4: Schedule personal training session"""
        print("Schedule Personal Training: ")
        try:
            member_id = int(input("Member ID: "))
            #thats to show the trainers
            self.cursor.execute("SELECT trainer_id, first_name, last_name FROM Trainers")
            trainers = self.cursor.fetchall()
            print("\n Available Trainers:")
            for t in trainers:
                print(f"{t[0]}. {t[1]} {t[2]}")

            trainer_id = int(input("Trainer ID: "))
            date = input("Date (YYYY-MM-DD): ")
            start_time = input("Start time (HH:MM): ")
            end_time = input("End time (HH:MM) ")

            #Here we can book session
            self.cursor.execute("""
                                INSERT INTO SessionsPossible (member_id, trainer_id, room_id, session_date, start_time, end_time, status)
                                VALUES (%s, %s, 5, %s, %s, %s, 'Scheduled')
                                RETURNING session_id""", (member_id, trainer_id, date, start_time, end_time))
            session_id = self.cursor.fetchone()[0]
            self.conn.commit()
            print(f"Session booked! ID: {session_id}")
            return True
        except Exception as e:
            self.conn.rollback()
            print(f"Booking has unfortunately failed: {e}")
            return False
    
    def set_trainer_availability(self):
        """Function 5: Set trainer availability"""
        print("\n Set Trainer Availability: ")
        try:
            trainer_id = int(input("Trainer ID: "))
            day = input("Day of the week (Monday-Sunday): ")
            start = input("Start time (HH:MM): ")
            end = input("End time (HH:MM): ")

            self.cursor.execute("""
                                INSERT INTO TrainerAvailability (trainer_id, day_of_week, start_time, end_time)
                                VALUES (%s, %s, %s, %s)""", (trainer_id, day, start, end))
            self.conn.commit()
            print("Availability was addded")
            return True
        except Exception as e:
            self.conn.rollback()
            print(f"Failed: {e}")
            return False
    def view_member_profile(self):
        """Function 6: trainer can search by name"""
        print("\n View Member Profile: ")
        try:
            search = input("Search member name: ")
            self.cursor.execute("""
                                SELECT member_id, first_name, last_name, fitness_goals
                                FROM Members
                                WHERE LOWER (first_name || ' ' || last_name) LIKE LOWER(%s)""", (f'%{search}%',))
            members = self.cursor.fetchall()
            for m in members:
                print(f"\nID: {m[0]} - {m[1]} {m[2]}")
                print(f"Goals: {m[3] or 'Not set'}")

            if not members:
                print("No members were found")

            return True
        except Exception as e:
            print(f" Search has failed: {e}")
            return False

    def manage_room_bookings(self):
        """Function 7: Manage room bookings"""
        print("\n Manage Room Bookings: ")
        try: 
            date = input("View bookings for date (YYYY-MM-DD): ")
            self.cursor.execute("""
                                SELECT r.room_name, s.start_time, s.end_time, 'Session' as type
                                FROM SessionsPossible s
                                JOIN Rooms r ON s.room_id = r.room_id
                                WHERE s.session_date = %s AND s.status = 'Scheduled'
                                UNION
                                SELECT r.room_name, c.start_time, c.end_time, c.class_name
                                FROM Classes c
                                JOIN Rooms r ON c.room_id = r.room_id
                                WHERE c.class_date = %s
                                ORDER BY start_time""", (date, date))
            bookings = self.cursor.fetchall()
            if bookings:
                print(f"\n Bookings for {date}:")
                for b in bookings:
                    print(f" {b[0]}: {b[1]}-{b[2]} ({b[3]})")                    
            else:
                print("No bookings were found")
            return True
        except Exception as e:
            print(f"Error: {e}")
            return False
        
    def manage_equipment_maintenance(self):
        """Function 8: Update equipment status"""
        print("Equipment Maintenance: ")
        try: 
            #first show the equipment
            self.cursor.execute("SELECT equipment_id, equipment_name, status FROM Equipment")
            equipment = self.cursor.fetchall()
            print("\nEquipment:")
            for e in equipment:
                print(f" {e[0]}. {e[1]} - Status: {e[2]}")
            equip_id = int(input("\nEquipment ID to update: "))
            print("1. Working")
            print("2. Under Reparations")
            print("3. Not Working")
            choice = input("New status: ")

            status_options = {'1': 'Working', '2': 'Under Reparations', '3' : 'Not Working'} 
            new_status = status_options.get(choice, 'Working')
            self.cursor.execute("""
                                UPDATE Equipment SET status = %s WHERE equipment_id = %s""", (new_status, equip_id))
            self.conn.commit()
            print("Status has now updated")
            return True
        except Exception as e:
            self.conn.rollback()
            print(f"The update has failed: {e}")
            return False

    def update_class_schedule(self):
        """Function 9: Update Class Schedules"""
        print("\n Update Class Schedules: ")
        try:
            #add a new possible class
            name = input("Class name: ")
            trainer_id = int(input("Trainer ID: "))
            room_id = int(input("Room ID (1-7): "))
            date = input("Date (YYYY-MM-DD): ")
            start = input("Start time (HH:MM): ")
            end = input("End time (HH:MM): ")
            capacity = int(input("Max capacity: "))

            self.cursor.execute("""
                                INSERT INTO Classes (class_name, trainer_id, room_id, class_date, start_time, end_time, max_capacity)
                                VALUES (%s, %s, %s, %s, %s, %s, %s)
                                RETURNING class_id""", (name, trainer_id, room_id, date, start, end, capacity))
            class_id = self.cursor.fetchone()[0]
            self.conn.commit()
            print(f"The Class was Created Successfully ID: {class_id}")
            return True
        except Exception as e:
            self.conn.rollback()
            print(f"Class Creation Failed: {e}")
            return False
        
    def process_member_payment(self):
        """Function 10: process billing and payments"""
        print("\n Process Payment")
        try:
            #show available bills
            self.cursor.execute("""
                                SELECT b.bill_id, m.first_name, m.last_name, b.total_amount, b.amount_paid
                                FROM Bills b
                                JOIN Members m ON b.member_id = m.member_id
                                WHERE b.status IN ('Pending', 'Partially')
                                LIMIT 10""")
            bills = self.cursor.fetchall()
            if bills:
                    print("\nPending Bills:")
                    for bill in bills:
                        print(f"ID: {bill[0]} | {bill[1]} {bill[2]} | Total: ${bill[3]} | Paid: ${bill[4]}")
            else:
                print("No pending bills found")
                return False
            bill_id = int(input("\n Bill ID to pay: "))
            amount = float(input("Payment amount: "))

            #update payment here
            self.cursor.execute("""
                                UPDATE Bills
                                Set amount_paid = amount_paid + %s,
                                status = CASE
                                WHEN amount_paid + %s >= total_amount THEN 'Paid'
                                ELSE 'Partially'
                                END,
                                payment_date = CURRENT_DATE
                                WHERE bill_id = %s""", (amount, amount, bill_id))
            self.conn.commit()
            print("The payment was processsed")
            return True
        except Exception as e:
            self.conn.rollback()
            print(f"Payment has failed: {e}")
            return False
        
    #Now here is the main menu
    def run(self):
        """This is the Main application"""
        while True:
            print("\n" + "=" * 50)
            print("FITNESS CLUB MANAGEMENT SYSTEM")
            print(" Team of 2 - We have 10 Functions")
            print("="*50)
            print("\n FUNCTIONS FOR MEMBERS")
            print("1. Member Registration")
            print("2. Update Profile or Metrics")
            print("3. View the Dashboard")
            print("4. Schedule a PT Session")
            print("\n FUNCTIONS FOR TRAINERS")
            print("5. Set Availability")
            print("6. View Member Profile")
            print("\n FUNCTIONS FOR Admins")
            print("7. Manage Room Bookings")
            print("8. Equipment Maintenance")
            print("9. Update Class Schedule")
            print("10. Process Payment")
            print("\n0. Exit")

            choice = input("\n Select (0-10): ")

            if choice == '0':
                print("Goodbye!!!")
                break
            elif choice == '1':
                self.member_registration()
            elif choice == '2':
                self.update_profile()
            elif choice == '3':
                self.view_dashboard()
            elif choice == '4':
                self.schedule_personal_training()
            elif choice == '5':
                self.set_trainer_availability()
            elif choice == '6':
                self.view_member_profile()
            elif choice == '7':
                self.manage_room_bookings()
            elif choice == '8':
                self.manage_equipment_maintenance()
            elif choice == '9':
                self.update_class_schedule()
            elif choice == '10':
                self.process_member_payment()
            else:
                print("Invalid choice brah!")

if __name__ == "__main__":
    app = FitnessClubSystem()
    app.run()
            
            
            

                               
