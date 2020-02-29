# - Try to find Citro3D
# You can set Citro3D_ROOT to specify a certain directory to look in first.
# Once done this will define
#  Citro3D_FOUND - System has Citro3D
#  Citro3D_INCLUDE_DIRS - The Citro3D include directories
#  Citro3D_LIBRARIES - The libraries needed to use Citro3D
# Unless we are unable to find ctrulib
# It also adds an imported target named `3ds::citro3d`, Linking against it is
# equivalent to:
# target_link_libraries(mytarget ${Citro3D_LIBRARIES})
# target_include_directories(mytarget PRIVATE ${Citro3D_INCLUDE_DIRS})

if(NOT 3DS)
    message(FATAL_ERROR "This module can only be used if you are using the 3DS toolchain file. Please erase this build directory or create another one, and then use -DCMAKE_TOOLCHAIN_FILE=DevkitArm3DS.cmake when calling cmake for the 1st time. For more information, see the Readme.md for more information.")
endif()

include(LibFindMacros)
include(try_add_imported_target)

# Citro3D requires ctrulib
libfind_package(Citro3D ctrulib)

set(_Citro3D_SEARCHES)

# Search Citro3D_ROOT first if it is set.
if(Citro3D_ROOT)
  set(_Citro3D_SEARCH_ROOT
    PATHS ${Citro3D_ROOT}
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH)
  list(APPEND _Citro3D_SEARCHES _Citro3D_SEARCH_ROOT)
endif()

# Search below ${DEVKITPRO}, ${DEVKITARM} etc.
set(_Citro3D_SEARCH_NORMAL
  PATHS / /citro3d /libctru /ctrulib
  NO_DEFAULT_PATH
  ONLY_CMAKE_FIND_ROOT_PATH)
list(APPEND _Citro3D_SEARCHES _Citro3D_SEARCH_NORMAL)

foreach(search ${_Citro3D_SEARCHES})
  find_path(Citro3D_INCLUDE_DIR NAMES citro3d.h
    ${${search}}
    PATH_SUFFIXES include)
  find_library(Citro3D_LIBRARY NAMES citro3d libcitro3d.a
    ${${search}}
    PATH_SUFFIXES lib)
endforeach()

#find_library(LIBM_LIBRARY NAMES m libm.a
#  PATHS / /arm-none-eabi
#  PATH_SUFFIXES lib/armv6k/fpu)

set(LIBM_LIBRARY m)

set(Citro3D_PROCESS_INCLUDES Citro3D_INCLUDE_DIR)
set(Citro3D_PROCESS_LIBS Citro3D_LIBRARY LIBM_LIBRARY)

libfind_process(Citro3D)

try_add_imported_target(Citro3D m 3ds::ctrulib)
