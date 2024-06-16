#[=======================================================================[.rst:
OpenCMISS FindCSim
------------------

An OpenCMISS wrapper to find a CSim implementation.

#]=======================================================================]

include(OCCMakeMiscFunctions)

set(CSIM_FOUND NO)

if(OpenCMIS_FIND_SYSTEM_CSIM)
  
  OCCMakeMessage(STATUS "Trying to find CSim at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(CSim)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT CSIM_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find CSim in the OpenCMISS build system.")
    
endif()

