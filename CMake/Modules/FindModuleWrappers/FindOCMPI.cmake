#[=======================================================================[.rst:
OpenCMISS FindMPI
-----------------

An OpenCMISS wrapper to find a Message Passing Interface (MPI) implementation.

This module will look at the OpenCMISS_MPI variable mnenomic and find that MPI implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(MPI_FOUND NO)

#if(OpenCMISS_FIND_SYSTEM_MPI)
  
  OCCMakeMessage(STATUS "Trying to find MPI (version ${MPI_FIND_VERSION}) at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(MPI ${MPI_FIND_VERSION})

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

#endif()

#if(NOT MPI_FOUND)
  
#  OCCMakeMessage(STATUS "Trying to find MPI (version ${MPI_FIND_VERSION}) in the OpenCMISS build system.")
    
#  find_package(MPI ${MPI_FIND_VERSION} CONFIG
#    QUIET
#    PATHS ${CMAKE_PREFIX_PATH}
#    NO_CMAKE_ENVIRONMENT_PATH
#    NO_SYSTEM_ENVIRONMENT_PATH
#    NO_CMAKE_BUILDS_PATH
#    NO_CMAKE_PACKAGE_REGISTRY
#    NO_CMAKE_SYSTEM_PATH
#    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
#  )
  
#  if(MPI_FOUND)
#    OCCMakeDebug("Found OpenCMISS MPI (version ${MPI_VERSION}) at '${MPI_DIR}'." 1)
#  else()
#    OCCMakeDebug("Could not find MPI." 1)
#  endif()

#else()
  OCCMakeDebug("Found system MPI (version ${MPI_VERSION}) at '${MPI_DIR}'." 1)
#endif()
