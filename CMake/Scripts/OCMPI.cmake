#[=======================================================================[.rst:
OpenCMISS MPI
-------------

All functions related to OpenCMISS_MPI and OpenCMISS_MPI_BUILD_TYPE

All the short mnemonics for MPI are:
        
:MPICH: The MPICH MPI library
:MSMPI: The Microsoft MPI library
:MVAPICH: The MVAPICH MPI library
:None: Do not use MPI
:OpenMPI: The OpenMPI MPI library
:Intel: The Intel MPI library
:Unspecified: Select an MPI library

All the short mnemonics for MPI build type are:
        
:none: Do not use a MPI build type


#]=======================================================================]

set(OC_MPI_MPICH OFF)
set(OC_MPI_MSMPI OFF)
set(OC_MPI_MVAPICH OFF)
set(OC_MPI_NONE OFF)
set(OC_MPI_OPENMPI OF)
set(OC_MPI_INTEL OFF)
set(OC_MPI_UNSPECIFIED OFF)
set(OC_MPI_BUILD_TYPE_NONE OFF)
set(OC_BUILD_OWN_MPI OFF)
if(DEFINED OpenCMISS_MPI)
  string(TOLOWER "${OpenCMISS_MPI}" _LOWERCASE_MPI)
else()
  if(DEFINED ENV{OpenCMISS_MPI})
    string(TOLOWER "$ENV{OpenCMISS_MPI}" _LOWERCASE_MPI)
  else()
    set(_LOWERCASE_MPI "unspecified")
  endif()
endif()
if(DEFINED OpenCMISS_MPI_BUILD_TYPE)
  string(TOLOWER "${OpenCMISS_MPI_BUILD_TYPE}" _LOWERCASE_MPI_BUILD_TYPE)
else()
  if(DEFINED OC_MPI_BUILD_TYPE)
    string(TOLOWER "${OC_MPI_BUILD_TYPE}" _LOWERCASE_MPI_BUILD_TYPE)
  else()
    if(DEFINED ENV{OpenCMISS_MPI_BUILD_TYPE})
      string(TOLOWER "$ENV{OpenCMISS_MPI_BUILD_TYPE}" _LOWERCASE_MPI_BUILD_TYPE)
    else()
      set(_LOWERCASE_MPI_BUILD_TYPE "none")
    endif()
  endif()
endif()

OCCMakeDebug("_LOWERCASE_MPI = '${_LOWERCASE_MPI}'." 1)

if(_LOWERCASE_MPI STREQUAL "mpich")
  set(OC_MPI_LIBRARY_NAME "MPICH" CACHE STRING "OpenCMISS MPI library name." FORCE)
  set(OC_MPI_MPICH ON)
elseif(_LOWERCASE_MPI STREQUAL "msmpi")
  set(OC_MPI_LIBRARY_NAME "MSMPI" CACHE STRING "OpenCMISS MPI library name." FORCE)
  set(OC_MPI_MSMPI ON)
elseif(_LOWERCASE_MPI STREQUAL "mvapich")
  set(OC_MPI_LIBRARY_NAME "MVAPICH" CACHE STRING "OpenCMISS MPI library name." FORCE)
  set(OC_MPI_MVAPICH ON)
elseif(_LOWERCASE_MPI STREQUAL "none")
  set(OC_MPI_LIBRARY_NAME "None" CACHE STRING "OpenCMISS MPI library name." FORCE)
  set(OC_MPI_MVAPICH ON)
elseif(_LOWERCASE_MPI STREQUAL "openmpi")
  set(OC_MPI_LIBRARY_NAME "OpenMPI" CACHE STRING "OpenCMISS MPI library name." FORCE)
  set(OC_MPI_OPENMPI ON)
elseif(_LOWERCASE_MPI STREQUAL "intel")
  set(OC_MPI_LIBRARY_NAME "Intel" CACHE STRING "OpenCMISS MPI library name." FORCE)
  set(OC_MPI_INTEL ON)
elseif(_LOWERCASE_MPI STREQUAL "unspecified")
  set(OC_MPI_LIBRARY_NAME "Unspecified" CACHE STRING "OpenCMISS MPI library name." FORCE)
  set(OC_MPI_UNSPECIFIED ON)
else()
  set(OC_MPI_LIBRARY_NAME "Unspecified" CACHE STRING "OpenCMISS MPI library name." FORCE)
  set(OC_MPI_UNSPECIFIED ON)
  OCCMakeWarning("The specified MPI library type of ${_LOWERCASE_MPI} is unknown. Defaulting to unspecified.")
  set(_LOWERCASE_MPI "unspecified")
endif()
if(_LOWERCASE_MPI_BUILD_TYPE STREQUAL "none")
  set(OC_MPI_BUILD_TYPE "None" CACHE STRING "OpenCMISS MPI build type." FORCE)
  set(OC_MPI_BUILD_TYPE_NONE ON)
