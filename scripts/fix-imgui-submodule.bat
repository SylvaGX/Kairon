@echo off
REM Script to manually fix the imgui submodule if it didn't clone properly

setlocal

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."
set "IMGUI_DIR=%PROJECT_ROOT%\Kairon\vendor\imgui"

echo Fixing imgui submodule...

if exist "%IMGUI_DIR%\imgui.h" (
    echo [OK] ImGui folder already exists and has files!
    exit /b 0
)

if exist "%IMGUI_DIR%" (
    echo Removing empty imgui directory...
    rmdir /s /q "%IMGUI_DIR%"
)

echo Cloning TheCherno's imgui repository...
git clone https://github.com/TheCherno/imgui.git "%IMGUI_DIR%"

if %errorlevel% neq 0 (
    echo [ERROR] Failed to clone imgui repository
    exit /b 1
)

echo Checking out the correct commit...
cd "%IMGUI_DIR%"
git checkout 781a4ffc674d98dfd2b4d42747e1cd27887fac36

if %errorlevel% neq 0 (
    echo [ERROR] Failed to checkout commit
    exit /b 1
)

echo.
echo [OK] ImGui submodule fixed successfully!
echo.
echo Next steps:
echo   1. Run: scripts\setup-imgui.bat
echo   2. Build the project
