#[=======================================================================[.rst:
OpenCMISS build types
---------------------

The build types for OpenCMISS are defined using the
:var:OpenCMISS_BUILD_TYPE variable. The build configurations for
OpenCMISS dependencies are defined using the
:var:OpenCMISS_DEPENDENCIES_BUILD_TYPE variable.

The build configurations can be specified when cmake is invoked using
a definition e.g.,

.. code-block:: console

$ cmake -DOpenCMISS_BUILD_TYPE=<build-configuration-type>

where the build configuration types are:
        
:Debug: Debug build type.
:Release: Release (optimised) build type.
:RelWithDebInfo: Release (optimised) build type with debug information.
:MinRelSize: Minimised release size build type.

If the build type variables are defined then the value of an
environment variable, if it exists, is used. If no variables are
specified the build types default to :Release:.

#]=======================================================================]

set(OC_BUILD_TYPE_DEBUG OFF)
set(OC_BUILD_TYPE_RELEASE OFF)
set(OC_BUILD_TYPE_RELWITHDEBINFO OFF)
set(OC_BUILD_TYPE_MINRELSIZE OFF)
if(DEFINED OpenCMISS_BUILD_TYPE)
  string(TOLOWER "${OpenCMISS_BUILD_TYPE}" _LOWERCASE_BUILD_TYPE)
else()
  if(DEFINED OC_BUILD_TYPE)
    string(TOLOWER "${OC_BUILD_TYPE}" _LOWERCASE_BUILD_TYPE)
  else()
    if(DEFINED ENV{OpenCMISS_BUILD_TYPE})
      string(TOLOWER "$ENV{OpenCMISS_BUILD_TYPE}" _LOWERCASE_BUILD_TYPE)
    else()
      if(DEFINED CMAKE_BUILD_TYPE)
	if(NOT CMAKE_BUILD_TYPE STREQUAL "")
          string(TOLOWER "${CMAKE_BUILD_TYPE}" _LOWERCASE_BUILD_TYPE)
	else()
	  set(_LOWERCASE_BUILD_TYPE "release")
	endif()
      else()
	set(_LOWERCASE_BUILD_TYPE "release")
      endif()
    endif()
  endif()
endif()

if(_LOWERCASE_BUILD_TYPE STREQUAL "debug")
  set(OC_BUILD_TYPE "Debug" CACHE STRING "OpenCMISS build type" FORCE)
  set(OC_BUILD_TYPE_DEBUG ON)
elseif(_LOWERCASE_BUILD_TYPE STREQUAL "release")
  set(OC_BUILD_TYPE "Release" CACHE STRING "OpenCMISS build type" FORCE)
  set(OC_BUILD_TYPE_RELEASE ON)
elseif(_LOWERCASE_BUILD_TYPE STREQUAL "relwithdebinfo")
  set(OC_BUILD_TYPE "RelWithDebInfo" CACHE STRING "OpenCMISS build type" FORCE)
  set(OC_BUILD_TYPE_RELWITHDEBINFO ON)
elseif(_LOWERCASE_BUILD_TYPE STREQUAL "minrelsize")
  set(OC_BUILD_TYPE "MinRelSize" CACHE STRING "OpenCMISS build type" FORCE)
  set(OC_BUILD_TYPE_MINRELSIZE ON PARENT_SCOPE)
else()
  set(OC_BUILD_TYPE "Release" CACHE STRING "OpenCMISS build type" FORCE)
  set(OC_BUILD_TYPE_RELEASE ON)
  OCCMakeWarning("The build type of '${_LOWERCASE_BUILD_TYPE}' is unknown. Defaulting to release.")
endif()

