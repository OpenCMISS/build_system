#[=======================================================================[.rst:
OpenCMISS FindSuperLU_DIST
--------------------------

An OpenCMISS wrapper to find a SuperLU_DIST implementation.

#]=======================================================================]


include(OCCMakeMiscellaneous)

set(SuperLU_DIST_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SuperLU_DIST)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU_DIST at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(SuperLU_DIST)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT SuperLU_DIST_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU_DIST in the OpenCMISS build system.")
    
endif()