else()
  set(OC_MPI_BUILD_TYPE "None" CACHE STRING "OpenCMISS MPI build type." FORCE)
  set(OC_MPI_BUILD_TYPE_NONE ON)
  OCCMakeWarning("The specified MPI library build type of ${_LOWERCASE_MPI_BUILD_TYPE} is unknown. Defaulting to none.")
endif()

OCCMakeDebug("Using a MPI library of ${OC_MPI_LIBRARY_NAME}." 1)
OCCMakeDebug("Using a MPI build type of ${OC_MPI_BUILD_TYPE}." 1)

unset(_LOWERCASE_MPI)
unset(_LOWERCASE_MPI_BUILD_TYPE)

set(OC_DEFAULT_USE_NOMPI ON CACHE BOOL "OpenCMISS default USE for dependencies that do not use MPI." FORCE)
if(OC_MPI_NONE)
  set(OC_DEFAULT_USE_MPI OFF CACHE BOOL "OpenCMISS default USE for dependencies that do use MPI." FORCE)
else()
  set(OC_DEFAULT_USE_MPI ON CACHE BOOL "OpenCMISS default USE for dependencies that do use MPI." FORCE)
endif()
 
function(OCDetermineMPILibraryType INCLUDE_DIRECTORY MPI_LIBRARY_TYPE)

  # Work out which MPI we have. Could look for symbols in mpi.h or execute mpiexec --version and parse results?

  # Check mpi.h for certain defines to determine MPI library
  if(EXISTS "${INCLUDE_DIRECTORY}/mpi.h")
  
    include(CheckSymbolExists)
    # Make sure that the include directory is passed in as a required include in case mpi.h includes other headers
    set(CMAKE_REQUIRED_INCLUDES ${INCLUDE_DIRECTORY})
    # Check for the various symbols in mpi.h
    unset(_OC_INTEL_MPI_SYMBOL_EXISTS CACHE)
    unset(_OC_OPEN_MPI_SYMBOL_EXISTS CACHE)
    unset(_OC_MVAPICH_MPI_SYMBOL_EXISTS CACHE)
    unset(_OC_MSMPI_MPI_SYMBOL_EXISTS CACHE)
    unset(_OC_MPICH_MPI_SYMBOL_EXISTS CACHE)
    check_symbol_exists(I_MPI_VERSION "${INCLUDE_DIRECTORY}/mpi.h" _OC_INTEL_MPI_SYMBOL_EXISTS)
    if(${_OC_INTEL_MPI_SYMBOL_EXISTS})
      set(_MPI_LIBRARY_TYPE "Intel")
    else()
      check_symbol_exists(OPEN_MPI "${INCLUDE_DIRECTORY}/mpi.h" _OC_OPEN_MPI_SYMBOL_EXISTS)
      if(${_OC_OPEN_MPI_SYMBOL_EXISTS})
        set(_MPI_LIBRARY_TYPE "OpenMPI")
      else()
        check_symbol_exists(MVAPICH2_VERSION "${INCLUDE_DIRECTORY}/mpi.h" _OC_MVAPICH_MPI_SYMBOL_EXISTS)
        if(${_OC_MVAPICH_MPI_SYMBOL_EXISTS})
          set(_MPI_LIBRARY_NAME "MVAPICH")
        else()
          check_symbol_exists(MSMPI_VER "${INCLUDE_DIRECTORY}/mpi.h" _OC_MSMPI_MPI_SYMBOL_EXISTS)
          if(${_OC_MSMPI_MPI_SYMBOL_EXISTS})
            set(_MPI_LIBRARY_TYPE "MSMPI")
          else()
            # Check for MPICH last as a number of other MPI implementations are based off it and have MPICH defines
            check_symbol_exists(MPICH_VERSION "${INCLUDE_DIRECTORY}/mpi.h" _OC_MPICH_MPI_SYMBOL_EXISTS)
            if(${_OC_MPICH_MPI_SYMBOL_EXISTS})
              set(_MPI_LIBRARY_TYPE "MPICH")
 	    else()
              set(_MPI_LIBRARY_TYPE "Unknown")
	    endif()
	  endif()
        endif()
      endif()
    endif()
    unset(_OC_INTEL_MPI_SYMBOL_EXISTS CACHE)
    unset(_OC_OPEN_MPI_SYMBOL_EXISTS CACHE)
    unset(_OC_MVAPICH_MPI_SYMBOL_EXISTS CACHE)
    unset(_OC_MSMPI_MPI_SYMBOL_EXISTS CACHE)
    unset(_OC_MPICH_MPI_SYMBOL_EXISTS CACHE)
  else()
    OCCMakeFatalError("The MPI header file ${INCLUDE_DIRECTORY}/mpi.h does not exist.")
  endif()

  OCCMakeDebug("MPI library type from ${INCLUDE_DIRECTORY} is ${_MPI_LIBRARY_TYPE}." 1)

  set(${MPI_LIBRARY_TYPE} ${_MPI_LIBRARY_TYPE} PARENT_SCOPE)

