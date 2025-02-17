#[=======================================================================[.rst:
OpenCMISS FindZLIB
------------------

An OpenCMISS wrapper to find a ZLIB implementation. Based on original FindZLIB.cmake.

# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

FindZLIB
--------
ind the native ZLIB includes and library.

IMPORTED Targets
^^^^^^^^^^^^^^^^

.. versionadded:: 3.1

This module defines :prop_tgt:`IMPORTED` target ``ZLIB::ZLIB``, if
ZLIB has been found.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

``ZLIB_INCLUDE_DIRS``
  where to find zlib.h, etc.
``ZLIB_LIBRARIES``
  List of libraries when using zlib.
``ZLIB_FOUND``
  True if zlib found.
``ZLIB_VERSION``
  .. versionadded:: 3.26
    the version of Zlib found.

  See also legacy variable ``ZLIB_VERSION_STRING``.

.. versionadded:: 3.4
  Debug and Release variants are found separately.

Legacy Variables
^^^^^^^^^^^^^^^^

The following variables are provided for backward compatibility:

``ZLIB_VERSION_MAJOR``
  The major version of zlib.

  .. versionchanged:: 3.26
    Superseded by ``ZLIB_VERSION``.
``ZLIB_VERSION_MINOR``
  The minor version of zlib.

  .. versionchanged:: 3.26
    Superseded by ``ZLIB_VERSION``.
``ZLIB_VERSION_PATCH``
  The patch version of zlib.

  .. versionchanged:: 3.26
    Superseded by ``ZLIB_VERSION``.
``ZLIB_VERSION_TWEAK``
  The tweak version of zlib.

  .. versionchanged:: 3.26
    Superseded by ``ZLIB_VERSION``.
``ZLIB_VERSION_STRING``
  The version of zlib found (x.y.z)

  .. versionchanged:: 3.26
    Superseded by ``ZLIB_VERSION``.
``ZLIB_MAJOR_VERSION``
  The major version of zlib.  Superseded by ``ZLIB_VERSION_MAJOR``.
``ZLIB_MINOR_VERSION``
  The minor version of zlib.  Superseded by ``ZLIB_VERSION_MINOR``.
``ZLIB_PATCH_VERSION``
  The patch version of zlib.  Superseded by ``ZLIB_VERSION_PATCH``.

Hints
^^^^^

A user may set ``ZLIB_ROOT`` to a zlib installation root to tell this
module where to look.

.. versionadded:: 3.24
  Set ``ZLIB_USE_STATIC_LIBS`` to ``ON`` to look for static libraries.
  Default is ``OFF``.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(ZLIB_FOUND NO)
				     
if(OpenCMISS_FIND_SYSTEM_ZLIB)

  OCCMakeMessage(STATUS "Trying to find ZLIB at the system level...")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(ZLIB ${ZLIB_FIND_VERSION} QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT ZLIB_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find ZLIB in the OpenCMISS build system...")

  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
  find_package(ZLIB ${ZLIB_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  #set(CMAKE_FIND_DEBUG_MODE FALSE)
  
  if(TARGET ZLIB::ZLIB)
    OCCMakeDebug("Found target ZLIB::ZLIB in ZLIB configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(ZLIB::ZLIB ZLIB
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_LINK_LIBRARIES
    )
    set(ZLIB_FOUND ON)
  endif()
  
  if(ZLIB_FOUND)
    OCCMakeMessage(STATUS "Found ZLIB (version ${ZLIB_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find ZLIB.")
  endif()
else()
  OCCMakeMessage(STATUS "Found ZLIB (version ${ZLIB_VERSION}) at the system level.")
endif()

if(ZLIB_FOUND)
  OCCMakeDebug("ZLIB_INCLUDE_DIRS = '${ZLIB_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("ZLIB_LIBRARIES = '${ZLIB_LIBRARIES}'." 2)    
endif()
