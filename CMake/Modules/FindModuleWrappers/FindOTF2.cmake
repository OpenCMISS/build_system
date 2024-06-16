#[=======================================================================[.rst:
OpenCMISS FindOTF2
---------------------

An OpenCMISS wrapper to find a OTF2 implementation.

#]=======================================================================]

include(OCCMakeMiscFunctions)
include(OCCMakeFindUtilityFunctions)

OCCMakeMessage(STATUS "Trying to find OTF2...")

if(NOT DEFINED OTF2_FOUND)
  set(OTF2_FOUND NO)
endif()

if(OpenCMISS_FIND_SYSTEM_OTF2)
  
  OCCMakeMessage(STATUS "Trying to find OTF2 at the system level.")
  
  OCCMakeClearModulePath()

  find_package(OTF2)

  OCCMakeRestoreModulePath()

endif()

if(NOT OTF2_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find OTF2 in the OpenCMISS build system.")
    
endif()
