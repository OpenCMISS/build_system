#[=======================================================================[.rst:
OpenCMISS FindLibXml2
---------------------

An OpenCMISS wrapper to find a LibXml2 implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(LibXml2_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_LibXml2)
  
  OCCMakeMessage(STATUS "Trying to find LibXml2 at the system level...")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(LibXml2 MODULE QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT LIBXML2_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find LibXml2 in the OpenCMISS build system...")
    
  find_package(LibXml2 ${LibXml2_FIND_VERSION} CONFIG
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

if(LibXml2_FOUND)
  set(LibXml2_FOUND ${LibXml2_FOUND})
  OCCMakeDebug("Found LibXml2 (version ${LIBXML2_VERSION_STRING})." 1)
else()
  OCCMakeDebug("Could not find LibXml2." 1)
endif()
