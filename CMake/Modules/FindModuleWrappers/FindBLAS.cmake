#[=======================================================================[.rst:
OpenCMISS FindBLAS
------------------

An OpenCMISS wrapper to find a Basic Linear Algebra Subroutines (BLAS)
implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(BLAS_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_BLAS)
  
  OCCMakeMessage(STATUS "Trying to find BLAS at the system level...")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(BLAS MODULE QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT BLAS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find BLAS in the OpenCMISS build system...")
    
  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
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
  
  #set(CMAKE_FIND_DEBUG_MODE FALSE)
  
  if(TARGET blas)
    OCCMakeDebug(STATUS "Found target blas in LAPACK configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(blas BLAS
      IMPORTED_LOCATIONS
      INTERFACE_LINK_LIBRARIES
    )
    if(NOT TARGET BLAS::BLAS)
      add_library(BLAS::BLAS ALIAS blas)
    endif()
    set(BLAS_FOUND ON)
  endif()
  
  if(BLAS_FOUND)
    OCCMakeMessage(STATUS "Found BLAS (version ${LAPACK_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find BLAS.")
  endif()
else()
  OCCMakeMessage(STATUS "Found BLAS (version ${BLAS_VERSION}) at the system level.")
endif()

if(BLAS_FOUND)
  OCCMakeDebug("BLAS_INCLUDE_DIRS = '${BLAS_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("BLAS_LIBRARIES = '${BLAS_LIBRARIES}'." 2)    
endif()
