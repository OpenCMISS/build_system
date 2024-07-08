#[=======================================================================[.rst:
OpenCMISS Toolchains
--------------------

All functions related to OpenCMISS_TOOLCHAIN 

All the short mnemonics for the toolchain are:
        
:gnu: The GNU toolchain
:oldintel: The old Intel toolchain
:intel: The Intel toolchain
:llvm: The LLVM toolchain (clang and flang)
:mingw: The MinGW toolchain for Windows environments
:msvc: MS Visual Studio compilers
:unspecified: Unspecified toolchain

#]=======================================================================]

function(OCSetToolchain ROOT_DIRECTORY)
  set(OC_TOOLCHAIN_GNU OFF PARENT_SCOPE)
  set(OC_TOOLCHAIN_INTEL OFF PARENT_SCOPE)
  set(OC_TOOLCHAIN_OLD_INTEL OFF PARENT_SCOPE)
  set(OC_TOOLCHAIN_LLVM OFF PARENT_SCOPE)
  set(OC_TOOLCHAIN_MINGW OFF PARENT_SCOPE)
  set(OC_TOOLCHAIN_UNSPECIFIED ON PARENT_SCOPE)
  if(DEFINED OpenCMISS_TOOLCHAIN)
    OCCMakeDebug("Defining compilers using the OpenCMISS toolchain, OpenCMISS_TOOLCHAIN = ${OpenCMISS_TOOLCHAIN}." 1)
    string(TOLOWER ${OpenCMISS_TOOLCHAIN} _LOWERCASE_TOOLCHAIN )
  else()
    if(DEFINED ENV{OpenCMISS_TOOLCHAIN})
     OCCMakeDebug("Defining compilers using the OpenCMISS toolchain environment variable, OpenCMISS_TOOLCHAIN = $ENV{OpenCMISS_TOOLCHAIN}." 1)
     string(TOLOWER "$ENV{OpenCMISS_TOOLCHAIN}" _LOWERCASE_TOOLCHAIN )
    else()
      set(_LOWERCASE_TOOLCHAIN "unspecified")
    endif() 
  endif()
  
  if(_LOWERCASE_TOOLCHAIN STREQUAL "gnu")
    OCCMakeDebug("Trying to find the GNU compilers..." 1)
    set(OC_TOOLCHAIN "GNU" CACHE STRING "OpenCMISS toolchain" FORCE)
    set(OC_TOOLCHAIN_GNU ON PARENT_SCOPE)
    set(CMAKE_TOOLCHAIN_FILE "${ROOT_DIRECTORY}/Toolchains/OCGNUToochain.cmake" FORCE)
  elseif(_LOWERCASE_TOOLCHAIN STREQUAL "intel")
    set(OC_TOOLCHAIN "Intel" CACHE STRING "OpenCMISS toolchain" FORCE)
    OCCMakeDebug("Trying to find the Intel compilers..." 1)
    set(OC_TOOLCHAIN_INTEL ON PARENT_SCOPE)
    find_program(CMAKE_C_COMPILER NAMES icx REQUIRED)
    find_program(CMAKE_CXX_COMPILER NAMES icpx REQUIRED)
    find_program(CMAKE_Fortran_COMPILER NAMES ifx REQUIRED)
    set(CMAKE_TOOLCHAIN_FILE "${ROOT_DIRECTORY}/Toolchains/OCIntelToochain.cmake" FORCE)
  elseif(_LOWERCASE_TOOLCHAIN STREQUAL "oldintel")
    OCCMakeDebug("Trying to find the old Intel compilers..." 1)
    set(OC_TOOLCHAIN "OldIntel" CACHE STRING "OpenCMISS toolchain" FORCE)
    set(OC_TOOLCHAIN_OLD_INTEL ON PARENT_SCOPE)
    set(CMAKE_TOOLCHAIN_FILE "${ROOT_DIRECTORY}/Toolchains/OCOldIntelToochain.cmake" FORCE)
  elseif(_LOWERCASE_TOOLCHAIN STREQUAL "llvm")
    OCCMakeDebug("Trying to find the LLVM compilers..." 1)
    set(OC_TOOLCHAIN "LLVM" CACHE STRING "OpenCMISS toolchain" FORCE)
    set(OC_TOOLCHAIN_LLVM ON PARENT_SCOPE)
    set(CMAKE_TOOLCHAIN_FILE "${ROOT_DIRECTORY}/Toolchains/OCLLVMToochain.cmake" FORCE)
  elseif(_LOWERCASE_TOOLCHAIN STREQUAL "mingw")
    OCCMakeDebug("Trying to find the MinGW compilers..." 1)
    set(OC_TOOLCHAIN "MinGW" CACHE STRING "OpenCMISS toolchain" FORCE)
    set(OC_TOOLCHAIN_MINGW ON PARENT_SCOPE)
    set(CMAKE_TOOLCHAIN_FILE "${ROOT_DIRECTORY}/Toolchains/OCGNUToochain.cmake" FORCE)
  elseif(_LOWERCASE_TOOLCHAIN STREQUAL "msvc")
    OCCMakeDebug("Trying to find the MSVC compilers..." 1)
    set(OC_TOOLCHAIN "MSVC" CACHE STRING "OpenCMISS toolchain" FORCE)
    set(OC_TOOLCHAIN_MSVC ON PARENT_SCOPE)
    set(CMAKE_TOOLCHAIN_FILE "${ROOT_DIRECTORY}/Toolchains/OCMSVCToochain.cmake" FORCE)
  elseif(_LOWERCASE_TOOLCHAIN STREQUAL "unspecified")
    OCCMakeDebug("Compilers are unspecified..." 1)
    set(OC_TOOLCHAIN "Unspecified" CACHE STRING "OpenCMISS toolchain" FORCE)
    set(OC_TOOLCHAIN_UNSPECIFIED ON PARENT_SCOPE)
  else()
    OCCMakeMessage(WARNING "The toolchain of ${_LOWERCASE_TOOLCHAIN} is unknown. Defaulting to unspecified.")
    set(OC_TOOLCHAIN "Unspecifed" CACHE STRING "OpenCMISS toolchain" FORCE)
    set(OC_TOOLCHAIN_UNSPECIFIED ON PARENT_SCOPE)
  endif()
  
  unset(_LOWERCASE_TOOLCHAIN)

  OCCMakeDebug("Using a toolchain of ${OC_TOOLCHAIN}." 1)
  
