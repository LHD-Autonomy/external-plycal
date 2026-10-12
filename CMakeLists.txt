cmake_minimum_required(VERSION 2.8)
project(PlyCal)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
add_definitions(-std=c++11)

# Optionally compiling part
option(BUILD_PlyCal_GUI "enables PlyCal viewer" true)
option(BUILD_PlyCal_TEST "enables PlyCal test" false)

# Default build type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING
      "Choose the build type." FORCE)
endif()

# Dependencies
find_package(PCL REQUIRED)
find_package(Eigen3 REQUIRED)

include_directories(
  thirdParty
  PlyCal
  ${PCL_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIRS}
)

add_definitions(${PCL_DEFINITIONS})

# Library prefix
set(LIB_PREFIX plycal)

# Subdirectories
add_subdirectory(PlyCal)

if(BUILD_PlyCal_GUI)
  add_subdirectory(PlyCal_qt)
endif()

if(BUILD_PlyCal_TEST)
  add_subdirectory(PlyCal_test)
endif()