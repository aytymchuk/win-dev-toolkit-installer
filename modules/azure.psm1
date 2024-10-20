# Import the helpers module
Import-Module "$PSScriptRoot\helpers.psm1" -Force

function Install-AzureTools { 
    # Install or update Azure CLI
    Install-Or-Update -packageName "azure-cli" -systemName "Azure CLI"

    # Install Azure Functions Core Tools
    Install-Or-Update -packageName "azure-functions-core-tools" -systemName "Azure Functions Core Tools"

    # Install Azurite (Azure Storage Emulator)
    Install-Or-Update -packageName "azurestorageemulator" -systemName "Azure Storage Emulator"
}

# Export the function
Export-ModuleMember -Function Install-AzureTools
