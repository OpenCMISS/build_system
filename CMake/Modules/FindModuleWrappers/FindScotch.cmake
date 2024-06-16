#[=======================================================================[.rst:
OpenCMISS FindScotch
--------------------

An OpenCMISS wrapper to find a Scotch implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(Scotch_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_Scotch)
  
  OCCMakeMessage(STATUS "Trying to find Scotch at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(Scotch)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT Scotch_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find Scotch in the OpenCMISS build system.")
    
endif()
