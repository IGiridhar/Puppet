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

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root or with sudo."
    exit 1
fi

echo "Starting AIDE database initialization..."

# Install AIDE if not installed
if ! command_exists aide; then
    echo "AIDE is not installed. Installing now..."
    yum install -y aide
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to install AIDE."
        exit 1
    fi
fi

# Initialize AIDE database
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

# Verify the database
echo "Verifying AIDE setup..."
$AIDE_BIN --check

echo "AIDE initialization process completed successfully."
