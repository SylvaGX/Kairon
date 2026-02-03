#!/bin/bash
# Script to manually fix the imgui submodule if it didn't clone properly

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
IMGUI_DIR="$PROJECT_ROOT/Kairon/vendor/imgui"

echo "Fixing imgui submodule..."

# Check if imgui directory exists
if [ -d "$IMGUI_DIR" ] && [ -f "$IMGUI_DIR/imgui.h" ]; then
    echo "✓ ImGui folder already exists and has files!"
    exit 0
fi

# Remove if it exists but is empty
if [ -d "$IMGUI_DIR" ]; then
    echo "Removing empty imgui directory..."
    rm -rf "$IMGUI_DIR"
fi

echo "Cloning TheCherno's imgui repository..."
git clone https://github.com/TheCherno/imgui.git "$IMGUI_DIR"

if [ $? -ne 0 ]; then
    echo "✗ Failed to clone imgui repository"
    exit 1
fi

echo "Checking out the correct commit..."
cd "$IMGUI_DIR"
git checkout 781a4ffc674d98dfd2b4d42747e1cd27887fac36

if [ $? -ne 0 ]; then
    echo "✗ Failed to checkout commit"
    exit 1
fi

echo ""
echo "✓ ImGui submodule fixed successfully!"
echo ""
echo "Verifying files..."
if [ -f "$IMGUI_DIR/imgui.cpp" ] && [ -f "$IMGUI_DIR/imgui.h" ]; then
    echo "✓ Core ImGui files found"
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./scripts/setup-imgui.sh"
    echo "  2. Build the project"
else
    echo "✗ ImGui files not found after clone"
    exit 1
fi