endfunction()

# Macro for adding a compile flag for a certain language (and optionally build type)
# Also performs a check if the current compiler supports the flag
#
# This needs to be included AFTER the MPIConfig as the used MPI mnemonic is used here, too!
macro(OCCompilerAddFlag VALUE LANGUAGE)
  
  OCCompilerGetFlagCheckVariableName(${VALUE} ${LANGUAGE} _CHK_VAR)
  if(${LANGUAGE} STREQUAL "C")
    check_c_compiler_flag("${VALUE}" ${_CHK_VAR})
  elseif(${LANGUAGE} STREQUAL "CXX")
    check_cxx_compiler_flag("${VALUE}" ${_CHK_VAR})
  elseif(${LANGUAGE} STREQUAL "Fortran")
    check_fortran_compiler_flag("${VALUE}" ${_CHK_VAR})
  endif()
  # Only add the flag if the check succeeded
  if(${_CHK_VAR})
    set(_FLAGS_VARNAME CMAKE_${LANGUAGE}_FLAGS)
    if (NOT "${ARGV2}" STREQUAL "")
      set(_FLAGS_VARNAME ${_FLAGS_VARNAME}_${ARGV2})
    endif()
    set(${_FLAGS_VARNAME} "${${_FLAGS_VARNAME}} ${VALUE}")
  endif()

  # Clear variables
  unset(_CHK_VAR)
  unset(_FLAGS_VARNAME)
  
endmacro()

macro(OCCompilerAddFlagAll VALUE)
  
  foreach(lang ${OC_ACTIVE_LANGUAGES})
    OCCompilerAddFlag(${VALUE} ${lang} ${ARGV1})
  endforeach()
  
endmacro()

function(OCCompilerGetFlagCheckVariableName FLAG LANGUAGE RESULT_VAR)
  
  if(${FLAG} MATCHES "^-.*")
    string(SUBSTRING ${FLAG} 1 -1 FLAG) 
  endif()
  string(REGEX REPLACE "[^a-zA-Z0-9 ]" "_" RES ${FLAG})
  set(${RESULT_VAR} ${LANGUAGE}_COMPILER_FLAG_${RES} PARENT_SCOPE)
  
endfunction()

if(C IN_LIST OC_ACTIVE_LANGUAGES)
  include(CheckCCompilerFlag)
endif()
if(CXX IN_LIST OC_ACTIVE_LANGUAGES)
  include(CheckCXXCompilerFlag)
endif ()
if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
  include(CheckFortranCompilerFlag)
