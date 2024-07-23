#[=======================================================================[.rst:
OpenCMISS FindSUNDIALS
----------------------

An OpenCMISS wrapper to find a SUNDIALS implementation.

If the variable SUNDIALS_PREFER_STATIC_LIBRARIES is set then the module
will try to find the static libraries, otherwise the shared libraries will
be looked for.


#]=======================================================================]

include(OCCMakeMiscellaneous)

OCCMakeMessage(STATUS "Trying to find SUNDIALS...")

set(SUNDIALS_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SUNDIALS)
  
  OCCMakeMessage(STATUS "Trying to find SUNDIALS at the system level...")
  
endif()

if(NOT SUNDIALS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SUNDIALS in the OpenCMISS build system...")
    
  find_package(SUNDIALS ${SUNDIALS_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )

  if(TARGET SUNDIALS::core-shared)
    OCCMakeDebug("Found target SUNDIALS::core-shared in SUNDIALS configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(SUNDIALS::core-shared SUNDIALS_CORE_SHARED
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
     INTERFACE_LINK_LIBRARIES
    )
    set(SUNDIALS_CORE_SHARED_FOUND ON)
    OCCMakeDebug("SUNDIALS_CORE_SHARED_INCLUDE_DIRS = '${SUNDIALS_CORE_SHARED_INCLUDE_DIRS}'." 3)      
    OCCMakeDebug("SUNDIALS_CORE_SHARED_LIBRARIES = '${SUNDIALS_CORE_SHARED_LIBRARIES}'." 3)
  endif()
  
  if(SUNDIALS_FOUND)
    OCCMakeMessage(STATUS "Found SUNDIALS (version ${SUNDIALS_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find SUNDIALS.")
  endif()
else()
  OCCMakeMessage(STATUS "Found SUNDIALS (version ${SUNDIALS_VERSION}) at the system level.")
endif()

if(SUNDIALS_FOUND)
  OCCMakeDebug("SUNDIALS_INCLUDE_DIRS = '${SUNDIALS_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("SUNDIALS_LIBRARIES = '${SUNDIALS_LIBRARIES}'." 1)    
endif()
