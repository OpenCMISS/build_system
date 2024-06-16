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
    
  set(CMAKE_FIND_DEBUG_MODE TRUE)
  
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
  
  set(CMAKE_FIND_DEBUG_MODE FALSE)
  
  if(TARGET blas)
    OCCMakeDebug("Target BLAS found in LAPACK configuration." 1)
    get_target_property(BLAS_IMPORTED_CONFIGURATIONS blas IMPORTED_CONFIGURATIONS)
    foreach(config ${BLAS_IMPORTED_CONFIGURATIONS})
      get_target_property(BLAS_LIBRARY_${config} blas IMPORTED_LOCATION_${config})
    endforeach()
    add_library(BLAS::BLAS ALIAS blas)
    get_property(_HAVE_MULTICONFIG_ENV GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
    if(_HAVE_MULTICONFIG_ENV)
      set(BLAS_LIBRARIES ${BLAS_LIBARAY_$<UPPER_CASE:$<CONFIG>>})
    else()
      string(TOUPPER ${CMAKE_BUILD_TYPE} _UPPER_BUILD_TYPE)
      set(BLAS_LIBRARIES ${BLAS_LIBRARY_${_UPPER_BUILD_TYPE}})
      unset(_UPPER_BUILD_TYPE)
    endif()
    set(BLAS_FOUND ON)
    unset(_HAVE_MULTICONFIG_ENV)
    OCCMakeDebug("BLAS_LIBRARIES = '${BLAS_LIBRARIES}'." 1)      
  endif()
  
  if(BLAS_FOUND)
    OCCMakeMessage(STATUS "Found BLAS (version ${LAPACK_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find BLAS.")
  endif()
else()
  OCCMakeMessage(STATUS "Found BLAS (version ${BLAS_VERSION}) at the system level.")
endif()
