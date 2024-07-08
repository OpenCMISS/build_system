#[=======================================================================[.rst:
OpenCMISS FindPETSc
--------------------

An OpenCMISS wrapper to find a PETSc implementation.

#]=======================================================================]

## See https://github.com/jedbrown/cmake-modules/blob/master/FindPETSc.cmake

include(OCCMakeMiscellaneous)

set(PETSc_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_PETSc)
  
  OCCMakeMessage(STATUS "Trying to find PETSc at the system level...")
  
  find_path(PETSc_DIR include/petsc.h
    HINTS ENV PETSC_DIR
    PATHS
    ${CMAKE_SYSTEM_PREFIX_PATH}
    DOC "PETSc Directory")
  
  set(PETSc_VERSION "3.0.0")
  find_path(PETSc_CONF_DIR rules HINTS "${PETSc_DIR}" PATH_SUFFIXES conf NO_DEFAULT_PATH)
  set(PETSc_FOUND Yes)

  if(PETSc_FOUND)
    set(PETSc_INCLUDES ${PETSc_DIR})
    find_path(PETSc_INCLUDE_DIR petscts.h HINTS "${PETSc_DIR}" PATH_SUFFIXES include NO_DEFAULT_PATH)
    list(APPEND PETSc_INCLUDES ${PETSc_INCLUDE_DIR})
    list(APPEND PETSc_INCLUDES ${PETSc_CONF_DIR})
    file(GLOB PETSc_LIBRARIES RELATIVE "${PETSc_DIR}/lib" "${PETSc_DIR}/lib/libpetsc*.a")
  endif(PETSc_FOUND)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(PETSc DEFAULT_MSG PETSc_LIBRARIES PETSc_INCLUDES)

endif()

if(NOT PETSc_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find PETSc in the OpenCMISS build system...")

  # Try and use the package config (.pc) file that PETSc installs
  find_package(PkgConfig REQUIRED)

  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
  # Find the PETSc package config directory
  find_path(_PETSc_PKG_CONFIG_DIR
    NAMES "PETSC.pc" "petsc.pc" "PETSc.pc"
    HINTS "${PETSC_DIR}" "$ENV{PETSC_DIR}"
    PATH_SUFFIXES lib/pkgconfig
  )

  #set(CMAKE_FIND_DEBUG_MODE FALSE)
  
  if(DEFINED _PETSc_PKG_CONFIG_DIR)
    # Add the found directory to the PKG_CONFIG_PATH environment variable
    set(ENV{PKG_CONFIG_PATH} "${_PETSc_PKG_CONFIG_DIR}:$ENV{PKG_CONFIG_DIR}")
    OCCMakeDebug("Added '${_PETSc_PKG_CONFIG_DIR}' to the PKG_CONFIG_DIR environment variable." 1)    
  endif()
  
  if(DEFINED PETSc_FIND_VERSION)
    # Try and find a particular version (or greater) of PETSc
    pkg_check_modules(PETSC IMPORTED_TARGET PETSc>=${PETSc_FIND_VERSION})
  else()
    # Try and find PETSc
    pkg_check_modules(PETSC IMPORTED_TARGET PETSc)
  endif()

  unset(_PETSc_PKG_CONFIG_DIR)

  if(PETSC_FOUND)
    OCCMakeDebug("PETSc found in package configuration." 1)
    if(NOT TARGET PETSc::PETSc)
      if(TARGET PkConfig::PETSc)	
	message(STATUS "Found PkConfig PETSc target.")
	add_library(PETSc::PETSc ALIAS PkConfig::PETSc)
      else()
	#Try and find PETSc dependencies???
	add_library(PETSc::PETSc INTERFACE IMPORTED GLOBAL)
	if(DEFINED PETSC_LINK_LIBRARIES)
	  set_target_properties(PETSc::PETSc PROPERTIES INTERFACE_LINK_LIBRARIES "${PETSC_LINK_LIBRARIES}")
	endif()
	if(DEFINED PETSC_LDFLAGS_OTHER)
	  set_target_properties(PETSc::PETSc PROPERTIES INTERFACE_LINK_OPTIONS "${PETSC_LDFLAGS_OTHER}")
	endif()
	if(DEFINED PETSC_INCLUDE_DIRS)
	  set_target_properties(PETSc::PETSc PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PETSC_INCLUDE_DIRS}")
	endif()
	if(DEFINED PETSC_CFLAGS_OTHER)
	  set_target_properties(PETSc::PETSc PROPERTIES INTERFACE_COMPILE_OPTIONS "${PETSC_CFLAGS_OTHER}")
	endif()
	set(PETSc_LIBRARIES "${PETSC_LIBRARIES}")
	set(PETSc_INCLUDE_DIRS "${PETSC_INCLUDE_DIRS}")
	set(PETSc_LINK_LIBRARIES "${PETSC_LINK_LIBRARIES}")
	set(PETSc_LINK_OPTIONS "${PETSC_LDFLAGS}")
	set(PETSc_COMPILE_OPTIONS "${PETSC_CFLAGS}")
      endif()
      set(PETSc_VERSION ${PETSC_VERSION})
      set(PETSc_FOUND ${PETSC_FOUND})
    endif()
  endif()
  
 if(PETSc_FOUND)
    OCCMakeMessage(STATUS "Found PETSc (version ${PETSc_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find PETSc.")
  endif()
else()
  OCCMakeMessage(STATUS "Found PETSc (version ${PETSc_VERSION}) at the system level.")
endif()

if(PETSc_FOUND)
  OCCMakeDebug("PETSc_INCLUDE_DIRS = '${PETSc_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("PETSc_LIBRARIES = '${PETSc_LIBRARIES}'." 2)    
endif()
