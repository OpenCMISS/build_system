#[=======================================================================[.rst:
OpenCMISS FindPAPI
------------------

An OpenCMISS wrapper to find a PAPI implementation.

#]=======================================================================]

include(OCCMakeMiscFunctions)
include(OCCMakeFindUtilityFunctions)

OCCMakeMessage(STATUS "Trying to find PAPI...")

if(NOT DEFINED PAPI_FOUND)
  set(PAPI_FOUND NO)
endif()

if(OpenCMISS_FIND_SYSTEM_PAPI)
  
  OCCMakeMessage(STATUS "Trying to find PAPI at the system level.")
  
  OCCMakeClearModulePath()

  find_package(PAPI)

  OCCMakeRestoreModulePath()

endif()

if(NOT PAPI_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find PAPI in the OpenCMISS build system.")
    
endif()
