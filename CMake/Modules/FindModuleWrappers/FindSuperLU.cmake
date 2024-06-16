#[=======================================================================[.rst:
OpenCMISS FindSuperLU
---------------------

An OpenCMISS wrapper to find a SuperLU implementation.

#]=======================================================================]

## See https://github.com/dune-project/dune-istl/blob/master/cmake/modules/FindSuperLU.cmake

## See https://android.googlesource.com/platform/external/eigen/+/master/cmake/FindSuperLU.cmake


include(OCCMakeMiscellaneous)

set(PETSc_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SuperLU)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(SuperLU)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT SuperLU_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU in the OpenCMISS build system.")
    
endif()
