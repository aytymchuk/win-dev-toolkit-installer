# Import the helpers module
Import-Module "$PSScriptRoot\helpers.psm1" -Force

function Install-SDKs {
    Write-Host "Installing Development SDKs & Tools..." -ForegroundColor Green


    # Install or update .NET 9
    $dotnetVersion = (dotnet --list-sdks | Select-String "9\.")
    if ($dotnetVersion) {
        Write-Host "Updating .NET 9 Runtime to latest version..."
        choco upgrade dotnet --version=9.0 -y
    } else {
        Write-Host "Installing .NET 9 Runtime via Chocolatey..."
        choco install dotnet --version=9.0 -y
    }

    # Check if .NET 9.0 SDK is installed
    if (Test-DotNetSdkInstalled "9\.0") {
        Write-Host "Updating .NET 9.0 SDK to latest version..."
        choco upgrade dotnet-9.0-sdk -y
    } else {
        Write-Host "Installing .NET 9.0 SDK via Chocolatey..."
        choco install dotnet-9.0-sdk -y
    }

    # Install ASP.NET Core Runtime 9.0
    Install-Or-Update -packageName "dotnet-9.0-aspnetruntime" -systemName "ASP.NET Core Runtime"

    # Install or update .NET 10
    $dotnetVersion10 = (dotnet --list-sdks | Select-String "10\.")
    if ($dotnetVersion10) {
        Write-Host "Updating .NET 10 Runtime to latest version..."
        choco upgrade dotnet --version=10.0 -y
    } else {
        Write-Host "Installing .NET 10 Runtime via Chocolatey..."
        choco install dotnet --version=10.0 -y
    }

    # Check if .NET 10.0 SDK is installed
    if (Test-DotNetSdkInstalled "10\.0") {
        Write-Host "Updating .NET 10.0 SDK to latest version..."
        choco upgrade dotnet-10.0-sdk -y
    } else {
        Write-Host "Installing .NET 10.0 SDK via Chocolatey..."
        choco install dotnet-10.0-sdk -y
    }

    # Install ASP.NET Core Runtime 10.0
    Install-Or-Update -packageName "dotnet-10.0-aspnetruntime" -systemName "ASP.NET Core Runtime"

    # Install or update Docker
    Install-Or-Update -packageName "docker-desktop" -systemName "Docker Desktop"

    # Install Terraform
    Install-Or-Update -packageName "terraform" -systemName "Terraform"

    # Install MongoDB Compass (GUI for MongoDB)
    Install-Or-Update -packageName "mongodb-compass" -systemName "MongoDB Compass"

    # Install or update Python (required for MCP servers)
    Install-Or-Update -packageName "python" -systemName "Python"

    # Install or update Node.js (required for MCP servers)
    Install-Or-Update -packageName "nodejs" -systemName "Node.js"

    # Install or update uv (Python package manager for MCP development)
    Install-Or-Update -packageName "uv" -systemName "uv Python Package Manager"
    
    Write-Host "Development SDKs & Tools installation completed!" -ForegroundColor Green
}
