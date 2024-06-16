#[=======================================================================[.rst:
OpenCMISS FindHDF5
-------------------

An OpenCMISS wrapper to find a HDF5 implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(HDF5_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_HDF5)
  
  OCCMakeMessage(STATUS "Trying to find HDF5 at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(HDF5 MODULE QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT HDF5_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find HDF5 in the OpenCMISS build system.")
    
  find_package(HDF5 ${HDF5_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
endif()

if(HDF5_FOUND)
  set(HDF5_FOUND ${HDF5_FOUND})
  OCCMakeDebug("Found HDF5 (version ${HDF5_VERSION_STRING})." 1)
else()
  OCCMakeDebug("Could not find HDF5." 1)
endif()
