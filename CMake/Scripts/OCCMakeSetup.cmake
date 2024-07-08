#[=======================================================================[.rst:
OpenCMISS CMake setup script
----------------------------

All OpenCMISS CMake setup definitions.

#]=======================================================================]

if(OC_DEVELOPER)
  list(APPEND OC_CMAKE_FLAGS "-Wdev -Wdepreciated")
endif()
if(OC_CMAKE_DEBUG)
  #list(APPEND OC_CMAKE_FLAGS "--debug-output")
  #list(APPEND OC_CMAKE_FLAGS "--debug-trycompile")
  #list(APPEND OC_CMAKE_FLAGS "--debug-find")
endif()
if(OC_CMAKE_TRACE)
  #list(APPEND OC_CMAKE_FLAGS "--trace")
  #list(APPEND OC_CMAKE_FLAGS "--trace-expand")
endif()
if(OC_CMAKE_PARALLEL_BUILD)
  #list(APPEND OC_CMAKE_BUILD_FLAGS "--parallel ${OC_CMAKE_PARALLEL_JOBS}")
endif()
 
if(OC_CMAKE_DEBUG)
  if(NOT DEFINED CMAKE_VERBOSE_MAKEFILE)
    set(CMAKE_VERBOSE_MAKEFILE ON)
  endif()
  if(NOT DEFINED CMAKE_EXECUTE_PROCESS_COMMAND_ECHO)
    set(CMAKE_EXECUTE_PROCESS_COMMAND_ECHO STDOUT)
  endif()
endif()

set(OC_CMAKE_SEPARATOR "+^+")
