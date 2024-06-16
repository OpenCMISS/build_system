#[=======================================================================[.rst:
OpenCMISS CMake miscellaneous script
------------------------------------

All OpenCMISS CMake miscellaneous functions.

#]=======================================================================]

if(NOT WIN32)
  string(ASCII 27 _OC_ESCAPE)
  set(_OC_COLOUR_RESET        "${_OC_ESCAPE}[m")
  set(_OC_COLOUR_BOLD         "${_OC_ESCAPE}[1m")
  set(_OC_COLOUR_RED          "${_OC_ESCAPE}[31m")
  set(_OC_COLOUR_GREEN        "${_OC_ESCAPE}[32m")
  set(_OC_COLOUR_YELLOW       "${_OC_ESCAPE}[33m")
  set(_OC_COLOUR_BLUE         "${_OC_ESCAPE}[34m")
  set(_OC_COLOUR_MAGENTA      "${_OC_ESCAPE}[35m")
  set(_OC_COLOUR_CYAN         "${_OC_ESCAPE}[36m")
  set(_OC_COLOUR_WHITE        "${_OC_ESCAPE}[37m")
  set(_OC_COLOUR_BOLD_RED     "${_OC_ESCAPE}[1;31m")
  set(_OC_COLOUR_BOLD_GREEN   "${_OC_ESCAPE}[1;32m")
  set(_OC_COLOUR_BOLD_YELLOW  "${_OC_ESCAPE}[1;33m")
  set(_OC_COLOUR_BOLD_BLUE    "${_OC_ESCAPE}[1;34m")
  set(_OC_COLOUR_BOLD_MAGENTA "${_OC_ESCAPE}[1;35m")
  set(_OC_COLOUR_BOLD_CYAN    "${_OC_ESCAPE}[1;36m")
  set(_OC_COLOUR_BOLD_WHITE   "${_OC_ESCAPE}[1;37m")
endif()
  
function(OCCMakeMessage LEVEL MESSAGE)
  if(WIN32)
    set(_OC_MESSAGE "OpenCMISS: ")
  else()
    set(_OC_MESSAGE "${_OC_COLOUR_BOLD_YELLOW}OpenCMISS:${_OC_COLOUR_RESET} ")
  endif()
  string(APPEND _OC_MESSAGE ${MESSAGE})
  message(${LEVEL} ${_OC_MESSAGE})
  unset(_OC_MESSAGE)
endfunction()

function(OCCMakeFatalError MESSAGE)
  if(WIN32)
    set(_OC_MESSAGE "OpenCMISS FATAL ERROR: ")
  else()
    set(_OC_MESSAGE "${_OC_COLOUR_BOLD_RED}OpenCMISS FATAL ERROR:${_OC_COLOUR_RESET} ")
  endif()
  string(APPEND _OC_MESSAGE ${MESSAGE})
  message(FATAL_ERROR ${_OC_MESSAGE})
  unset(_OC_MESSAGE)
endfunction()

function(OCCMakeWarning MESSAGE)
  if(WIN32)
    set(_OC_MESSAGE "OpenCMISS WARNING: ")
  else()
    set(_OC_MESSAGE "${_OC_COLOUR_BOLD_CYAN}OpenCMISS WARNING:${_OC_COLOUR_RESET} ")
  endif()
  string(APPEND _OC_MESSAGE ${MESSAGE})
  message(WARNING ${_OC_MESSAGE})
  unset(_OC_MESSAGE)
endfunction()

function(OCCMakeDebug DEBUG_MESSAGE DEBUG_LEVEL)
  #if(OC_CMAKE_DEBUG)
  #  if(DEBUG_LEVEL LESS_EQUAL OC_CMAKE_DEBUG_LEVEL)
      if(WIN32)
	set(_OC_DEBUG_MESSAGE "OpenCMISS DEBUG: ")
      else()
	set(_OC_DEBUG_MESSAGE "${_OC_COLOUR_BOLD_MAGENTA}OpenCMISS DEBUG:${_OC_COLOUR_RESET} ")
      endif()
      string(APPEND _OC_DEBUG_MESSAGE ${DEBUG_MESSAGE})
      if(CMAKE_DEBUG)
        message(DEBUG ${_OC_DEBUG_MESSAGE})
      else()
        message(STATUS ${_OC_DEBUG_MESSAGE})
      endif()
      unset(_OC_DEBUG_MESSAGE)
  #  endif()
  #endif()
endfunction()

macro(OCCMakeClearModulePath)
  # Remove all paths resolving to this one here so that recursive calls will not search here again
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)
  #get_filename_component(_THIS_DIRECTORY ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
  #foreach(_ENTRY "${_ORIGINAL_CMAKE_MODULE_PATH}")
  #  get_filename_component(_ENTRY_ABSOLUTE "${_ENTRY}" ABSOLUTE)
  #  if("${_ENTRY_ABSOLUTE}" STREQUAL "${_THIS_DIRECTORY}")
  #    list(REMOVE_ITEM CMAKE_MODULE_PATH "${_ENTRY}")
  #  endif()
  #endforeach()
  #unset(_THIS_DIRECTORY)
  #unset(_ENTRY_ABSOLUTE)
endmacro()

macro(OCCMakeResetModulePath)
  # Restore the current module path
  # This needs to be done BEFORE any calls in CONFIG find mode - if the found config has our
  # xxx-config-dependencies, which in turn might be allowed as system lookup, the FindModuleWrapper dir
  # is missing and stuff breaks. Took a while to figure out the problem as you might guess ;-)
  # Scenario discovered on Michael Sprenger's Ubuntu 10 system with 
  # OC_SYSTEM_ZLIB=YES and found, OC_SYSTEM_LIBXML2=ON but not found. This broke the CELLML-build as
  # the wrapper call for LIBXML removed the wrapper dir from the module path, then found libxml2 in config mode,
  # which in turn called find_dependency(ZLIB), which used the native FindZLIB instead of the wrapper first.
  # This problem only was detected because the native zlib library is called "(lib)z", but we link against the 
  # "zlib" target, which is either provided by our own build or by the wrapper that creates it. 
  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)
endmacro()
