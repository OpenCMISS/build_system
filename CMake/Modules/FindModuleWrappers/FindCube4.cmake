#[=======================================================================[.rst:
OpenCMISS FindCube4
-------------------

An OpenCMISS wrapper to find a Cube4 implementation.

#]=======================================================================]

include(OCCMakeMiscFunctions)

set(CUBE4_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_CUBE4)
  
  OCCMakeMessage(STATUS "Trying to find Cube-4 at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(Cube4)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT CUBE4_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find Cube-4 in the OpenCMISS build system.")
    
endif()
