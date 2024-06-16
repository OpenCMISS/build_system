#[=======================================================================[.rst:
OpenCMISS FindCellML
---------------------

An OpenCMISS wrapper to find a CellML-API implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(CELLMLAPI_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_CELLMLAPI)
  
  OCCMakeMessage(STATUS "Trying to find CellML-API at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(CellML)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT CELLMLAPI_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find CellML-API in the OpenCMISS build system.")
    
endif()
