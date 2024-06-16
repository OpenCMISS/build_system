#[=======================================================================[.rst:
OpenCMISS FindBZip2
-------------------

An OpenCMISS wrapper to find a BZip2 implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

OCCMakeMessage(STATUS "Trying to find BZip2...")

set(BZIP2_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_BZip2)
  
  OCCMakeMessage(STATUS "Trying to find BZip2 at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(BZip2)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT BZIP2_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find BZip2 in the OpenCMISS build system.")
    
endif()
