# Copyright 2017 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if("${gRPC_ZLIB_PROVIDER}" STREQUAL "module")
  if(NOT ZLIB_ROOT_DIR)
    set(ZLIB_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/zlib)
  endif()
  if(EXISTS "${ZLIB_ROOT_DIR}/CMakeLists.txt")
    # TODO(jtattermusch): workaround for https://github.com/madler/zlib/issues/218
    include_directories("${ZLIB_ROOT_DIR}")
    add_subdirectory(${ZLIB_ROOT_DIR} third_party/zlib)

    if(TARGET zlibstatic)
      set(_gRPC_ZLIB_LIBRARIES zlibstatic)
      set(_gRPC_ZLIB_INCLUDE_DIR "${ZLIB_ROOT_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/third_party/zlib")
    endif()
  else()
      message(WARNING "gRPC_ZLIB_PROVIDER is \"module\" but ZLIB_ROOT_DIR is wrong")
  endif()
  if(gRPC_INSTALL)
    message(WARNING "gRPC_INSTALL will be forced to FALSE because gRPC_ZLIB_PROVIDER is \"module\"")
    set(gRPC_INSTALL FALSE)
  endif()
elseif("${gRPC_ZLIB_PROVIDER}" STREQUAL "package")
  hunter_add_package(ZLIB)
  find_package(ZLIB CONFIG REQUIRED)
  set(_gRPC_ZLIB_LIBRARIES ZLIB::zlib)
  set(_gRPC_ZLIB_INCLUDE_DIR ${ZLIB_INCLUDE_DIRS})
  set(_gRPC_FIND_ZLIB "if(NOT ZLIB_FOUND)\n  find_package(ZLIB)\nendif()")
endif()
