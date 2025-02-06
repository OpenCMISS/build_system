#[=======================================================================[.rst:
OpenCMISS FindParMETIS
----------------------

An OpenCMISS wrapper to find a ParMETIS implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(ParMETIS_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_ParMETIS)
  
  OCCMakeMessage(STATUS "Trying to find ParMETIS at the system level...")
  
  # Try and find ParMETIS header file
  find_path(ParMETIS_INCLUDE_DIRS "parmetis.h"
    HINTS ${ParMETIS_DIR} ENV ParMETIS_DIR
    PATH_SUFFIXES include
    PATHS $ENV{HOME}/ParMETIS
    DOC "ParMETIS include directory."
  )

  if(EXISTS "${ParMETIS_INCLUDE_DIRS}/parmetis.h")
    # Found the header file, try and fine the library.
    find_library(ParMETIS_LIBRARY "ParMETIS"
      HINTS ${ParMETIS_DIR} ENV ParMETIS_DIR
      PATH_SUFFIXES lib lib64
      DOC "ParMETIS library."
    )
    
    if(EXISTS ${ParMETIS_LIBRARY})
      
      # Should test if ParMETIS is useable
      
      # Try and find ParMETIS version and configuration information
      file(READ ${ParMETIS_INCLUDE_DIRS}/parmetis.h _ParMETIS_CONFIG_H_CONTENTS)
      string(REGEX REPLACE ".*#define[ \t]PARMETIS_VER_MAJOR[ \t]+\"([0-9.]+)\".*" "\\1" ParMETIS_VER_MAJOR ${_ParMETIS_CONFIG_H_CONTENTS})
      string(REGEX REPLACE ".*#define[ \t]PARMETIS_VER_MINOR[ \t]+\"([0-9.]+)\".*" "\\1" ParMETIS_VER_MINOR ${_ParMETIS_CONFIG_H_CONTENTS})
      string(REGEX REPLACE ".*#define[ \t]PARMETIS_VER_SUBMINOR[ \t]+\"([0-9.]+)\".*" "\\1" ParMETIS_VER_SUBMINOR ${_ParMETIS_CONFIG_H_CONTENTS})
      set(ParMETIS_VERSION "${ParMETIS_VER_MAJOR}.${ParMETIS_VER_MINOR}.${ParMETIS_VER_SUBMINOR}")
      unset(_ParMETIS_CONFIG_H_CONTENTS)
    endif()
 
    set(ParMETIS_LIBRARIES "${ParMETIS_LIBRARY}")
      
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args("ParMETIS"
    FOUND_VAR ParMETIS_FOUND
    REQUIRED_VARS ParMETIS_LIBRARIES ParMETIS_INCLUDE_DIRS
    VERSION_VAR ParMETIS_VERSION
  )
  
  if(ParMETIS_FOUND)
    if(NOT TARGET ParMETIS::ParMETIS)
      # If the ParMETIS target hasn't already been processed add it
      find_package(MPI QUIET)
      find_package(METIS QUIET)
      #find_package(OpenMP QUIET)
      add_library(ParMETIS::ParMETIS UNKNOWN IMPORTED)
      set_target_properties(ParMETIS::ParMETIS PROPERTIES
	IMPORTED_LOCATION ${ParMETIS_LIBRARIES}
	INTERFACE_INCLUDE_DIRECTORIES "${ParMETIS_INCLUDE_DIRS}"
      )
      # Add in dependencies
      if(TARGET MPI::MPI)
	target_link_libraries(ParMETIS::ParMETIS
	  INTERFACE MPI::MPI)
      endif()
      if(TARGET METIS::METIS)
	target_link_libraries(ParMETIS::ParMETIS
	  INTERFACE METIS::METIS)
      endif()
      if(TARGET OpenMP::OpenMP)
	target_link_libraries(ParMETIS::ParMETIS
	  INTERFACE OpenMP::OpenMP)
      endif()
    endif()
  endif()

endif()

if(NOT ParMETIS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find ParMETIS in the OpenCMISS build system...")
  
  find_package(ParMETIS ${ParMETIS_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  if(TARGET ParMETIS::ParMETIS)
    OCCMakeDebug("Found target ParMETIS::ParMETIS in ParMETIS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(ParMETIS::ParMETIS ParMETIS
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_LINK_LIBRARIES
    )
    set(ParMETIS_FOUND ON)
    set(PARMETIS_FOUND ON)
  endif()

  if(ParMETIS_FOUND)
    OCCMakeMessage(STATUS "Found ParMETIS (version ${ParMETIS_VERSION}) in the OpenCMISS build system.")    
  else()
    OCCMakeMessage(STATUS "Could not find ParMETIS.")
  endif()
else()
  OCCMakeMessage(STATUS "Found ParMETIS (version ${ParMETIS_VERSION}) at the system level.")
endif()

if(ParMETIS_FOUND)
  OCCMakeDebug("ParMETIS_INCLUDE_DIRS = '${ParMETIS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("ParMETIS_LIBRARIES = '${ParMETIS_LIBRARIES}'." 1)    
endif()
