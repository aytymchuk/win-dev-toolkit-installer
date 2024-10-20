# PowerShell Installation Tool

## Overview

This PowerShell-based tool automates the installation of various development components and tools on a Windows system. It's designed to streamline the setup process for developers, ensuring a consistent environment across different machines.

The overall installation process works as follows:

1. The user runs the `install.bat` file, which launches the main PowerShell script with administrator privileges.

2. The main script (`main.ps1`) dynamically loads all PowerShell modules (.psm1 files) from the `modules` folder.

3. The script first installs Chocolatey, a package manager for Windows, if it's not already installed.

4. It then proceeds to install various components by calling functions from the loaded modules. These typically include:
   - General development tools
   - Software Development Kits (SDKs)
   - Integrated Development Environments (IDEs)
   - Azure tools

5. Each module uses helper functions to check if a tool is already installed, and either installs it or updates it to the latest version.

6. The installation process is designed to be idempotent, meaning it can be run multiple times without causing issues, only updating or installing components as necessary.

This modular approach allows for easy customization and extension of the tool to fit specific development environment needs.

## Components List
This tool installs the following components:

1. Chocolatey (Package Manager)

2. General Development Tools
   - Git
   - Postman
   - GitKraken

3. Software Development Kits (SDKs)
   - .NET 8 SDK
   - ASP.NET Core Runtime
   - Docker Desktop
   - Terraform
   - MongoDB Compass

4. Integrated Development Environments (IDEs)
   - JetBrains Toolbox
   - JetBrains Rider
   - Visual Studio Code

5. Azure Tools
   - Azure CLI
   - Azure Functions Core Tools
   - Azurite (Azure Storage Emulator)

## Installation Principle
The installation process follows these principles:

1. **Modularity**: Each category of tools is managed by a separate PowerShell module (.psm1 file), allowing for easy maintenance and updates.

2. **Automation**: The tool aims to minimize user interaction during the installation process, automating as much as possible.

3. **Idempotency**: The installation scripts are designed to be safely run multiple times without causing issues or unnecessary reinstallations.

4. **Flexibility**: Users can easily customize which components to install by modifying the main script or individual modules.

5. **Error Handling**: The tool includes error checking and reporting to ensure a smooth installation process and to help troubleshoot any issues.

## Usage

There are two ways to run this installation process:

### Option 1: Using install.bat (Recommended)

1. Clone or download this repository to your local machine.
2. Double-click the `install.bat` file.
3. If prompted, allow the script to run with administrator privileges.
4. The installation process will begin automatically.

### Option 2: Running main.ps1 directly

If the `install.bat` method doesn't work for any reason, you can run the PowerShell script directly:

1. Clone or download this repository to your local machine.
2. Right-click on `main.ps1` and select "Run with PowerShell".
3. If prompted, allow the script to run with administrator privileges.
4. The installation process will begin automatically.

Note: If you encounter any execution policy restrictions, you may need to open PowerShell as an administrator and run the following command before running the script:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

Then run the script using:

```powershell
.\main.ps1
```

5. Follow any on-screen prompts if they appear.

## Customization and Extending Functionality

You can easily extend this tool to install additional components or perform custom actions by creating new modules. Here's how:

1. Create a new .psm1 file in the `modules` folder. Name it according to its functionality (e.g., `custom-tools.psm1`).

2. In your new module file, define your installation function(s). For example:

   ```powershell
   # modules/custom-tools.psm1
   
   # Import the helpers module
   Import-Module "$PSScriptRoot\helpers.psm1" -Force
   
   function Install-CustomTools {
       # Install or update Custom Tool 1
       Install-Or-Update "custom-tool-1" "Custom Tool 1"
   
       # Install or update Custom Tool 2
       Install-Or-Update "custom-tool-2" "Custom Tool 2"
   
       # Add more tools as needed
   }
   
   # Export the function
   Export-ModuleMember -Function Install-CustomTools
   ```

3. Open the `main.ps1` file and add your new function to the `Install-Applications` function. For example:

   ```powershell
   function Install-Applications {
       Install-GeneralApplications
       Install-SDKs
       Install-IDEs
       Install-AzureTools
       Install-CustomTools  # Add your new function here
   }
   ```

4. If you want to control the order of installation, you can place your new function call wherever you prefer within the `Install-Applications` function.

By following this approach, you can easily add new installation modules and customize the tool to fit your specific needs while maintaining the modular structure of the project.

Remember to update this README file with information about your custom modules if you plan to share your modified version of the tool.

### Helper Functions

The `helpers.psm1` module provides several utility functions that you can use in your custom modules:

1. `Test-Installed($name)`
   - Checks if a program exists in the system PATH.
   - Usage: `Test-Installed "git"`

2. `Test-ProgramInstalled($programName)`
   - Performs a comprehensive check to determine if a program is installed.
   - Checks using Get-Package, Get-CimInstance, common installation directories, and registry entries.
   - Usage: `Test-ProgramInstalled "Visual Studio Code"`

3. `Install-Or-Update($packageName, $systemName)`
   - Installs or updates a package using Chocolatey.
   - Parameters:
     - `$packageName`: The name of the package as it appears in the Chocolatey repository.
     - `$systemName`: The display name of the program as it might appear in Windows' installed programs list.
   - This function first checks if the program is already installed (either through Chocolatey or other methods) before proceeding with installation or update.
   - Usage: `Install-Or-Update "vscode" "Visual Studio Code"`
   - Note: The `$packageName` is typically the name used in Chocolatey commands, while `$systemName` is the more human-readable name that might be used in Windows' list of installed programs or in the program's installation directory.

4. `Test-DotNetSdkInstalled($version)`
   - Checks if a specific .NET SDK version is installed.
   - Usage: `Test-DotNetSdkInstalled "6.0"`

To use these helper functions in your custom module, make sure to import the helpers module at the beginning of your .psm1 file:

```powershell
Import-Module "$PSScriptRoot\helpers.psm1" -Force
```

Then you can use these functions in your custom installation logic. For example:

```powershell
function Install-CustomTools {
    # Install or update Git
    Install-Or-Update "git" "Git"

    # Install or update Visual Studio Code
    Install-Or-Update "vscode" "Visual Studio Code"

    # Install or update Node.js
    Install-Or-Update "nodejs" "Node.js"
}
```

By leveraging these helper functions, you can ensure that your custom modules follow the same installation principles and error-handling practices as the core modules.

## Requirements
- Windows 10 or later
- PowerShell 5.1 or later
- Internet connection

## Contributing
Contributions to improve the tool or add new features are welcome. Please submit a pull request or open an issue to discuss proposed changes.

## License
[Specify your license here, e.g., MIT License]
