# Import the helpers module
Import-Module "$PSScriptRoot\helpers.psm1" -Force

function Install-IDEs {
    # Install or update JetBrains ToolBox
    Install-Or-Update -packageName "jetbrainstoolbox" -systemName "JetBrains Toolbox"

    # Install or update JetBrains Rider
    Install-Or-Update -packageName "jetbrains-rider" -systemName "JetBrains Rider" -skipUpdate $true

    # Install or update Visual Studio Code
    Install-Or-Update -packageName "visualstudiocode" -systemName "Visual Studio Code"

    # Install Visual Studio 2022 workload for managed desktop build tools
    Install-Or-Update -packageName "visualstudio2022-workload-manageddesktopbuildtools" -systemName "VS 2022 Managed Desktop Build Tools"

    # Install Visual Studio 2022 workload for web build tools
    Install-Or-Update -packageName "visualstudio2022-workload-webbuildtools" -systemName "VS 2022 Web Build Tools"

    # Install NuGet Command Line
    Install-Or-Update -packageName "nuget.commandline" -systemName "NuGet Command Line"

    # Install NuGet Credential Provider
    Install-NuGetCredentialProvider
}

function Install-NuGetCredentialProvider {

    Write-Host "Installing NuGet Credential Provider for .NET 8"
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-artifacts-credprovider.ps1) } -InstallNet8"
}

# Export the function
Export-ModuleMember -Function Install-IDEs
