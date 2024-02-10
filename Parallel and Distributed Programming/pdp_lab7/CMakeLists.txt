cmake_minimum_required(VERSION 3.26)
project(pdp_lab7)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_COMPILER cl)

# Find MPI
find_package(MPI REQUIRED)

# Specify MPI include and library directories
include_directories("D:/Program Files (x86)/Microsoft SDKs/MPI/Include")
link_directories("D:/Program Files (x86)/Microsoft SDKs/MPI/Lib/x64")

# Add your executable
add_executable(pdp_lab7 main.cpp)

# Link your executable with MPI libraries
target_link_libraries(pdp_lab7 msmpi.lib)
