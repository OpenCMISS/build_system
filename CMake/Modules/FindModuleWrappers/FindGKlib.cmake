#[=======================================================================[.rst:
OpenCMISS FindGKlib
-------------------

An OpenCMISS wrapper to find a GKlib implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(GKlib_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_GKlib)
  
  OCCMakeMessage(STATUS "Trying to find GKlib at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(GKlib)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT GKlib_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find GKlib in the OpenCMISS build system...")
  
  find_package(GKlib CONFIG QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  
  if(GKlib_FOUND)
    OCCMakeMessage(STATUS "Found GKlib (version ${GKlib_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find GKlib.")
  endif()
else()
  OCCMakeMessage(STATUS "Found GKlib at the system level.")
endif()
