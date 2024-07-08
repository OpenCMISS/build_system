#[=======================================================================[.rst:
OpenCMISS FindSuperLU_DIST
--------------------------

An OpenCMISS wrapper to find a SuperLU_DIST implementation.

#]=======================================================================]


include(OCCMakeMiscellaneous)

set(SuperLU_DIST_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SuperLU_DIST)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU_DIST at the system level...")
  
endif()

if(NOT SuperLU_DIST_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU_DIST in the OpenCMISS build system...")
    
  find_package(superlu_dist ${SuperLU_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  if(TARGET superlu_dist::superlu_dist)
    OCCMakeDebug("Found target superlu::superlu in SuperLU configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(superlu_dist::superlu_dist SuperLU_DIST
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(SuperLU_DIST_FOUND ON)
    # Add an alias target
    if(NOT TARGET SuperLU_DIST::SuperLU_DIST)
      add_library(SuperLU_DIST::SuperLU_DIST ALIAS superlu_dist::superlu_dist)
    endif()
  endif()
  
  if(SuperLU_DIST_FOUND)
    OCCMakeMessage(STATUS "Found SuperLU_DIST (version ${SuperLU_DIST_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find SuperLU_DIST.")
  endif()
else()
  OCCMakeMessage(STATUS "Found SuperLU (version ${SuperLU_DIST_VERSION}) at the system level.")
endif()

if(SuperLU_DIST_FOUND)
  OCCMakeDebug("SuperLU_DIST_INCLUDE_DIRS = '${SuperLU_DIST_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("SuperLU_DIST_LIBRARIES = '${SuperLU_DIST_LIBRARIES}'." 2)    
endif()
