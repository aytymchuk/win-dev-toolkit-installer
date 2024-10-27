# Import the helpers module
Import-Module "$PSScriptRoot\helpers.psm1" -Force

function Install-GeneralApplications {
    # Install or update Git
    Install-Or-Update -packageName "git" -systemName "Git"

    # Install or update GitHub Desktop
    Install-Or-Update -packageName "github-desktop" -systemName "GitHub Desktop"

    # Install or update Postman
    Install-Or-Update -packageName "postman" -systemName "Postman"

    # Install or update GitKraken
    Install-Or-Update -packageName "gitkraken" -systemName "GitKraken"

    # Install or update SourceTree
    Install-Or-Update -packageName "sourcetree" -systemName "SourceTree"

    # Install or update Fiddler
    Install-Or-Update -packageName "fiddler" -systemName "Fiddler"
}

# Export the function
Export-ModuleMember -Function Install-GeneralApplications