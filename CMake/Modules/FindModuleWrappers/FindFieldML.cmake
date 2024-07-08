#[=======================================================================[.rst:
OpenCMISS FindFieldML
---------------------

An OpenCMISS wrapper to find a FieldML-API implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(FieldML_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_FieldML)
  
  OCCMakeMessage(STATUS "Trying to find FieldML at the system level...")
  
endif()

if(NOT FieldML_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find FieldML in the OpenCMISS build system...")
    
  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
  find_package(fieldml-api ${FieldML_FIND_VERSION} CONFIG
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

  if(TARGET fieldml-api)
    OCCMakeDebug("Found target fieldml-api in fieldml-api configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(fieldml-api FieldML
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(FieldML_VERSION "${fieldml_VERSION}")
    set(FieldML_FOUND ON)
    if(NOT TARGET FieldML::FieldML-API)
      add_library(FieldML::FieldML-API ALIAS fieldml-api)
    endif()
  endif()
  
  if(FieldML_FOUND)
    OCCMakeMessage(STATUS "Found FieldML (version ${FieldML_VERSION}) in the OpenCMISS build system.")    
  else()
    OCCMakeMessage(STATUS "Could not find FieldML.")
  endif()
else()
  OCCMakeMessage(STATUS "Found FieldML (version ${FieldML_VERSION}) at the system level.")
endif()

if(FieldML_FOUND)
  OCCMakeDebug("FieldML_INCLUDE_DIRS = '${FieldML_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("FieldML_LIBRARIES = '${FieldML_LIBRARIES}'." 1)    
  OCCMakeDebug("FieldML_INTERFACE_LINK_LIBRARIES = '${FieldML_INTERFACE_LINK_LIBRARIES}'." 1)    
endif()
