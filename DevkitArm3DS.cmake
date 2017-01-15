set(CMAKE_SYSTEM_NAME 3DS-devkitARM)
set(CMAKE_SYSTEM_VERSION 45)
set(CMAKE_SYSTEM_PROCESSOR armv6k)
set(3DS TRUE) # To be used for multiplatform projects

set(CMAKE_SYSTEM_INCLUDE_PATH /include)
set(CMAKE_SYSTEM_LIBRARY_PATH /lib)

include("${CMAKE_CURRENT_LIST_DIR}/cmake/msys_to_cmake_path.cmake")

msys_to_cmake_path("$ENV{DEVKITPRO}" DEVKITPRO)
if(NOT IS_DIRECTORY ${DEVKITPRO})
    message(FATAL_ERROR "Please set DEVKITPRO in your environment")
endif()

msys_to_cmake_path("$ENV{DEVKITARM}" DEVKITARM)
if(NOT IS_DIRECTORY ${DEVKITARM})
    message(FATAL_ERROR "Please set DEVKITARM in your environment")
endif()

# Prefix detection only works with compiler id "GNU"
# CMake will look for prefixed g++, cpp, ld, etc. automatically
if(WIN32)
    set(CMAKE_C_COMPILER "${DEVKITARM}/bin/arm-none-eabi-gcc.exe")
    set(CMAKE_CXX_COMPILER "${DEVKITARM}/bin/arm-none-eabi-g++.exe")
    set(CMAKE_AR "${DEVKITARM}/bin/arm-none-eabi-gcc-ar.exe" CACHE STRING "")
    set(CMAKE_RANLIB "${DEVKITARM}/bin/arm-none-eabi-gcc-ranlib.exe" CACHE STRING "")
else()
    set(CMAKE_C_COMPILER "${DEVKITARM}/bin/arm-none-eabi-gcc")
    set(CMAKE_CXX_COMPILER "${DEVKITARM}/bin/arm-none-eabi-g++")
    set(CMAKE_AR "${DEVKITARM}/bin/arm-none-eabi-gcc-ar" CACHE STRING "")
    set(CMAKE_RANLIB "${DEVKITARM}/bin/arm-none-eabi-gcc-ranlib" CACHE STRING "")
endif()

set(WITH_PORTLIBS ON CACHE BOOL "use portlibs ?")

if(WITH_PORTLIBS)
    set(CMAKE_FIND_ROOT_PATH ${DEVKITARM} ${DEVKITPRO} ${DEVKITPRO}/portlibs/3ds ${DEVKITPRO}/portlibs/armv6k)
else()
    set(CMAKE_FIND_ROOT_PATH ${DEVKITARM} ${DEVKITPRO})
endif()

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Technically, the 3DS does support it (CROs), but the toolchain doesn't.
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

add_definitions(-DARM11 -D_3DS)

set(ARCH "-march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft ")
set(CMAKE_C_FLAGS " -mword-relocations ${ARCH}" CACHE STRING "C flags")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "C++ flags")
set(DKA_SUGGESTED_C_FLAGS "-fomit-frame-pointer")
set(DKA_SUGGESTED_CXX_FLAGS "${DKA_SUGGESTED_C_FLAGS} -fno-rtti -fno-exceptions -std=gnu++11")

set(CMAKE_INSTALL_PREFIX ${DEVKITPRO}/portlibs/3ds
    CACHE PATH "Install libraries in the portlibs dir")
