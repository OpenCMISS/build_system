#[=======================================================================[.rst:
OpenCMISS FindSLEPc
--------------------

An OpenCMISS wrapper to find a SLEPc implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SLEPc_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SLEPc)
  
  OCCMakeMessage(STATUS "Trying to find SLEPc at the system level...")
  
  find_path(SLEPc_DIR include/petsc.h
    HINTS ENV PETSC_DIR
    PATHS
    ${CMAKE_SYSTEM_PREFIX_PATH}
    DOC "SLEPc Directory")
  
  set(SLEPc_VERSION "3.0.0")
  find_path(SLEPc_CONF_DIR rules HINTS "${SLEPc_DIR}" PATH_SUFFIXES conf NO_DEFAULT_PATH)
  set(SLEPc_FOUND Yes)

  if(SLEPc_FOUND)
    set(SLEPc_INCLUDES ${SLEPc_DIR})
    find_path(SLEPc_INCLUDE_DIR petscts.h HINTS "${SLEPc_DIR}" PATH_SUFFIXES include NO_DEFAULT_PATH)
    list(APPEND SLEPc_INCLUDES ${SLEPc_INCLUDE_DIR})
    list(APPEND SLEPc_INCLUDES ${SLEPc_CONF_DIR})
    file(GLOB SLEPc_LIBRARIES RELATIVE "${SLEPc_DIR}/lib" "${SLEPc_DIR}/lib/libpetsc*.a")
  endif(SLEPc_FOUND)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(SLEPc DEFAULT_MSG SLEPc_LIBRARIES SLEPc_INCLUDES)

endif()

if(NOT SLEPc_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SLEPc in the OpenCMISS build system...")


  # Try and use the package config (.pc) file that SLEPc installs
  find_package(PkgConfig REQUIRED)

  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
  # Find the SLEPc package config directory
  find_path(_SLEPc_PKG_CONFIG_DIR
    NAMES "PETSC.pc" "petsc.pc" "SLEPc.pc"
    HINTS "${PETSC_DIR}" "$ENV{PETSC_DIR}"
    PATH_SUFFIXES lib/pkgconfig
  )

  #set(CMAKE_FIND_DEBUG_MODE FALSE)
  
  if(DEFINED _SLEPc_PKG_CONFIG_DIR)
    # Add the found directory to the PKG_CONFIG_PATH environment variable
    set(ENV{PKG_CONFIG_PATH} "${_SLEPc_PKG_CONFIG_DIR}:$ENV{PKG_CONFIG_DIR}")
    OCCMakeDebug("Added '${_SLEPc_PKG_CONFIG_DIR}' to the PKG_CONFIG_DIR environment variable." 1)    
  endif()
  
  if(DEFINED SLEPc_FIND_VERSION)
    # Try and find a particular version (or greater) of SLEPc
    pkg_check_modules(SLEPC IMPORTED_TARGET SLEPc>=${SLEPc_FIND_VERSION})
  else()
    # Try and find SLEPc
    pkg_check_modules(SLEPC IMPORTED_TARGET SLEPc)
  endif()

  unset(_SLEPc_PKG_CONFIG_DIR)

  if(SLEPC_FOUND)
    OCCMakeDebug("SLEPc found in package configuration." 1)
    if(NOT TARGET SLEPc::SLEPc)
      if(TARGET PkConfig::SLEPc)	
	message(STATUS "Found PkConfig SLEPc target.")
	add_library(SLEPc::SLEPc ALIAS PkConfig::SLEPc)
      else()
	#Try and find SLEPc dependencies???
	add_library(SLEPc::SLEPc INTERFACE IMPORTED GLOBAL)
	if(DEFINED SLEPC_LINK_LIBRARIES)
	  set_target_properties(SLEPc::SLEPc PROPERTIES INTERFACE_LINK_LIBRARIES "${SLEPC_LINK_LIBRARIES}")
	endif()
	if(DEFINED SLEPC_LDFLAGS_OTHER)
	  set_target_properties(SLEPc::SLEPc PROPERTIES INTERFACE_LINK_OPTIONS "${SLEPC_LDFLAGS_OTHER}")
	endif()
	if(DEFINED SLEPC_INCLUDE_DIRS)
	  set_target_properties(SLEPc::SLEPc PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${SLEPC_INCLUDE_DIRS}")
	endif()
	if(DEFINED SLEPC_CFLAGS_OTHER)
	  set_target_properties(SLEPc::SLEPc PROPERTIES INTERFACE_COMPILE_OPTIONS "${SLEPC_CFLAGS_OTHER}")
	endif()
	set(SLEPc_LIBRARIES "${SLEPC_LIBRARIES}")
	set(SLEPc_INCLUDE_DIRS "${SLEPC_INCLUDE_DIRS}")
	set(SLEPc_LINK_LIBRARIES "${SLEPC_LINK_LIBRARIES}")
	set(SLEPc_LINK_OPTIONS "${SLEPC_LDFLAGS}")
	set(SLEPc_COMPILE_OPTIONS "${SLEPC_CFLAGS}")
      endif()
      set(SLEPc_VERSION ${SLEPC_VERSION})
      set(SLEPc_FOUND ${SLEPC_FOUND})
    endif()
  endif()
  
 if(SLEPc_FOUND)
    OCCMakeMessage(STATUS "Found SLEPc (version ${SLEPc_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find SLEPc.")
  endif()
else()
  OCCMakeMessage(STATUS "Found SLEPc (version ${SLEPc_VERSION}) at the system level.")
endif()

if(SLEPc_FOUND)
  OCCMakeDebug("SLEPc_INCLUDE_DIRS = '${SLEPc_INCLUDE_DIRS}'." 2)    
  OCCMakeDebug("SLEPc_LIBRARIES = '${SLEPc_LIBRARIES}'." 2)    
endif()
