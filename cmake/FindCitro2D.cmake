# - Try to find Citro2D
# You can set Citro2D_ROOT to specify a certain directory to look in first.
# Once done this will define
#  Citro2D_FOUND - System has Citro2D
#  Citro2D_INCLUDE_DIRS - The Citro2D include directories
#  Citro2D_LIBRARIES - The libraries needed to use Citro2D
# Unless we are unable to find ctrulib
# It also adds an imported target named `3ds::citro2d`, Linking against it is
# equivalent to:
# target_link_libraries(mytarget ${Citro2D_LIBRARIES})
# target_include_directories(mytarget PRIVATE ${Citro2D_INCLUDE_DIRS})

if(NOT 3DS)
    message(FATAL_ERROR "This module can only be used if you are using the 3DS toolchain file. Please erase this build directory or create another one, and then use -DCMAKE_TOOLCHAIN_FILE=DevkitArm3DS.cmake when calling cmake for the 1st time. For more information, see the Readme.md for more information.")
endif()

include(LibFindMacros)
include(try_add_imported_target)

# Citro2D requires ctrulib
libfind_package(Citro2D ctrulib)
libfind_package(Citro2D Citro3D)

set(_Citro2D_SEARCHES)

# Search Citro2D_ROOT first if it is set.
if(Citro2D_ROOT)
  set(_Citro2D_SEARCH_ROOT
    PATHS ${Citro2D_ROOT}
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH)
  list(APPEND _Citro2D_SEARCHES _Citro2D_SEARCH_ROOT)
endif()

# Search below ${DEVKITPRO}, ${DEVKITARM} etc.
set(_Citro2D_SEARCH_NORMAL
  PATHS / /citro2d /libctru /ctrulib /citro3d
  NO_DEFAULT_PATH
  ONLY_CMAKE_FIND_ROOT_PATH)
list(APPEND _Citro2D_SEARCHES _Citro2D_SEARCH_NORMAL)

foreach(search ${_Citro2D_SEARCHES})
  find_path(Citro2D_INCLUDE_DIR NAMES citro2d.h
    ${${search}}
    PATH_SUFFIXES include)
  find_library(Citro2D_LIBRARY NAMES citro2d libcitro2d.a
    ${${search}}
    PATH_SUFFIXES lib)
endforeach()

#find_library(LIBM_LIBRARY NAMES m libm.a
#  PATHS / /arm-none-eabi
#  PATH_SUFFIXES lib/armv6k/fpu)

set(LIBM_LIBRARY m)

set(Citro2D_PROCESS_INCLUDES Citro2D_INCLUDE_DIR)
set(Citro2D_PROCESS_LIBS Citro2D_LIBRARY LIBM_LIBRARY)

libfind_process(Citro2D)

try_add_imported_target(Citro2D m 3ds::ctrulib 3ds::citro3d)
