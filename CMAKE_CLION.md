# Building with CLion

## CMake 3.27+ Compatibility Issue

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

### Alternative: Command Line Build

If you prefer command line:

```bash
mkdir build && cd build
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ..
cmake --build . -j$(sysctl -n hw.ncpu)
```

## CLion Configuration Steps

### Step 1: Open Project

1. **File** → **Open**
2. Navigate to the Kairon project directory
3. Select the root folder (where the main `CMakeLists.txt` is)
4. Click **Open**

### Step 2: Configure CMake Profiles

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

### Step 3: Select Build Configuration

In the top toolbar:
1. Select your desired configuration (Debug/Release)
2. Select **Sandbox** as the target

### Step 4: Build and Run

- Click the **Build** button (🔨) or press **⌘F9**
- Click the **Run** button (▶️) or press **⌃R**
- Click the **Debug** button (🐛) or press **⌃D**

## First Time Setup Checklist

Before building in CLion, make sure you've completed:

- [ ] Cloned the repository
- [ ] Checked out `cursor/premake-to-cmake-migration-73a6` branch
- [ ] Initialized submodules: `git submodule update --init --recursive`
- [ ] Fixed imgui if needed: `./scripts/fix-imgui-submodule.sh`
- [ ] Applied imgui bug fix: `./scripts/setup-imgui.sh`
- [ ] Added CMake option in CLion: `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`

## Troubleshooting

### "imgui.cpp: No such file or directory"

ImGui bug fix wasn't applied. Run:
```bash
./scripts/setup-imgui.sh
```

Then reload CMake project in CLion (**Tools** → **CMake** → **Reload CMake Project**)

### "Cannot find OpenGL"

On macOS, OpenGL should be found automatically. If not:
```bash
xcode-select --install
```

### Build directory issues

If you get weird build errors, try:
1. **Tools** → **CMake** → **Reset Cache and Reload Project**
2. Or manually delete the `cmake-build-*` directories

## Running from Terminal

If you prefer terminal over CLion:

```bash
# Configure
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Debug -B build

# Build
cmake --build build -j$(sysctl -n hw.ncpu)

# Run
./build/bin/Sandbox
```

## Debugging in CLion

1. Set breakpoints by clicking in the gutter next to line numbers
2. Click the **Debug** button (🐛) or press **⌃D**
3. Use the debug toolbar to step through code:
   - **Step Over**: **F8**
   - **Step Into**: **F7**
   - **Step Out**: **⇧F8**
   - **Resume**: **⌥⌘R**

## CLion Tips

- **Double-tap Shift**: Search everywhere
- **⌘O**: Go to class
- **⌘⇧O**: Go to file
- **⌘E**: Recent files
- **⌥F7**: Find usages
- **⌘B**: Go to declaration
- **⌃Space**: Code completion
