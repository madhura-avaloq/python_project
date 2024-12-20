from flask import Flask, request, jsonify, abort
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app, origins=["http://140.245.26.89:3000"])

# MySQL Database connection configuration
def get_db_connection():
    conn = mysql.connector.connect(
        host='localhost',  # Change this if your MySQL server is on a different host
        user='root',       # Your MySQL username
        password='Root@12345',  # Your MySQL password
        database='flask_app'  # Database name
    )
    return conn

# Sample user data (replacing MySQL users table)
def validate_user(username, password):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE username = %s', (username,))
    user = cursor.fetchone()
    conn.close()
    if user and user['password'] == password:  # Check plain text password
        return True
    return False

#-----Login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username', None)
    password = data.get('password', None)
    
    if username is None or password is None:
        abort(400, description="Username and password are required.")

    if validate_user(username, password):
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('SELECT * FROM users WHERE username = %s', (username,))
        user = cursor.fetchone()
        conn.close()

        if user:
            return jsonify({"message": "Login successful", "role": user['role']})
        else:
            abort(401, description="User not found.")
    
    abort(401, description="Invalid username or password.")

#----Add new player
@app.route("/players", methods=["POST"])
def add_player():
    data = request.get_json()
    if not data or not data.get("name") or not data.get("age") or not data.get("team") or not data.get("position"):
        abort(400, description="Missing required player data.")
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO players (name, age, team, position) 
        VALUES (%s, %s, %s, %s)
    ''', (data['name'], data['age'], data['team'], data['position']))
    conn.commit()
    conn.close()

    return jsonify({"message": "Player added successfully!"}), 201

#---Get all players
@app.route("/players", methods=["GET"])
def get_players():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM players')
    players = cursor.fetchall()
    conn.close()

    return jsonify(players)

#--Get player by ID
@app.route("/players/<int:player_id>", methods=["GET"])
def get_player(player_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM players WHERE id = %s', (player_id,))
    player = cursor.fetchone()
    conn.close()

    if not player:
        abort(404, description=f"Player with ID {player_id} not found.")
    
    return jsonify(player)

# Delete a player 
@app.route("/players/<int:player_id>", methods=["DELETE"])
def delete_player(player_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM players WHERE id = %s', (player_id,))
    conn.commit()
    conn.close()

    return jsonify({"message": f"Player with id {player_id} successfully deleted !!"})

# Edit player info
@app.route("/players/<int:player_id>", methods=["PUT"])
def edit_player(player_id):
    data = request.get_json()
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM players WHERE id = %s', (player_id,))
    player = cursor.fetchone()

    if not player:
        abort(404, description=f"Player with ID {player_id} not found.")
    
    cursor.execute('''
        UPDATE players 
        SET name = %s, age = %s, team = %s, position = %s 
        WHERE id = %s
    ''', (data.get('name', player['name']), 
          data.get('age', player['age']), 
          data.get('team', player['team']), 
          data.get('position', player['position']),
          player_id))
    conn.commit()
    conn.close()

    return jsonify({"message": f"Player with ID {player_id} successfully updated!"})

#-------Error handling
@app.errorhandler(400)
def bad_request(error):
    return jsonify({"error": str(error)}), 400

@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": str(error)}), 404

@app.errorhandler(405)
def method_not_allowed(error):
    return jsonify({"error": "Method Not Allowed"}), 405

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0', port=5000)