endif()

# ABI detection - no crosscompiling implemented yet, so will use native
#if(NOT ABI)
#  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
#    set(ABI 64)
#  else()
#    set(ABI 32)
#  endif()
#endif()
#foreach(lang ${OC_ACTIVE_LANGUAGES})
#  set(CMAKE_${lang}_FLAGS "-m${ABI} ${CMAKE_${lang}_FLAGS}")
#endforeach()

if(CMAKE_COMPILER_IS_GNUC OR "${CMAKE_C_COMPILER_ID}" STREQUAL "GNU" OR MINGW)
  
  OCCMakeDebug("Adding GNU compiler flags." 1)
  
  # ABI Flag -m$(ABI)
    
  # These flags are set by CMake by default anyways.
  
  # Release    
  OCCompilerAddFlagAll("-Ofast" RELEASE)        
  
  # Debug
  OCCompilerAddFlagAll("-O0" DEBUG)
  
  if(OC_WARN_ALL)
    OCCompilerAddFlagAll("-Wall" DEBUG)
  endif()
  if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
    OCCompilerAddFlag("-fbacktrace" Fortran DEBUG)
  endif()
  # Compiler minor >= 8
  if(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER 4.7)
    OCCompilerAddFlag("-Warray-temporaries" Fortran DEBUG)
    OCCompilerAddFlag("-Wextra" Fortran DEBUG)
    OCCompilerAddFlag("-Wsurprising" Fortran DEBUG)
    OCCompilerAddFlag("-Wrealloc-lhs-all" Fortran DEBUG)
  endif()
  
  if(OC_CHECK_ALL)
    # Compiler version 4.4
    if(CMAKE_Fortran_COMPILER_VERSION VERSION_EQUAL 4.4)
      OCCompilerAddFlag("-fbounds-check" Fortran DEBUG)
    endif()
    # Compiler minor >= 8
    if(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER 4.7)
      OCCompilerAddFlag("-finit-real=snan" Fortran DEBUG)
    endif()
    # Newer versions
    if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-fcheck=all" Fortran DEBUG)
      OCCompilerAddFlag("-ffpe-trap=invalid,zero,overflow" Fortran DEBUG)
    endif()
  endif()
  
  if(OC_INSTRUMENTATION_GPROF)
    
    OCCMakeDebug("Adding gprof instrumentation flags." 2)
    
    ##TODO: Why are we not using the add flags function?
    foreach(lang C CXX Fortran)
      set(CMAKE_${lang}_FLAGS_RELEASE "${CMAKE_${lang}_FLAGS_RELEASE} -g -pg -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS_DEBUG "${CMAKE_${lang}_FLAGS_DEBUG} -g -pg -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -g -pg -fno-omit-frame-pointer")
    endforeach()
    
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg -g")
    
  endif()
  
elseif ("${CMAKE_C_COMPILER_ID}" STREQUAL "Intel" OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
  
  OCCMakeDebug("Adding Intel compiler flags." 1)
  
  # ABI Flag -m$(ABI)
  
  # CMake default anyways
  #OCCompilerAddFlagAll("-O3" RELEASE)
  
  # Somehow CMake does not add the appropriate C-standard flags even though
  # the C_STANDARD variable is set. Well do it manually for now.
  #
  # EDIT: Unfortunately, this does not work out for all components. e.g. the gdcm build fails
  # with that switched on. Currently, i've added that flag for the superlu_dist package only. 
  #if(UNIX)
  #  OCCompilerAddFlag("-std=c99" C)
  #endif()
    
  # Release
  # OCCompilerAddFlagAll("-fast" RELEASE)
  # Release - needed for Intel Parallel Studio 2017+
  if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
    OCCompilerAddFlagAll("-fPIE" Fortran RELEASE)
  endif()
  # Release - added for vector optimisation
  check_c_compiler_flag(AVX _HAVE_AVX_FLAG)
  if(_HAVE_AVX_FLAG)
    OCCompilerAddFlagAll("-xAVX" RELEASE)
  endif()
    
  # Debug
  OCCompilerAddFlagAll("-traceback" DEBUG)
  if(OC_WARN_ALL)
    if(C IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-Wall" C DEBUG)
    endif()
    if(CXX IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-Wall" CXX DEBUG)
    endif()
    if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-warn all" Fortran DEBUG)
    endif()
  endif()
  if(OC_CHECK_ALL)
    foreach(lang C CXX)
      if(lang IN_LIST OC_ACTIVE_LANGUAGES)
        OCCompilerAddFlag("-Wcheck" ${lang} DEBUG)
        OCCompilerAddFlag("-fp-trap=common" ${lang} DEBUG)
        OCCompilerAddFlag("-ftrapuv" ${lang} DEBUG)
      endif()
    endforeach()
    if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-check all" Fortran DEBUG)
      OCCompilerAddFlag("-fpe-all=0" Fortran DEBUG)
      OCCompilerAddFlag("-ftrapuv" Fortran DEBUG)
    endif()
  endif()

  if(OC_INSTRUMENTATION_VTUNE)
    
    OCCMakeDebug("Adding vtune instrumentation flags." 2)
    
    ##TODO: Why are we not using the add flags function?
    foreach(lang C CXX Fortran)
      set(CMAKE_${lang}_FLAGS_RELEASE "${CMAKE_${lang}_FLAGS_RELEASE} -g -shared-intel -debug inline-debug-info -D TBB_USE_THREADING_TOOLS -qopenmp-link dynamic -parallel-source-info=2 -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS_DEBUG "${CMAKE_${lang}_FLAGS_DEBUG} -g -shared-intel -debug inline-debug-info -D TBB_USE_THREADING_TOOLS -qopenmp-link dynamic -parallel-source-info=2 -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -g -shared-intel -debug inline-debug-info -D TBB_USE_THREADING_TOOLS -qopenmp-link dynamic -parallel-source-info=2 -fno-omit-frame-pointer")
    endforeach()
    
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -qopenmp -g -shared-intel -qopenmp-link dynamic -tcollect")
    
  elseif(OC_INSTRUMENTATION_GPROF)
    
    OCCMakeDebug("Adding gprof instrumentation flags." 2)
    
    foreach(lang C CXX Fortran)
      set(CMAKE_${lang}_FLAGS_RELEASE "${CMAKE_${lang}_FLAGS_RELEASE} -g -pg -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS_DEBUG "${CMAKE_${lang}_FLAGS_DEBUG} -g -pg -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -g -pg -fno-omit-frame-pointer")
    endforeach()
    
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg -g")
    
  endif()
  
elseif ("${CMAKE_C_COMPILER_ID}" STREQUAL "IntelLLVM" OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "IntelLLVM")
  
  OCCMakeDebug("Adding Intel LLVM compiler flags." 1)
  
  # ABI Flag -m$(ABI)
  
  # CMake default anyways
  #OCCompilerAddFlagAll("-O3" RELEASE)
  
  # Somehow CMake does not add the appropriate C-standard flags even though
  # the C_STANDARD variable is set. Well do it manually for now.
  #
  # EDIT: Unfortunately, this does not work out for all components. e.g. the gdcm build fails
  # with that switched on. Currently, i've added that flag for the superlu_dist package only. 
  #if(UNIX)
  #  OCCompilerAddFlag("-std=c99" C)
  #endif()
    
  # Release
  # OCCompilerAddFlagAll("-fast" RELEASE)
  # Release - needed for Intel Parallel Studio 2017+
  if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
    OCCompilerAddFlagAll("-fPIE" Fortran RELEASE)
  endif()
  # Release - added for vector optimisation
  check_c_compiler_flag(AVX _HAVE_AVX_FLAG)
  if(_HAVE_AVX_FLAG)
    OCCompilerAddFlagAll("-xAVX" RELEASE)
  endif()
    
  # Debug
  OCCompilerAddFlagAll("-traceback" DEBUG)
  if(OC_WARN_ALL)
    if(C IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-Wall" C DEBUG)
    endif()
    if(CXX IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-Wall" CXX DEBUG)
    endif()
    if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-warn all" Fortran DEBUG)
    endif()
  endif()
  if(OC_CHECK_ALL)
    foreach(lang C CXX)
      if(lang IN_LIST OC_ACTIVE_LANGUAGES)
        OCCompilerAddFlag("-Wcheck" ${lang} DEBUG)
        OCCompilerAddFlag("-fp-trap=common" ${lang} DEBUG)
        OCCompilerAddFlag("-ftrapuv" ${lang} DEBUG)
      endif()
    endforeach()
    if(Fortran IN_LIST OC_ACTIVE_LANGUAGES)
      OCCompilerAddFlag("-check all" Fortran DEBUG)
      OCCompilerAddFlag("-fpe-all=0" Fortran DEBUG)
      OCCompilerAddFlag("-ftrapuv" Fortran DEBUG)
    endif()
  endif()

  if(OC_INSTRUMENTATION_VTUNE)
    
    OCCMakeDebug("Adding vtune instrumentation flags." 2)
    
    ##TODO: Why are we not using the add flags function?
    foreach(lang C CXX Fortran)
      set(CMAKE_${lang}_FLAGS_RELEASE "${CMAKE_${lang}_FLAGS_RELEASE} -g -shared-intel -debug inline-debug-info -D TBB_USE_THREADING_TOOLS -qopenmp-link dynamic -parallel-source-info=2 -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS_DEBUG "${CMAKE_${lang}_FLAGS_DEBUG} -g -shared-intel -debug inline-debug-info -D TBB_USE_THREADING_TOOLS -qopenmp-link dynamic -parallel-source-info=2 -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -g -shared-intel -debug inline-debug-info -D TBB_USE_THREADING_TOOLS -qopenmp-link dynamic -parallel-source-info=2 -fno-omit-frame-pointer")
    endforeach()
    
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -qopenmp -g -shared-intel -qopenmp-link dynamic -tcollect")
    
  elseif(OC_INSTRUMENTATION_GPROF)
    
    OCCMakeDebug("Adding gprof instrumentation flags." 2)
    
    foreach(lang C CXX Fortran)
      set(CMAKE_${lang}_FLAGS_RELEASE "${CMAKE_${lang}_FLAGS_RELEASE} -g -pg -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS_DEBUG "${CMAKE_${lang}_FLAGS_DEBUG} -g -pg -fno-omit-frame-pointer")
      set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -g -pg -fno-omit-frame-pointer")
    endforeach()
    
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg -g")
    
  endif()
  
elseif(CMAKE_C_COMPILER_ID STREQUAL "XL" OR CMAKE_CXX_COMPILER_ID STREQUAL "XL") # IBM case
  
  OCCMakeDebug("Adding IBM XL compiler flags." 1)
  
  if(OC_MULTITHREADING)
    # FindOpenMP uses "-qsmp" for multithreading.. will need to see.
    OCCompilerAddFlagAll("-qomp" RELEASE)
    OCCompilerAddFlagAll("-qomp:noopt" DEBUG)
  endif()
  # ABI Flag -q$(ABI)
  
  # Instruction type - use auto here (pwr4-pwr7 available)
  OCCompilerAddFlagAll("-qarch=auto")
  OCCompilerAddFlagAll("-qtune=auto")
  
  # Release
  OCCompilerAddFlagAll("-qstrict" RELEASE)
    
  # Debug
  if(OC_WARN_ALL)
    # Assuming 64bit builds here. will need to see if that irritates the compiler for 32bit arch
    OCCompilerAddFlagAll("-qflag=i:i" DEBUG)
    OCCompilerAddFlagAll("-qwarn64" DEBUG)
  endif()
  if(OC_CHECK_ALL)
    OCCompilerAddFlagAll("-qcheck" DEBUG)
  endif()
endif()

##TODO: sort out profiling
# Thus far all compilers seem to use the -p flag for profiling
if(OC_PROFILING)
  OCCompilerAddFlagAll("-p" )
endif()

# MPI - dependent flags
# For intel MPI we need to add the skip flags to avoid SEEK_GET/SEEK_END definition errors
# See https://software.intel.com/en-us/articles/intel-cluster-toolkit-for-linux-error-when-compiling-c-aps-using-intel-mpi-library-compilation-driver-mpiicpc
# or google @#error "SEEK_SET is #defined but must not be for the C++ binding of MPI. Include mpi.h before stdio.h"@ 
if(OC_MPI_INTEL)
  OCCompilerAddFlagAll("-DMPICH_IGNORE_CXX_SEEK") # -DMPICH_SKIP_MPICXX
endif()

# Some verbose output for summary
foreach(lang ${OC_ACTIVE_LANGUAGES})
  if(CMAKE_${lang}_FLAGS)
    OCCMakeMessage(STATUS "${lang} flags=${CMAKE_${lang}_FLAGS}")
  endif()
  if(CMAKE_${lang}_FLAGS_RELEASE)
    OCCMakeMessage(STATUS "${lang} flags (RELEASE)=${CMAKE_${lang}_FLAGS_RELEASE}")
  endif()
  if(CMAKE_${lang}_FLAGS_DEBUG)
    OCCMakeMessage(STATUS "${lang} flags (DEBUG)=${CMAKE_${lang}_FLAGS_DEBUG}")
  endif()
endforeach()


