#!/bin/bash
# Script to apply the necessary bug fix to TheCherno's ImGui fork

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
IMGUI_DIR="$PROJECT_ROOT/Kairon/vendor/imgui"
IMGUI_CPP="$IMGUI_DIR/imgui.cpp"

echo "Applying ImGui bug fix..."

if [ ! -f "$IMGUI_CPP" ]; then
    echo "Error: imgui.cpp not found at $IMGUI_CPP"
    echo "Please run 'git submodule update --init --recursive' first"
    exit 1
fi

# Check if fix is already applied
# We need to check specifically for the fixed pattern in the SetActiveID function
if grep -A 2 "void ImGui::SetActiveID" "$IMGUI_CPP" | tail -20 | grep -q "for (int i = 0; i < window->DC.Layouts"; then
    echo "ImGui bug fix already applied!"
    exit 0
fi

# Apply the fix
echo "Patching imgui.cpp..."

# Use sed to replace DC with window->DC in the SetActiveID function
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' 's/for (int i = 0; i < DC\.Layouts\.Data\.Size; i++)/for (int i = 0; i < window->DC.Layouts.Data.Size; i++)/' "$IMGUI_CPP"
    sed -i '' 's/ImGuiLayout\* layout = (ImGuiLayout\*)DC\.Layouts\.Data\[i\]\.val_p;/ImGuiLayout* layout = (ImGuiLayout*)window->DC.Layouts.Data[i].val_p;/' "$IMGUI_CPP"
else
    # Linux and others
    sed -i 's/for (int i = 0; i < DC\.Layouts\.Data\.Size; i++)/for (int i = 0; i < window->DC.Layouts.Data.Size; i++)/' "$IMGUI_CPP"
    sed -i 's/ImGuiLayout\* layout = (ImGuiLayout\*)DC\.Layouts\.Data\[i\]\.val_p;/ImGuiLayout* layout = (ImGuiLayout*)window->DC.Layouts.Data[i].val_p;/' "$IMGUI_CPP"
fi

# Verify the fix was applied
if grep -q "window->DC.Layouts.Data.Size" "$IMGUI_CPP"; then
    echo "✓ ImGui bug fix applied successfully!"
    exit 0
else
    echo "✗ Failed to apply ImGui bug fix"
    echo "Please manually edit $IMGUI_CPP"
    echo "See Kairon/vendor/imgui_cmake/README.md for instructions"
    exit 1
fi
