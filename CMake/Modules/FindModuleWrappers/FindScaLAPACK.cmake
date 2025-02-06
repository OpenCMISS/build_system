#[=======================================================================[.rst:
OpenCMISS FindScaLAPACK
--------------------

An OpenCMISS wrapper to find a Scalable Linear Algebra PACKage (ScaLAPACK)
implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

OCCMakeMessage(STATUS "Trying to find ScaLAPACK...")

set(ScaLAPACK_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_BLACS_ScaLAPACK)
  
  OCCMakeMessage(STATUS "Trying to find ScaLAPACK at the system level...")
   
  find_library(ScaLAPACK_LIBRARY
    NAMES scalapack scalapack-mpi scalapack-mpich scalapack-mpich2 scalapack-openmpi
    PATHS /usr/lib64 /usr/lib /usr/local/lib64 /usr/local/lib
    /opt/local/lib /opt/sw/lib /sw/lib
    ENV LD_LIBRARY_PATH
    ENV DYLD_FALLBACK_LIBRARY_PATH
    ENV DYLD_LIBRARY_PATH
    ENV SCALAPACKDIR
    ENV BLACSDIR)

  if(EXISTS ${ScaLAPACK_LIBRARY})

    # Should test if ScaLAPACK is useable
  
    set(ScaLAPACK_LIBRARIES ${ScaLAPACK_LIBRARY})
    
  endif()
  
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args("ScaLAPACK"
    FOUND_VAR ScaLAPACK_FOUND
    REQUIRED_VARS ScaLAPACK_LIBRARIES
  )
    
  if(ScaLAPACK_FOUND)
    if(NOT TARGET ScaLAPACK::ScaLAPACK)
      # If the ScaLAPACK target hasn't already been processed add it
      find_package(LAPACK QUIET)
      find_package(MPI COMPONENTS C QUIET)
      add_library(ScaLAPACK::ScaLAPACK UNKNOWN IMPORTED)
      set_target_properties(ScaLAPACK::ScaLAPACK PROPERTIES
	IMPORTED_LOCATION ${ScaLAPACK_LIBRARIES}
      # Add in dependencies
      if(TARGET LAPACK::LAPACK)
	target_link_libraries(ScaLAPACK::ScaLAPACK
	  INTERFACE LAPACK::LAPACK
	)
      else()
	target_link_libraries(ScaLAPACK::ScaLAPACK
	  INTERFACE ${LAPACK_LINKER_FLAGS} ${LAPACK_LIBRARIES}
	)	
      endif()
      if(TARGET MPI::MPI_C)
	target_link_libraries(ScaLAPACK::ScaLAPACK
	  INTERFACE MPI::MPI_C
	)
      else()
	target_link_libraries(ScaLAPACK::ScaLAPACK
	  INTERFACE ${MPI_C_LINK_FLAGS} ${MPI_C_LIBRARIES}
	)	
      endif()
     )
    endif()    
  endif()
endif()

if(NOT ScaLAPACK_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find ScaLAPACK in the OpenCMISS build system...")
    
  #set(CMAKE_FIND_DEBUG_MODE TRUE)
  
  find_package(SCALAPACK ${ScaLAPACK_FIND_VERSION} CONFIG
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
  
  if(TARGET scalapack)
    OCCMakeDebug("Found target scalapack in the SCALAPACK configuration." 1)
    OCCMakeFoundTargetPropertiesToVariables(scalapack ScaLAPACK
      IMPORTED_LOCATIONS
      INTERFACE_LINK_LIBRARIES
    )
    set(ScaLAPACK_VERSION "${SCALAPACK_VERSION}")
    set(ScaLAPACK_FOUND ON)
    if(NOT TARGET ScaLAPACK::ScaLAPACK)
      add_library(ScaLAPACK::ScaLAPACK ALIAS scalapack)
    endif()

  endif()
  
  if(ScaLAPACK_FOUND)
    OCCMakeMessage(STATUS "Found ScaLAPACK (version ${ScaLAPACK_VERSION}) in the OpenCMISS build system.")
  else()
    OCCMakeMessage(STATUS "Could not find ScaLAPACK.")
  endif()
else()
  OCCMakeMessage(STATUS "Found ScaLAPACK (version ???) at the system level.")
endif()

if(ScaLAPACK_FOUND)
  OCCMakeDebug("ScaLAPACK_LIBRARIES = '${ScaLAPACK_LIBRARIES}'." 2)    
endif()
  
