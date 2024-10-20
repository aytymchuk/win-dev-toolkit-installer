
# Helper function to check if a program exists
function Test-Installed($name) {
    Get-Command $name -ErrorAction SilentlyContinue
}

# Helper function to check if a program exists in the system (not only through Chocolatey)
function Test-ProgramInstalled($programName) {
    try {
        # Checking system-wide installed programs
        $installedPrograms = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%$programName%'" -ErrorAction SilentlyContinue
        return $installedPrograms
    } catch {
        # In case of an error (e.g., program not found), we return $null
        Write-Host "Error checking for installed program $programName : $_"
        return $null
    }
}

# Helper function to install or upgrade a package using Chocolatey
function Install-Or-Update($packageName) {
    # First, check if the program exists system-wide
    if (Test-ProgramInstalled $packageName) {
        Write-Host "$packageName is already installed through a non-Chocolatey method."
    }
    # Then, check if the program exists through Chocolatey
    elseif (choco list --local-only | Select-String -Pattern $packageName) {
        Write-Host "$packageName is already installed through Chocolatey. Updating to the latest version..."
        choco upgrade $packageName -y
    } else {
        Write-Host "$packageName is not installed. Installing..."
        choco install $packageName -y
    }
}

# Helper function to check if a specific .NET SDK version is installed
# Helper function to check if a specific .NET SDK version is installed
function Test-DotNetSdkInstalled($version) {
    try {
        # Attempt to list installed .NET SDKs and search for the specific version
        $sdks = dotnet --list-sdks | Select-String "$version" -ErrorAction Stop
        return $sdks
    } catch {
        # Handle any errors that occur, such as if dotnet command fails
        Write-Host "Error checking for .NET SDK version " + $version
        return $null
    }
}

# Install Chocolatey if it's not already installed
if (-not (Test-Installed 'choco')) {
    Write-Host "Chocolatey is not installed. Installing..."
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed."
}

# Install or update .NET 8
$dotnetVersion = (dotnet --list-sdks | Select-String "8\.")
if ($dotnetVersion) {
    Write-Host ".NET 8 is already installed. Checking for updates..."
    choco upgrade dotnet --version=8.0 -y
} else {
    Write-Host ".NET 8 is not installed. Installing..."
    choco install dotnet --version=8.0 -y
}

# Check if .NET 8.0 SDK is installed
if (Test-DotNetSdkInstalled "8\.0") {
    Write-Host ".NET 8 is already installed. Checking for updates..."
    choco upgrade dotnet --version=8.0 -y

    Write-Host ".NET 8 SDK is already installed. Checking for updates..."
    choco upgrade dotnet-8.0-sdk

} else {
    Write-Host ".NET 8 is not installed. Installing..."
    choco install dotnet --version=8.0 -y

    Write-Host ".NET 8.0 SDK is not installed. Installing via Chocolatey..."
    choco install dotnet-8.0-sdk -y
}

# Install ASP.NET Core Runtime
Install-Or-Update "aspnetcore-runtime"

# Install or update Docker
Install-Or-Update "docker-desktop"

# Install or update Azure CLI
Install-Or-Update "azure-cli"

# Install Azure Functions Core Tools
Install-Or-Update "azure-functions-core-tools-4"

# Install Azurite (Azure Storage Emulator)
Install-Or-Update "azurite"

# Install Terraform
Install-Or-Update "terraform"

# Install MongoDB Compass (GUI for MongoDB)
Install-Or-Update "mongodb-compass"

# Install or update JetBrains ToolBox
Install-Or-Update "jetbrains-toolbox"

# Install or update JetBrains Rider
Install-Or-Update "jetbrains-rider"

# Install or update Git
Install-Or-Update "git"

# Install or update Postman
Install-Or-Update "postman"

# Install or update GitKraken
Install-Or-Update "gitkraken"

# Install or update Visual Code
Install-Or-Update "visualstudiocode"

Write-Host "Installation and updates completed."

# Ask the user if they want to restart the machine
$restartResponse = Read-Host "Do you want to restart the machine now? (Yes/No)"

if ($restartResponse -eq "Yes" -or $restartResponse -eq "Y") {
    Write-Host "Restarting the machine..."
    Restart-Computer -Force
} else {
    Write-Host "Process completed without restarting."
}