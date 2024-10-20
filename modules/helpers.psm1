# Helper function to check if a program exists
function Test-Installed($name) {
    Get-Command $name -ErrorAction SilentlyContinue
}

# Helper function to check if a program exists in the system (not only through Chocolatey)
function Test-ProgramInstalled($programName) {
    # Check using Get-Package (works for most modern installations)
    if (Get-Package -Name $programName -ErrorAction SilentlyContinue) {
        return $true
    }

    # Check using Get-CimInstance (replaces Get-WmiObject)
    if (Get-CimInstance -ClassName Win32_Product -Filter "Name LIKE '%$programName%'" -ErrorAction SilentlyContinue) {
        return $true
    }

    # Check common installation directories
    $commonPaths = @(
        "${env:ProgramFiles}\$programName",
        "${env:ProgramFiles(x86)}\$programName",
        "${env:LocalAppData}\Programs\$programName"
    )
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            return $true
        }
    }

    # Check registry for installed applications
    $registryPaths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    foreach ($path in $registryPaths) {
        if (Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*$programName*" }) {
            return $true
        }
    }

    return $false
}

# Helper function to install or upgrade a package using Chocolatey
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
        Write-Host "$systemName is already installed $installMethod. Updating to the latest version..."

        if ($skipUpdate) {
            Write-Host "Skip update of $systemName..."
            return
        }    

        choco upgrade $packageName -y --force
    }
    else {
        Write-Host "$systemName is not installed. Installing..."
        choco install $packageName -y --force
    }
}

# Helper function to check if a specific .NET SDK version is installed
function Test-DotNetSdkInstalled($version) {
    try {
        $sdks = dotnet --list-sdks | Select-String "$version" -ErrorAction Stop
        return $sdks
    } catch {
        Write-Host "Error checking for .NET SDK version $version"
        return $null
    }
}

# Export the functions
Export-ModuleMember -Function Test-Installed, Test-ProgramInstalled, Install-Or-Update, Test-DotNetSdkInstalled
