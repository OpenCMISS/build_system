#[=======================================================================[.rst:
OpenCMISS External Project Download
-----------------------------------

Script to handle downloading external projects (dependencies) for OpenCMISS.

This script consumes many external variables. The two most important
variables that need to be passed in are:

  **OC_DEPENDENCY_NAME**:STRING
  The name in the OpenCMISS build system of the dependency to download. For example this could be
  BLAS_LAPACK, MUMPS, etc. It is used to define the other variables that are consumed i.e.,
  OC_${OC_DEPENDENCY_NAME}_XXX

  **OC_DEPENDENCY_REPO_NAME**:STRING
  The name in the dependency respository to download. In general this may be different
  from OC_DEPENDENCY_NAME as the repository name is, in general, not all
  uppercase. For example this could be lapack, mumps etc.

#]=======================================================================]

include(${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeMiscellaneous.cmake)

# Sanity check to make sure variables are defined for this dependency.
if(NOT DEFINED OC_DEPENDENCY_NAME)
  OCCMakeFatalError("The OC_DEPENDENCY_NAME is not defined. Cannot proceed with download.")
endif()
if(NOT DEFINED OC_DEPENDENCY_REPO_NAME)
  OCCMakeFatalError("The OC_DEPENDENCY_REPO_NAME is not defined. Cannot proceed with download.")
endif()
string(TO_LOWER ${OC_DEPENDENCY_NAME} LOWER_DEPENDENCY_NAME)  
string(TO_UPPER ${OC_DEPENDENCY_NAME} UPPER_DEPENDENCY_NAME)
if(NOT DEFINED OC_DEPENDENCIES_SOURCE_ROOT)    
  OCCMakeFatalError("The OC_DEPENDENCIES_SOURCE_ROOT is not defined. Cannot proceed with download.")
endif()

if(OC_HAVE_GIT)
  # Check we have the dependency git variables defined
  if(NOT DEFINED OC_${UPPER_DEPENDENCY_NAME}_GIT_HOST)
    OCCMakeFatalError("OC_${UPPER_DEPENDENCY_NAME}_GIT_HOST is not defined. Cannot proceed with download.")
  endif()
  if(NOT DEFINED OC_${UPPER_DEPENDENCY_NAME}_GIT_ORGANISATION)
    OCCMakeFatalError("OC_${UPPER_DEPENDENCY_NAME}_GIT_HOST is not defined. Cannot proceed with download.")
  endif()
  OCGetGitURL(${OC_${UPPER_DEPENDENCY_NAME}_GIT_HOST} ${OC_${UPPER_DEPENDENCY_NAME}} _GIT_URL)
  OCGetGitRepositoryURL(${_GIT_URL} ${OC_DEPENDENCY_REPO_NAME} _GIT_REPO_URL)
  if(OC_DEVELOPER)
    if(NOT DEFINED OC_${UPPER_DEPENDENCY_NAME}_GIT_DEFAULT_BRANCH)
      OCCMakeFatalError("OC_${UPPER_DEPENDENCY_NAME}_GIT_DEFAULT_BRANCH is not defined. Cannot proceed with download.")
    endif()
  else()
    if(NOT DEFINED OC_${UPPER_DEPENDENCY_NAME}_VERSION)
      OCCMakeFatalError("OC_${UPPER_DEPENDENCY_NAME}_VERSION is not defined. Cannot proceed with download.")
    endif()
  endif()
else()
  OCCMakeFatalError("Non-git downloads not implemented.")
endif()
