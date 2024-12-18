import os
from flask import Flask, request, jsonify, abort
from flask_mysql import MySQL
from flask_cors import CORS
from werkzeug.security import check_password_hash
 
app = Flask(__name__)
CORS(app, supports_credentials=True, origins=["http://localhost:3000"])

# MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'player_db'

mysql = MySQL(app)

# Function
def validate_user(username, password):
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
    user = cursor.fetchone()
    cursor.close() 
    conn.close()
    if user and check_password_hash(user[2], password):  # 
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
        # Assuming the user table has a 'role' column
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT role FROM users WHERE username = %s", (username,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if user:
            return jsonify({"message": "Login successful", "role": user[0]})
        else:
            abort(401, description="User not found.")

    abort(401, description="Invalid username or password.")

#----AddnewPlayer
@app.route("/players", methods=["POST"])
def add_player():
    data = request.get_json()
    if not data or not data.get("name") or not data.get("age") or not data.get("team") or not data.get("position"):
        abort(400, description="Missing required player data.")
    
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO players (name, age, team, position) VALUES (%s, %s, %s, %s)",
                   (data["name"], data["age"], data["team"], data["position"]))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Player added successfully!"}), 201

#---getall
@app.route("/players", methods=["GET"])
def get_players():
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM players")
    players = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(players)

#--getbyID
@app.route("/players/<int:player_id>", methods=["GET"])
def get_player(player_id):
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM players WHERE id = %s", (player_id,))
    player = cursor.fetchone()
    cursor.close()
    conn.close()
    if not player:
        abort(404, description=f"Player with ID {player_id} not found.")
    return jsonify(player)

# Delete a player 
@app.route("/players/<int:player_id>", methods=["DELETE"])
def delete_player(player_id):
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM players WHERE id = %s", (player_id,))
    rowsaffected = cursor.rowcount
    conn.commit()
    cursor.close()
    conn.close()
    if rowsaffected == 0:
        abort(404, description=f"Player with ID {player_id} not found.")
    return jsonify({"message": f"Player with id {player_id} successfully deleted!"})

# Edit player info (currently commented out as a placeholder)
# @app.route("/players/<int:player_id>", methods=["PUT"])
# def edit_player(player_id):
#     conn = mysql.connect()
#     cursor = conn.cursor()
#     cursor.execute()

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
    app.run(debug=True)
