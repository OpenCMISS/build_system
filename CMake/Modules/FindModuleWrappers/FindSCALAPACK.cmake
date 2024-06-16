#[=======================================================================[.rst:
OpenCMISS FindSCALAPACK
--------------------

An OpenCMISS wrapper to find a Scalable Linear Algebra PACKage (ScaLAPACK)
implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SCALAPACK_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SCALAPACK)
  
  OCCMakeMessage(STATUS "Trying to find SCALAPACK at the system level...")
   
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(SCALAPACK MODULE QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT SCALAPACK_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SCALAPACK in the OpenCMISS build system...")
    
  find_package(SCALAPACK CONFIG
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

if(SCALAPACK_FOUND)
  set(SCALAPACK_FOUND ${SCALAPACK_FOUND})
  OCCMakeDebug("Found SCALAPACK." 1)
else()
  OCCMakeDebug("Could not find SCALAPACK." 1)
endif()
