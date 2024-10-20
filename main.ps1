# Ensure the script is running in PowerShell
if ($Host.Name -ne 'ConsoleHost')
{
    # Relaunch the script in PowerShell
    PowerShell -NoProfile -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Definition
    exit
}

# Get the current script's directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Find all .psm1 files in the current directory and its subdirectories
$modules = Get-ChildItem -Path $scriptPath -Recurse -Filter "*.psm1"

foreach ($module in $modules) {
    try {
        Import-Module -Name $module.FullName -Force -ErrorAction Stop -WarningAction SilentlyContinue
        Write-Host "Successfully imported module: $($module.Name)"
    } catch {
        Write-Warning "Failed to import module: $($module.Name). Error: $_"
    }
}

function Install-Chocolatey {
    Install-ChocolateyPackageManager
}

function Install-Applications {
    Install-GeneralApplications
    Install-SDKs
    Install-IDEs
    Install-AzureTools
}

function Request-Restart {
    $restartResponse = Read-Host "Do you want to restart the machine now? (Yes/No)"
    if ($restartResponse -eq "[Y]es" -or $restartResponse -eq "Y") {
        Write-Host "Restarting the machine..."
        Restart-Computer -Force
    } else {
        Write-Host "Installation completed without restarting."
    }
}

function Start-FullInstallation {
    Install-Chocolatey
    Install-Applications
    Write-Host "Installation and updates completed."
    # Request-Restart
}

# Execute the full installation
Start-FullInstallation
