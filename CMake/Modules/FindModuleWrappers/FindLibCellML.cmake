#[=======================================================================[.rst:
OpenCMISS FindLibCellML
-----------------------

An OpenCMISS wrapper to find a LibCellML implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(libCellML_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_libCellML)
   
  OCCMakeMessage(STATUS "Trying to find libCellML at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(LibCellML)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT libCellML_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find libCellML in the OpenCMISS build system.")
    
endif()
