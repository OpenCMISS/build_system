#[=======================================================================[.rst:
OpenCMISS FindSUNDIALS
----------------------

An OpenCMISS wrapper to find a SUNDIALS implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SUNDIALS_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SUNDIALS)
  
  OCCMakeMessage(STATUS "Trying to find SUNDIALS at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(SUNDIALS)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT SUNDIALS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SUNDIALS in the OpenCMISS build system.")
    
endif()
