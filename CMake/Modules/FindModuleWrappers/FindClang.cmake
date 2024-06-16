#[=======================================================================[.rst:
OpenCMISS FindClang
-------------------

An OpenCMISS wrapper to find a Clang implementation.

#]=======================================================================]

include(OCCMakeMiscFunctions)

set(CLANG_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_CLANG)
  
  OCCMakeMessage(STATUS "Trying to find Clang at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(Clang)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT CLANG_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find Clang in the OpenCMISS build system.")
    
endif()
