#[=======================================================================[.rst:
OpenCMISS FindGKlib
-------------------

An OpenCMISS wrapper to find a GKlib implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(GKlib_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_GKlib)
  
  OCCMakeMessage(STATUS "Trying to find GKlib at the system level...")
  
  # Try and find GKlib header file
  find_path(GKlib_INCLUDE_DIRS "GKlib.h"
    HINTS ${GKlib_DIR} ENV GKlib_DIR
    PATH_SUFFIXES include
    PATHS $ENV{HOME}/GKlib
    DOC "GKlib include directory."
  )

  if(EXISTS "${GKlib_INCLUDE_DIRS}/GKlib.h")
    # Found the header file, try and fine the library.
    find_library(GKlib_LIBRARY "GKlib"
      HINTS ${GKlib_DIR} ENV GKlib_DIR
      PATH_SUFFIXES lib lib64
      DOC "GKlib library."
    )

    if(EXISTS ${GKlib_LIBRARY})

      # Should test if GKlib is useable
      set(GKlib_LIBRARIES "${GKlib_LIBRARY}")
      set(GKlib_VERSION "1.0.0")
      
    endif()
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args("GKlib"
    FOUND_VAR GKlib_FOUND
    REQUIRED_VARS GKlib_LIBRARIES GKlib_INCLUDE_DIRS
    VERSION_VAR GKlib_VERSION
  )

  if(GKlib_FOUND)
    if(NOT TARGET GKlib::GKlib)
      # If the GKlib target hasn't already been processed add it
      add_library(GKlib::GKlib UNKNOWN IMPORTED)
      set_target_properties(GKlib::GKlib PROPERTIES
	IMPORTED_LOCATION ${GKlib_LIBRARIES}
	INTERFACE_INCLUDE_DIRECTORIES "${GKlib_INCLUDE_DIRS}"
      )
    endif()
  endif()
  
endif()

if(NOT GKlib_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find GKlib in the OpenCMISS build system...")
  
  find_package(GKlib ${GKlib_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  if(TARGET GKlib::GKlib)
    OCCMakeDebug("Found GKlib::GKlib in GKlib configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(GKlib::GKlib GKlib
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(GKlib_FOUND ON)
  endif()
    
  if(GKlib_FOUND)
    OCCMakeMessage(STATUS "Found GKlib (version ${GKlib_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find GKlib.")
  endif()
else()
  OCCMakeMessage(STATUS "Found GKlib (version ${GKlib_VERSION}) at the system level.")
endif()

if(GKlib_FOUND)
  OCCMakeDebug("GKlib_INCLUDE_DIRS = '${GKlib_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("GKlib_LIBRARIES = '${GKlib_LIBRARIES}'." 2)    
endif()
