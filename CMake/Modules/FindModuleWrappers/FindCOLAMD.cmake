#[=======================================================================[.rst:
OpenCMISS FindCOLAMD
-------------------------

An OpenCMISS wrapper to find a COLAMD implementation.

#]=======================================================================]

## SEE https://ceres-solver.googlesource.com/ceres-solver/+/master/cmake/FindCOLAMD.cmake

## SEE https://github.com/sergiud/COLAMD


include(OCCMakeMiscellaneous)

set(COLAMD_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SUITESPARSE)
  
  OCCMakeMessage(STATUS "Trying to find COLAMD at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

 
  find_package(COLAMD)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT COLAMD_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find COLAMD in the OpenCMISS build system.")
    
  find_package(COLAMD ${COLAMD_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )

  if(COLAMD_FOUND)
    OCCMakeMessage(STATUS "Found COLAMD (version ${COLAMD_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find COLAMD.")
  endif()
else()
  OCCMakeMessage(STATUS "Found COLAMD (version ${COLAMD_VERSION}) at the system level.")
endif()
