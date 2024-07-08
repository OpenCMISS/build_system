#[=======================================================================[.rst:
OpenCMISS FindSUNDIALS
----------------------

An OpenCMISS wrapper to find a SUNDIALS implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SUNDIALS_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SUNDIALS)
  
  OCCMakeMessage(STATUS "Trying to find SUNDIALS at the system level...")
  
endif()

if(NOT SUNDIALS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SUNDIALS in the OpenCMISS build system...")
    
endif()
