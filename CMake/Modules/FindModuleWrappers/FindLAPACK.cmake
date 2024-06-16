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

  # TODO: This should be done in the lapack config file. Remove when this is put in there.
  if(TARGET lapack)
    OCCMakeDebug("Target LAPACK found in the LAPACK configuration." 1)
    get_target_property(LAPACK_IMPORTED_CONFIGURATIONS lapack IMPORTED_CONFIGURATIONS)
    foreach(config ${LAPACK_IMPORTED_CONFIGURATIONS})
      get_target_property(LAPACK_LIBRARY_${config} lapack IMPORTED_LOCATION_${config})
    endforeach()
    add_library(LAPACK::LAPACK ALIAS lapack)
    get_property(_HAVE_MULTICONFIG_ENV GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
    if(_HAVE_MULTICONFIG_ENV)
      set(LAPACK_LIBRARIES ${BLAS_LIBRARY_$<UPPER_CASE:$<CONFIG>>})
    else()
      string(TOUPPER ${CMAKE_BUILD_TYPE} _UPPER_BUILD_TYPE)
      set(LAPACK_LIBRARIES ${LAPACK_LIBRARY_${_UPPER_BUILD_TYPE}})
      unset(_UPPER_BUILD_TYPE)
    endif()
    set(LAPACK_FOUND ON)
    unset(_HAVE_MULTICONFIG_ENV)
    OCCMakeDebug("LAPACK_LIBRARIES = '${LAPACK_LIBRARIES}'." 1)
    OCCMakeMessage(STATUS "Found LAPACK (version ${LAPACK_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find LAPACK.")
  endif()
else()
  OCCMakeMessage(STATUS "Found LAPACK (version ${LAPACK_VERSION}) at the system level.")
endif()
