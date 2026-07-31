def read_data(cur, key):
    cur.execute("""SELECT * FROM hr.departments WHERE department_id = %s""", (key,) )
    for record in cur:
            print(record) 

def update_data(cur, key, name, manager, location):
    cur.execute("""UPDATE hr.departments
                    SET department_name = %s,
                        manager_id = %s,
                        location_id = %s
                    WHERE department_id = %s""", (name, manager, location, key))
    
def create_data(cur, key, name, manager, location):
    cur.execute("""INSERT INTO hr.departments
                    VALUES (%s, %s, %s, %s) """,(key, name, manager, location))

def delete_data(cur, key):
    cur.execute("""DELETE FROM hr.departments WHERE department_id = %s""", (key,))

###############################################
# Aufruf der CRUD-Funktionen
###############################################

import psycopg

# Connect to an existing database
# psycopg.connect("dbname=postgres user=postgres password=admin")
with psycopg.connect("postgresql://postgres:admin@localhost") as conn:

    # Open a cursor to perform database operations
    with conn.cursor() as cur:

        read_data(cur, 50)

        create_data(cur, 300, "Karrer_Abteilung", 100, None)

        read_data(cur, 300)

        update_data(cur,300, "Neue_Abteilung", None, None)

        read_data(cur, 300)

        delete_data(cur, 300)

        

        # Make the changes to the database persistent
        conn.commit()