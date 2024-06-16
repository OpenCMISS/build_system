#[=======================================================================[.rst:
OpenCMISS FindSZip
------------------

An OpenCMISS wrapper to find a SZip implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SZip_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SZip)
  
  OCCMakeMessage(STATUS "Trying to find SZip at the system level...")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(SZip MODULE QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT SZip_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SZip (version ${SZip_FIND_VERSION}) in the OpenCMISS build system...")
  
  find_package(SZip ${SZip_FIND_VERSION} CONFIG
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

if(SZip_FOUND)
  set(SZip_FOUND ${SZip_FOUND})
  OCCMakeDebug("Found SZip (version ${SZip_VERSION}) at '${SZip_DIR}'." 1)
else()
  OCCMakeDebug("Could not find SZip." 1)
endif()
