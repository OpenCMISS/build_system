#[=======================================================================[.rst:
OpenCMISS Architecture Path
---------------------------

In order to allow simultaneous installation of builds for various
configuration and choices, OpenCMISS uses an *architecture path* to
store produced files, libraries and headers into separate directories.

The architecture path is composed of the following elements (in that order)

:architecture: The system architecture, e.g. :literal:`x86_64_linux`

:toolchain: The toolchain info for the build.  This path is composed
following the pattern
:path:`/<mnemonic>-C<c_version>-<mnemonic>-F<fortran_version>`, where
*mnemonic* stands for one of the items below, *c_version* the version
of the C compiler and *fortran_version* the version of the Fortran
compiler.

:instrumenation: Any instrumentation systems for the build. The
architecture path is composed of the following pattern
:path:`/<mnemonic>`. Otherwise, the path element is skipped.

:multithreading: If :var:`OC_MULTITHREADING` is enabled, this segment
is :path:`/<multithreading-type>`.  Otherwise, the path element is skipped.

:mpi: Denotes the used MPI implementation along with the mpi build
type.  The path element is composed as
:path:`/mpi-<mnemonic>-<mpi-build-type>`, where
*mnemonic*/*mpi-build-type* contains the lower-case value of the
:var:`OC_MPI_LIBRARY_NAME`/:var:`OC_MPI_BUILD_TYPE` variable,
respectively. Moreover, a path element :path:`mpi-none` is used for any
component that does not use MPI at all or if OC_MPI_LIBRARY_NAME is none.

:buildtype: Path element for the current overall build type determined
by :var:`OC_BUILD_TYPE`.  This is for single-configuration platforms
only - multiconfiguration environments like Visual Studio have their
own way of dealing with build types.

For example, a typical architecture path looks like::

x86_64_linux/gnu-C4.6-gnu-F4.6/mpi-openmpi-release/release

This function returns two architecture paths, the first for mpi-unaware
applications (NOMPI_ARCH_PATH) and the second for applications that link
against an mpi implementation (MPI_ARCH_PATH)

Requires the extra (=non-cmake default) variables: MPI

#]=======================================================================]

# See also: OCGetSystemPartArchitecturePath, OCGetMPIPartArchitecturePath
function(OCGetArchitecturePath NOMPI_ARCH_PATH MPI_ARCH_PATH)
    
    # Get compiler part
    OCGetCompilerPartArchitecturePath(_COMPILER_PART)

    OCGetArchitecturePathGivenCompilerPart(${_COMPILER_PART} _NOMPI_ARCH_PATH _MPI_ARCH_PATH)

    # Append to desired variable
    set(${NOMPI_ARCH_PATH} "${_NOMPI_ARCH_PATH}" PARENT_SCOPE)
    set(${MPI_ARCH_PATH} "${_MPI_ARCH_PATH}" PARENT_SCOPE)

    OCCMakeDebug("Using a MPI full architecture path of '${_MPI_ARCH_PATH}'." 1)
    OCCMakeDebug("Using a non MPI full architecture path of '${_NOMPI_ARCH_PATH}'." 1)
    
    # Clear variables
    unset(_COMPILER_PART)
    unset(_NOMPI_ARCH_PATH)
    unset(_MPI_ARCH_PATH)
    
endfunction()

# This function returns two architecture paths, the first for mpi-unaware applications (ARCH_PATH_NOMPI)
# and the second for applications that link against an mpi implementation (ARCH_PATH_MPI) when the 
# compiler part of the architecture path is given
#
function(OCGetArchitecturePathGivenCompilerPart COMPILER_ARCH_PATH ARCH_PATH_NOMPI ARCH_PATH_MPI)
  
    # Get the system architecture path
    OCGetSystemPartArchitecturePath(_SYSTEM_ARCH_PATH)

    # Don't get compiler part

    # Get instrumentation part
    OCGetInstrumentationPartArchitecturePath(_INSTRUMENTATION_ARCH_PATH _NO_INSTRUMENTATION_ARCH_PATH)

    # Get multithreading part
    OCGetMultithreadingPartArchitecturePath(_MULTITHREADING_ARCH_PATH _NO_MULTITHREADING_ARCH_PATH)

    # Get the MPI Part
    OCGetMPIPartArchitecturePath(_MPI_ARCH_PATH _NO_MPI_ARCH_PATH)

    set(_ARCH_PATH_MPI "${_SYSTEM_ARCH_PATH}/${COMPILER_ARCH_PATH}${_INSTRUMENTATION_ARCH_PATH}${_MULTITHREADING_ARCH_PATH}/${_MPI_ARCH_PATH}")
    set(_ARCH_PATH_NOMPI "${_SYSTEM_ARCH_PATH}/${COMPILER_ARCH_PATH}${_INSTRUMENTATION_ARCH_PATH}${_MULTITHREADING_ARCH_PATH}/${_NO_MPI_ARCH_PATH}")

    # Append to desired variable
    set(${ARCH_PATH_MPI} ${_ARCH_PATH_MPI} PARENT_SCOPE)
    set(${ARCH_PATH_NOMPI} ${_ARCH_PATH_NOMPI} PARENT_SCOPE)

    # Clear variables
    unset(_SYSTEM_ARCH_PATH)
    unset(_COMPILER_ARCH_PATH)
    unset(_INTRUMENTATION_ARCH_PATH)
    unset(_NO_INTRUMENTATION_ARCH_PATH)
    unset(_MULTITHREADING_ARCH_PATH)
    unset(_NO_MULTITHREADING_ARCH_PATH)
    unset(_MPI_ARCH_PATH)
    unset(_NO_MPI_ARCH_PATH)
    unset(_ARCH_PATH_MPI)
    unset(_ARCH_PATH_NOMPI)
    
endfunction()

# This function assembles the MPI part of the architecture path.
# This part is made up of mpi-[OC_MPI_LIBRARY_NAME][OC_MPI_BUILD_TYPE]
# if building our own MPI otherwise it is made up of
# mpi-[OC_MPI_LIBRARY_NAME]-system.
function(OCGetMPIPartArchitecturePath MPI_ARCH_PATH NO_MPI_ARCH_PATH)
  
  # MPI version information
  set(_NO_MPI_ARCH_PATH "mpi-none")
  if(OC_MPI_NONE)
    set(_MPI_ARCH_PATH "${_NO_MPI_ARCH_PATH}")
  else()
    # Add the build type of MPI to the architecture path - we obtain different libraries
    # for different mpi build types
    if(OC_BUILD_OWN_MPI)
      string(TOLOWER "${OC_MPI_BUILD_TYPE}" _LOWERCASE_MPI_BUILD_TYPE)
    else ()
      set(_LOWERCASE_MPI_BUILD_TYPE system)
    endif ()
    string(TOLOWER "${OC_MPI_LIBRARY_NAME}" _LOWERCASE_MPI_LIBRARY_NAME)
    set(_MPI_ARCH_PATH "mpi-${_LOWERCASE_MPI_LIBRARY_NAME}-${_LOWERCASE_MPI_BUILD_TYPE}")
  endif()
  
  # Append to desired variable
  set(${MPI_ARCH_PATH} ${_MPI_ARCH_PATH} PARENT_SCOPE)
  set(${NO_MPI_ARCH_PATH} ${_NO_MPI_ARCH_PATH} PARENT_SCOPE)
  
  OCCMakeDebug("Using a MPI architecture path of '${_MPI_ARCH_PATH}'." 2)
  OCCMakeDebug("Using a no MPI architecture path of '${_NO_MPI_ARCH_PATH}'." 2)
  
  # Clear variables
  unset(_LOWERCASE_MPI_BUILD_TYPE)
  unset(_LOWERCASE_MPI_LIBRARY_NAME)
  unset(_MPI_ARCH_PATH)
  unset(_NO_MPI_ARCH_PATH)
  
endfunction()

# This function assembles the multithreading part of the architecture path.
#
function(OCGetMultithreadingPartArchitecturePath MULTITHREADING_ARCH_PATH NO_MULTITHREADING_ARCH_PATH)
  
  # Multithreading
  set(_NO_MULTITHREADING_ARCH_PATH )
  if(OC_MULTITHREADING_NONE)
    set(_MULTITHREADING_ARCH_PATH "${_NO_MULTITHREADING_ARCH_PATH}")
  elseif(OC_MULTITHREADING_OPENACC)
    set(_MULTITHREADING_ARCH_PATH "/openacc")
  elseif(OC_MULTITHREADING_OPENMP)
    set(_MULTITHREADING_ARCH_PATH "/openmp")
  else()
    set(_MULTITHREADING_ARCH_PATH "${_NO_MULTITHREADING_ARCH_PATH}")
    OCCMakeWarning("Unknown multithreading option. Ignoring.")
  endif()
    
  # Append to desired variable
  set(${MULTITHREADING_ARCH_PATH} "${_MULTITHREADING_ARCH_PATH}" PARENT_SCOPE)
  set(${NO_MULTITHREADING_ARCH_PATH} "${_NO_MULTITHREADING_ARCH_PATH}" PARENT_SCOPE)
  
  OCCMakeDebug("Using a multithreading architecture path of '${_MULTITHREADING_ARCH_PATH}'." 2)
  OCCMakeDebug("Using a no multithreading architecture path of '${_NO_MULTITHREADING_ARCH_PATH}'." 2)
  
  # Clear variables
  unset(_MULTITHREADING_ARCH_PATH)
  unset(_NO_MULTITHREADING_ARCH_PATH)
  
endfunction()

# This function assembles the instrumentation part of the architecture path.
# This part is made up of [OC_INSTRUMENTATION]
#
function(OCGetInstrumentationPartArchitecturePath INSTRUMENTATION_ARCH_PATH NO_INSTRUMENTATION_ARCH_PATH)

  # Instrumentation
  set(_NO_INSTRUMENTATION_ARCH_PATH )
  if(OC_INSTRUMENTATION_GPROF)
    set(_INSTRUMENTATION_ARCH_PATH "/gprof")
  elseif(OC_INSTRUMENTATION_NONE)
    set(_INSTRUMENTATION_ARCH_PATH "${_NO_INSTRUMENTATION_ARCH_PATH}")
  elseif(OC_INSTRUMENTATION_SCOREP)
    set(_INSTRUMENTATION_ARCH_PATH "/scorep")
  elseif(OC_INSTRUMENTATION_VTUNE)
    set(_INSTRUMENTATION_ARCH_PATH "/vtune")
  else()
    set(_INSTRUMENTATION_ARCH_PATH "${_NO_INSTRUMENTATION_ARCH_PATH}")
    OCCMakeWarning("Unknown instrumentation option. Ignoring.")
  endif()
  
  # Append to desired variable
  set(${INSTRUMENTATION_ARCH_PATH} "${_INSTRUMENTATION_ARCH_PATH}" PARENT_SCOPE)
  set(${NO_INSTRUMENTATION_ARCH_PATH} "${_NO_INSTRUMENTATION_ARCH_PATH}" PARENT_SCOPE)
  
  OCCMakeDebug("Using an instrumentation architecture path of '${_INSTRUMENTATION_ARCH_PATH}'." 2)
  OCCMakeDebug("Using a no instrumentation architecture path of '${_NO_INSTRUMENTATION_ARCH_PATH}'." 2)
    
  # Clear variables
  unset(_INSTRUMENTATION_ARCH_PATH)
  unset(_NO_INSTRUMENTATION_ARCH_PATH)
  
endfunction()

# This function assembles the system part of the architecture path
# This part is made up of [SYSTEM_NAME][SYSTEM_PROCESSOR]
#
function(OCGetSystemPartArchitecturePath SYSTEM_ARCH_PATH)
    
  # Architecture/System
  string(TOLOWER ${CMAKE_SYSTEM_NAME} _LOWERCASE_CMAKE_SYSTEM_NAME)
  set(_SYSTEM_ARCH_PATH ${CMAKE_SYSTEM_PROCESSOR}-${_LOWERCASE_CMAKE_SYSTEM_NAME})
  
  # Bit/Adressing bandwidth
  #if(ABI)
  #  set(_SYSTEM_ARCH_PATH ${_SYSTEM_ARCH_PATH}/${ABI}bit)
  #endif()
  
  # Append to desired variable
  set(${SYSTEM_ARCH_PATH} ${_SYSTEM_ARCH_PATH} PARENT_SCOPE)
    
  OCCMakeDebug("Using a system architecture path of '${_SYSTEM_ARCH_PATH}'." 2)
  
  # Clear variables
  unset(_SYSTEM_ARCH_PATH)
  
endfunction()

# This function assembles the compiler part of the architecture path
# This part is made up of [C_COMPILER_NAME][C_COMPILER_VERSION][Fortran_COMPILER_NAME][Fortran_COMPILER_VERSION]
function(OCGetCompilerPartArchitecturePath COMPILER_ARCH_PATH)
  
  # Form the C compiler part
  # Get the C compiler name
  if(BORLAND )
    set(_C_COMPILER_NAME "borland" )
  elseif(CMAKE_C_COMPILER_ID MATCHES Clang)
    set(_C_COMPILER_NAME "clang")
  elseif( CYGWIN )
    set(_C_COMPILER_NAME "cygwin")
  elseif(CMAKE_COMPILER_IS_GNUCC)
    set(_C_COMPILER_NAME "gnu")
  elseif(CMAKE_C_COMPILER_ID MATCHES Intel 
      OR CMAKE_CXX_COMPILER_ID MATCHES Intel)
    set(_C_COMPILER_NAME "intel")
  elseif(MINGW)
    set(_C_COMPILER_NAME "mingw" )
  elseif(MSVC OR MSVC_IDE OR MSVC60 OR MSVC70 OR MSVC71 OR MSVC80 OR CMAKE_COMPILER_2005 OR MSVC90 )
    set(_C_COMPILER_NAME "msvc" )
  elseif(MSYS )
    set(_C_COMPILER_NAME "msys" )
  elseif(CMAKE_C_COMPILER_ID MATCHES PGI)
    set(_C_COMPILER_NAME "pgi")
  elseif(WATCOM )
    set(_C_COMPILER_NAME "watcom" )
  else()
    set(_C_COMPILER_NAME "unknown")       
  endif()
	
  # Get compiler major + minor versions
  set(_COMPILER_VERSION_REGEX "^[0-9]+\\.[0-9]+")
  string(REGEX MATCH ${_COMPILER_VERSION_REGEX}
    _C_COMPILER_VERSION_MM "${CMAKE_C_COMPILER_VERSION}")
  # Form C part
  set(_C_COMPILER_ARCH_PATH "${_C_COMPILER_NAME}-C${_C_COMPILER_VERSION_MM}")
  
  # Also for the fortran compiler (if exists)
  set(_Fortran_COMPILER_ARCH_PATH "")
  if (CMAKE_Fortran_COMPILER_ID)
    # Get the Fortran compiler name
    if(CMAKE_Fortran_COMPILER_ID MATCHES Absoft)
      set(_Fortran_COMPILER_NAME "absoft")
    elseif(CMAKE_Fortran_COMPILER_ID MATCHES Ccur)
      set(_Fortran_COMPILER_NAME "ccur")
    elseif(CMAKE_C_COMPILER_ID MATCHES Flang)
      set(_Fortran_COMPILER_NAME "flang")
    elseif(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
      set(_Fortran_COMPILER_NAME "gnu")
    elseif(CMAKE_Fortran_COMPILER_ID MATCHES G95)
      set(_Fortran_COMPILER_NAME "g95")
    elseif(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
      set(_Fortran_COMPILER_NAME "intel")
    elseif(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
      set(_Fortran_COMPILER_NAME "pgi")
    else()
      set(_Fortran_COMPILER_NAME "unknown")       
    endif()
    string(REGEX MATCH ${_COMPILER_VERSION_REGEX}
      _Fortran_COMPILER_VERSION_MM "${CMAKE_Fortran_COMPILER_VERSION}")
    set(_Fortran_COMPILER_ARCH_PATH "-${_Fortran_COMPILER_NAME}-F${_Fortran_COMPILER_VERSION_MM}")
  endif()
  
  set(_COMBINED_COMPILER_ARCH_PATH "${_C_COMPILER_ARCH_PATH}${_Fortran_COMPILER_ARCH_PATH}")
  
  # Combine C and Fortran part into e.g. gnu-C4.8-intel-F4.5
  set(${COMPILER_ARCH_PATH} ${_COMBINED_COMPILER_ARCH_PATH} PARENT_SCOPE)
  
  OCCMakeDebug("Using a compiler architecture path of '${_COMBINED_COMPILER_ARCH_PATH}'." 2)
  
  # Clear variables
  unset(_C_COMPILER_ARCH_PATH)
  unset(_C_COMPILER_NAME)
  unset(_Fortran_COMPILER_ARCH_PATH)
  unset(_Fortran_COMPILER_NAME)
  unset(_COMPILER_VERSION_REGEX)
  unset(_COMBINED_COMPILER_ARCH_PATH)
  
endfunction()

# Returns the build type arch path element.
# useful only for single-configuration builds, '.' otherwise.
function(OCetBuildTypePathElem BUILD_TYPE_ARCH_PATH)
  
  # Build type
  if(OC_HAVE_MULTICONFIG_ENV)
    set(_BUILD_TYPE_ARCH_PATH .)
  else()
    string(TOLOWER ${CMAKE_BUILD_TYPE} _BUILD_TYPE_ARCH_PATH)
  endif()
  set(${BUILD_TYPE_ARCH_PATH} ${_BUILD_TYPE_ARCH_PATH} PARENT_SCOPE)
   
  OCCMakeDebug("Using a build type architecture path of '${_BUILD_TYPE_ARCH_PATH}'." 2)
  
  # Clear variables
  unset(_BUILD_TYPE_ARCH_PATH)
  
endfunction()
