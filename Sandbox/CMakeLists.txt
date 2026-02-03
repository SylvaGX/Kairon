cmake_minimum_required(VERSION 3.16)
project(Sandbox LANGUAGES CXX)

# Source files
set(SANDBOX_SOURCES
    src/SandBoxApp.cpp
)

# Create executable
add_executable(Sandbox ${SANDBOX_SOURCES})

# Include directories
target_include_directories(Sandbox PRIVATE
    ${CMAKE_SOURCE_DIR}/Kairon/vendor/spdlog/include
    ${CMAKE_SOURCE_DIR}/Kairon/src
    ${CMAKE_SOURCE_DIR}/Kairon/vendor
    ${CMAKE_SOURCE_DIR}/Kairon/vendor/glm
)

# Link Kairon engine
target_link_libraries(Sandbox PRIVATE
    Kairon
)

# Platform-specific definitions
if(WIN32)
    target_compile_definitions(Sandbox PRIVATE
        KR_PLATFORM_WINDOWS
    )
elseif(APPLE)
    target_compile_definitions(Sandbox PRIVATE
        KR_PLATFORM_MACOS
    )
elseif(UNIX)
    target_compile_definitions(Sandbox PRIVATE
        KR_PLATFORM_LINUX
    )
endif()

# C++ standard
target_compile_features(Sandbox PRIVATE cxx_std_17)

# Set as default startup project for IDEs
set_property(TARGET Sandbox PROPERTY VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
