cmake_minimum_required(VERSION 3.16)
project(Glad LANGUAGES C)

add_library(Glad STATIC
    src/glad.c
    include/glad/glad.h
    include/KHR/khrplatform.h
)

target_include_directories(Glad PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Position independent code for Linux
if(UNIX AND NOT APPLE)
    set_target_properties(Glad PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()
