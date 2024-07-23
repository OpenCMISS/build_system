#[=======================================================================[.rst:
OpenCMISS FindHDF5
-------------------

An OpenCMISS wrapper to find a HDF5 implementation.

If the variable HDF5_PREFER_STATIC_LIBRARIES is set then the module
will try to find the static libraries, otherwise the shared libraries will
be looked for.



#]=======================================================================]

include(OCCMakeMiscellaneous)

OCCMakeMessage(STATUS "Trying to find HDF5...")

set(HDF5_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_HDF5)
  
  OCCMakeMessage(STATUS "Trying to find HDF5 at the system level...")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(HDF5 MODULE QUIET)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT HDF5_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find HDF5 in the OpenCMISS build system...")
    
  find_package(HDF5 ${HDF5_FIND_VERSION} CONFIG
    QUIET
    PATHS ${CMAKE_PREFIX_PATH}
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_BUILDS_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
  )

  if(TARGET hdf5-static)
    OCCMakeDebug("Found target hdf5-static in HDF5 configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(hdf5-static HDF5_STATIC
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_LINK_LIBRARIES
    )
    set(HDF5_STATIC_FOUND ON)
    OCCMakeDebug("HDF5_STATIC_INCLUDE_DIRS = '${HDF5_STATIC_INCLUDE_DIRS}'." 1)      
    OCCMakeDebug("HDF5_STATIC_LIBRARIES = '${HDF5_STATIC_LIBRARIES}'." 1)
    set(HDF5_INCLUDE_DIRS "${HDF5_STATIC_INCLUDE_DIRS}")
    set(HDF5_LIBRARIES "${HDF5_STATIC_LIBRARIES}")
  endif()
  
  if(TARGET hdf5-shared)
    OCCMakeDebug("Found target hdf5-shared in HDF5 configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(hdf5-shared HDF5_SHARED
      IMPORTED_LOCATIONS
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_COMPILE_DEFINITIONS
      INTERFACE_LINK_LIBRARIES
    )
    set(HDF5_SHARED_FOUND ON)
    OCCMakeDebug("HDF5_SHARED_INCLUDE_DIRS = '${HDF5_SHARED_INCLUDE_DIRS}'." 1)      
    OCCMakeDebug("HDF5_SHARED_LIBRARIES = '${HDF5_SHARED_LIBRARIES}'." 1)
  endif()

  
  if(HDF5_STATIC_FOUND AND HDF5_SHARED_FOUND)
    # Both static and shared found
    if(DEFINED HDF5_PREFER_STATIC_LIBRARIES)
      # Return static
      set(HDF5_INCLUDE_DIRS "${HDF5_STATIC_INCLUDE_DIRS}")
      set(HDF5_LIBRARIES "${HDF5_STATIC_LIBRARIES}")
    else()
      # Return shared
      set(HDF5_INCLUDE_DIRS "${HDF5_SHARED_INCLUDE_DIRS}")
      set(HDF5_LIBRARIES "${HDF5_SHARED_LIBRARIES}")
    endif()
    set(HDF5_FOUND ON)
  else()
    if(HDF5_STATIC_FOUND)
      #Static found - return static
      set(HDF5_INCLUDE_DIRS "${HDF5_STATIC_INCLUDE_DIRS}")
      set(HDF5_LIBRARIES "${HDF5_STATIC_LIBRARIES}")
      set(HDF5_FOUND ON)
    else()
      if(HDF5_SHARED_FOUND)
	#Shared found - return shared
	set(HDF5_INCLUDE_DIRS "${HDF5_SHARED_INCLUDE_DIRS}")
	set(HDF5_LIBRARIES "${HDF5_SHARED_LIBRARIES}")
	set(HDF5_FOUND ON)
      endif()
    endif()
  endif()
  
  if(HDF5_FOUND)
    OCCMakeMessage(STATUS "Found HDF5 (version ${HDF5_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find HDF5.")
  endif()
else()
  OCCMakeMessage(STATUS "Found HDF5 (version ${HDF5_VERSION}) at the system level.")
endif()

if(HDF5_FOUND)
  OCCMakeDebug("HDF5_INCLUDE_DIRS = '${HDF5_INCLUDE_DIRS}'." 1)    
  OCCMakeDebug("HDF5_LIBRARIES = '${HDF5_LIBRARIES}'." 1)    
endif()
