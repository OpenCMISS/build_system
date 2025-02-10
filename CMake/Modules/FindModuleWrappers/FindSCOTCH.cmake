#[=======================================================================[.rst:
OpenCMISS FindScotch
--------------------

An OpenCMISS wrapper to find a SCOTCH implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SCOTCH_FOUND NO)
set(PTSCOTCH_FOUND NO)
set(ESMUMPS_FOUND NO)
set(PTESMUMPS_FOUND NO)
set(SCOTCH_METIS_FOUND NO)
set(PTSCOTCH_PARMETIS_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SCOTCH)
  
  OCCMakeMessage(STATUS "Trying to find Scotch at the system level...")  

endif()

if(NOT SCOTCH_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find Scotch in the OpenCMISS build system...")

  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
  find_package(SCOTCH ${SCOTCH_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_DEFAULT_PATH
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )
   
  #set(CMAKE_FIND_DEBUG_MODE FALSE)

  if(TARGET SCOTCH::scotch)
    OCCMakeDebug("Found target SCOTCH::scotch in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::scotch SCOTCH_SCOTCH
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_LINK_LIBRARIES
    )
    set(SCOTCH_SCOTCH_FOUND ON)
  endif()
  if(TARGET SCOTCH::scotcherr)
    OCCMakeDebug("Found target SCOTCH::scotcherr in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::scotcherr SCOTCH_SCOTCHERR
      IMPORTED_LOCATIONS
    )
    set(SCOTCH_SCOTCHERR_FOUND ON)
  endif()
  if(TARGET SCOTCH::scotcherrexit)
    OCCMakeDebug("Found target SCOTCH::scotcherrexit in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::scotcherrexit SCOTCH_SCOTCHERREXIT
      IMPORTED_LOCATIONS
    )
    set(SCOTCH_SCOTCHERR_FOUND ON)
  endif()
  if(TARGET SCOTCH::ptscotch)
    OCCMakeDebug("Found target SCOTCH::ptscotch in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::ptscotch SCOTCH_PTSCOTCH
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_LINK_LIBRARIES
    )
    set(SCOTCH_PTSCOTCH_FOUND ON)
  endif()
  if(TARGET SCOTCH::ptscotcherr)
    OCCMakeDebug("Found target SCOTCH::ptscotcherr in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::ptscotcherr SCOTCH_PTSCOTCHERR
      IMPORTED_LOCATIONS
    )
    set(SCOTCH_PTSCOTCHERR_FOUND ON)
  endif()
  if(TARGET SCOTCH::ptscotcherrexit)
    OCCMakeDebug("Found target SCOTCH::ptscotcherrexit in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::ptscotcherrexit SCOTCH_PTSCOTCHERREXIT
      IMPORTED_LOCATIONS
    )
    set(SCOTCH_PTSCOTCHERREXIT_FOUND ON)
  endif()
  if(TARGET SCOTCH::esmumps)
    OCCMakeDebug("Found target SCOTCH::esmumps in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::esmumps SCOTCH_ESMUMPS
      IMPORTED_LOCATIONS
    )
    set(SCOTCH_ESMUMPS_FOUND ON)
  endif()
  if(TARGET SCOTCH::ptesmumps)
    OCCMakeDebug("Found target SCOTCH::ptesmumps in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::ptesmumps SCOTCH_PTESMUMPS
      IMPORTED_LOCATIONS
    )
    set(SCOTCH_PTESMUMPS_FOUND ON)
  endif()
  if(TARGET SCOTCH::scotchmetis)
    OCCMakeDebug("Found target SCOTCH::scotchmetis in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::scotchmetis SCOTCH_SCOTCHMETIS
      IMPORTED_LOCATIONS
    )
    set(SCOTCH_SCOTCHMETIS_FOUND ON)
  endif()
  if(TARGET SCOTCH::ptscotchparmetis)
    OCCMakeDebug("Found target SCOTCH::ptscotchparmetis in SCOTCH configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SCOTCH::ptscotchparmetis SCOTCH_PTSCOTCHParMETIS
      IMPORTED_LOCATIONS
    )
    set(SCOTCH_PTSCOTCHParMETIS_FOUND ON)
  endif()

  if(SCOTCH_SCOTCH_FOUND AND (SCOTCH_SCOTCHERR_FOUND OR SCOTCH_SCOTCHERREXIT_FOUND) AND SCOTCH_ESMUMPS_FOUND)
    set(SCOTCH_COMPILE_DERFINITIONS "${SCOTCH_SCOTCH_COMPILE_DEFINITIONS}")
    set(SCOTCH_INCLUDE_DIRS "${SCOTCH_SCOTCH_INCLUDE_DIRS}")
    set(SCOTCH_LIBRARIES "${SCOTCH_SCOTCH_LIBRARIES}")
    if(SCOTCH_SCOTCHERR_FOUND)
      list(APPEND SCOTCH_LIBRARIES "${SCOTCH_SCOTCHERR_LIBRARIES}")
    else()
      list(APPEND SCOTCH_LIBRARIES "${SCOTCH_SCOTCHERREXIT_LIBRARIES}")
    endif()
    set(SCOTCH_FOUND ON)    
  endif()
  
  if(SCOTCH_ESMUMPS_FOUND AND SCOTCH_FOUND)
    set(ESMUMPS_INCLUDE_DIRS "${SCOTCH_SCOTCH_INCLUDE_DIRS}")
    set(ESMUMPS_LIBRARIES "${SCOTCH_ESMUMPS_LIBRARIES}")
    list(APPEND ESMUMPS_LIBRARIES "${SCOTCH_LIBRARIES}")
    set(ESMUMPS_FOUND ON)    
  endif()

  if(SCOTCH_PTSCOTCH_FOUND AND (SCOTCH_PTSCOTCHERR_FOUND OR SCOTCH_PTSCOTCHERREXIT_FOUND) AND SCOTCH_SCOTCH_FOUND)
    set(PTSCOTCH_COMPILE_DERFINITIONS "${SCOTCH_PTSCOTCH_COMPILE_DEFINITIONS}")
    set(PTSCOTCH_INCLUDE_DIRS "${SCOTCH_PTSCOTCH_INCLUDE_DIRS}")
    set(PTSCOTCH_LIBRARIES "${SCOTCH_PTSCOTCH_LIBRARIES}")
    list(APPEND PTSCOTCH_LIBRARIES "${SCOTCH_SCOTCH_LIBRARIES}")
    if(SCOTCH_PTSCOTCHERR_FOUND)
      list(APPEND PTSCOTCH_LIBRARIES "${SCOTCH_PTSCOTCHERR_LIBRARIES}")
    else()
      list(APPEND PTSCOTCH_LIBRARIES "${SCOTCH_PTSCOTCHERREXIT_LIBRARIES}")
    endif()
    set(PTSCOTCH_FOUND ON)    
  endif()

  if(SCOTCH_PTESMUMPS_FOUND AND PTSCOTCH_FOUND)
    set(PTESMUMPS_INCLUDE_DIRS "${SCOTCH_PTSCOTCH_INCLUDE_DIRS}")
    set(PTESMUMPS_LIBRARIES "${SCOTCH_PTESMUMPS_LIBRARIES}")
    list(APPEND PTESMUMPS_LIBRARIES "${PTSCOTCH_LIBRARIES}")
    set(PTESMUMPS_FOUND ON)    
  endif()
  
  if(SCOTCH_FOUND)
    OCCMakeMessage(STATUS "Found SCOTCH (version ${SCOTCH_VERSION}) in the OpenCMISS build system.")
    if(PTSCOTCH_FOUND)
      OCCMakeMessage(STATUS "Found PTSCOTCH (version ${SCOTCH_VERSION}) in the OpenCMISS build system.")
    endif()
  else()
    OCCMakeMessage(STATUS "Could not find SCOTCH.")
  endif()
else()
  OCCMakeMessage(STATUS "Found SCOTCH (version ${SCOTCH_VERSION}) at the system level.")
  if(PTSCOTCH_FOUND)
    OCCMakeMessage(STATUS "Found PTSCOTCH (version ${SCOTCH_VERSION}) in the OpenCMISS build system.")
  endif()
endif()

if(SCOTCH_FOUND)
  OCCMakeDebug("SCOTCH_INCLUDE_DIRS = '${SCOTCH_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("SCOTCH_LIBRARIES = '${SCOTCH_LIBRARIES}'." 1)    
endif()
if(PTSCOTCH_FOUND)
  OCCMakeDebug("PTSCOTCH_INCLUDE_DIRS = '${PTSCOTCH_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("PTSCOTCH_LIBRARIES = '${PTSCOTCH_LIBRARIES}'." 1)    
endif()
if(ESMUMPS_FOUND)
  OCCMakeDebug("ESMUMPS_INCLUDE_DIRS = '${ESMUMPS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("ESMUMPS_LIBRARIES = '${ESMUMPS_LIBRARIES}'." 1)    
endif()
if(PTESMUMPS_FOUND)
  OCCMakeDebug("PTESMUMPS_INCLUDE_DIRS = '${PTESMUMPS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("PTESMUMPS_LIBRARIES = '${PTESMUMPS_LIBRARIES}'." 1)    
endif()
