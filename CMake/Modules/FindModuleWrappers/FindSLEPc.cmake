#[=======================================================================[.rst:
OpenCMISS FindSLEPc
--------------------

An OpenCMISS wrapper to find a SLEPc implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(SLEPc_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_SLEPc)
  
  OCCMakeMessage(STATUS "Trying to find SLEPc at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_path(SLEPc_DIR include/slepc.h
    HINTS ENV SLEPc_DIR
    PATHS
    ${CMAKE_SYSTEM_PREFIX_PATH}
    DOC "SLEPc Directory")
  
  set(SLEPc_VERSION "3.0.0")
  find_path(SLEPc_CONF_DIR rules HINTS "${SLEPc_DIR}" PATH_SUFFIXES conf NO_DEFAULT_PATH)
  set(SLEPc_FOUND Yes)

  if(SLEPc_FOUND)
    set(SLEPc_INCLUDES ${SLEPc_DIR})
    find_path(SLEPc_INCLUDE_DIR slepcts.h HINTS "${SLEPc_DIR}" PATH_SUFFIXES include NO_DEFAULT_PATH)
    list(APPEND SLEPc_INCLUDES ${SLEPc_INCLUDE_DIR})
    list(APPEND SLEPc_INCLUDES ${SLEPc_CONF_DIR})
    file(GLOB SLEPc_LIBRARIES RELATIVE "${SLEPc_DIR}/lib" "${SLEPc_DIR}/lib/libslepc*.a")
  endif(SLEPc_FOUND)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(SLEPc DEFAULT_MSG SLEPc_LIBRARIES SLEPc_INCLUDES)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT SLEPc_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find SLEPc in the OpenCMISS build system.")
    
  
endif()
