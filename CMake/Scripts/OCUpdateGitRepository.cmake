#[=======================================================================[.rst:
OpenCMISS Update Git Repository
---------------------------------

Handles the updating of a git repository as part of an external project.

#]=======================================================================]

if(NOT DEFINED OC_BUILD_SYSTEM_ROOT)
  message(FATAL_ERROR “OC_BUILD_SYSTEM_ROOT is not defined.”)
endif()

include(${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeMiscellaneous.cmake)

#Check we have the required defines

if(NOT DEFINED OC_GIT_SOURCE_DIR)
  OCCMakeFatalError("OC_GIT_SOURCE_DIR is not defined.")
endif()

if(NOT DEFINED OC_GIT_WORKING_DIR)
  OCCMakeFatalError("OC_GIT_WORKING_DIR is not defined.")
endif()

if(NOT DEFINED OC_GIT_URL)
  OCCMakeFatalError("OC_GIT_URL is not defined.")
endif()

if(NOT DEFINED OC_GIT_REPO)
  OCCMakeFatalError("OC_GIT_REPO is not defined.")
endif()

if(NOT DEFINED OC_GIT_BRANCH)
  OCCMakeFatalError("OC_GIT_BRANCH is not defined.")
endif()

if(NOT DEFINED OC_DEVELOPER) 
  if(NOT DEFINED OC_GIT_TAG)
    OCCMakeFatalError("OC_GIT_TAG must be specified for a non developer setup.")
  endif()
endif()
