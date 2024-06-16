#[=======================================================================[.rst:
OpenCMISS FindSuperLU_MT
------------------------

An OpenCMISS wrapper to find a SuperLU_MT implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SuperLU_MT_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SuperLU_MT)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU_MT at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(SuperLU_MT)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT SuperLU_MT_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU_MT in the OpenCMISS build system.")
    
endif()
