#!/bin/bash
# Script to remove the ImGui DC layout cleanup loop

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
IMGUI_DIR="$PROJECT_ROOT/Kairon/vendor/imgui"
IMGUI_CPP="$IMGUI_DIR/imgui.cpp"

echo "Applying ImGui DC fix..."

if [ ! -f "$IMGUI_CPP" ]; then
    echo "Error: imgui.cpp not found at $IMGUI_CPP"
    exit 1
fi

# Check if the loop is already gone
if ! grep -q "for (int i = 0; i < DC.Layouts.Data.Size; i++)" "$IMGUI_CPP"; then
    echo "ImGui DC fix already applied!"
    exit 0
fi

echo "Patching imgui.cpp..."

# Delete the entire for-loop block
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (BSD sed)
    sed -i '' '/for (int i = 0; i < DC\.Layouts\.Data\.Size; i++)/,/^[[:space:]]*}/d' "$IMGUI_CPP"
else
    # Linux / GNU sed
    sed -i '/for (int i = 0; i < DC\.Layouts\.Data\.Size; i++)/,/^[[:space:]]*}/d' "$IMGUI_CPP"
fi

# Verify removal
if ! grep -q "for (int i = 0; i < DC.Layouts.Data.Size; i++)" "$IMGUI_CPP"; then
    echo "✓ ImGui DC fix applied successfully!"
    exit 0
else
    echo "✗ Failed to apply ImGui DC fix"
    exit 1
fi
