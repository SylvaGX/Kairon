cmake_minimum_required(VERSION 3.15)
project(Kairon VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 23)

find_package(glfw3 REQUIRED)
find_package(VulkanHeaders REQUIRED)

add_executable(${PROJECT_NAME} src/main.cpp)

target_link_libraries(${PROJECT_NAME} glfw)
target_link_libraries(${PROJECT_NAME} vulkan-headers::vulkan-headers)
