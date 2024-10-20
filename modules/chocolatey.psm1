# Import the helpers module
Import-Module "$PSScriptRoot\helpers.psm1" -Force

function Install-ChocolateyPackageManager {
    Write-Host "Installing Chocolatey..."

    if (-not (Test-Installed 'choco')) {
        Write-Host "Chocolatey is not installed. Installing..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    } else {
        Write-Host "Chocolatey is already installed."
    }
}

# . ./install-helpers.psm1  # Dot-source the helpers to use Test-Installed
#     Install-Chocolatey

# Export the function
Export-ModuleMember -Function Install-ChocolateyPackageManager