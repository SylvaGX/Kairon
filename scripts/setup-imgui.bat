@echo off
REM Script to apply the necessary bug fix to TheCherno's ImGui fork (Windows)

set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..
set IMGUI_DIR=%PROJECT_ROOT%\Kairon\vendor\imgui
set IMGUI_CPP=%IMGUI_DIR%\imgui.cpp

echo Applying ImGui bug fix...

if not exist "%IMGUI_CPP%" (
    echo Error: imgui.cpp not found at %IMGUI_CPP%
    echo Please run "git submodule update --init --recursive" first
    exit /b 1
)

REM Check if the loop is already removed
findstr /C:"for (int i = 0; i < DC.Layouts.Data.Size; i++)" "%IMGUI_CPP%" >nul
if errorlevel 1 (
    echo ImGui bug fix already applied!
    exit /b 0
)

echo Patching imgui.cpp...

REM Use PowerShell to delete the entire for-loop block
powershell -NoProfile -Command ^
    "$content = Get-Content '%IMGUI_CPP%' -Raw; " ^
    "$pattern = 'for \(int i = 0; i < DC\.Layouts\.Data\.Size; i\+\+\)\s*\{[\s\S]*?\n\s*\}'; " ^
    "$content = [regex]::Replace($content, $pattern, ''); " ^
    "Set-Content '%IMGUI_CPP%' $content"

REM Verify the fix was applied
findstr /C:"for (int i = 0; i < DC.Layouts.Data.Size; i++)" "%IMGUI_CPP%" >nul
if errorlevel 1 (
    echo ✓ ImGui bug fix applied successfully!
    exit /b 0
) else (
    echo ✗ Failed to apply ImGui bug fix
    echo Please manually edit %IMGUI_CPP%
    exit /b 1
)
