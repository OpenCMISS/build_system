#[=======================================================================[.rst:
OpenCMISS FindLibCellML
-----------------------

An OpenCMISS wrapper to find a libCellML implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(libCellML_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_libCellML)
   
  OCCMakeMessage(STATUS "Trying to find libCellML at the system level...")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_package(LibCellML)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT libCellML_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find libCellML in the OpenCMISS build system...")
    
  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
  find_package(libCellML ${libCellML_FIND_VERSION} CONFIG
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
  
  if(TARGET cellml)
    OCCMakeDebug("Found target cellml in libCellML configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(cellml libCellML
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_COMPILE_FEATURES
      INTERFACE_LINK_LIBRARIES
    )
    set(libCellML_FOUND ON)
    if(NOT TARGET libCellML::libCellML)
      add_library(libCellML::libCellML ALIAS cellml)
    endif()
  endif()

  if(libCellML_FOUND)
    OCCMakeMessage(STATUS "Found libCellML (version ${libCellML_VERSION}) in the OpenCMISS build system.")    
  else()
    OCCMakeMessage(STATUS "Could not find libCellML.")
  endif()
else()
  OCCMakeMessage(STATUS "Found libCellML (version ${libCellML_VERSION}) at the system level.")
endif()

if(Libcellml_FOUND)
  OCCMakeDebug("libCellML_INCLUDE_DIRS = '${libCellML_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("libCellML_LIBRARIES = '${libCellML_LIBRARIES}'." 1)    
endif()
