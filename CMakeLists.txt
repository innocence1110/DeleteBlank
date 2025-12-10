cmake_minimum_required(VERSION 3.15)

# 设置项目名称
project(小功能)

# 设置C++标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 设置构建类型
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

# 生成compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 设置编译器选项，处理中文字符
if(MINGW)
  # 添加UTF-8支持
  add_compile_options(-finput-charset=UTF-8 -fexec-charset=UTF-8)
endif()

############## 三方库配置 #############################################

############### 项目配置 ##############################################
# 头文件
include_directories(${CMAKE_SOURCE_DIR}/include)

# 为根目录下的main.cpp创建可执行文件
if(EXISTS "${CMAKE_SOURCE_DIR}/main.cpp")
    add_executable(main "${CMAKE_SOURCE_DIR}/main.cpp")
endif()

# 为任意目录下的每个cpp文件创建可执行文件（递归搜索）
file(GLOB_RECURSE ALL_CPP_FILES 
    "${CMAKE_SOURCE_DIR}/*.cpp"
)
set(CPP_COUNTER 1)
foreach(CPP_FILE ${ALL_CPP_FILES})
    # 排除build目录中的文件
    string(FIND "${CPP_FILE}" "/build/" BUILD_FOUND)
    
    # 跳过build目录
    if(NOT ${BUILD_FOUND} EQUAL -1)
        continue()
    endif()
    
    # 检查文件是否包含main函数
    file(READ ${CPP_FILE} FILE_CONTENT)
    string(FIND "${FILE_CONTENT}" "int main" MAIN_FOUND)
    
    # 只有包含main函数的文件才构建
    if(NOT ${MAIN_FOUND} EQUAL -1)
        # 创建唯一的目标名称
        get_filename_component(FILE_NAME ${CPP_FILE} NAME_WE)
        set(TARGET_NAME "${FILE_NAME}")
        
        # 获取文件名（不含路径）
        get_filename_component(FILE_NAME_WITH_EXT ${CPP_FILE} NAME)
        
        # 创建一个临时的源文件，使用相对路径
        set(TEMP_CPP_FILE "${CMAKE_BINARY_DIR}/temp_${TARGET_NAME}.cpp")
        file(COPY ${CPP_FILE} DESTINATION ${CMAKE_BINARY_DIR})
        file(RENAME "${CMAKE_BINARY_DIR}/${FILE_NAME_WITH_EXT}" ${TEMP_CPP_FILE})
        
        # 使用临时文件创建可执行文件
        add_executable(${TARGET_NAME} ${TEMP_CPP_FILE})
        
        # 设置对象文件输出目录，避免路径过长
        set_target_properties(${TARGET_NAME} PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
            ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
            RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        )
        
        math(EXPR CPP_COUNTER "${CPP_COUNTER} + 1")
    endif()
endforeach()