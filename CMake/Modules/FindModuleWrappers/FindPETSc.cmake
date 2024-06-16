#[=======================================================================[.rst:
OpenCMISS FindPETSc
--------------------

An OpenCMISS wrapper to find a PETSc implementation.

#]=======================================================================]

## See https://github.com/jedbrown/cmake-modules/blob/master/FindPETSc.cmake

include(OCCMakeMiscellaneous)

set(PETSc_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_PETSc)
  
  OCCMakeMessage(STATUS "Trying to find PETSc at the system level.")
  
  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  unset(CMAKE_MODULE_PATH)

  find_path(PETSc_DIR include/petsc.h
    HINTS ENV PETSC_DIR
    PATHS
    ${CMAKE_SYSTEM_PREFIX_PATH}
    DOC "PETSc Directory")
  
  set(PETSc_VERSION "3.0.0")
  find_path(PETSc_CONF_DIR rules HINTS "${PETSc_DIR}" PATH_SUFFIXES conf NO_DEFAULT_PATH)
  set(PETSc_FOUND Yes)

  if(PETSc_FOUND)
    set(PETSc_INCLUDES ${PETSc_DIR})
    find_path(PETSc_INCLUDE_DIR petscts.h HINTS "${PETSc_DIR}" PATH_SUFFIXES include NO_DEFAULT_PATH)
    list(APPEND PETSc_INCLUDES ${PETSc_INCLUDE_DIR})
    list(APPEND PETSc_INCLUDES ${PETSc_CONF_DIR})
    file(GLOB PETSc_LIBRARIES RELATIVE "${PETSc_DIR}/lib" "${PETSc_DIR}/lib/libpetsc*.a")
  endif(PETSc_FOUND)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(PETSc DEFAULT_MSG PETSc_LIBRARIES PETSc_INCLUDES)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)

endif()

if(NOT PETSc_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find PETSc in the OpenCMISS build system.")
  
endif()
