# Import the helpers module
Import-Module "$PSScriptRoot\helpers.psm1" -Force

function Install-AITools {
    Write-Host "Installing AI Development Tools..." -ForegroundColor Green

    # Install Claude Desktop (Direct download from Anthropic)
    Install-ClaudeDesktop

    # Install Claude Code VS Code Extension
    Install-ClaudeCode

    # Install GitHub Copilot (VS Code Extension)
    Install-GitHubCopilot

    # Install Cursor IDE
    Install-CursorIDE

    # Install Continue.dev VS Code Extension
    Install-ContinueDev

    # Install Codeium VS Code Extension
    Install-CodeiumExtension
}

function Install-ClaudeDesktop {
    Write-Host "Installing Claude Desktop..." -ForegroundColor Yellow
    
    $claudeDesktopPath = "$env:LOCALAPPDATA\Programs\Claude"
    $claudeExePath = "$claudeDesktopPath\Claude.exe"
    
    if (Test-Path $claudeExePath) {
        Write-Host "Claude Desktop is already installed." -ForegroundColor Green
        return
    }
    
    try {
        $downloadUrl = "https://storage.googleapis.com/osprey-downloads-c02f6a0d-347c-492b-a752-3e0651722e97/nest/Claude-Setup.exe"
        $tempPath = "$env:TEMP\Claude-Setup.exe"
        
        Write-Host "Downloading Claude Desktop installer..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath -UseBasicParsing
        
        Write-Host "Installing Claude Desktop..." -ForegroundColor Yellow
        Start-Process -FilePath $tempPath -ArgumentList "/S" -Wait
        
        # Clean up
        Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        
        Write-Host "Claude Desktop installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install Claude Desktop: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Install-ClaudeCode {
    Write-Host "Installing Claude Code VS Code Extension..." -ForegroundColor Yellow
    
    if (Test-Installed "code") {
        try {
            # Install Claude Code extension for VS Code
            & code --install-extension anthropic.claude-code --force
            Write-Host "Claude Code VS Code extension installed successfully!" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to install Claude Code extension: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "VS Code is not installed. Skipping Claude Code extension installation." -ForegroundColor Yellow
    }
}

function Install-GitHubCopilot {
    Write-Host "Installing GitHub Copilot VS Code Extension..." -ForegroundColor Yellow
    
    if (Test-Installed "code") {
        try {
            # Install GitHub Copilot extension for VS Code
            & code --install-extension GitHub.copilot --force
            & code --install-extension GitHub.copilot-chat --force
            Write-Host "GitHub Copilot extensions installed successfully!" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to install GitHub Copilot extensions: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "VS Code is not installed. Skipping GitHub Copilot extension installation." -ForegroundColor Yellow
    }
}

function Install-CursorIDE {
    Write-Host "Installing Cursor IDE..." -ForegroundColor Yellow
    
    # Check if Cursor is already installed
    $cursorPath = "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe"
    if (Test-Path $cursorPath) {
        Write-Host "Cursor IDE is already installed." -ForegroundColor Green
        return
    }
    
    try {
        # Try installing via Chocolatey first
        if (Test-Installed "choco") {
            choco install cursor -y
            Write-Host "Cursor IDE installed via Chocolatey successfully!" -ForegroundColor Green
        } else {
            Write-Host "Chocolatey not available. Please install Cursor IDE manually from https://cursor.sh/" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Failed to install Cursor IDE: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please install Cursor IDE manually from https://cursor.sh/" -ForegroundColor Yellow
    }
}

function Install-ContinueDev {
    Write-Host "Installing Continue.dev VS Code Extension..." -ForegroundColor Yellow
    
    if (Test-Installed "code") {
        try {
            # Install Continue.dev extension for VS Code
            & code --install-extension Continue.continue --force
            Write-Host "Continue.dev VS Code extension installed successfully!" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to install Continue.dev extension: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "VS Code is not installed. Skipping Continue.dev extension installation." -ForegroundColor Yellow
    }
}

function Install-CodeiumExtension {
    Write-Host "Installing Codeium VS Code Extension..." -ForegroundColor Yellow
    
    if (Test-Installed "code") {
        try {
            # Install Codeium extension for VS Code
            & code --install-extension Codeium.codeium --force
            Write-Host "Codeium VS Code extension installed successfully!" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to install Codeium extension: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "VS Code is not installed. Skipping Codeium extension installation." -ForegroundColor Yellow
    }
}

# Export the main function
Export-ModuleMember -Function Install-AITools