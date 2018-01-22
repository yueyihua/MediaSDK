# Copyright (c) 2018 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

find_path( GTEST_INCLUDE gtest/gtest.h PATHS $ENV{GTEST_PATH}/include )
find_library( GTEST_LIBRARY gtest PATHS $ENV{GTEST_PATH}/lib )
find_library( GTEST_MAIN_LIBRARY gtest_main PATHS $ENV{GTEST_PATH}/lib )

if(GTEST_INCLUDE MATCHES NOTFOUND)
    if(GTEST_LIBRARY MATCHES NOTFOUND AND
        GTEST_MAIN_LIBRARY MATCHES NOTFOUND)

        message( STATUS "Google tests libraries and headers were not found! Download from GitHub" )

        include(ExternalProject)

        ExternalProject_Add(
            googletest
            GIT_REPOSITORY https://github.com/google/googletest.git
            GIT_TAG "release-1.8.0"
            PREFIX "googletest-1.8.0"
            UPDATE_COMMAND ""
            INSTALL_COMMAND ""
            LOG_DOWNLOAD ON
            LOG_CONFIGURE ON
            LOG_BUILD ON
        )

        ExternalProject_Get_Property(googletest source_dir)
        set(GTEST_INCLUDE ${source_dir}/googletest/include)

        ExternalProject_Get_Property(googletest binary_dir)
        set(GTEST_LIB_DIR ${binary_dir}/googlemock/gtest/${CMAKE_FIND_LIBRARY_PREFIXES}gtest.a)
        message( STATUS "Gtest library ${GTEST_LIB_DIR}" )
        set(GTEST_LIBRARY gtest)
        add_library(${GTEST_LIBRARY} STATIC IMPORTED)
        add_dependencies(${GTEST_LIBRARY} googletest)

        set(GTEST_MAIN_LIB_DIR ${binary_dir}/googlemock/gtest/${CMAKE_FIND_LIBRARY_PREFIXES}gtest_main.a)
        message( STATUS "Gtest library ${GTEST_MAIN_LIB_DIR}" )
        set(GTEST_MAIN_LIBRARY gtest_main)
        add_library(${GTEST_MAIN_LIBRARY} STATIC IMPORTED)
        add_dependencies(${GTEST_MAIN_LIBRARY} googletest)
    endif()
endif()

get_filename_component(GTEST_LIB_DIR ${GTEST_LIB_DIR} PATH)
get_filename_component(GTEST_MAIN_LIB_DIR ${GTEST_MAIN_LIB_DIR} PATH)

include_directories( "${GTEST_INCLUDE}" )
link_directories( "${GTEST_LIB_DIR}" "${GTEST_MAIN_LIB_DIR}" )

message( STATUS "Google tests libraries were found in ${GTEST_LIB_DIR}" )
message( STATUS "Google tests headers were found in ${GTEST_INCLUDE}" )
