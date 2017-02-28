#[=======================================================================[.rst:
FindJsonCpp
-----------

Find JsonCpp includes and library. If JsonCpp was built with the
``JSONCPP_WITH_CMAKE_PACKAGE`` option enabled, generating a config file,
it is used preferentially.

Imported Targets
^^^^^^^^^^^^^^^^

An :ref:`imported target <Imported targets>` named
``JsonCpp::JsonCpp`` is provided if JsonCpp has been found.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

``JsonCpp_FOUND``
  True if JsonCpp was found, false otherwise.
``JsonCpp_INCLUDE_DIRS``
  Include directories needed to include JsonCpp headers.
``JsonCpp_LIBRARIES``
  Libraries needed to link to JsonCpp.
``JsonCpp_VERSION_STRING``
  The version of JsonCpp found.
  May not be set for JsonCpp versions prior to 1.0.
``JsonCpp_VERSION_MAJOR``
  The major version of JsonCpp.
``JsonCpp_VERSION_MINOR``
  The minor version of JsonCpp.
``JsonCpp_VERSION_PATCH``
  The patch version of JsonCpp.

Cache Variables
^^^^^^^^^^^^^^^

This module uses the following cache variables:

``JsonCpp_LIBRARY``
  The location of the JsonCpp library file.
``JsonCpp_INCLUDE_DIR``
  The location of the JsonCpp include directory containing ``json/json.h``.

The cache variables should not be used by project code.
They may not be set (or may be set to ``...-NOTFOUND``) if the config
file method was used successfully to find the library.
They may be set by end users to point at JsonCpp components.
#]=======================================================================]

#=============================================================================
# Copyright 2014-2015 Kitware, Inc.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# 
# * Neither the names of Kitware, Inc., the Insight Software Consortium,
#   nor the names of their contributors may be used to endorse or promote
#   products derived from this software without specific prior written
#   permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

#-----------------------------------------------------------------------------

find_package(jsoncpp QUIET CONFIG)
if(TARGET jsoncpp_lib)
  get_target_property(JsonCpp_INCLUDE_DIR jsoncpp_lib INTERFACE_INCLUDE_DIRECTORIES)
  set(JsonCpp_LIBRARY jsoncpp_lib)
else()
  find_library(JsonCpp_LIBRARY
    NAMES jsoncpp
    )
  mark_as_advanced(JsonCpp_LIBRARY)

  find_path(JsonCpp_INCLUDE_DIR
    NAMES json/json.h
    PATH_SUFFIXES jsoncpp
    )
  mark_as_advanced(JsonCpp_INCLUDE_DIR)
endif()

#-----------------------------------------------------------------------------
# Extract version number if possible.
set(_JsonCpp_H_REGEX "^#[ \t]*define[ \t]+JSONCPP_VERSION_STRING[ \t]+\"(([0-9]+)\\.([0-9]+)\\.([0-9]+)[^\"]*)\".*$")
if(JsonCpp_INCLUDE_DIR AND EXISTS "${JsonCpp_INCLUDE_DIR}/json/version.h")
  file(STRINGS "${JsonCpp_INCLUDE_DIR}/json/version.h" _JsonCpp_H REGEX "${_JsonCpp_H_REGEX}")
else()
  set(_JsonCpp_H "")
endif()
if(_JsonCpp_H MATCHES "${_JsonCpp_H_REGEX}")
  set(JsonCpp_VERSION_STRING "${CMAKE_MATCH_1}")
  set(JsonCpp_VERSION_MAJOR "${CMAKE_MATCH_2}")
  set(JsonCpp_VERSION_MINOR "${CMAKE_MATCH_3}")
  set(JsonCpp_VERSION_PATCH "${CMAKE_MATCH_4}")
else()
  set(JsonCpp_VERSION_STRING "")
  set(JsonCpp_VERSION_MAJOR "")
  set(JsonCpp_VERSION_MINOR "")
  set(JsonCpp_VERSION_PATCH "")
endif()
unset(_JsonCpp_H_REGEX)
unset(_JsonCpp_H)

#-----------------------------------------------------------------------------
include(FindPackageHandleStandardArgs)

if(TARGET jsoncpp_lib)
  FIND_PACKAGE_HANDLE_STANDARD_ARGS(JsonCpp
    FOUND_VAR JsonCpp_FOUND
    REQUIRED_VARS JsonCpp_INCLUDE_DIR
    VERSION_VAR JsonCpp_VERSION_STRING
    )
else()
  FIND_PACKAGE_HANDLE_STANDARD_ARGS(JsonCpp
    FOUND_VAR JsonCpp_FOUND
    REQUIRED_VARS JsonCpp_LIBRARY JsonCpp_INCLUDE_DIR
    VERSION_VAR JsonCpp_VERSION_STRING
    )
endif()
set(JSONCPP_FOUND ${JsonCpp_FOUND})

#-----------------------------------------------------------------------------
# Provide documented result variables and targets.
if(JsonCpp_FOUND)
  set(JsonCpp_INCLUDE_DIRS ${JsonCpp_INCLUDE_DIR})
  set(JsonCpp_LIBRARIES ${JsonCpp_LIBRARY})
  if(NOT TARGET JsonCpp::JsonCpp)
    if(TARGET jsoncpp_lib)
      add_library(JsonCpp::JsonCpp UNKNOWN IMPORTED)
      set_target_properties(JsonCpp::JsonCpp PROPERTIES
        INTERFACE_LINK_LIBRARIES "jsoncpp_lib")
    else()
      add_library(JsonCpp::JsonCpp UNKNOWN IMPORTED)
      set_target_properties(JsonCpp::JsonCpp PROPERTIES
        IMPORTED_LOCATION "${JsonCpp_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${JsonCpp_INCLUDE_DIRS}"
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        )
    endif()
  endif()
endif()
