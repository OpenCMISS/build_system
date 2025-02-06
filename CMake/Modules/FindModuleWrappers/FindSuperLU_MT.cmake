#[=======================================================================[.rst:
OpenCMISS FindSuperLU_MT
------------------------

An OpenCMISS wrapper to find a SuperLU_MT implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SuperLU_MT_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SuperLU_MT)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU_MT at the system level...")
  
endif()

if(NOT SuperLU_MT_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU_MT in the OpenCMISS build system...")
    
   
  find_package(superlu_mt ${SuperLU_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  if(TARGET superlu_mt::superlu_mt)
    OCCMakeDebug("Found target superlu::superlu in SuperLU configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(superlu_mt::superlu_mt SuperLU_MT
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_FEATURES
      INTERFACE_LINK_LIBRARIES
    )
    set(SuperLU_MT_FOUND ON)
    # Add an alias target
    if(NOT TARGET SuperLU_MT::SuperLU_MT)
      add_library(SuperLU_MT::SuperLU_MT ALIAS superlu_mt::superlu_mt)
    endif()
  endif()
  
  if(SuperLU_MT_FOUND)
    OCCMakeMessage(STATUS "Found SuperLU_MT (version ${SuperLU_MT_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find SuperLU_MT.")
  endif()
else()
  OCCMakeMessage(STATUS "Found SuperLU (version ${SuperLU_MT_VERSION}) at the system level.")
endif()

if(SuperLU_MT_FOUND)
  OCCMakeDebug("SuperLU_MT_INCLUDE_DIRS = '${SuperLU_MT_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("SuperLU_MT_LIBRARIES = '${SuperLU_MT_LIBRARIES}'." 2)    
endif()
