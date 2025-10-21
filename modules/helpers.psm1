# Test if a program is installed by checking the registry
function Test-Installed {
    param([string]$programName)
    $x86 = ((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue( "DisplayName" ) -like "*$programName*" } ).Length -gt 0;
    $x64 = ((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue( "DisplayName" ) -like "*$programName*" } ).Length -gt 0;
    return $x86 -or $x64;
}

# Test if a program is installed by checking common installation paths and registry
function Test-ProgramInstalled {
    param([string]$programName)
    
    # Check if the program is in the PATH
    $inPath = Get-Command $programName -ErrorAction SilentlyContinue
    if ($inPath) {
        return $true
    }
    
    # Check registry for installed programs
    return Test-Installed $programName
}

# Install or update a package using Chocolatey
function Install-Or-Update {
    param (
        [Parameter(Mandatory=$true)]
        [string]$packageName,
        
        [Parameter(Mandatory=$true)]
        [string]$systemName,

        [Parameter(Mandatory=$false)]
        [bool]$skipUpdate = $false
    )

    $isInstalledSystem = Test-ProgramInstalled $systemName
    $isInstalledChoco = $null -ne (choco list --local-only | Select-String -Pattern "^$packageName\s")

    if ($isInstalledSystem) {
        $installMethod = if ($isInstalledChoco) { "through Chocolatey" } else { "through a non-Chocolatey method" }
        Write-Host "$systemName is already installed $installMethod."
        
        if ($skipUpdate) {
            Write-Host "Skipping update for $systemName as requested."
            return
        }    

        Write-Host "Checking for updates for $systemName..."
        choco upgrade $packageName -y
    }
    else {
        Write-Host "$systemName is not installed. Installing via Chocolatey..."
        choco install $packageName -y
    }
}

# Test if a specific .NET SDK version is installed
function Test-DotNetSdkInstalled {
    param([string]$version)
    
    try {
        $installedSdks = dotnet --list-sdks 2>$null
        if ($installedSdks) {
            return $installedSdks | Select-String -Pattern $version -Quiet
        }
        return $false
    }
    catch {
        return $false
    }
}

# Export the functions
Export-ModuleMember -Function Test-Installed, Test-ProgramInstalled, Install-Or-Update, Test-DotNetSdkInstalled