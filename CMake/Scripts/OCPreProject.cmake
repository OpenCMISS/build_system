#[=======================================================================[.rst:
OpenCMISS CMake pre-project script
----------------------------------

OpenCMISS script called pre-project to initialise everything and check command line etc.

#]=======================================================================]

#message(STATUS “Executing pre-project script.”)

# Ensure we have an out-of-directory build
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR “In-source build detected! Please run cmake from a different directory to the CMakeLists.txt file.”)
endif()

# Compute the installation prefix relative to the current CMakeLists.txt file. It might be a mounted location or whatever.
get_filename_component(_OC_PRE_PREFIX "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)
get_filename_component(OC_PRE_PREFIX "${_OC_PRE_PREFIX}" ABSOLUTE)
unset(_OC_PRE_PREIX)

# Initialise OpenCMISS CMake debug/trace/etc. behaviour
if(DEFINED OpenCMISS_CMAKE_FLAGS)
  set(OC_CMAKE_FLAGS "${OpenCMISS_CMAKE_FLAGS}" CACHE STRING "CMake flags to apply for the OpenCMISS build system." FORCE)
else()
  if(DEFINED ENV{OpenCMISS_CMAKE_FLAGS})
    set(OC_CMAKE_FLAGS "$ENV{OpenCMISS_CMAKE_FLAGS}" CACHE STRING "CMake flags to apply for the OpenCMISS build system." FORCE)
  else()
    set(OC_CMAKE_FLAGS "" CACHE STRING "CMake flags to apply for the OpenCMISS build system." FORCE)
  endif()
endif()
if(DEFINED OpenCMISS_CMAKE_DEBUG)
  if(${OpenCMISS_CMAKE_DEBUG})
    set(OC_CMAKE_DEBUG ON CACHE BOOL "OpenCMISS CMake debug output flag." FORCE)
  else()
    set(OC_CMAKE_DEBUG OFF CACHE BOOL "OpenCMISS CMake debug output flag." FORCE)
  endif()
else()
  if(DEFINED ENV{OpenCMISS_CMAKE_DEBUG})
    set(OC_CMAKE_DEBUG ON CACHE BOOL "OpenCMISS CMake debug output flag." FORCE)
  else()
    set(OC_CMAKE_DEBUG OFF CACHE BOOL "OpenCMISS CMake debug output flag." FORCE)
  endif()
endif()
if(OC_CMAKE_DEBUG)
  if(DEFINED OpenCMISS_CMAKE_DEBUG_LEVEL)
    set(OC_CMAKE_DEBUG_LEVEL "${OpenCMISS_CMAKE_DEBUG_LEVEL}" CACHE STRING "OpenCMISS CMake debug output level." FORCE)
  else()
    if(DEFINED ENV{OpenCMISS_CMAKE_DEBUG_LEVEL})
      set(OC_CMAKE_DEBUG_LEVEL "$ENV{OpenCMISS_CMAKE_DEBUG_LEVEL}" CACHE STRING "OpenCMISS CMake debug output level." FORCE)
    else()
      set(OC_CMAKE_DEBUG_LEVEL 999 CACHE STRING "OpenCMISS CMake debug output level." FORCE)
    endif()
  endif()
endif()
if(DEFINED OpenCMISS_CMAKE_TRACE)
  if(OpenCMISS_CMAKE_TRACE)
    set(OC_CMAKE_TRACE ON CACHE BOOL "OpenCMISS CMake trace flag." FORCE)
  else()
    set(OC_CMAKE_TRACE OFF CACHE BOOL "OpenCMISS CMake trace flag." FORCE)
  endif()
else()
  if(DEFINED ENV{OpenCMISS_CMAKE_TRACE})
    set(OC_CMAKE_TRACE ON CACHE BOOL "OpenCMISS CMake trace flag." FORCE)
  else()
    set(OC_CMAKE_TRACE OFF CACHE BOOL "OpenCMISS CMake trace flag." FORCE)
  endif()
endif()
if(DEFINED OpenCMISS_CMAKE_PARALLEL_BUILD)
  if(OpenCMISS_CMAKE_PARALLEL_BUILD)
    set(OC_CMAKE_PARALLEL_BUILD ON CACHE BOOL "Enable OpenCMISS CMake parallel build." FORCE)
  else()
    set(OC_CMAKE_TRACE OFF CACHE BOOL "Enable OpenCMISS CMake parallel build." FORCE)
  endif()
else()
  if(DEFINED ENV{OpenCMISS_CMAKE_PARALLEL_BUILD})
    set(OC_CMAKE_PARALLEL_BUILD ON CACHE BOOL "Enable OpenCMISS CMake parallel build." FORCE)
  else()
    set(OC_CMAKE_PARALLEL_BUILD OFF CACHE BOOL "Enable OpenCMISS CMake parallel build." FORCE)
  endif()
endif()
if(OC_CMAKE_PARALLEL_BUILD)
  if(DEFINED OpenCMISS_CMAKE_PARALLEL_JOBS)
    set(OC_CMAKE_PARALLEL_JOBS "${OpenCMISS_CMAKE_PARALLEL_JOBS}" CACHE STRING "Number of parallel jobs for OpenCMISS CMake parallel builds." FORCE)
  else()
    if(DEFINED ENV{OpenCMISS_CMAKE_PARALLEL_JOBS})
      set(OC_CMAKE_PARALLEL_JOBS "$ENV{OpenCMISS_CMAKE_PARALLEL_JOBS}" CACHE STRING "Number of parallel jobs for OpenCMISS CMake parallel builds." FORCE)
    else()
      set(OC_CMAKE_PARALLEL_JOBS 1 CACHE STRING "Number of parallel jobs for OpenCMISS CMake parallel builds." FORCE)
    endif()
  endif()
endif()

# Set up misc functions
include(${OC_PRE_PREFIX}/OCCMakeMiscellaneous.cmake)

# Get OpenCMISS Toolchain
include(${OC_PRE_PREFIX}/OCToolchains.cmake)
OCSetToolchain("${OC_PRE_PREFIX}")
  
