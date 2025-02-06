#[=======================================================================[.rst:
OpenCMISS FindSuperLU
---------------------

An OpenCMISS wrapper to find a SuperLU implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SuperLU_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SuperLU)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU at the system level.")

  set(_SuperLU_HAVE_METIS False)
  
  # Try and find SuperLU header file
  find_path(SuperLU_INCLUDE_DIRS "supermatrix.h"
    HINTS ${SuperLU_DIR} ENV SuperLU_DIR
    PATH_SUFFIXES include
    PATHS $ENV{HOME}/superlu
    DOC "SuperLU include directory."
  )

  if(EXISTS "${SuperLU_INCLUDE_DIRS}/supermatrix.h")

    # Found the header file, try and fine the library.
    find_library(SuperLU_LIBRARY superlu
      HINTS ${SuperLU_DIR} ENV SuperLU_DIR
      PATH_SUFFIXES lib lib64
      DOC "SuperLU library."
    )

    if(EXISTS ${SuperLU_LIBRARY})

      # Should test if SuperLU is useable

      set(SuperLU_LIBRARIES "${SuperLU_LIBRARIES}")
      
      # Try and find SuperLU version and configuration information
      set(SuperLU_VERSION )
      find_file(_SLU_UTIL_H_FILE "slu_util.h"
	HINTS ${SuperLU_INCLUDE_DIRS}
	NO_DEFAULT_PATH
      )
      if(EXISTS "${_SLU_UTIL_H_FILE}")
	file(READ "${_SLU_UTIL_H_FILE}" _SLU_UTIL_H_CONTENTS)
	string(REGEX REPLACE ".*#define[ \t]SUPERLU_MAJOR_VERSION[ \t]+\"([0-9.]+)\".*" "\\1" SuperLU_MAJOR_VERSION ${_SLU_UTIL_H_CONTENTS})
	string(REGEX REPLACE ".*#define[ \t]SUPERLU_MINOR_VERSION[ \t]+\"([0-9.]+)\".*" "\\1" SuperLU_MINOR_VERSION ${_SLU_UTIL_H_CONTENTS})
	string(REGEX REPLACE ".*#define[ \t]SUPERLU_PATCH_VERSION[ \t]+\"([0-9.]+)\".*" "\\1" SuperLU_PATCH_VERSION ${_SLU_UTIL_H_CONTENTS})
	set(SuperLU_VERSION "${SuperLU_MAJOR_VERSION}.${SuperLU_MINOR_VERSION}.${SuperLU_PATCH_VERSION}")
	unset(_SLU_UTIL_H_CONTENTS)
      endif()
      unset(_SLU_UTIL_H_FILE)
      find_file(_SuperLU_CONFIG_H_FILE "superlu_config.h"
	HINTS ${SuperLU_INCLUDE_DIRS}
	NO_DEFAULT_PATH
      )
      if(EXISTS "${_SuperLU_CONFIG_H_FILE}")
	file(READ "${_SuperLU_CONFIG_H_FILE}" _SuperLU_CONFIG_H_CONTENTS)
	string(REGEX REPLACE ".*#define[ \t]HAVE_METIS[ \t]+\"([TtRrUuEe]+)\".*" "\\1" SuperLU_HAVE_METIS ${_SuperLU_CONFIG_H_CONTENTS})
	unset(_SuperLU_CONFIG_H_CONTENTS)
      endif()
      
    endif()
    
  endif()
    
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args("SuperLU"
    FOUND_VAR SuperLU_FOUND
    REQUIRED_VARS SuperLU_LIBRARIES SuperLU_INCLUDE_DIRS
    VERSION_VAR SuperLU_VERSION
  )

  if(SuperLU_FOUND)
    if(NOT TARGET superlu::superlu)
      # If the SuperLU target hasn't already been processed add it
      find_package(BLAS QUIET)
      if(SuperLU_HAVE_METIS)
	find_package(METIS QUIET)
      endif()
      add_library(superlu::superlu UNKNOWN IMPORTED)
      set_target_properties(superlu::superlu PROPERTIES
	IMPORTED_LOCATION ${SuperLU_LIBRARIES}
	INTERFACE_INCLUDE_DIRECTORIES "${SuperLU_INCLUDE_DIRS}"
      )
      # Add in dependencies
      if(TARGET BLAS::BLAS)
	target_link_libraries(superlu::superlu
	  INTERFACE BLAS::BLAS
	)
      else()
	target_link_libraries(superlu::superlu
	  INTERFACE ${BLAS_LINKER_FLAGS} ${BLAS_LIBRARIES}
	)	
      endif()
      if(SuperLU_HAVE_METIS)
	if(TARGET METIS::METIS)
	  target_link_libraries(superlu::superlu
	    INTERFACE METIS::METIS
	  )
	else()
	  target_link_libraries(superlu::superlu
	    INTERFACE ${METIS_LIBRARIES}
	  )
	endif()
      endif()
      # Add an alias target
      if(NOT TARGET SuperLU::SuperLU)
	add_library(SuperLU::SuperLU ALIAS superlu::superlu)
      endif()
    endif()    
  endif()
  
  unset(_SuperLU_HAVE_METIS)
  
endif()

if(NOT SuperLU_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SuperLU in the OpenCMISS build system...")
    
  find_package(superlu ${SuperLU_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
  
  if(TARGET superlu::superlu)
    OCCMakeDebug("Found target superlu::superlu in SuperLU configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(superlu::superlu SuperLU
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_LINK_LIBRARIES
    )
    set(SuperLU_FOUND ON)
    # Add an alias target
    add_library(SuperLU::SuperLu ALIAS superlu::superlu)
  endif()
  
  if(SuperLU_FOUND)
    OCCMakeMessage(STATUS "Found SuperLU (version ${SuperLU_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find SuperLU.")
  endif()
else()
  OCCMakeMessage(STATUS "Found SuperLU (version ${SuperLU_VERSION}) at the system level.")
endif()

if(SuperLU_FOUND)
  OCCMakeDebug("SuperLU_INCLUDE_DIRS = '${SuperLU_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("SuperLU_LIBRARIES = '${SuperLU_LIBRARIES}'." 2)    
endif()
