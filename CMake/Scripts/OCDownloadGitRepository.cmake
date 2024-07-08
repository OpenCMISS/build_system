#[=======================================================================[.rst:
OpenCMISS Download Git Repository
---------------------------------

Handles the downloading of a git repository as part of an external project.

#]=======================================================================]

if(NOT DEFINED OC_BUILD_SYSTEM_ROOT)
  message(FATAL_ERROR “OC_BUILD_SYSTEM_ROOT is not defined.”)
endif()

include(${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeSetup.cmake)
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

OCCMakeDebug("Download git repository variables:" 2)
OCCMakeDebug("OC_DEVELOPER: '${OC_DEVELOPER}'." 2)
OCCMakeDebug("OC_GIT_SOURCE_DIR: '${OC_GIT_SOURCE_DIR}'." 2)
OCCMakeDebug("OC_GIT_WORKING_DIR: '${OC_GIT_WORKING_DIR}'." 2)
OCCMakeDebug("OC_GIT_URL: '${OC_GIT_URL}'." 2)
OCCMakeDebug("OC_GIT_REPO: '${OC_GIT_REPO}'." 2)
OCCMakeDebug("OC_GIT_BRANCH: '${OC_GIT_BRANCH}'." 2)
OCCMakeDebug("OC_GIT_TAG: '${OC_GIT_TAG}'." 2)

find_package(Git)
if(Git_FOUND)

  OCCMakeDebug("Using git to download the repository. GIT_EXECUTABLE = '${GIT_EXECUTABLE}'." 1)
  
  #Adapted from https://github.com/tschuchortdev/cmake_git_clone/
  
  #Check if the source directory already exists

  #Determine if git repository already exists
  if(EXISTS "${OC_GIT_SOURCE_DIR}")
    OCCMakeDebug("Source directory of '${OC_GIT_SOURCE_DIR}' exists." 1)
    # Determine if the direcotry contains a git repository
    if(EXISTS "${OC_GIT_SOURCE_DIR}/.git")
      OCCMakeDebug("Git directory of '${OC_GIT_SOURCE_DIR}.git' exists." 1)
      set(_GIT_REPO_EXISTS ON)    
    else()
      OCCMakeDebug("Git directory of '${OC_GIT_SOURCE_DIR}/.git' doesn't exist." 1)
      set(_GIT_REPO_EXISTS OFF)
    endif()
  else()
    OCCMakeDebug("Source directory of '${OC_GIT_SOURCE_DIR}' doesn't exist." 1)
    set(_GIT_REPO_EXISTS OFF)
  endif()
  
  OCCMakeDebug("_GIT_REPO_EXISTS = '${_GIT_REPO_EXISTS}'." 1)
  
  if(_GIT_REPO_EXISTS)
    
    #Source directory already exists. Don't do a clone, do a pull and update instead.
    
    ### SHOULD THIS JUST NOT DO ANYTHING AND DO THIS AS PART OF AN UPDATE STEP?
    
    ### SHOULD THIS CHECK TO ENSURE THAT THERE IS NOTHING TO COMMIT???

    #COMMENT FOR NOW UNTIL WORKING
    
    OCCMakeDebug("Source directory of '${OC_GIT_SOURCE_DIR}' already exists for the git repository." 2)
    #Try a pull
    set(_GIT_ARGUMENT "pull ${OC_GIT_REPO} ${OC_GIT_BRANCH}")
    OCCMakeDebug("Git pull command: '${GIT_EXECUTABLE} ${_GIT_ARGUMENT}'." 1)
    #execute_process(
    #  COMMAND "${GIT_EXECUTABLE}" "${_GIT_ARGUMENT}"
    #  WORKING_DIRECTORY "${OC_GIT_SOURCE_DIR}"
    #  RESULT_VARIABLE _OC_GIT_RESULT
    #  OUTPUT_VARIABLE _OC_GIT_OUTPUT
    #  ERROR_VARIABLE _OC_GIT_ERROR
    #)
    #if(_OC_GIT_RESULT EQUAL "0")
    #  #Update any submodules
    #  set(_GIT_ARGUMENT "submodule update --remote")
    #  OCCMakeDebug("Git submodule command: '${GIT_EXECUTABLE} ${_GIT_ARGUMENT}'." 1)
    #  execute_process(
    #	COMMAND "${GIT_EXECUTABLE}" "${_GIT_ARGUMENT}"
    #	WORKING_DIRECTORY "${OC_GIT_SOURCE_DIR}"
    #	RESULT_VARIABLE _OC_GIT_RESULT
    #	OUTPUT_VARIABLE _OC_GIT_OUTPUT
    #	ERROR_VARIABLE _OC_GIT_ERROR
    #  )
    #  if(NOT _OC_GIT_RESULT EQUAL "0")
    #	OCCMakeWarning("Git submodule update error, '${_OC_GIT_RESULT}'.")
    #  endif()
    #else()
    #  OCCMakeWarning("Git pull error, '${_OC_GIT_RESULT}'.")
    #endif()
  else()
    #Source directory does not exist. Do a clone. 
    OCCMakeDebug("Source directory of '${OC_GIT_SOURCE_DIR}' does not exist for the git repository." 2)
    #Try and clone
    set(_GIT_ARGUMENT "clone ${OC_GIT_URL} --recursive ${OC_GIT_SOURCE_DIR}")
    OCCMakeDebug("Git clone command: '${GIT_EXECUTABLE} ${_GIT_ARGUMENT}'." 1)

    #COMMENT FOR NOW UNTIL WOKRING
    
    #execute_process(
    #  COMMAND ${GIT_EXECUTABLE} clone ${OC_GIT_URL} --recursive ${OC_GIT_SOURCE_DIR}
    #  WORKING_DIRECTORY "${OC_GIT_WORKING_DIR}"
    #  RESULT_VARIABLE _OC_GIT_RESULT
    #  OUTPUT_VARIABLE _OC_GIT_OUTPUT
    #  ERROR_VARIABLE _OC_GIT_ERROR
    #)
    #if(NOT _OC_GIT_RESULT EQUAL "0")
    #  OCCMakeWarning("Git clone result: '${_OC_GIT_RESULT}'")
    #  OCCMakeWarning("          output: '${_OC_GIT_OUTPUT}'")
    #  OCCMakeWarning("           error: '${_OC_GIT_ERROR}'")
    #endif()
    if(DEFINED OC_DEVELOPER)
      #Set upstream repos etc. 
    endif()
  endif()
  
  #Check out the right branch or tag
  if(DEFINED OC_DEVELOPER)
    #We are in developer mode so checkout the developer branch.
    OCCMakeDebug("Checking out the branch '${OC_GIT_BRANCH}'." 2)
    set(_GIT_ARGUMENT "fetch --all")
    OCCMakeDebug("Git fetch command: '${GIT_EXECUTABLE} ${_GIT_ARGUMENT}'." 1)
    # execute_process(
    #   COMMAND "${GIT_EXECUTABLE}" "${_GIT_ARGUMENT}"
    #   WORKING_DIRECTORY "${OC_GIT_SOURCE_DIR}"
    #   RESULT_VARIABLE _OC_GIT_RESULT
    #   OUTPUT_VARIABLE _OC_GIT_OUTPUT
    #   ERROR_VARIABLE _OC_GIT_ERROR
    # )
    # if(NOT _OC_GIT_RESULT EQUAL "0")
    #   OCCMakeWarning("Git fetch error, '${_OC_GIT_RESULT}'.")
    # endif()
    # set(_GIT_ARGUMENT "checkout ${OC_GIT_REPO} ${OC_GIT_BRANCH}")
    # OCCMakeDebug("Git checkout command: '${GIT_EXECUTABLE} ${_GIT_ARGUMENT}'." 1)
    # execute_process(
    #   COMMAND "${GIT_EXECUTABLE}" "${_GIT_ARGUMENT}"
    #   WORKING_DIRECTORY "${OC_GIT_SOURCE_DIR}"
    #   RESULT_VARIABLE _OC_GIT_RESULT
    #   OUTPUT_VARIABLE _OC_GIT_OUTPUT
    #   ERROR_VARIABLE _OC_GIT_ERROR
    # )
    # if(NOT _OC_GIT_RESULT EQUAL "0")
    #   OCCMakeWarning("Git checkout error, '${_OC_GIT_RESULT}'.")
    # endif()
    
  else()
    #We are NOT in developer mode so checkout the specified tag
    OCCMakeDebug("Checking out the tag '${OC_GIT_TAG}'." 2)
    set(_GIT_ARGUMENT "fetch --all --tags --prune")
    OCCMakeDebug("Git fetch command: '${_GIT_ARGUMENT}'." 1)
    # execute_process(
    #   COMMAND "${GIT_EXECUTABLE}" "${_GIT_ARGUMENT}"
    #   WORKING_DIRECTORY "${OC_GIT_SOURCE_DIR}"
    #   RESULT_VARIABLE _OC_GIT_RESULT
    #   OUTPUT_VARIABLE _OC_GIT_OUTPUT
    #   ERROR_VARIABLE _OC_GIT_ERROR
    # )
    # if(NOT _OC_GIT_RESULT EQUAL "0")
    #   OCCMakeWarning("Git fetch error, '${_OC_GIT_RESULT}'.")
    # endif()  
    # set(_GIT_ARGUMENT "checkout tags/${OC_GIT_TAG} -b ${OC_GIT_BRANCH}")
    # OCCMakeDebug("Git checkout command: '${GIT_EXECUTABLE} ${_GIT_ARGUMENT}'." 1)
    # execute_process(
    #   COMMAND "${GIT_EXECUTABLE}" "${_GIT_ARGUMENT}"
    #   WORKING_DIRECTORY "${OC_GIT_SOURCE_DIR}"
    #   RESULT_VARIABLE _OC_GIT_RESULT
    #   OUTPUT_VARIABLE _OC_GIT_OUTPUT
    #   ERROR_VARIABLE _OC_GIT_ERROR
    # )
    # if(NOT _OC_GIT_RESULT EQUAL "0")
    #   OCCMakeWarning("Git checkout error, '${_OC_GIT_RESULT}'.")
    # endif()  
  endif()
  
else()
  OCCMakeFatalError("Non git download not implemented.")
endif()
