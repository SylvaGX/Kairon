# Quick Start Guide

## For First-Time Setup (macOS)

Follow these steps to get the project building on your Mac:

### 1. Clone the Repository

```bash
git clone https://github.com/SylvaGX/Kairon.git
cd Kairon
```

### 2. Checkout the CMake Branch

```bash
git checkout cursor/premake-to-cmake-migration-73a6
```

### 3. Initialize Submodules

```bash
git submodule update --init --recursive
```

**If imgui folder is missing** (check with `git submodule status`), run:

```bash
./scripts/fix-imgui-submodule.sh
```

### 4. Apply ImGui Bug Fix

**This step is critical!** Run the setup script to fix a compilation bug in TheCherno's ImGui fork:

```bash
./scripts/setup-imgui.sh
```

You should see: `✓ ImGui bug fix applied successfully!`

### 5. Install Dependencies (macOS)

Make sure you have Xcode Command Line Tools:

```bash
xcode-select --install
```

### 6. Build the Project

```bash
mkdir build
cd build
cmake ..
cmake --build . -j$(sysctl -n hw.ncpu)
```

### 7. Run the Sandbox

```bash
./bin/Sandbox
```

## For CLion Users

**IMPORTANT:** If using CMake 3.27+, you need to add a CMake option first!

1. **Open CLion**
2. **Settings** → **Build, Execution, Deployment** → **CMake**
3. In **CMake options** field, add: `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`
4. **File → Open** and select the Kairon project directory
5. CLion will automatically detect CMake and start configuring
6. Select **Sandbox** from the run configurations dropdown (top-right)
7. Click the green play button (▶️) to run

**See `CMAKE_CLION.md` for detailed CLion setup instructions.**

## Troubleshooting

**See `TROUBLESHOOTING.md` for comprehensive troubleshooting steps.**

### ImGui folder is empty after submodule init

Try these steps in order:

```bash
# 1. Force sync and update
git submodule sync --recursive
git submodule update --init --force --recursive

# 2. If still empty, manually clone
rm -rf Kairon/vendor/imgui
git clone https://github.com/TheCherno/imgui.git Kairon/vendor/imgui
cd Kairon/vendor/imgui
git checkout 781a4ffc674d98dfd2b4d42747e1cd27887fac36
cd ../../..
```

### Build fails with "DC was not declared in this scope"

The ImGui bug fix wasn't applied. Run:

```bash
./scripts/setup-imgui.sh
```

### CMake can't find OpenGL

Make sure you have Xcode Command Line Tools installed:

```bash
xcode-select --install
```

### Submodule initialization failed

If you see errors about commit `6c4a8f49ece98969bb7946587a2bed6a609e9bfe` not being found, that's expected. That was a local commit that has been removed. Just make sure you're on the latest commit of the `cursor/premake-to-cmake-migration-73a6` branch:

```bash
git pull origin cursor/premake-to-cmake-migration-73a6
git submodule update --init --recursive
./scripts/setup-imgui.sh
```

## What Was Changed?

The project has been migrated from Premake to CMake, enabling:
- ✅ Cross-platform development (Windows, macOS, Linux)
- ✅ CLion IDE support
- ✅ Better dependency management
- ✅ Standard build configurations (Debug, Release, etc.)

See `MIGRATION_SUMMARY.md` for full details.

## Need Help?

- See `CMAKE_BUILD.md` for detailed build instructions
- See `Kairon/vendor/imgui_cmake/README.md` for ImGui setup details
- Check GitHub issues for known problems

---

**Happy coding on macOS! 🚀**
