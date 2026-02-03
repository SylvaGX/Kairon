cmake_minimum_required(VERSION 3.16)
project(Kairon LANGUAGES CXX)

# Collect all source files
set(KAIRON_SOURCES
    # Precompiled header
    src/hzpch.cpp
    src/hzpch.h
    
    # Core engine files
    src/Kairon.h
    src/Kairon/Core.h
    src/Kairon/Application.cpp
    src/Kairon/Application.h
    src/Kairon/EntryPoint.h
    src/Kairon/Input.h
    src/Kairon/KeyCodes.h
    src/Kairon/MouseButtonCodes.h
    src/Kairon/Layer.cpp
    src/Kairon/Layer.h
    src/Kairon/LayerStack.cpp
    src/Kairon/LayerStack.h
    src/Kairon/Log.cpp
    src/Kairon/Log.h
    src/Kairon/Window.h
    
    # Events
    src/Kairon/Events/Event.h
    src/Kairon/Events/ApplicationEvent.h
    src/Kairon/Events/KeyEvent.h
    src/Kairon/Events/MouseEvent.h
    
    # ImGui integration
    src/Kairon/ImGui/ImGuiBuild.cpp
    src/Kairon/ImGui/ImGuiLayer.cpp
    src/Kairon/ImGui/ImGuiLayer.h
    
    # Renderer
    src/Kairon/Renderer/Buffer.cpp
    src/Kairon/Renderer/Buffer.h
    src/Kairon/Renderer/GraphicsContext.h
    src/Kairon/Renderer/Renderer.cpp
    src/Kairon/Renderer/Renderer.h
    src/Kairon/Renderer/Shader.cpp
    src/Kairon/Renderer/Shader.h
    
    # Platform - OpenGL
    src/Platform/OpenGL/OpenGLBuffer.cpp
    src/Platform/OpenGL/OpenGLBuffer.h
    src/Platform/OpenGL/OpenGLContext.cpp
    src/Platform/OpenGL/OpenGLContext.h
)

# Platform-specific sources
if(WIN32)
    list(APPEND KAIRON_SOURCES
        src/Platform/Windows/WindowsInput.cpp
        src/Platform/Windows/WindowsInput.h
        src/Platform/Windows/WindowsWindow.cpp
        src/Platform/Windows/WindowsWindow.h
    )
elseif(APPLE)
    # On macOS, we'll use the Windows implementation for now
    # You may want to create macOS-specific implementations later
    list(APPEND KAIRON_SOURCES
        src/Platform/Windows/WindowsInput.cpp
        src/Platform/Windows/WindowsInput.h
        src/Platform/Windows/WindowsWindow.cpp
        src/Platform/Windows/WindowsWindow.h
    )
elseif(UNIX)
    # On Linux, we'll use the Windows implementation for now
    list(APPEND KAIRON_SOURCES
        src/Platform/Windows/WindowsInput.cpp
        src/Platform/Windows/WindowsInput.h
        src/Platform/Windows/WindowsWindow.cpp
        src/Platform/Windows/WindowsWindow.h
    )
endif()

# Create static library
add_library(Kairon STATIC ${KAIRON_SOURCES})

# Precompiled headers
target_precompile_headers(Kairon PRIVATE src/hzpch.h)

# Include directories
target_include_directories(Kairon PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/spdlog/include
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/GLFW/include
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/Glad/include
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/imgui
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/imgui/backends
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/glm
)

# Link libraries
target_link_libraries(Kairon PUBLIC
    glfw
    Glad
    ImGui
    glm
    spdlog
)

# Platform-specific definitions and libraries
if(WIN32)
    target_compile_definitions(Kairon PUBLIC
        KR_PLATFORM_WINDOWS
        GLFW_INCLUDE_NONE
    )
    # Link OpenGL on Windows
    target_link_libraries(Kairon PUBLIC opengl32)
elseif(APPLE)
    target_compile_definitions(Kairon PUBLIC
        KR_PLATFORM_MACOS
        GLFW_INCLUDE_NONE
    )
    # Link OpenGL framework on macOS
    find_library(OPENGL_LIBRARY OpenGL REQUIRED)
    find_library(COCOA_LIBRARY Cocoa REQUIRED)
    find_library(IOKIT_LIBRARY IOKit REQUIRED)
    find_library(COREVIDEO_LIBRARY CoreVideo REQUIRED)
    target_link_libraries(Kairon PUBLIC
        ${OPENGL_LIBRARY}
        ${COCOA_LIBRARY}
        ${IOKIT_LIBRARY}
        ${COREVIDEO_LIBRARY}
    )
elseif(UNIX)
    target_compile_definitions(Kairon PUBLIC
        KR_PLATFORM_LINUX
        GLFW_INCLUDE_NONE
    )
    # Link OpenGL on Linux
    find_package(OpenGL REQUIRED)
    target_link_libraries(Kairon PUBLIC OpenGL::GL ${CMAKE_DL_LIBS})
endif()

# Compiler-specific settings
if(MSVC)
    target_compile_options(Kairon PRIVATE /W4)
else()
    target_compile_options(Kairon PRIVATE -Wall -Wextra -Wpedantic)
endif()

# C++ standard
target_compile_features(Kairon PUBLIC cxx_std_17)
