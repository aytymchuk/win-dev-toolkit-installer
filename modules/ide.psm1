# Import the helpers module
Import-Module "$PSScriptRoot\helpers.psm1" -Force

function Install-IDEs {
    # Install or update JetBrains ToolBox
    Install-Or-Update -packageName "jetbrainstoolbox" -systemName "JetBrains Toolbox"

    # Install or update JetBrains Rider
    Install-Or-Update -packageName "jetbrains-rider" -systemName "JetBrains Rider" -skip

    # Install or update Visual Studio Code
    Install-Or-Update -packageName "visualstudiocode" -systemName "Visual Studio Code"
}

# Export the function
Export-ModuleMember -Function Install-IDEs