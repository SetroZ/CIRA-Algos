cmake_minimum_required(VERSION 3.15)
project(brute)

# Add the include directory where brute.h is located
include_directories(${CMAKE_SOURCE_DIR}/src)

add_executable(brute src/main.cpp src/brute.cpp)

# Find and link CCfits library
find_package(ccfits REQUIRED)
target_link_libraries(brute ccfits::ccfits)
