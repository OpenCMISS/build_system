#[=======================================================================[.rst:
OpenCMISS FindFieldML
---------------------

An OpenCMISS wrapper to find a FieldML-API implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(FIELDML_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_FieldML)
  
  OCCMakeMessage(STATUS "Trying to find FieldML-API at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(FieldML)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT FIELDML_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find FieldML-API in the OpenCMISS build system.")
    
endif()
