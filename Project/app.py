from flask import Flask, request, jsonify, abort
from flask_cors import CORS  # Import CORS

app = Flask(__name__)


CORS(app, origins=["http://localhost:3000"])

# Sample static data (replacing MySQL)
players = [
    {'id': 1, 'name': 'John Doe', 'age': 28, 'team': 'Team A', 'position': 'Forward'},
    {'id': 2, 'name': 'Jane Smith', 'age': 24, 'team': 'Team B', 'position': 'Midfielder'},
    {'id': 3, 'name': 'Sam Brown', 'age': 30, 'team': 'Team C', 'position': 'Defender'}
]

# Sample user data (replacing MySQL users table)
users = {
    'admin': {'password': 'pass1', 'role': 'admin'},
    'user': {'password': 'pass2', 'role': 'user'}
}

# Function to validate user
def validate_user(username, password):
    user = users.get(username)
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
        # Return user role after login
        user = users.get(username)
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
    
    new_player = {
        'id': len(players) + 1,
        'name': data["name"],
        'age': data["age"],
        'team': data["team"],
        'position': data["position"]
    }
    players.append(new_player)
    return jsonify({"message": "Player added successfully!"}), 201

#---Get all players
@app.route("/players", methods=["GET"])
def get_players():
    return jsonify(players)

#--Get player by ID
@app.route("/players/<int:player_id>", methods=["GET"])
def get_player(player_id):
    player = next((p for p in players if p['id'] == player_id), None)
    if not player:
        abort(404, description=f"Player with ID {player_id} not found.")
    return jsonify(player)

# Delete a player 
@app.route("/players/<int:player_id>", methods=["DELETE"])
def delete_player(player_id):
    global players
    players = [p for p in players if p['id'] != player_id]
    return jsonify({"message": f"Player with id {player_id} successfully deleted !!"})

# Edit player info
@app.route("/players/<int:player_id>", methods=["PUT"])
def edit_player(player_id):
    data = request.get_json()
    player = next((p for p in players if p['id'] == player_id), None)

    if not player:
        abort(404, description=f"Player with ID {player_id} not found.")
    
    player['name'] = data.get('name', player['name'])
    player['age'] = data.get('age', player['age'])
    player['team'] = data.get('team', player['team'])
    player['position'] = data.get('position', player['position'])

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
    app.run(debug=True)
