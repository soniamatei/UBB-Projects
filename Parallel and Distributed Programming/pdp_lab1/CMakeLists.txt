cmake_minimum_required(VERSION 3.25)
project(pdp_lab1)

set(CMAKE_CXX_STANDARD 17)

add_executable(pdp_lab1 main.cpp
        inventory.cpp
        inventory.h
        Manager.cpp
        Manager.h
        Manager.h)
