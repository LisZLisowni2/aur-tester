cmake_minimum_required(VERSION 3.10)
project(aurtester)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED true)

include_directories(include)

set(SOURCES
    src/main.cpp
    src/tester.cpp
    src/makeCopy.cpp
    src/installPackage.cpp
    src/scanMalware.cpp
    src/scanRootkit.cpp
    src/difference.cpp
    utils/global.cpp
    utils/utils.cpp
)

add_executable(aurtester ${SOURCES})

install(TARGETS aurtester
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib/static
)
