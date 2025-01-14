# Function to find Python executable
function Find-Python {
    if (Get-Command python -ErrorAction SilentlyContinue) {
        return "python"
    }
    elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
        return "python3"
    }
    else {
        Write-Host "Error: Python is not installed. Please install Python before proceeding."
        exit 1
    }
}

# Get the Python executable
$PYTHON = Find-Python

# Get the directory of this script, not where it is called from
$DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Make sure we are in the correct directory
Set-Location $DIR

Write-Host "Creating a python virtual environment..."
# Create a virtual environment
& $PYTHON -m venv venv

# Activate the virtual environment
$venvActivate = Join-Path $DIR "venv\Scripts\Activate.ps1"
if (Test-Path $venvActivate) {
    & $venvActivate
}
else {
    Write-Host "Error: Virtual environment activation script not found."
    exit 1
}

Write-Host "Installing project requirements..."

# Upgrade pip and install requirements
& "venv\Scripts\python.exe" -m pip install --upgrade pip
& "venv\Scripts\python.exe" -m pip install -r requirements.txt

# Deactivate the virtual environment when done
deactivate

# Define a universal function for Windows systems, this runs
# the Python script from the created virtual environment
# there is no need to activate the virtual environment and deactivate it after
$functionDefinition = @"
function pii {
    & "$DIR\venv\Scripts\python.exe" "$DIR\pii.py" $args
}
"@

# Ensure that the PowerShell profile exists
if (-not (Test-Path -Path $PROFILE)) {
    # Create the profile file if it doesn't exist
    New-Item -Path $PROFILE -ItemType File -Force
    Write-Host "PowerShell profile created at $PROFILE"
}


# Check if $PROFILE contains the function definition
if (-not (Get-Content -Path $PROFILE | Select-String -Pattern 'function pii')) {
    # Add the function definition to the PowerShell profile
    Add-Content -Path $PROFILE -Value $functionDefinition
    Write-Host "pii function added to your profile."
    Write-Host "Setup complete. Please restart your PowerShell session or run `. $PROFILE` to apply the changes."
}
else {
    Write-Host "pii function already exists in your profile"
    Write-Host "Setup complete."
}
