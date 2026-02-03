# Troubleshooting Guide

## ImGui Submodule Not Populating

If `git submodule update --init --recursive` doesn't populate the imgui folder, try these steps:

### Step 1: Check Git Submodule Status

```bash
cd /path/to/Kairon
git submodule status
```

**Expected output:**
```
 4fba735d5eaa60e685195aeac8f30c1460ab2a97 Kairon/vendor/GLFW (3.2.1-1014-g4fba735d)
 efec5db081e3aad807d0731e172ac597f6a39447 Kairon/vendor/glm (0.9.5.3-2723-gefec5db0)
 781a4ffc674d98dfd2b4d42747e1cd27887fac36 Kairon/vendor/imgui (v1.62-4007-g781a4ffc)
 233e97c5e46d8f8e83a6ea06b2dc8db804a4aed4 Kairon/vendor/spdlog (v1.2.1-1560-g233e97c5)
```

If you see a `-` or `+` prefix before the commit hash, the submodule isn't properly initialized.

### Step 2: Check Directory Contents

```bash
ls -la Kairon/vendor/imgui/
```

**If empty or only `.git` file:**

The directory exists but isn't populated. Try:

```bash
cd Kairon/vendor/imgui
git checkout 781a4ffc674d98dfd2b4d42747e1cd27887fac36
```

### Step 3: Force Submodule Sync

If the submodule is registered but not pulling correctly:

```bash
git submodule sync --recursive
git submodule update --init --force --recursive
```

### Step 4: Manual Clone (Last Resort)

If submodules still don't work:

```bash
# Remove the broken submodule directory
rm -rf Kairon/vendor/imgui

# Manually clone TheCherno's imgui
git clone https://github.com/TheCherno/imgui.git Kairon/vendor/imgui

# Checkout the specific commit
cd Kairon/vendor/imgui
git checkout 781a4ffc674d98dfd2b4d42747e1cd27887fac36
cd ../../..
```

### Step 5: Verify ImGui Files Exist

After any of the above steps, verify:

```bash
ls Kairon/vendor/imgui/*.cpp Kairon/vendor/imgui/*.h
```

**Expected files:**
- `imgui.cpp`
- `imgui.h`
- `imgui_demo.cpp`
- `imgui_draw.cpp`
- `imgui_internal.h`
- `imgui_tables.cpp`
- `imgui_widgets.cpp`
- And more...

## Common Issues

### Issue: "Submodule 'Kairon/vendor/imgui' registered for path but nothing happens"

**Cause:** Git credentials or network issue

**Solution:**
```bash
# Try with explicit HTTPS
git config --global url."https://github.com/".insteadOf git://github.com/

# Then retry
git submodule update --init --recursive
```

### Issue: Empty `.git` file in imgui directory

**Cause:** Submodule registered but not fetched

**Solution:**
```bash
cd Kairon/vendor
rm -rf imgui
cd ..
git submodule update --init --recursive
```

### Issue: "fatal: remote error: upload-pack: not our ref..."

**Cause:** Trying to fetch a commit that doesn't exist in the remote

**Solution:** 
Make sure you're on the latest commit of the `cursor/premake-to-cmake-migration-73a6` branch:

```bash
git fetch origin
git checkout cursor/premake-to-cmake-migration-73a6
git pull origin cursor/premake-to-cmake-migration-73a6
git submodule update --init --recursive
```

## Still Having Issues?

Please provide the following information:

1. Output of `git --version`
2. Output of `git submodule status`
3. Output of `ls -la Kairon/vendor/imgui/`
4. Full error message if any
5. Your operating system (macOS version, Linux distro, Windows version)

### Quick Test

To verify the submodule is configured correctly:

```bash
cat .gitmodules | grep -A 2 imgui
```

**Expected output:**
```
[submodule "Kairon/vendor/imgui"]
	path = Kairon/vendor/imgui
	url = https://github.com/TheCherno/imgui
```

## After ImGui is Populated

Don't forget to apply the bug fix:

```bash
./scripts/setup-imgui.sh
```

Then build:

```bash
mkdir build && cd build
cmake ..
cmake --build . -j$(nproc)  # Linux/macOS
```
