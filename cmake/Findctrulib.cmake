# - Try to find ctrulib
# You can set ctrulib_ROOT to specify a certain directory to look in first.
# Once done this will define
#  ctrulib_FOUND - System has ctrulib
#  ctrulib_INCLUDE_DIRS - The ctrulib include directories
#  ctrulib_LIBRARIES - The libraries needed to use ctrulib
# It also adds an imported target named `3ds::ctrulib`, Linking against it is
# equivalent to:
# target_link_libraries(mytarget ${ctrulib_LIBRARY})
# target_include_directories(mytarget PRIVATE ${ctrulib_INCLUDE_DIRS})

if(NOT 3DS)
    message(FATAL_ERROR "This module can only be used if you are using the 3DS toolchain file. Please erase this build directory or create another one, and then use -DCMAKE_TOOLCHAIN_FILE=DevkitArm3DS.cmake when calling cmake for the 1st time. For more information, see the Readme.md for more information.")
endif()

include(LibFindMacros)
include(try_add_imported_target)

set(_ctrulib_SEARCHES)

# Search ctrulib_ROOT first if it is set.
if(ctrulib_ROOT)
  set(_ctrulib_SEARCH_ROOT
    PATHS ${ctrulib_ROOT}
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH)
  list(APPEND _ctrulib_SEARCHES _ctrulib_SEARCH_ROOT)
endif()

# Search below ${DEVKITPRO}, ${DEVKITARM} etc.
set(_ctrulib_SEARCH_NORMAL
  PATHS / /libctru /ctrulib
  NO_DEFAULT_PATH
  ONLY_CMAKE_FIND_ROOT_PATH)
list(APPEND _ctrulib_SEARCHES _ctrulib_SEARCH_NORMAL)

foreach(search ${_ctrulib_SEARCHES})
  find_path(ctrulib_INCLUDE_DIR NAMES 3ds.h
    ${${search}}
    PATH_SUFFIXES include libctru/include)
  find_library(ctrulib_LIBRARY NAMES ctru libctru.a
    ${${search}}
    PATH_SUFFIXES lib libctru/lib)
endforeach()

set(ctrulib_PROCESS_INCLUDES ctrulib_INCLUDE_DIR)
set(ctrulib_PROCESS_LIBS ctrulib_LIBRARY)

libfind_process(ctrulib)

try_add_imported_target(ctrulib)

if(ctrulib_FOUND AND NOT DEFINED ctrulib)
  get_filename_component(ctrulib ${ctrulib_INCLUDE_DIR} DIRECTORY)
  message(STATUS "Setting ctrulib to ${ctrulib}")
endif()
