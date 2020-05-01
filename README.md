# 3ds-cmake (3DStris)

CMake scripts for devkitArm and 3DS homebrew development.

It aims to provide at least the same functionalities as the devkitPro makefiles. It can help to build more complex projects or simply compile libraries by using the toolchain file.

## Table of Contents

<!-- toc -->

- [How to use it?](#how-to-use-it)
  * [For 3DS projects](#for-3ds-projects)
  * [General](#general)
- [3DS CMake files](#3ds-cmake-files)
  * [The toolchain file (DevkitArm3DS.cmake)](#the-toolchain-file-devkitarm3dscmake)
    + [3DS](#3ds)
    + [DKA_SUGGESTED_C_FLAGS](#dka_suggested_c_flags)
    + [DKA_SUGGESTED_CXX_FLAGS](#dka_suggested_cxx_flags)
    + [WITH_PORTLIBS](#with_portlibs)
  * [FindCTRULIB.cmake](#findctrulibcmake)
  * [FindCITRO3D.cmake](#findcitro3dcmake)
  * [FindSF2D.cmake](#findsf2dcmake)
  * [FindSFTD.cmake](#findsftdcmake)
  * [FindSFIL.cmake](#findsfilcmake)
  * [FindZLIB.cmake](#findzlibcmake)
  * [FindPNG.cmake](#findpngcmake)
  * [FindJPEG.cmake](#findjpegcmake)
  * [FindFreetype.cmake](#findfreetypecmake)
  * [Tools3DS.cmake](#tools3dscmake)
    + [add_3dsx_target](#add_3dsx_target)
      - [add_3dsx_target(target [NO_SMDH])](#add_3dsx_targettarget-no_smdh)
      - [add_3dsx_target(target APP_TITLE APP_DESCRIPTION APP_AUTHOR [APP_ICON])](#add_3dsx_targettarget-app_title-app_description-app_author-app_icon)
    + [add_cia_target(target RSF IMAGE SOUND [APP_TITLE APP_DESCRIPTION APP_AUTHOR [APP_ICON]])](#add_cia_targettarget-rsf-image-sound-app_title-app_description-app_author-app_icon)
    + [add_cci_target(target RSF IMAGE SOUND [APP_TITLE APP_DESCRIPTION APP_AUTHOR [APP_ICON]])](#add_cci_targettarget-rsf-image-sound-app_title-app_description-app_author-app_icon)
    + [add_netload_target(name target_or_file)](#add_netload_targetname-target_or_file)
    + [add_binary_library(target input1 [input2 ...])](#add_binary_librarytarget-input1-input2-)
    + [target_embed_file(target input1 [input2 ...])](#target_embed_filetarget-input1-input2-)
    + [add_shbin(output input [entrypoint][shader_type])](#add_shbinoutput-input-entrypointshader_type)
    + [generate_shbins(input1 [input2 ...])](#generate_shbinsinput1-input2-)
    + [add_shbin_library(target input1 [input2 ...])](#add_shbin_librarytarget-input1-input2-)
    + [target_embed_shader(target input1 [input2 ...])](#target_embed_shadertarget-input1-input2-)
  * [Example of CMakeLists.txt using ctrulib and shaders](#example-of-cmakeliststxt-using-ctrulib-and-shaders)

<!-- tocstop -->

## How to use it?

### For 3DS projects

Simply copy `DevkitArm3DS.cmake` and the `cmake` folder at the root of your project (where your CMakeLists.txt is). Then start cmake with

```sh
cmake -DCMAKE_TOOLCHAIN_FILE=DevkitArm3DS.cmake
```

Or, put the following at the top of your `CMakeLists.txt` file:

```cmake
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/DevkitArm3DS.cmake)
```

### General

If you are on windows, I suggest using the `Unix Makefiles` generator.

`cmake-gui` is also a good alternative, you can specify the toolchain file the first time you configure a build.

You can use the macros and find scripts of the `cmake` folder by adding the following line to your CMakeLists.cmake :

```cmake
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
```

## 3DS CMake files

### The toolchain file (DevkitArm3DS.cmake)

#### 3DS

This CMake variable will be set so that you can test against it for projects that can be built on other platforms.

#### DKA_SUGGESTED_C_FLAGS

This CMake variable is set to `-fomit-frame-pointer -ffunction-sections`. Those are the recommended C flags for devkitArm projects but are non-mandatory.

#### DKA_SUGGESTED_CXX_FLAGS

This CMake variable is set to `-fomit-frame-pointer -ffunction-sections -fno-rtti -fno-exceptions -std=gnu++11`. Those are the recommended C++ flags for devkitArm projects but are non-mandatory.

#### WITH_PORTLIBS

By default the portlibs folder will be used, it can be disabled by changing the value of WITH_PORTLIBS to OFF from the cache (or forcing the value from your CMakeLists.txt).

### FindCTRULIB.cmake

```cmake
find_package(CTRULIB [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `CTRULIB_ROOT` - the root directory of your CTRULIB install.

If CTRULIB is found it will set the following:

- `CTRULIB_FOUND`
- `CTRULIB_LIBRARIES` - the necessary libraries to link against to use CTRULIB.
- `CTRULIB_INCLUDE_DIRS` - the necessary include directories to use CTRULIB.
- It will also add an imported target named `3ds::ctrulib`.

Examples of linking against CTRULIB:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(CTRULIB REQUIRED)

target_link_libraries(mytarget ${CTRULIB_LIBRARIES})
target_include_directories(mytarget PRIVATE ${CTRULIB_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(CTRULIB REQUIRED)

target_link_libraries(mytarget 3ds::ctrulib)
```

### FindCITRO3D.cmake

```cmake
find_package(CITRO3D [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `CITRO3D_ROOT` - the root directory of your CITRO3D install.

CITRO3D also depends on the following being found:

- [CTRULIB](#findctrulib-cmake)

If CITRO3D is found it will set the following:

- `CITRO3D_FOUND`
- `CITRO3D_LIBRARIES` - the necessary libraries to link against to use CITRO3D (including CTRULIB).
- `CITRO3D_INCLUDE_DIRS` - the necessary include directories to use CITRO3D (including CTRULIB).
- It will also add an imported target named `3ds::citro3d`.
  - This automatically links against `3ds::ctrulib` and `m` as well.

Examples of linking against CITRO3D:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(CITRO3D REQUIRED)

target_link_libraries(mytarget ${CITRO3D_LIBRARIES})
target_include_directories(mytarget PRIVATE ${CITRO3D_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(CITRO3D REQUIRED)

target_link_libraries(mytarget 3ds::citro3d)
```

### FindSF2D.cmake

```cmake
find_package(SF2D [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `SF2D_ROOT` - the root directory of your SF2D install.

SF2D also depends on the following being found:

- [CITRO3D](#findcitro3d-cmake)

If SF2D is found it will set the following:

- `SF2D_FOUND`
- `SF2D_LIBRARIES` - the necessary libraries to link against to use SF2D (including CITRO3D etc.).
- `SF2D_INCLUDE_DIRS` - the necessary include directories to use SF2D (including CITRO3D etc.).
- It will also add an imported target named `3ds::sf2d`.
  - This automatically links against `3ds::citro3d` as well.

Examples of linking against SF2D:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(SF2D REQUIRED)

target_link_libraries(mytarget ${SF2D_LIBRARIES})
target_include_directories(mytarget PRIVATE ${SF2D_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(SF2D REQUIRED)

target_link_libraries(mytarget 3ds::sf2d)
```

### FindSFTD.cmake

```cmake
find_package(SFTD [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `SFTD_ROOT` - the root directory of your SFTD install.

SFTD also depends on the following being found:

- [SF2D](#findsf2d-cmake)
- [Freetype](#findfreetype-cmake)

If SFTD is found it will set the following:

- `SFTD_FOUND`
- `SFTD_LIBRARIES` - the necessary libraries to link against to use SFTD (including Freetype and SF2D etc.).
- `SFTD_INCLUDE_DIRS` - the necessary include directories to use SFTD (including Freetype and SF2D etc.).
- It will also add an imported target named `3ds::sftd`.
  - This automatically links against `3ds::freetype` and `3ds::sf2d` as well.

Examples of linking against SFTD:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(SFTD REQUIRED)

target_link_libraries(mytarget ${SFTD_LIBRARIES})
target_include_directories(mytarget PRIVATE ${SFTD_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(SFTD REQUIRED)

target_link_libraries(mytarget 3ds::sftd)
```

### FindSFIL.cmake

```cmake
find_package(SFIL [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `SFIL_ROOT` - the root directory of your SFIL install.

SFIL also depends on the following being found:

- [SF2D](#findsf2d-cmake)
- [PNG](#findpng-cmake)
- [JPEG](#findjpeg-cmake)

If SFIL is found it will set the following:

- `SFIL_FOUND`
- `SFIL_LIBRARIES` - the necessary libraries to link against to use SFIL (including PNG, JPEG and SF2D etc.).
- `SFIL_INCLUDE_DIRS` - the necessary include directories to use SFIL (including PNG, JPEG and SF2D etc.).
- It will also add an imported target named `3ds::sfil`.
  - This automatically links against `3ds::png`, `3ds::jpeg` and `3ds::sf2d` as well.

Examples of linking against SFIL:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(SFIL REQUIRED)

target_link_libraries(mytarget ${SFIL_LIBRARIES})
target_include_directories(mytarget PRIVATE ${SFIL_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(SFIL REQUIRED)

target_link_libraries(mytarget 3ds::sfil)
```

### FindZLIB.cmake

```cmake
find_package(ZLIB [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `ZLIB_ROOT` - the root directory of your ZLIB install.

As this is a portlib, this is almost certainly fail to find ZLIB if `WITH_PORTLIBS`
is set to OFF, unless you set `ZLIB_ROOT`.

If ZLIB is found it will set the following:

- `ZLIB_FOUND`
- `ZLIB_LIBRARIES` - the necessary libraries to link against to use ZLIB.
- `ZLIB_INCLUDE_DIRS` - the necessary include directories to use ZLIB.
- It will also add an imported target named `3ds::zlib`.

Examples of linking against ZLIB:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(ZLIB REQUIRED)

target_link_libraries(mytarget ${ZLIB_LIBRARIES})
target_include_directories(mytarget PRIVATE ${ZLIB_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(ZLIB REQUIRED)

target_link_libraries(mytarget 3ds::zlib)
```

### FindPNG.cmake

```cmake
find_package(PNG [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `PNG_ROOT` - the root directory of your PNG install.

As this is a portlib, this is almost certainly fail to find PNG if `WITH_PORTLIBS`
is set to OFF, unless you set `PNG_ROOT`.

PNG also depends on the following being found:

- [ZLIB](#findzlib-cmake)

If PNG is found it will set the following:

- `PNG_FOUND`
- `PNG_LIBRARIES` - the necessary libraries to link against to use PNG (including ZLIB).
- `PNG_INCLUDE_DIRS` - the necessary include directories to use PNG (including ZLIB).
- It will also add an imported target named `3ds::png`.
  - This automatically links against `3ds::zlib` and `m` as well.

Examples of linking against PNG:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(PNG REQUIRED)

target_link_libraries(mytarget ${PNG_LIBRARIES})
target_include_directories(mytarget PRIVATE ${PNG_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(PNG REQUIRED)

target_link_libraries(mytarget 3ds::png)
```

### FindJPEG.cmake

```cmake
find_package(JPEG [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `JPEG_ROOT` - the root directory of your JPEG install.

As this is a portlib, this is almost certainly fail to find JPEG if `WITH_PORTLIBS`
is set to OFF, unless you set `JPEG_ROOT`.

If JPEG is found it will set the following:

- `JPEG_FOUND`
- `JPEG_LIBRARIES` - the necessary libraries to link against to use JPEG.
- `JPEG_INCLUDE_DIRS` - the necessary include directories to use JPEG.
- It will also add an imported target named `3ds::jpeg`.

Examples of linking against JPEG:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(JPEG REQUIRED)

target_link_libraries(mytarget ${JPEG_LIBRARIES})
target_include_directories(mytarget PRIVATE ${JPEG_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(JPEG REQUIRED)

target_link_libraries(mytarget 3ds::jpeg)
```

### FindFreetype.cmake

```cmake
find_package(Freetype [REQUIRED])
```

You can optionally set the following before calling `find_package`:

- `Freetype_ROOT` - the root directory of your Freetype install.

As this is a portlib, this is almost certainly fail to find Freetype if `WITH_PORTLIBS`
is set to OFF, unless you set `Freetype_ROOT`.

PNG also depends on the following being found:

- [ZLIB](#findzlib-cmake)

If Freetype is found it will set the following:

- `Freetype_FOUND`
- `Freetype_LIBRARIES` - the necessary libraries to link against to use Freetype (including ZLIB).
- `Freetype_INCLUDE_DIRS` - the necessary include directories to use Freetype (including ZLIB).
- It will also add an imported target named `3ds::freetype`.
  - This automatically links against `3ds::zlib` as well.

Examples of linking against Freetype:

- Using `_LIBRARIES` and `_INCLUDE_DIRS`:

```cmake
find_package(Freetype REQUIRED)

target_link_libraries(mytarget ${Freetype_LIBRARIES})
target_include_directories(mytarget PRIVATE ${Freetype_INCLUDE_DIRS})
```

- Using the imported target:

```cmake
find_package(Freetype REQUIRED)

target_link_libraries(mytarget 3ds::freetype)
```

### Tools3DS.cmake

This file must be included with `include(Tools3DS)`. It provides several macros related to 3DS development such as `add_shader_library` which assembles your shaders into a C library.

#### add_3dsx_target

This macro has two signatures :

##### add_3dsx_target(target [NO_SMDH])

Adds a target that generates a .3dsx file from `target`. If NO_SMDH is specified, no .smdh file will be generated.

You can set the following variables to change the SMDH file :

- APP_TITLE is the name of the app stored in the SMDH file (Optional)
- APP_DESCRIPTION is the description of the app stored in the SMDH file (Optional)
- APP_AUTHOR is the author of the app stored in the SMDH file (Optional)
- APP_ICON is the filename of the icon (.png), relative to the project folder.
  If not set, it attempts to use one of the following (in this order):
  - \$(target).png
  - icon.png
  - \$(libctru folder)/default_icon.png

##### add_3dsx_target(target APP_TITLE APP_DESCRIPTION APP_AUTHOR [APP_ICON])

This version will produce the SMDH with the values passed as arguments. The APP_ICON is optional and follows the same rule as the other version of `add_3dsx_target`.

#### add_cia_target(target RSF IMAGE SOUND [APP_TITLE APP_DESCRIPTION APP_AUTHOR [APP_ICON]])

Same as add_3dsx_target but for CIA files.

- RSF is the .rsf file to be given to makerom.
- IMAGE is either a .png or a cgfximage file.
- SOUND is either a .wav or a cwavaudio file.

#### add_cci_target(target RSF IMAGE SOUND [APP_TITLE APP_DESCRIPTION APP_AUTHOR [APP_ICON]])

Same as add_cia_target but for CCI files.

#### add_netload_target(name target_or_file)

Adds a target `name` that sends a .3dsx using the homebrew launcher netload system (3dslink).

- `target_or_file` is either the name of a target (on which you used add_3dsx_target) or a file name.

#### add_binary_library(target input1 [input2 ...])

**/!\ Requires ASM to be enabled ( `enable_language(ASM)` or
`project(yourprojectname C CXX ASM)`)**

Converts the files given as input to arrays of their binary data. This is useful to embed resources into your project. For example, logo.bmp will generate the array `u8 logo_bmp[]` and its size `logo_bmp_size`. By linking this library, you will also have access to a generated header file called `logo_bmp.h` which contains the declarations you need to use it.

Note : All dots in the filename are converted to `_`, and if it starts with a number, `_` will be prepended. For example `8x8.gas.tex` would give the name `_8x8_gas_tex`.

#### target_embed_file(target input1 [input2 ...])

This is the same as:

```cmake
add_binary_library(tempbinlib input1 [input2 ...])
target_link_libraries(target tempbinlib)
```

#### add_shbin(output input [entrypoint][shader_type])

Assembles the shader given as `input` into the file `output`. No file extension is added. You can choose the shader assembler by setting SHADER_AS to `picasso` or `nihstro`.

If `nihstro` is set as the assembler, entrypoint and shader_type will be used.

- entrypoint is set to `main` by default
- shader_type can be either VSHADER or GSHADER. By default it is VSHADER.

#### generate_shbins(input1 [input2 ...])

Assemble all the shader files given as input into .shbin files. Those will be located in the folder `shaders` of the build directory. The names of the output files will be
`<name of input without shortest extension>.shbin`. `shader.pica` will output `shader.shbin` but `shader.vertex.pica` will output `shader.vertex.shbin`.

#### add_shbin_library(target input1 [input2 ...])

**/!\ Requires ASM to be enabled ( `enable_language(ASM)` or
`project(yourprojectname C CXX ASM)`)**

This is the same as:

```cmake
generate_shbins(source/shader.vertex.pica)
add_binary_library(target ${CMAKE_CURRENT_BINARY_DIR}/shaders/shader.vertex.shbin)
```

This is the function to be used to reproduce devkitArm makefiles behaviour. For example, add_shbin_library(shaders data/my1stshader.vsh.pica) will generate the target library `shaders` and you will be able to use the shbin in your program by linking it, including `my1stshader_pica.h` and using `my1stshader_pica[]` and `my1stshader_pica_size`.

#### target_embed_shader(target input1 [input2 ...])

This is the same as:

```cmake
add_shbin_library(tempbinlib input1 [input2 ...])
target_link_libraries(target tempbinlib)
```

### Example of CMakeLists.txt using ctrulib and shaders

```cmake
cmake_minimum_required(VERSION 2.8)
project(hello_cmake C CXX ASM)

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
target_link_libraries(hello_cmake shaders 3ds::ctrulib)

add_3dsx_target(hello_cmake)
```
