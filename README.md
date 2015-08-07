# 3ds-cmake

CMake scripts for devkitArm and 3DS homebrew development.

It aims to provide at least the same functionalities than devkitPro makefiles. It can help to build more complex projects or simply compile libraries by using the toolchain file.

## How to use it ?

Simply copy `DevkitArm3DS.cmake` and the `cmake` folder at the root of your project (where your CMakeLists.txt is).
Then start cmake with

    cmake -DCMAKE_TOOLCHAIN_FILE=DevkitArm3DS.cmake

If you are on windows, I suggest using the `Unix Makefiles` generator.

`cmake-gui` is also a good alternative, you can specify the toolchain file the first time you configure a build.
	
You can use the macros and find scripts of the `cmake` folder by adding the following line to your CMakeLists.cmake :

    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

## FindCTRULIB.cmake

You can use `find_package(CTRULIB)`. If found, `LIBCTRU_LIBRARIES` and `LIBCTRU_INCLUDE_DIRS` will be set.

## Tools3DS.cmake

This file must be include with `include(Tools3DS)`. It provides several macros related to 3DS development such as `add_shader_library` which assembles your shaders into a C library.

### add_3dsx_target

This macro has two signatures :

#### add_3dsx_target(target [NO_SMDH])

Adds a target that generates a .3dsx file from `target`. If NO_SMDH is specified, no .smdh file will be generated.

You can set the following variables to change the SMDH file :

* APP_TITLE is the name of the app stored in the SMDH file (Optional)
* APP_DESCRIPTION is the description of the app stored in the SMDH file (Optional)
* APP_AUTHOR is the author of the app stored in the SMDH file (Optional)
* APP_ICON is the filename of the icon (.png), relative to the project folder.
  If not set, it attempts to use one of the following (in this order):
    - $(target).png
    - icon.png
    - $(libctru folder)/default_icon.png

#### add_3dsx_target(target APP_TITLE APP_DESCRIPTION APP_AUTHOR [APP_ICON])

This version will produce the SMDH with tha values passed as arguments. Tha APP_ICON is optional and follows the same rule as the other version of `add_3dsx_target`.

### add_binary_library(target input1 [input2 ...])

    /!\ Requires ASM to be enabled ( `enable_language(ASM)` or `project(yourprojectname C CXX ASM)`)

Converts the files given as input to arrays of their binary data. This is useful to embed resources into your project.
For example, logo.bmp will generate the array `u8 logo_bmp[]` and its size `logo_bmp_size`. By linking this library, you 
will also have access to a generated header file called `logo_bmp.h` which contains the declarations you need to use it.

    Note : All dots in the filename are converted to `_`, and if it starts with a number, `_` will be prepended. 
    For example 8x8.gas.tex would give the name _8x8_gas_tex.

### add_shbin(output input [entrypoint] [shader_type])
 
Assembles the shader given as `input` into the file `output`. No file extension is added.
You can choose the shader assembler by setting SHADER_AS to `picasso` or `nihstro`.

If `nihstro` is set as the assembler, entrypoint and shader_type will be used.
- entrypoint is set to `main` by default
- shader_type can be either VSHADER or GSHADER. By default it is VSHADER. 

### generate_shbins(input1 [input2 ...])

Assemble all the shader files given as input into .shbin files. Those will be located in the folder `shaders` of the build directory.

### add_shbin_library(target input1 [input2 ...])

    /!\ Requires ASM to be enabled ( `enable_language(ASM)` or `project(yourprojectname C CXX ASM)`)

This is the same as calling generate_shbins and add_binary_library. This is the function to be used to reproduce devkitArm makefiles behaviour.
For example, add_shbin_library(shaders data/my1stshader.vsh.pica) will generate the target library `shaders` and you
will be able to use the shbin in your program by linking it, including `my1stshader_vsh_pica.h` and using `my1stshader_vsh_pica[]` and `my1stshader_vsh_pica_size`.

# Example of CMakeLists.txt using ctrulib and shaders

    cmake_minimum_required(VERSION 2.8)
    project(videoPlayer C CXX ASM)
    
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
    include(Tools3DS)
    
    find_package(CTRULIB REQUIRED)
    
    file(GLOB_RECURSE SHADERS_FILES
        data/*.pica
    )
    add_shbin_library(shaders ${SHADERS_FILES})
    
    file(GLOB_RECURSE SOURCE_FILES
        source/*
    )
    add_executable(hello_cmake ${SOURCE_FILES})
    target_link_libraries(hello_cmake shaders ${LIBCTRU_LIBRARIES})
    target_include_directories(hello_cmake PUBLIC include ${LIBCTRU_INCLUDE_DIRS})
	
	add_3dsx_target(hello_cmake)
