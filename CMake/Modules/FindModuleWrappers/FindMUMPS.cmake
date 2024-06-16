#[=======================================================================[.rst:
OpenCMISS FindMUMPS
-------------------

An OpenCMISS wrapper to find a MUMPS solver implementation.

#]=======================================================================]

include(OCCMakeMiscellaneous)

set(libCellML_FOUND NO)

if(OpenCMISS_FIND_SYSTEM_MUMPS)
  
  OCCMakeMessage(STATUS "Trying to find MUMPS at the system level.")

  find_path(MUMPS_DIR include/mumps_compat.h HINTS ENV MUMPS_DIR PATHS $ENV{HOME}/mumps DOC "Mumps Directory")

  if(EXISTS ${MUMPS_DIR}/include/mumps_compat.h)
    set(MUMPS_FOUND YES)
    set(MUMPS_INCLUDES ${MUMPS_DIR})
    find_path(MUMPS_INCLUDE_DIR mumps_compat.h HINTS "${MUMPS_DIR}" PATH_SUFFIXES include NO_DEFAULT_PATH)
    list(APPEND MUMPS_INCLUDES ${MUMPS_INCLUDE_DIR})
    file(GLOB MUMPS_LIBRARIES "${MUMPS_DIR}/lib/libmumps*.a" "${MUMPS_DIR}/lib/lib*mumps*.a" "${MUMPS_DIR}/lib/lib*pord*.a")
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(MUMPS DEFAULT_MSG MUMPS_LIBRARIES MUMPS_INCLUDES)

endif()

if(NOT MUMPS_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find MUMPS in the OpenCMISS build system.")

endif()  

# Output either success or failure messages

if(MUMPS_FOUND)

  OCCMakeMessage(STATUS "Found MUMPS in ${MUMPS_DIR}.")
 
else()
  
  if(MUMPS_FIND_REQUIRED)
  
    if(OpenCMISS_FIND_SYSTEM_MUMPS)
    
      message(FATAL_ERROR "FindMUMPS error!\n"
        "Could not find MUMPS ${MUMPS_FIND_VERSION} with a system search or in the OpenCMISS build system with either MODULE or CONFIG mode.\n"
        "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}\n"
        "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}\n"
        "Alternatively, refer to CMake(Output|Error).log in ${PROJECT_BINARY_DIR}/CMakeFiles\n"
        )
      
    else()
    
      message(FATAL_ERROR "FindMUMPS error!\n"
	"Could not find MUMPS ${MUMPS_FIND_VERSION} in the OpenCMISS build system with either MODULE or CONFIG mode.\n"
	"CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}\n"
	"CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}\n"
      "Allow system search for MUMPS: ${OpenCMISS_FIND_SYSTEM}\n"
      "Alternatively, refer to CMake(Output|Error).log in ${PROJECT_BINARY_DIR}/CMakeFiles\n"
      )
    
    endif()
  
  endif()

endif()
