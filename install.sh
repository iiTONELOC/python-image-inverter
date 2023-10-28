#!/bin/zsh

# Check if Python is installed
if ! command -v python &> /dev/null; then
    echo "Python is not installed. Please install Python before proceeding."
    exit 1
fi

# Get the directory of this script, not where it is called from
DIR="$(cd "$(dirname "$0")" && pwd)"

# make sure we are in the correct directory
cd "$DIR"

echo "Creating virtual environment..."
# Create a virtual environment
python -m venv venv

# Activate the virtual environment
source venv/bin/activate

echo "Installing project requirements...\n"
# Install project requirements
venv/bin/python -m pip install --upgrade pip

venv/bin/python -m pip install -r requirements.txt

# Deactivate the virtual environment when done
deactivate