set(OC_DEPENDENCIES_BUILD_TYPE_DEBUG OFF)
set(OC_DEPENDENCIES_BUILD_TYPE_RELEASE OFF)
set(OC_DEPENDENCIES_BUILD_TYPE_RELWITHDEBINFO OFF)
set(OC_DEPENDENCIES_BUILD_TYPE_MINRELSIZE OFF)
if(DEFINED OpenCMISS_DEPENDENCIES_BUILD_TYPE)
  string(TOLOWER "${OpenCMISS_DEPENDENCIES_BUILD_TYPE}" _LOWERCASE_DEPENDENCIES_BUILD_TYPE)
else()
  if(DEFINED OC_DEPENDENCIES_BUILD_TYPE)
    string(TOLOWER "${OC_DEPENDENCIES_BUILD_TYPE}" _LOWERCASE_DEPENDENCIES_BUILD_TYPE)
  else()
    if(DEFINED ENV{OpenCMISS_DEPENDENCIES_BUILD_TYPE})
      string(TOLOWER "$ENV{OpenCMISS_DEPENDENCIES_BUILD_TYPE}" _LOWERCASE_DEPENDENCIES_BUILD_TYPE)
    else()
      if(DEFINED CMAKE_BUILD_TYPE)
	if(NOT CMAKE_BUILD_TYPE STREQUAL "")
          string(TOLOWER "${CMAKE_BUILD_TYPE}" _LOWERCASE_DEPENDENCIES_BUILD_TYPE)
	else()
	  set(_LOWERCASE_DEPENDENCIES_BUILD_TYPE "${_LOWERCASE_BUILD_TYPE}")
	endif()
      else()
	set(_LOWERCASE_DEPENDENCIES_BUILD_TYPE "${_LOWERCASE_BUILD_TYPE}")
      endif()
    endif()
  endif()
endif()

if(_LOWERCASE_DEPENDENCIES_BUILD_TYPE STREQUAL "debug")
  set(OC_DEPENDENCIES_BUILD_TYPE "Debug" CACHE STRING "OpenCMISS dependencies build type" FORCE)
  set(OC_DEPENDENCIES_BUILD_TYPE_DEBUG ON)
elseif(_LOWERCASE_DEPENDENCIES_BUILD_TYPE STREQUAL "release")
  set(OC_DEPENDENCIES_BUILD_TYPE "Release" CACHE STRING "OpenCMISS dependencies build type" FORCE)
  set(OC_DEPENDENCIES_BUILD_TYPE_RELEASE ON)
elseif(_LOWERCASE_DEPENDENCIES_BUILD_TYPE STREQUAL "relwithdebinfo")
  set(OC_DEPENDENCIES_BUILD_TYPE "RelWithDebInfo" CACHE STRING "OpenCMISS dependencies build type" FORCE)
  set(OC_DEPENDENCIES_BUILD_TYPE_RELWITHDEBINFO ON)
elseif(_LOWERCASE_DEPENDENCIES_BUILD_TYPE STREQUAL "minrelsize")
  set(OC_DEPENDENCIES_BUILD_TYPE "MinRelSize" CACHE STRING "OpenCMISS dependencies build type" FORCE)
  set(OC_DEPENDENCIES_BUILD_TYPE_MINRELSIZE ON PARENT_SCOPE)
else()
  set(OC_DEPENDENCIES_BUILD_TYPE "Release" CACHE STRING "OpenCMISS dependencies build type" FORCE)
  set(OC_DEPENDENCIES_BUILD_TYPE_RELEASE ON)
  OCCMakeWarning("The dependencies build type of '${_LOWERCASE_DEPENDENCIES_BUILD_TYPE}' is unknown. Defaulting to release.")
endif()

set(CMAKE_BUILD_TYPE ${OC_BUILD_TYPE} CACHE STRING "CMake build type" FORCE)
OCCMakeDebug("Using a build type of '${OC_BUILD_TYPE}'." 1)
OCCMakeDebug("Using a dependencies build type of '${OC_DEPENDENCIES_BUILD_TYPE}'." 1)

unset(_LOWERCASE_BUILD_TYPE)
unset(_LOWERCASE_DEPENDENCIES_BUILD_TYPE)
 
