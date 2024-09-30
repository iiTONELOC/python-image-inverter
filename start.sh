#!/bin/bash

# Get the directory of this script, not where it is called from
DIR="$(cd "$(dirname "$0")" && pwd)"

# The venv is located in the same directory as this script (start.sh)
VENV="$DIR/venv"

# Check if the virtual environment is activated
if [ -z "$VENV" ]; then
    echo "Virtual environment was not found, installing..."
    sh "$DIR/install.sh"
fi

# Run the pii.py program from the virtual environment with the provided argument
"$VENV/bin/python" "$DIR/pii.py" "$1"
