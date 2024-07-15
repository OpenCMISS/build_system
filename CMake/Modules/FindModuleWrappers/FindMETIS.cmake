#[=======================================================================[.rst:
OpenCMISS FindMETIS
-------------------

An OpenCMISS wrapper to find a METIS implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(METIS_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_METIS)
  
  OCCMakeMessage(STATUS "Trying to find METIS at the system level...")
  
  # Try and find METIS header file
  find_path(METIS_INCLUDE_DIRS "metis.h"
    HINTS ${METIS_DIR} ENV METIS_DIR
    PATH_SUFFIXES include
    PATHS $ENV{HOME}/METIS
    DOC "METIS include directory."
  )

  if(EXISTS "${METIS_INCLUDE_DIRS}/metis.h")
    # Found the header file, try and fine the library.
    find_library(METIS_LIBRARY "METIS"
      HINTS ${METIS_DIR} ENV METIS_DIR
      PATH_SUFFIXES lib lib64
      DOC "METIS library."
    )
    
    if(EXISTS ${METIS_LIBRARY})
      
      # Should test if METIS is useable
      
      # Try and find METIS version and configuration information
      file(READ ${METIS_INCLUDE_DIRS}/metis.h _METIS_CONFIG_H_CONTENTS)
      string(REGEX REPLACE ".*#define[ \t]METIS_VER_MAJOR[ \t]+\"([0-9.]+)\".*" "\\1" METIS_VER_MAJOR ${_METIS_CONFIG_H_CONTENTS})
      string(REGEX REPLACE ".*#define[ \t]METIS_VER_MINOR[ \t]+\"([0-9.]+)\".*" "\\1" METIS_VER_MINOR ${_METIS_CONFIG_H_CONTENTS})
      string(REGEX REPLACE ".*#define[ \t]METIS_VER_SUBMINOR[ \t]+\"([0-9.]+)\".*" "\\1" METIS_VER_SUBMINOR ${_METIS_CONFIG_H_CONTENTS})
      set(METIS_VERSION "${METIS_VER_MAJOR}.${METIS_VER_MINOR}.${METIS_VER_SUBMINOR}")
      unset(_METIS_CONFIG_H_CONTENTS)
    endif()
 
    set(METIS_LIBRARIES "${METIS_LIBRARY}")
      
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args("METIS"
    FOUND_VAR METIS_FOUND
    REQUIRED_VARS METIS_LIBRARIES METIS_INCLUDE_DIRS
    VERSION_VAR METIS_VERSION
  )
  
  if(METIS_FOUND)
    if(NOT TARGET METIS::METIS)
      # If the METIS target hasn't already been processed add it
      find_package(GKlib QUIET)
      #find_package(OpenMP QUIET)
      add_library(METIS::METIS UNKNOWN IMPORTED)
      set_target_properties(METIS::METIS PROPERTIES
	IMPORTED_LOCATION ${METIS_LIBRARIES}
	INTERFACE_INCLUDE_DIRECTORIES "${METIS_INCLUDE_DIRS}"
      )
      # Add in dependencies
      if(TARGET GKlib:GKlib)
	target_link_libraries(METIS::METIS
	  INTERFACE GKlib::GKlib)
      endif()
      if(TARGET OpenMP::OpenMP)
	target_link_libraries(METIS::METIS
	  INTERFACE OpenMP::OpenMP)
      endif()
    endif()
  endif()
  
endif()

if(NOT METIS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find METIS in the OpenCMISS build system...")
  
  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
  find_package(METIS ${METIS_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  #set(CMAKE_FIND_DEBUG_MODE FALSE)
  
  if(TARGET METIS::METIS)
    OCCMakeDebug("Found target METIS::METIS in METIS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(METIS::METIS METIS
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(METIS_FOUND ON) 
  endif()

  if(METIS_FOUND)
    OCCMakeMessage(STATUS "Found METIS (version ${METIS_VERSION}) in the OpenCMISS build system.")    
  else()
    OCCMakeMessage(STATUS "Could not find METIS.")
  endif()
else()
  OCCMakeMessage(STATUS "Found METIS (version ${METIS_VERSION}) at the system level.")
endif()

if(METIS_FOUND)
  OCCMakeDebug("METIS_INCLUDE_DIRS = '${METIS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("METIS_LIBRARIES = '${METIS_LIBRARIES}'." 1)    
endif()
