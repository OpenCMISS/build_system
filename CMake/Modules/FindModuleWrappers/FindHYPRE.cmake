#[=======================================================================[.rst:
OpenCMISS FindHYPRE
-------------------

An OpenCMISS wrapper to find a HYPRE implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

OCCMakeMessage(STATUS "Trying to find HYPRE...")

if(OpenCMISS_FIND_SYSTEM_HYPRE)
  
  OCCMakeMessage(STATUS "Trying to find HYPRE at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(HYPRE)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT HYPRE_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find HYPRE in the OpenCMISS build system.")
    
endif()

