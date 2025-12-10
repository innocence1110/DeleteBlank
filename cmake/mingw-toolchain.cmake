# CMake工具链文件，用于MinGW-w64

# 设置目标系统
set(CMAKE_SYSTEM_NAME Windows)

# 强制设置MinGW编译器路径
# 根据终端输出，MinGW安装在C:/mingw64/mingw64/bin
set(CMAKE_C_COMPILER "C:/mingw64/mingw64/bin/gcc.exe")
set(CMAKE_CXX_COMPILER "C:/mingw64/mingw64/bin/g++.exe")

# 输出检测到的编译器路径
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "CXX Compiler: ${CMAKE_CXX_COMPILER}")

# 添加MinGW包含路径，解决bits/stdc++.h找不到的问题
execute_process(
  COMMAND ${CMAKE_CXX_COMPILER} -print-file-name=include
  OUTPUT_VARIABLE CXX_INCLUDE_DIR
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

if(CXX_INCLUDE_DIR)
  include_directories(${CXX_INCLUDE_DIR})
  message(STATUS "Include directory: ${CXX_INCLUDE_DIR}")
endif()

# 设置C++标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 设置构建类型
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

# 设置编译选项
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -finput-charset=UTF-8 -fexec-charset=UTF-8")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG -finput-charset=UTF-8 -fexec-charset=UTF-8")

# 设置链接器选项
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--enable-stdcall-fixup")

# 生成compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)