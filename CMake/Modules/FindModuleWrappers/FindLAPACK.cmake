#[=======================================================================[.rst:
OpenCMISS FindLAPACK
--------------------

An OpenCMISS wrapper to find a Linear Algebra PACKage (LAPACK)
implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(LAPACK_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_LAPACK)
  
  OCCMakeMessage(STATUS "Trying to find LAPACK at the system level...")
   
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(LAPACK MODULE QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT LAPACK_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find LAPACK in the OpenCMISS build system...")
    
  find_package(LAPACK CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )

  if(TARGET lapack)
    OCCMakeDebug("Found target lapack in LAPACK configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(lapack LAPACK
      IMPORTED_LOCATIONS
      INTERFACE_LINK_LIBRARIES
    )
    if(NOT TARGET LAPACK::LAPACK)
      add_library(LAPACK::LAPACK ALIAS lapack)
    endif()
    set(LAPACK_FOUND ON)
  endif()
  
  if(LAPACK_FOUND)
    OCCMakeMessage(STATUS "Found LAPACK (version ${LAPACK_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find LAPACK.")
  endif()
else()
  OCCMakeMessage(STATUS "Found LAPACK (version ${LAPACK_VERSION}) at the system level.")
endif()

if(LAPACK_FOUND)
  OCCMakeDebug("LAPACK_INCLUDE_DIRS = '${LAPACK_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("LAPACK_LIBRARIES = '${LAPACK_LIBRARIES}'." 2)    
endif()
  
