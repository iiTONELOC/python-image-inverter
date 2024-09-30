#!/bin/bash

# Function to find Python executable
find_python() {
    if command -v python &> /dev/null; then
        echo "python"
    elif command -v python3 &> /dev/null; then
        echo "python3"
    else
        echo "Error: Python is not installed. Please install Python before proceeding."
        exit 1
    fi
}

# Function to check if we are on Windows
is_windows() {
    if [[ "$(uname -s)" =~ (CYGWIN|MINGW|MSYS|WSL) ]]; then
        return 0  # True, we are on a Windows environment
    else
        return 1  # False, we are on a non-Windows environment
    fi
}

# Function to make sure the shell is configured correctly
setup_shell_rc() {
    local shell_name="$1"
    local rc_file="$HOME/.${shell_name}rc"
    local profile_file="$HOME/.${shell_name}_profile"

    # Check if the configuration file exists, create it if it doesn't
    if [ ! -f "$rc_file" ]; then
        # Make sure the profile file exists and sources the rc file
        if [ ! -f "$profile_file" ]; then
            touch "$profile_file"
            echo -e "test -f ~/.profile && . ~/.profile\ntest -f ~/${shell_name}rc && . ~/${shell_name}rc" >> "$profile_file"
        fi
        touch "$rc_file"
    fi
}

# Function to update the alias in the shell configuration file
add_alias() {
    local shell_rc=$1
    local alias_name="pii"
    local alias_command="alias $alias_name='$DIR/start.sh'"

    if [ -f "$shell_rc" ]; then
        # Check if the alias already exists
        if grep -q "alias $alias_name=" "$shell_rc"; then
            # Check if the alias has the correct path
            existing_alias=$(grep "alias $alias_name=" "$shell_rc")
            if [[ "$existing_alias" == "$alias_command" ]]; then
                echo "Alias already exists in $shell_rc with the correct path. Skipping..."
            else
                # Remove the old alias and add the updated one
                echo "Alias exists but with a different path. Updating $alias_name in $shell_rc..."
                sed -i "/alias $alias_name=/d" "$shell_rc" # Remove the old alias
                echo "$alias_command" >> "$shell_rc"      # Add the new alias
                echo "Alias updated in $shell_rc"
            fi
        else
            # Add the alias if it doesn't exist
            echo "Adding alias to $shell_rc..."
            echo "$alias_command" >> "$shell_rc"
            echo "Alias added to $shell_rc"
        fi
    else
        echo "$shell_rc not found. Skipping."
    fi
}

# ________ Main Script ________

# Get the Python executable
PYTHON=$(find_python)

# Get the directory of this script, not where it is called from
DIR="$(cd "$(dirname "$0")" && pwd)"

# Make sure we are in the correct directory
cd "$DIR"

echo "Creating virtual environment..."
# Create a virtual environment
$PYTHON -m venv venv

# Determine the correct paths for activation and pip depending on the OS
if is_windows; then
    # Windows uses 'Scripts' for virtual environments
    VENV_ACTIVATE="venv/Scripts/activate"
    VENV_PYTHON="venv/Scripts/python"
else
    # Unix-based systems use 'bin' for virtual environments
    VENV_ACTIVATE="venv/bin/activate"
    VENV_PYTHON="venv/bin/python"
fi

# Activate the virtual environment
source "$VENV_ACTIVATE"

echo "Installing project requirements..."
# Install project requirements
$VENV_PYTHON -m pip install --upgrade pip
$VENV_PYTHON -m pip install -r requirements.txt

# Deactivate the virtual environment when done
deactivate


# Check for installed shells and create the corresponding rc files if necessary
if command -v bash &> /dev/null; then
    setup_shell_rc "bash"
    add_alias "$HOME/.bashrc"
fi

if command -v zsh &> /dev/null; then
    setup_shell_rc "zsh"
    add_alias "$HOME/.zshrc"
fi


# if not on windows, make the start.sh executable
if ! is_windows; then
    chmod +x start.sh
fi

echo "Installation complete. Please restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc' to apply changes."
