#[=======================================================================[.rst:
OpenCMISS FindMUMPS
-------------------

An OpenCMISS wrapper to find a MUMPS solver implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

OCCMakeMessage(STATUS "Trying to find MUMPS...")

set(MUMPS_FOUND NO)
set(MUMPS_PORD_FOUND NO)
set(MUMPS_COMMON_FOUND NO)
set(MUMPS_SMUMPS_FOUND NO)
set(MUMPS_DMUMPS_FOUND NO)
set(MUMPS_CMUMPS_FOUND NO)
set(MUMPS_ZMUMPS_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_MUMPS)
  
  OCCMakeMessage(STATUS "Trying to find MUMPS at the system level...")

  find_path(MUMPS_DIR include/mumps_compat.h HINTS ENV MUMPS_DIR PATHS $ENV{HOME}/mumps DOC "Mumps Directory")

  if(EXISTS ${MUMPS_DIR}/include/mumps_compat.h)
    set(MUMPS_FOUND YES)
    set(MUMPS_INCLUDES ${MUMPS_DIR})
    find_path(MUMPS_INCLUDE_DIR mumps_compat.h HINTS "${MUMPS_DIR}" PATH_SUFFIXES include NO_DEFAULT_PATH)
    list(APPEND MUMPS_INCLUDES ${MUMPS_INCLUDE_DIR})
    file(GLOB MUMPS_LIBRARIES "${MUMPS_DIR}/lib/libmumps*.a" "${MUMPS_DIR}/lib/lib*mumps*.a" "${MUMPS_DIR}/lib/lib*pord*.a")
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(MUMPS DEFAULT_MSG MUMPS_LIBRARIES MUMPS_INCLUDES)

endif()

if(NOT MUMPS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find MUMPS in the OpenCMISS build system...")

  #set(CMAKE_FIND_DEBUG_MODE TRUE)
    
  find_package(MUMPS ${MUMPS_FIND_VERSION} CONFIG
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

  if(TARGET MUMPS::PORD)
    OCCMakeDebug("Found target MUMPS::PORD in MUMPS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(MUMPS::PORD MUMPS_PORD
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(MUMPS_PORD_FOUND ON)
  endif()
  if(TARGET MUMPS::COMMON)
    OCCMakeDebug("Found target MUMPS::COMMON in MUMPS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(MUMPS::COMMON MUMPS_COMMON
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(MUMPS_COMMON_FOUND ON)
  endif()
  if(TARGET MUMPS::SMUMPS)
    OCCMakeDebug("Found target MUMPS::SMUMPS in MUMPS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(MUMPS::SMUMPS MUMPS_SMUMPS
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(MUMPS_SMUMPS_FOUND ON)
  endif()
  if(TARGET MUMPS::DMUMPS)
    OCCMakeDebug("Found target MUMPS::DMUMPS in MUMPS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(MUMPS::DMUMPS MUMPS_DMUMPS
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(MUMPS_DMUMPS_FOUND ON)
  endif()
  if(TARGET MUMPS::CMUMPS)
    OCCMakeDebug("Found target MUMPS::CMUMPS in MUMPS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(MUMPS::CMUMPS MUMPS_CMUMPS
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(MUMPS_CMUMPS_FOUND ON)
  endif()
  if(TARGET MUMPS::ZMUMPS)
    OCCMakeDebug("Found target MUMPS::ZMUMPS in MUMPS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(MUMPS::ZMUMPS MUMPS_ZMUMPS
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(MUMPS_ZMUMPS_FOUND ON)
  endif()
  if(TARGET MUMPS::MUMPS)
    OCCMakeDebug("Found target MUMPS::MUMPS in MUMPS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(MUMPS::MUMPS MUMPS_MUMPS
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
    )
    set(MUMPS_MUMPS_FOUND ON)
  endif()

  if(MUMPS_MUMPS_FOUND)
    set(MUMPS_INCLUDE_DIRS "${MUMPS_DMUMPS_INCLUDE_DIRS}")
    set(MUMPS_LIBRARIES "${MUMPS_DMUMPS_LIBRARIES}")
    set(MUMPS_FOUND ON)
  endif()

  if(MUMPS_FOUND)
    OCCMakeMessage(STATUS "Found MUMPS (version ${MUMPS_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find MUMPS.")
  endif()
else()
  OCCMakeMessage(STATUS "Found MUMPS (version ${MUMPS_VERSION}) at the system level.")
endif()

if(MUMPS_FOUND)
  OCCMakeDebug("MUMPS_INCLUDE_DIRS = '${MUMPS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("MUMPS_LIBRARIES = '${MUMPS_LIBRARIES}'." 1)    
endif()
if(MUMPS_PORD_FOUND)
  OCCMakeDebug("MUMPS_PORD_INCLUDE_DIRS = '${MUMPS_PORD_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("MUMPS_PORD_LIBRARIES = '${MUMPS_PORD_LIBRARIES}'." 1)    
endif()
if(MUMPS_COMMON_FOUND)
  OCCMakeDebug("MUMPS_COMMON_INCLUDE_DIRS = '${MUMPS_COMMON_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("MUMPS_COMMON_LIBRARIES = '${MUMPS_COMMMON_LIBRARIES}'." 1)    
endif()
if(MUMPS_SMUMPS_FOUND)
  OCCMakeDebug("MUMPS_SMUMPS_INCLUDE_DIRS = '${MUMPS_SMUMPS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("MUMPS_SMUMPS_LIBRARIES = '${MUMPS_SMUMPS_LIBRARIES}'." 1)    
endif()
if(MUMPS_DMUMPS_FOUND)
  OCCMakeDebug("MUMPS_DMUMPS_INCLUDE_DIRS = '${MUMPS_DMUMPS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("MUMPS_DMUMPS_LIBRARIES = '${MUMPS_DMUMPS_LIBRARIES}'." 1)    
endif()
if(MUMPS_CMUMPS_FOUND)
  OCCMakeDebug("MUMPS_CMUMPS_INCLUDE_DIRS = '${MUMPS_CMUMPS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("MUMPS_CMUMPS_LIBRARIES = '${MUMPS_CMUMPS_LIBRARIES}'." 1)    
endif()
if(MUMPS_ZMUMPS_FOUND)
  OCCMakeDebug("MUMPS_ZMUMPS_INCLUDE_DIRS = '${MUMPS_ZMUMPS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("MUMPS_ZMUMPS_LIBRARIES = '${MUMPS_ZMUMPS_LIBRARIES}'." 1)    
endif()
