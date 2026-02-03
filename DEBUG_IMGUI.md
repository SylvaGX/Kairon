# Debugging ImGui Submodule Issue

## The Problem

When you run `git submodule status`, imgui is missing even though it should be there.

## Quick Check

Run these commands to diagnose:

```bash
# 1. Check .gitmodules (should show imgui)
cat .gitmodules | grep -A 2 imgui

# 2. Check git's internal config (might not show imgui)
git config --file .git/config --get-regexp submodule

# 3. Check if the directory exists
ls -la Kairon/vendor/ | grep imgui
```

## Expected vs Actual

### What .gitmodules Should Show:
```
[submodule "Kairon/vendor/imgui"]
	path = Kairon/vendor/imgui
	url = https://github.com/TheCherno/imgui
```

### What git submodule status SHOULD show:
```
 4fba735d5eaa60e685195aeac8f30c1460ab2a97 Kairon/vendor/GLFW
 efec5db081e3aad807d0731e172ac597f6a39447 Kairon/vendor/glm
 781a4ffc674d98dfd2b4d42747e1cd27887fac36 Kairon/vendor/imgui    ← THIS IS MISSING
 233e97c5e46d8f8e83a6ea06b2dc8db804a4aed4 Kairon/vendor/spdlog
```

## Solution 1: Manually Register the Submodule

```bash
# Tell git to register imgui submodule
git submodule init Kairon/vendor/imgui

# Now update it
git submodule update Kairon/vendor/imgui

# Verify it worked
git submodule status
```

## Solution 2: Use the Fix Script

```bash
# Pull latest (includes all fix scripts)
git pull origin cursor/premake-to-cmake-migration-73a6

# Run the fix
./scripts/fix-imgui-submodule.sh
```

## Solution 3: Force Complete Reinitialization

```bash
# Sync all submodules from .gitmodules
git submodule sync --recursive

# Initialize ALL submodules (including imgui)
git submodule init

# Update all submodules
git submodule update --recursive
```

## Solution 4: Nuclear Option (Clean Slate)

If nothing else works:

```bash
# 1. Remove ALL vendor submodules
rm -rf Kairon/vendor/GLFW
rm -rf Kairon/vendor/glm
rm -rf Kairon/vendor/imgui
rm -rf Kairon/vendor/spdlog

# 2. Clean git's submodule tracking
rm -rf .git/modules/Kairon/vendor/*

# 3. Reinitialize everything
git submodule init
git submodule update --recursive

# 4. Verify all 4 submodules are present
git submodule status
```

## Why This Happens

Git submodules have two places where they're registered:

1. **`.gitmodules`** (version controlled) - Lists what submodules SHOULD exist
2. **`.git/config`** (local only) - Lists what submodules your git knows about

Sometimes these get out of sync. The `git submodule init` command syncs them.

## After Fixing

Once imgui shows up in `git submodule status`, apply the bug fix:

```bash
./scripts/setup-imgui.sh
```

Then you can build the project!

## Still Not Working?

Share the output of these commands:

```bash
# Check git version
git --version

# Check what's in .gitmodules
cat .gitmodules

# Check git's internal config
cat .git/config | grep -A 3 submodule

# Check vendor directory
ls -la Kairon/vendor/
```
