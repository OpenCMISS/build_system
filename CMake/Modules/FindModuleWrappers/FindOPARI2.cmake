#[=======================================================================[.rst:
OpenCMISS FindOPARI2
---------------------

An OpenCMISS wrapper to find a OPARI2 implementation.

#]=======================================================================]

include(OCCMakeMiscFunctions)
include(OCCMakeFindUtilityFunctions)

OCCMakeMessage(STATUS "Trying to find OPARI2...")

if(NOT DEFINED OPARI2_FOUND)
  set(OPARI2_FOUND NO)
endif()

if(OpenCMISS_FIND_SYSTEM_OPARI2)
  
  OCCMakeMessage(STATUS "Trying to find OPARI2 at the system level.")
  
  OCCMakeClearModulePath()

  find_package(OPARI2)

  OCCMakeRestoreModulePath()

endif()

if(NOT OPARI2_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU in the OPARI2 build system.")
    
endif()