endfunction()

function(OCSetMPILibrary MPI_LIBRARY_NAME)

  if(NOT ${OC_MPI_NONE})
    OCCMakeDebug("Trying to find a MPI library." 1)
    set(_OC_MPI_FIND_COUNT 0)
    set(_OC_MPI_FIND_CONTINUE 1)
    while((${_OC_MPI_FIND_CONTINUE}) AND (${_OC_MPI_FIND_COUNT} LESS_EQUAL 2))
      math(EXPR _OC_MPI_FIND_COUNT "${_OC_MPI_FIND_COUNT}+1")
      OCCMakeDebug("Find Loop: _OC_MPI_FIND_CONTINUE = ${_OC_MPI_FIND_CONTINUE}, _OC_MPI_FIND_COUNT = ${_OC_MPI_FIND_COUNT}" 1)
      find_package(MPI)
      set(_OC_MPI_FOUND ${MPI_FOUND})
      if(${MPI_FOUND})
        OCCMakeDebug("Candidate MPI library found. MPI_C_INCLUDE_DIRS = ${MPI_C_INCLUDE_DIRS}." 1)
	OCDetermineMPILibraryType(${MPI_C_INCLUDE_DIRS} _MPI_LIBRARY_TYPE)
	if(${_MPI_LIBRARY_TYPE} STREQUAL "Intel")
	  if(${OC_MPI_INTEL} OR ${OC_MPI_UNSPECIFIED})
            set(_OC_MPI_FIND_CONTINUE 0)
            set(OC_MPI_INTEL_FOUND ON PARENT_SCOPE)
            set(_MPI_LIBRARY_NAME "Intel")
	  else()
	    # Set hints for Intel and try again
	  endif()
	elseif(${_MPI_LIBRARY_TYPE} STREQUAL "MPICH")
	  if(${OC_MPI_MPICH} OR ${OC_MPI_UNSPECIFIED})
            set(_OC_MPI_FIND_CONTINUE 0)
            set(OC_MPI_MPICH_FOUND ON PARENT_SCOPE)
            set(_MPI_LIBRARY_NAME "MPICH")
	  else()
	    # Set hints for MPICH and try again
	  endif()
	elseif(${_MPI_LIBRARY_NAME} STREQUAL "MSMPI")
	  if(${OC_MPI_MSMPI} OR ${OC_MPI_UNSPECIFIED})
            set(_OC_MPI_FIND_CONTINUE 0)
            set(OC_MPI_MSMPI_FOUND ON PARENT_SCOPE)
            set(_MPI_LIBRARY_NAME "MSMPI")
	  else()
	    # Set hints for MSMPI and try again
	  endif()
	elseif(${_MPI_LIBRARY_NAME} STREQUAL "MVAPICH")
	  if(${OC_MPI_MVAPICH} OR ${OC_MPI_UNSPECIFIED})
            set(_OC_MPI_FIND_CONTINUE 0)
            set(OC_MPI_MVAPICH_FOUND ON PARENT_SCOPE)
            set(_MPI_LIBRARY_NAME "MVAPICH")
	  else()
	    # Set hints for MVAPICH and try again
	  endif()
	elseif(${_MPI_LIBRARY_NAME} STREQUAL "OpenMPI")
	  if(${OC_MPI_OPENMPI} OR ${OC_MPI_UNSPECIFIED})
            set(_OC_MPI_FIND_CONTINUE 0)
            set(OC_MPI_OPENMPI_FOUND ON PARENT_SCOPE)
            set(_MPI_LIBRARY_NAME "OpenMPI")
	  else()
	    # Set hints for OpenMPI and try again
	  endif()
	elseif(${_MPI_LIBRARY_NAME} STREQUAL "Unknown")
	  if(${OC_MPI_UNSPECIFIED})
            set(_OC_MPI_FIND_CONTINUE 0)
            set(_MPI_LIBRARY_NAME "Unknown")
	  endif()
	else()
          OCCMakeFatalError("Unknown MPI library name of ${_MPI_LIBRARY_NAME}.")
	endif()
      else()
        OCCMakeFatalError("Could not find any MPI libraries.")
      endif()
    endwhile()
  else()
    set(_MPI_LIBRARY_NAME "None")
  endif()
  
  OCCMakeDebug("MPI library name ${_MPI_LIBRARY_NAME}." 1)
  
  set(${MPI_LIBRARY_NAME} ${_MPI_LIBRARY_NAME} PARENT_SCOPE)
  
endfunction()
