#[=======================================================================[.rst:
OpenCMISS FindHYPRE
-------------------

An OpenCMISS wrapper to find a HYPRE implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

OCCMakeMessage(STATUS "Trying to find HYPRE...")

set(HYPRE_FOUND False)

if(OpenCMISS_FIND_SYSTEM_HYPRE)
  
  OCCMakeMessage(STATUS "Trying to find HYPRE at the system level...")

  # Try and find Hypre header file
  find_path(HYPRE_INCLUDE_DIRS HYPRE.h
    HINTS ${HYPRE_DIR} ENV HYPRE_DIR
    PATH_SUFFIXES include
    PATHS $ENV{HOME}/hypre
    DOC "Hypre include directory."
  )

  if(EXISTS ${HYPRE_INCLUDE_DIRS}/HYPRE.h)

    # Found the header file, try and fine the library.
    find_library(HYPRE_LIBRARY HYPRE
      HINTS ${HYPRE_DIR} ENV HYPRE_DIR
      PATH_SUFFIXES lib lib64
      DOC "Hypre library."
    )

    if(EXISTS ${HYPRE_LIBRARY})

      # Should test if Hypre is useable

      # Try and find Hypre version and configuration information
      set(HYPRE_VERSION )
      if(EXISTS ${HYPRE_INCLUDE_DIRS}/HYPRE_config.h)
	file(READ ${HYPRE_INCLUDE_DIRS}/HYPRE_config.h _HYPRE_CONFIG_H_CONTENTS)
	string(REGEX REPLACE ".*#define[ \t]HYPRE_RELEASE_VERSION[ \t]+\"([0-9.]+)\".*" "\\1" HYPRE_VERSION ${_HYPRE_CONFIG_H_CONTENTS})
	unset(_HYPRE_CONFIG_H_CONTENTS)
      endif()
      
    endif()
    
  endif()
    
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args("HYPRE"
    FOUND_VAR HYPRE_FOUND
    REQUIRED_VARS HYPRE_LIBRARIES HYPRE_INCLUDE_DIRS
    VERSION_VAR HYPRE_VERSION
  )

  if(HYPRE_FOUND)
    if(NOT TARGET HYPRE::HYPRE)
      # If the HYPRE target hasn't already been processed add it
      add_library(HYPRE::HYPRE UNKNOWN IMPORTED)
      set_target_properties(HYPRE::HYPRE PROPERTIES
	IMPORTED_LOCATION ${HYPRE_LIBRARIES}
	INTERFACE_INCLUDE_DIRECTORIES "${HYPRE_INCLUDE_DIRS}"
      )
    endif()    
  endif()
  
endif()

if(NOT HYPRE_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find HYPRE in the OpenCMISS build system...")
    
  find_package(HYPRE ${HYPRE_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )

  if(TARGET HYPRE::HYPRE)
    OCCMakeDebug("Target HYPRE::HYPRE found in HYPRE configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(HYPRE::HYPRE HYPRE
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(HYPRE_FOUND ON)
  endif()
  
  if(HYPRE_FOUND)
    OCCMakeMessage(STATUS "Found HYPRE (version ${HYPRE_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find HYPRE.")
  endif()
else()
  OCCMakeMessage(STATUS "Found HYPRE (version ${HYPRE_VERSION}) at the system level.")
endif()

if(HYPRE_FOUND)
  OCCMakeDebug("HYPRE_INCLUDE_DIRS = '${HYPRE_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("HYPRE_LIBRARIES = '${HYPRE_LIBRARIES}'." 2)    
endif()
