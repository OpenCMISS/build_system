#[=======================================================================[.rst:
OpenCMISS FindLLVM
------------------

An OpenCMISS wrapper to find a LLVM implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(LAPACK_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_LLVM)
  
  OCCMakeMessage(STATUS "Trying to find LLVM at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(LLVM)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT LLVML_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find LLVM in the OpenCMISS build system.")
    
endif()
