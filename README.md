# Kairon
Kairon Engine

# Videos e github support
https://github.com/TheCherno/Hazel/commit/cfd270f5d535e55c3bfd6735cda391ec25aa6fc2  
https://www.youtube.com/watch?v=_Kj6BSfM6P4&list=PLlrATfBNZ98dC-V-N3m0Go4deliWHPFwT&index=28

# Quick Start Guide

Follow these steps to get the project building on your PC:

### 1. Clone the Repository

```bash
git clone https://github.com/SylvaGX/Kairon.git
cd Kairon
```

### 2. Checkout the CMake Branch

```bash
git checkout main
```

### 3. Initialize Submodules

```bash
git submodule update --init --recursive
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

# CLion

**IMPORTANT:** If using CMake 3.27+, you need to add a CMake option first!

1. **Open CLion**
2. **Settings** → **Build, Execution, Deployment** → **CMake**
3. In **CMake options** field, add: `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`
4. **File → Open** and select the Kairon project directory
5. CLion will automatically detect CMake and start configuring
6. Select **Sandbox** from the run configurations dropdown (top-right)
7. Click the green play button (▶️) to run

## More info

### Building with CLion

##### Step 1: Open Project

1. **File** → **Open**
2. Navigate to the Kairon project directory
3. Select the root folder (where the main `CMakeLists.txt` is)
4. Click **Open**

##### Step 2: Configure CMake Profiles

1. **Settings/Preferences** → **Build, Execution, Deployment** → **CMake**
2. You should see a **Debug** profile by default
3. Add the CMake option as mentioned above: `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`

**Optional:** Add more build configurations:

**Release Profile:**
- Name: `Release`
- Build type: `Release`
- CMake options: `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`

**RelWithDebInfo Profile:**
- Name: `RelWithDebInfo`
- Build type: `RelWithDebInfo`
- CMake options: `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`

**If you want to have conan add this to the profile CMake options**
- `-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="conan_provider.cmake"`

##### Step 3: Select Build Configuration

In the top toolbar:
1. Select your desired configuration (Debug/Release)
2. Select **Sandbox** as the target

##### Step 4: Build and Run

- Click the **Build** button (🔨) or press **⌘F9**
- Click the **Run** button (▶️) or press **⌃R**
- Click the **Debug** button (🐛) or press **⌃D**

### First Time Setup Checklist

Before building in CLion, make sure you've completed:

- [ ] Cloned the repository
- [ ] Checked out `main` branch
- [ ] Initialized submodules: `git submodule update --init --recursive`
- [ ] Applied imgui bug fix: Can do manually by running `./scripts/setup-imgui.sh` or reloading CMake. In case reloading CMake didn't work delete file `Kairon/vendor/imgui_cmake/imgui_dc_fix.hash` and reload CMake again
- [ ] Added CMake option in CLion: `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`
- [ ] Added CMake option in CLion if conan needed: - `-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="conan_provider.cmake"`

### CMake 3.27+ Compatibility Issue

If you're using CMake 3.27 or newer, you may encounter this error:

```
CMake Error: Compatibility with CMake < 3.5 has been removed from CMake.
```

This happens because GLFW and GLM submodules use older `cmake_minimum_required` versions.

### Solution: Configure CLion CMake Options

1. Open **CLion**
2. Go to **Settings/Preferences** → **Build, Execution, Deployment** → **CMake**
3. In the **CMake options** field, add:
   ```
   -DCMAKE_POLICY_VERSION_MINIMUM=3.5
   ```
4. Click **Apply** and **OK**
5. CLion will automatically reload the CMake project

### Troubleshooting

#### "imgui.cpp: No such file or directory"

ImGui bug fix wasn't applied. 

Run manually:
```bash
./scripts/setup-imgui.sh
```
**or reload CMake. In case reloading CMake didn't work delete file `Kairon/vendor/imgui_cmake/imgui_dc_fix.hash` and reload CMake again.**

Then reload CMake project in CLion (**Tools** → **CMake** → **Reload CMake Project**)

#### "Cannot find OpenGL"

On macOS, OpenGL should be found automatically. If not:
```bash
xcode-select --install
```

#### Build directory issues

If you get weird build errors, try:
1. **Tools** → **CMake** → **Reset Cache and Reload Project**
2. Or manually delete the `cmake-build-*` directories

### Running from Terminal

If you prefer terminal over CLion:

```bash
# Configure
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Debug -B build

# Build
cmake --build build -j$(sysctl -n hw.ncpu)

# Run
./build/bin/Sandbox
```

### Debugging in CLion

1. Set breakpoints by clicking in the gutter next to line numbers
2. Click the **Debug** button (🐛) or press **⌃D**
3. Use the debug toolbar to step through code:
    - **Step Over**: **F8**
    - **Step Into**: **F7**
    - **Step Out**: **⇧F8**
    - **Resume**: **⌥⌘R**

### CLion Tips

- **Double-tap Shift**: Search everywhere
- **⌘O**: Go to class
- **⌘⇧O**: Go to file
- **⌘E**: Recent files
- **⌥F7**: Find usages
- **⌘B**: Go to declaration
- **⌃Space**: Code completion


**Happy coding on Windows, macOS or Linux! 🚀**
