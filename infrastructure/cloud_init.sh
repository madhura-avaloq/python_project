#!/bin/bash

echo "****************************SCRIPT START*********************************"

sudo yum install git -y

cd /home/opc

# Step 1: Clone the project repository from GitHub
git clone https://github.com/madhura-avaloq/python_project.git

# Step 2: Navigate to the frontend directory
cd python_project/application/frontend/

# Step 3: Install curl to fetch external resources
sudo yum install -y curl

# Step 4: Setup Node.js repository (LTS version)
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -

# Step 5: Install Node.js
sudo yum install -y nodejs

# Step 6: Verify Node.js installation by checking its version
node -v

# Step 7: Clean yum cache to save disk space
sudo yum clean all

echo "*********************************************************** FRONTEND"

cd python_project/application/backend/

# Step 9: Activate the Python virtual environment
source ./myenv/bin/activate

# Step 10: Install Python 3
sudo yum install -y python3

# Step 11: Install Python package manager (pip)
sudo yum install -y python3-pip

# Step 12: Verify Python 3 installation
python3 --version

# Step 13: Verify pip3 installation
pip3 --version

# Step 14: Install Flask framework using pip3
pip3 install flask

# Step 15: Install Flask-CORS extension using pip3
pip3 install flask_cors

deactivate

# Step 16: Clean yum cache to save disk space
sudo yum clean all

echo "*********************************************************** BACKEND"

###################################################################
# Step 1: Install MySQL and MySQL Server
echo "Installing MySQL server..."
sudo yum install -y mysql mysql-server

# Step 2: Start MySQL service
echo "Starting MySQL service..."
sudo systemctl start mysqld

# Step 3: Enable MySQL service to start on boot
echo "Enabling MySQL to start on boot..."
sudo systemctl enable mysqld

# Step 4: Retrieve the temporary root password generated during MySQL installation
temp_password=$(sudo grep 'temporary password' /var/log/mysqld.log | tail -1 | awk '{print $NF}')
echo "Temporary root password: $temp_password"

# Step 5: Secure MySQL installation and set root password to 'Root@123'
echo "Securing MySQL installation..."
sudo mysql --user=root --password="$temp_password" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Root@123';  # Set new root password
FLUSH PRIVILEGES;  # Apply changes
EXIT;
EOF


echo "***********************************************************************MYSQL DONE"


# Step 6: Create and populate the database
echo "Creating and populating the database..."
sudo mysql --user=root --password='Root@123' <<EOF

echo "MySQL installation completed and root password set to 'Root@123'."
###############################################################


CREATE DATABASE flask_app;

USE flask_app;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,   -- Auto-incrementing ID for each user
    username VARCHAR(50) NOT NULL UNIQUE, -- Unique username
    password VARCHAR(255) NOT NULL,       -- Password (ideally hashed in production)
    role VARCHAR(50) NOT NULL             -- Role of the user (e.g., admin, user)
);

INSERT INTO users (username, password, role)
VALUES
('admin', 'pass1', 'admin'),   -- Sample admin user (password should be hashed)
('user', 'pass2', 'user');     -- Sample regular user (password should be hashed)

CREATE TABLE players (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- Auto-incrementing ID for each player
    name VARCHAR(100) NOT NULL,         -- Player's name
    age INT NOT NULL,                   -- Player's age
    team VARCHAR(100) NOT NULL,         -- Team of the player
    position VARCHAR(50) NOT NULL       -- Position of the player in the team
);

INSERT INTO players (name, age, team, position)
VALUES
('John Doe', 25, 'Team A', 'Forward'),    -- Sample player 1
('Jane Smith', 27, 'Team B', 'Goalkeeper'); -- Sample player 2
EOF

# Step 7: Verify the changes
echo "Verifying the database and tables..."
mysql -u root -p'Root@123' -e "SHOW DATABASES;"
mysql -u root -p'Root@123' -e "USE flask_app; SHOW TABLES;"

echo "***********************************************************************MYSQL DONE"



pip3 install mysql-connector-python


################################################################################


cd python_project/application/frontend/

npm start

cd python_project/application/backend/

source ./myenv/bin/activate

python app.py

echo "***************************************************************************DEPLOYMENT DONE"
