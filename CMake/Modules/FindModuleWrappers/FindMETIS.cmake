#[=======================================================================[.rst:
OpenCMISS FindMETIS
-------------------

An OpenCMISS wrapper to find a METIS implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(METIS_FOUND NO)

message(STATUS "hello")

if(OpenCMISS_FIND_SYSTEM_METIS)
  
  OCCMakeMessage(STATUS "Trying to find METIS at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(METIS)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT METIS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find METIS in the OpenCMISS build system...")
  
  find_package(METIS ${METIS_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  if(METIS_FOUND)
    OCCMakeMessage(STATUS "Found METIS (version ${METIS_VERSION}) in the OpenCMISS build system.")
    if(TARGET METIS::METIS)
      get_property(_HAVE_MULTICONFIG_ENV GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
      if(_HAVE_MULTICONFIG_ENV)
	set(METIS_LIBRARIES ${METIS_LIBARAY_$<UPPER_CASE:$<CONFIG>>})
      else()
	string(TOUPPER ${CMAKE_BUILD_TYPE} _UPPER_BUILD_TYPE)
	set(METIS_LIBRARIES ${METIS_LIBRARY_${_UPPER_BUILD_TYPE}})
	unset(_UPPER_BUILD_TYPE)
      endif()
      unset(_HAVE_MULTICONFIG_ENV)
    endif()
  else()
    OCCMakeMessage(STATUS "Could not find METIS.")
  endif()
else()
  OCCMakeMessage(STATUS "Found METIS (version ${METIS_VERSION}) at the system level.")
endif()

if(METIS_FOUND)
  OCCMakeDebug("METIS_LIBRARIES = '${METIS_LIBRARIES}'." 1)    
  OCCMakeDebug("METIS_INCLUDE_DIRECTORIES = '${METIS_INCLUDE_DIRECTORIES}'." 1)    
endif()
