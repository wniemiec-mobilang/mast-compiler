cmake_minimum_required(VERSION 2.6)

# Set up Google testing framework
include(FetchContent)
FetchContent_Declare(
        googletest
        URL https://github.com/google/googletest/archive/609281088cfefc76f9d0ce82e1ff6c30cc3591e5.zip
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)
include_directories(${GTEST_INCLUDE_DIRS})

# Link runTests with what we want to test and the GTest and pthread library
file(GLOB object_files
        "../../../src/main/cpp/wniemiec/mobilex/mast/*.o"
        "../../../src/main/cpp/wniemiec/mobilex/mast/data*.o"
        "../../../src/main/cpp/wniemiec/mobilex/mast/export*.o"
        "../../../src/main/cpp/wniemiec/mobilex/mast/syntax*.o"
        "../../../src/main/cpp/wniemiec/mobilex/mast/semantic*.o"
        "../../../src/main/cpp/wniemiec/mobilex/mast/util*.o"
)
list(FILTER object_files EXCLUDE REGEX ".*main.o.*$")
list(FILTER object_files EXCLUDE REGEX ".*lex.yy.o.*$")
list(FILTER object_files EXCLUDE REGEX ".*parser.tab.o.*$")
file(GLOB test_files
        "wniemiec/mobilex/mast/*.cpp"
        "wniemiec/mobilex/mast/export/*.cpp"
)
add_executable(runTests ${test_files})
target_link_libraries(runTests gtest_main pthread ${object_files})
ADD_CUSTOM_TARGET(clean-all
	COMMAND rm -rf CMakeFiles; 
            rm -rf CMakeCache.txt; 
            rm -rf cmake_install.cmake; 
            rm -rf bin; 
            rm -rf Makefile;
            rm -rf lib;
            rm -rf _deps;
            rm -rf runTests;
)