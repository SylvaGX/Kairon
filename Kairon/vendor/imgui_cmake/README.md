# ImGui Build Configuration

This directory contains CMake build configuration for the ImGui library.

## Why This Directory Exists

The ImGui submodule at `../imgui` is TheCherno's fork with docking/viewports support. However:

1. We cannot modify the submodule directly (it's TheCherno's repository)
2. The submodule contains a bug that needs fixing for compilation
3. We need a CMakeLists.txt to build ImGui with CMake

## Solution

This directory provides:
- `CMakeLists.txt` - Builds ImGui from the `../imgui` submodule directory
- Build configuration that works with our CMake-based project

## Important: ImGui Submodule Bug Fix

TheCherno's ImGui fork has a bug in `imgui.cpp` at line 3839:

```cpp
// WRONG (causes compilation error):
for (int i = 0; i < DC.Layouts.Data.Size; i++)
{
    ImGuiLayout* layout = (ImGuiLayout*)DC.Layouts.Data[i].val_p;
    
// CORRECT:
for (int i = 0; i < window->DC.Layouts.Data.Size; i++)
{
    ImGuiLayout* layout = (ImGuiLayout*)window->DC.Layouts.Data[i].val_p;
```

**This fix is applied directly in the submodule at `../imgui/imgui.cpp`.**

### For New Contributors

When you clone the repository and run `git submodule update --init --recursive`, the imgui submodule will be checked out at the original commit. **The bug fix must be reapplied manually:**

```bash
cd Kairon/vendor/imgui

# Apply the fix (replace DC with window->DC on lines 3839 and 3841)
# Option 1: Use sed (Linux/macOS)
sed -i 's/for (int i = 0; i < DC\.Layouts/for (int i = 0; i < window->DC.Layouts/' imgui.cpp
sed -i 's/ImGuiLayout\* layout = (ImGuiLayout\*)DC\.Layouts/ImGuiLayout* layout = (ImGuiLayout*)window->DC.Layouts/' imgui.cpp

# Option 2: Manually edit imgui.cpp at lines 3839-3841
#   Change: DC.Layouts.Data.Size
#   To: window->DC.Layouts.Data.Size
#
#   Change: DC.Layouts.Data[i].val_p
#   To: window->DC.Layouts.Data[i].val_p
```

### Alternative: Use a Forked ImGui Repository

If you prefer, you can fork TheCherno's imgui repository, apply the fix there, and update `.gitmodules` to point to your fork:

```ini
[submodule "Kairon/vendor/imgui"]
    path = Kairon/vendor/imgui
    url = https://github.com/YOUR_USERNAME/imgui
```

Then commit the fix in your fork and update the submodule reference.

## Files in This Directory

- `CMakeLists.txt` - CMake configuration that builds ImGui as a static library
- `README.md` - This file
- `imgui_dc_fix.patch` - Patch file for reference (may need updating if imgui version changes)
