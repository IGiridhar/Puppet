#!/bin/bash

# Define variables
AIDE_BIN="/usr/sbin/aide"
AIDE_CONF="/etc/aide.conf"
AIDE_DB="/var/lib/aide/aide.db.gz"
AIDE_NEW_DB="/var/lib/aide/aide.db.new.gz"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to initialize AIDE database
initialize_aide_db() {
    echo "Initializing AIDE database..."
    $AIDE_BIN --init

    # Check if the new database was created
    if [[ -f "$AIDE_NEW_DB" ]]; then
        echo "AIDE database initialized successfully."
        echo "Replacing the current database with the new one..."
        mv -f "$AIDE_NEW_DB" "$AIDE_DB"
        echo "Database initialization complete!"
    else
        echo "Error: AIDE database initialization failed."
        exit 1
    fi
}

# Function to update AIDE database
update_aide_db() {
    echo "Updating AIDE database..."
    $AIDE_BIN --update

    # Check if the updated database exists
    if [[ -f "$AIDE_NEW_DB" ]]; then
        echo "AIDE database updated successfully."
        echo "Replacing the current database with the updated one..."
        mv -f "$AIDE_NEW_DB" "$AIDE_DB"
        echo "Database update complete!"
    else
        echo "Error: AIDE database update failed."
        exit 1
    fi
}

# Function to verify AIDE setup
verify_aide_db() {
    echo "Verifying AIDE setup..."
    $AIDE_BIN --check
}

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root or with sudo."
    exit 1
fi

echo "Starting AIDE setup..."

# Install AIDE if not installed
if ! command_exists aide; then
    echo "AIDE is not installed. Installing now..."
    yum install -y aide
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to install AIDE."
        exit 1
    fi
fi

# Ask the user for action (initialize or update)
echo "Select an option:"
echo "1. Initialize AIDE Database"
echo "2. Update AIDE Database"
read -p "Enter your choice (1 or 2): " choice

if [[ "$choice" == "1" ]]; then
    initialize_aide_db
elif [[ "$choice" == "2" ]]; then
    update_aide_db
else
    echo "Invalid choice. Please select 1 or 2."
    exit 1
fi

# Verify the database after the operation
verify_aide_db

echo "AIDE operation completed successfully."


# Function to check if AIDE_NEW_DB already exists
check_aide_new_db() {
    if [[ -f "$AIDE_NEW_DB" ]]; then
        echo "Error: AIDE new database file ($AIDE_NEW_DB) already exists."
        echo "Please remove or rename it before initializing a new database."
        exit 1
    fi
}
