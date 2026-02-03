# CMake Build Instructions

This project has been successfully migrated from Premake to CMake, enabling cross-platform development with CLion on Windows, macOS, and Linux.

## Project Structure

The project consists of two main targets:

1. **Kairon** - A static library (the game engine)
2. **Sandbox** - An executable application (the UI/testing application)

The Sandbox links against Kairon, allowing you to develop and test engine features.

## Prerequisites

### All Platforms
- CMake 3.16 or higher
- C++17 compatible compiler
- Git (for submodules)

### Platform-Specific

#### Windows
- Visual Studio 2019 or later (with C++ Desktop Development workload)
- Or MinGW-w64 with GCC

#### macOS
- Xcode Command Line Tools
- Install with: `xcode-select --install`

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install build-essential cmake git
sudo apt-get install libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev
sudo apt-get install libgl1-mesa-dev libglu1-mesa-dev
```

## Building the Project

### 1. Clone and Initialize Submodules

If you haven't already initialized the git submodules:

```bash
git submodule update --init --recursive
```

#### Important: Apply ImGui Bug Fix

TheCherno's ImGui fork has a compilation bug that must be fixed. After initializing submodules, run the setup script:

**Linux/macOS:**
```bash
./scripts/setup-imgui.sh
```

**Windows:**
```batch
scripts\setup-imgui.bat
```

**Manual Fix (Alternative):**

If the script doesn't work, manually edit `Kairon/vendor/imgui/imgui.cpp` at lines 3839-3841:
- Change `DC.Layouts.Data.Size` to `window->DC.Layouts.Data.Size`  
- Change `DC.Layouts.Data[i].val_p` to `window->DC.Layouts.Data[i].val_p`

See `Kairon/vendor/imgui_cmake/README.md` for more details.

### 2. Configure with CMake

Create a build directory and configure:

```bash
mkdir build
cd build
cmake ..
```

For a specific build type:

```bash
# Debug build (default)
cmake -DCMAKE_BUILD_TYPE=Debug ..

# Release build
cmake -DCMAKE_BUILD_TYPE=Release ..

# Release with debug info
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..

# Minimum size release
cmake -DCMAKE_BUILD_TYPE=MinSizeRel ..
```

### 3. Build

```bash
cmake --build .
```

Or with multiple cores:

```bash
cmake --build . -j$(nproc)  # Linux/macOS
cmake --build . -j%NUMBER_OF_PROCESSORS%  # Windows
```

### 4. Run

The executable will be in `build/bin/Sandbox`:

```bash
./bin/Sandbox  # Linux/macOS
bin\Sandbox.exe  # Windows
```

## Using with CLion

### Opening the Project

1. Open CLion
2. Choose **File → Open** and select the project root directory (where the top-level CMakeLists.txt is)
3. CLion will automatically detect CMake and configure the project
4. Wait for CMake to finish configuring

### Configuring Build Types

1. Go to **File → Settings → Build, Execution, Deployment → CMake**
2. You'll see the default Debug profile
3. Add more profiles (Release, RelWithDebInfo) by clicking the **+** button
4. For each profile, set:
   - **Name**: Debug/Release/etc.
   - **Build type**: Debug/Release/RelWithDebInfo/MinSizeRel
   - **Build directory**: build-debug / build-release / etc.

### Running the Sandbox

1. In the top-right corner, select **Sandbox** from the run configurations dropdown
2. Click the green play button (▶) to run
3. Or press Shift+F10 (Windows/Linux) or Ctrl+R (macOS)

### Debugging

1. Set breakpoints by clicking in the gutter next to line numbers
2. Click the debug button (🐛) or press Shift+F9 (Windows/Linux) or Ctrl+D (macOS)

## Project Dependencies

The project uses the following libraries (managed as git submodules):

- **GLFW** - Window and input handling
- **Glad** - OpenGL loader
- **ImGui** - Immediate mode GUI (TheCherno's docking branch)
- **glm** - OpenGL Mathematics library
- **spdlog** - Fast C++ logging library

## Platform Differences

### macOS Specific Notes

- OpenGL is deprecated on macOS but still supported
- The project uses OpenGL 4.1 (via GLFW)
- Metal support may be added in the future

### Linux Specific Notes

- Requires X11 libraries for windowing
- Make sure your graphics drivers support OpenGL 4.1+

### Windows Specific Notes

- Works with both Visual Studio and MinGW compilers
- If using MinGW, ensure it's in your PATH

## Troubleshooting

### CMake Can't Find Dependencies

Make sure you've initialized git submodules:
```bash
git submodule update --init --recursive
```

### OpenGL Errors on Linux

Install Mesa development libraries:
```bash
sudo apt-get install libgl1-mesa-dev libglu1-mesa-dev
```

### X11 Errors on Linux

Install X11 development libraries:
```bash
sudo apt-get install libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev
```

### Build Fails with Compiler Errors

Make sure you're using a C++17 compatible compiler:
- GCC 7+ 
- Clang 5+
- MSVC 2017+

## Clean Build

To perform a clean build:

```bash
rm -rf build
mkdir build
cd build
cmake ..
cmake --build .
```

## IDE Support

This CMake project works with:
- **CLion** (JetBrains)
- **Visual Studio** (2019+)
- **Visual Studio Code** (with CMake Tools extension)
- **Qt Creator**
- **Eclipse CDT**
- **Xcode** (generate with `cmake -G Xcode ..`)

## Premake Removed

All Premake build files have been removed from the project. The project now uses CMake exclusively for all platforms.
