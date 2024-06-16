#[=======================================================================[.rst:
OpenCMISS FindlibCellML
---------------------

An OpenCMISS wrapper to find a libCellML implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(libCellML_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_libCellML)
  
  OCCMakeMessage(STATUS "Trying to find libCellML at the system level...")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(libCellML MODULE QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT LIBXML2_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find libCellML in the OpenCMISS build system...")
    
  find_package(libCellML ${libCellML_FIND_VERSION} CONFIG
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

if(libCellML_FOUND)
  set(libCellML_FOUND ${libCellML_FOUND})
  OCCMakeDebug("Found libCellML (version ${LIBCELLML_VERSION_STRING})." 1)
else()
  OCCMakeDebug("Could not find libCellML." 1)
endif()
