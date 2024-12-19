import mysql.connector

try:
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='Root@12345',
        database='flask_app'
        )                
    print("Connection successful")
    cursor=conn.cursor(dictionary=True)
    cursor.execute('select * from users where username="admin";')
    temp=cursor.fetchall()

    for i ,j in temp.items():


    print(temp)
    conn.close()
except mysql.connector.Error as err:
    print(f"Error: {err}")

