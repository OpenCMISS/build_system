#[=======================================================================[.rst:
OpenCMISS FindScalasca
----------------------

An OpenCMISS wrapper to find a Scalasca implementation.

#]=======================================================================]

include(OCCMakeMiscFunctions)
include(OCCMakeFindUtilityFunctions)

OCCMakeMessage(STATUS "Trying to find Scalasca...")

if(NOT DEFINED SCALASCA_FOUND)
  set(SCALASCA_FOUND NO)
endif()

if(OpenCMISS_FIND_SYSTEM_SCALASCA)
  
  OCCMakeMessage(STATUS "Trying to find Scalasca at the system level.")
  
  OCCMakeClearModulePath()

  find_package(Scalasca)

  OCCMakeRestoreModulePath()

endif()

if(NOT SCALASCA_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find Scalasca in the OpenCMISS build system.")
    
endif()
