cmake_minimum_required(VERSION 3.16)
project(ImGui LANGUAGES CXX)

# Reference the imgui submodule directory
set(IMGUI_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../imgui)

# Apply patch to fix DC bug in TheCherno's imgui fork
# This patch fixes a bug where DC should be window->DC in SetActiveID
set(PATCH_FILE ${CMAKE_CURRENT_SOURCE_DIR}/imgui_dc_fix.patch)
set(PATCH_MARKER ${IMGUI_DIR}/.dc_fix_applied)

if(NOT EXISTS ${PATCH_MARKER})
    message(STATUS "Applying ImGui DC fix patch...")
    execute_process(
        COMMAND git apply --check ${PATCH_FILE}
        WORKING_DIRECTORY ${IMGUI_DIR}
        RESULT_VARIABLE PATCH_CHECK
        OUTPUT_QUIET
        ERROR_QUIET
    )
    
    if(PATCH_CHECK EQUAL 0)
        execute_process(
            COMMAND git apply ${PATCH_FILE}
            WORKING_DIRECTORY ${IMGUI_DIR}
            RESULT_VARIABLE PATCH_RESULT
        )
        
        if(PATCH_RESULT EQUAL 0)
            file(WRITE ${PATCH_MARKER} "DC fix applied")
            message(STATUS "ImGui DC fix patch applied successfully")
        else()
            message(WARNING "Failed to apply ImGui DC fix patch")
        endif()
    else()
        # Patch already applied or not needed
        file(WRITE ${PATCH_MARKER} "DC fix not needed or already applied")
    endif()
endif()

add_library(ImGui STATIC
    ${IMGUI_DIR}/imconfig.h
    ${IMGUI_DIR}/imgui.h
    ${IMGUI_DIR}/imgui.cpp
    ${IMGUI_DIR}/imgui_draw.cpp
    ${IMGUI_DIR}/imgui_internal.h
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp
    ${IMGUI_DIR}/imgui_demo.cpp
    ${IMGUI_DIR}/imstb_rectpack.h
    ${IMGUI_DIR}/imstb_textedit.h
    ${IMGUI_DIR}/imstb_truetype.h
    # Backends are NOT compiled here - they're included directly in ImGuiLayer.cpp
)

target_include_directories(ImGui PUBLIC
    ${IMGUI_DIR}
    ${IMGUI_DIR}/backends
)

# Position independent code for Linux
if(UNIX AND NOT APPLE)
    set_target_properties(ImGui PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()

# C++ standard
target_compile_features(ImGui PUBLIC cxx_std_17)
