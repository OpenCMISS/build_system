#[=======================================================================[.rst:
OpenCMISS CMake Find Module utilities
-------------------------------------

All OpenCMISS CMake Find Module functions.

#]=======================================================================]

macro(OCCMakeClearModulePath)
  # Remove all paths resolving to this one here so that recursive calls will not search here again
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  get_filename_component(_THIS_DIRECTORY ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
  foreach(_ENTRY "${_ORIGINAL_CMAKE_MODULE_PATH}")
    get_filename_component(_ENTRY_ABSOLUTE "${_ENTRY}" ABSOLUTE)
    if("${_ENTRY_ABSOLUTE}" STREQUAL "${_THIS_DIRECTORY}")
      list(REMOVE_ITEM CMAKE_MODULE_PATH "${_ENTRY}")
    endif()
  endforeach()
  unset(_THIS_DIRECTORY)
  unset(_ENTRY_ABSOLUTE)
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
