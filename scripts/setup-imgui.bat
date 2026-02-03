@echo off
REM Script to apply the necessary bug fix to TheCherno's ImGui fork

setlocal

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."
set "IMGUI_DIR=%PROJECT_ROOT%\Kairon\vendor\imgui"
set "IMGUI_CPP=%IMGUI_DIR%\imgui.cpp"

echo Applying ImGui bug fix...

if not exist "%IMGUI_CPP%" (
    echo Error: imgui.cpp not found at %IMGUI_CPP%
    echo Please run 'git submodule update --init --recursive' first
    exit /b 1
)

REM Check if fix is already applied
findstr /C:"window->DC.Layouts.Data.Size" "%IMGUI_CPP%" >nul 2>&1
if %errorlevel% equ 0 (
    echo ImGui bug fix already applied!
    exit /b 0
)

echo Patching imgui.cpp...

REM Use PowerShell to do the replacement (more reliable than batch)
powershell -Command "(Get-Content '%IMGUI_CPP%') -replace 'for \(int i = 0; i < DC\.Layouts\.Data\.Size; i\+\+\)', 'for (int i = 0; i < window->DC.Layouts.Data.Size; i++)' | Set-Content '%IMGUI_CPP%'"
powershell -Command "(Get-Content '%IMGUI_CPP%') -replace 'ImGuiLayout\* layout = \(ImGuiLayout\*\)DC\.Layouts\.Data\[i\]\.val_p;', 'ImGuiLayout* layout = (ImGuiLayout*)window->DC.Layouts.Data[i].val_p;' | Set-Content '%IMGUI_CPP%'"

REM Verify the fix was applied
findstr /C:"window->DC.Layouts.Data.Size" "%IMGUI_CPP%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] ImGui bug fix applied successfully!
    exit /b 0
) else (
    echo [ERROR] Failed to apply ImGui bug fix
    echo Please manually edit %IMGUI_CPP%
    echo See Kairon\vendor\imgui_cmake\README.md for instructions
    exit /b 1
)
