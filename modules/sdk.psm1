# Import the helpers module
Import-Module "$PSScriptRoot\helpers.psm1" -Force

function Install-SDKs {
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
        Write-Host ".NET 8 SDK is already installed. Checking for updates..."
        choco upgrade dotnet-8.0-sdk
    } else {
        Write-Host ".NET 8.0 SDK is not installed. Installing via Chocolatey..."
        choco install dotnet-8.0-sdk -y
    }

    # Install ASP.NET Core Runtime
    Install-Or-Update -packageName "dotnet-8.0-aspnetruntime" -systemName "ASP.NET Core Runtime"

    # Install or update Docker
    Install-Or-Update -packageName "docker-desktop" -systemName "Docker Desktop"

    # Install Terraform
    Install-Or-Update -packageName "terraform" -systemName "Terraform"

    # Install MongoDB Compass (GUI for MongoDB)
    Install-Or-Update -packageName "mongodb-compass" -systemName "MongoDB Compass"
}
