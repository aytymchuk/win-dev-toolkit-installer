@echo off
echo Administrator privileges are required to run this script.
echo Requesting administrator rights...

powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0main.ps1\"' -Verb RunAs"

if %errorlevel% neq 0 (
    echo Failed to obtain administrator rights or user cancelled the request.
    echo Installation cannot proceed.
    pause
    exit /b 1
)

exit /b 0
