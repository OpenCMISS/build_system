#[=======================================================================[.rst:
OpenCMISS Setup External
--------------------------

Handles setting up an external project for OpenCMISS.

#]=======================================================================]

include(ExternalProject)

function(OCAddExternal
    EXTERNAL_NAME
    EXTERNAL_REPO_NAME
    EXTERNAL_SOURCE_BASE_DIR
    EXTERNAL_SOURCE_SUBDIR
    EXTERNAL_BUILD_BASE_DIR
    EXTERNAL_INSTALL_BASE_DIR
    EXTERNAL_IS_MAIN
    EXTERNAL_USES_MPI
    EXTERNAL_DEFINES
    EXTERNAL_DEPENDENCIES
  )

  OCCMakeMessage(STATUS "Adding external project '${EXTERNAL_NAME}' to the OpenCMISS build system.")

  string(TOLOWER ${EXTERNAL_NAME} _LOWER_EXTERNAL_NAME)  

  OCGetGitURL("${OpenCMISS_${EXTERNAL_NAME}_GIT_HOST}" "${OpenCMISS_${EXTERNAL_NAME}_GIT_ORGANISATION}" _GIT_URL)
  OCGetGitRepositoryURL("${_GIT_URL}" "${EXTERNAL_REPO_NAME}" _GIT_REPO_URL)
  set(_GIT_REPO "origin")
  if(OC_DEVELOPER)
    set(_GIT_BRANCH "opencmiss_develop")
  else()
    set(_GIT_BRANCH "${OpenCMISS_${EXTERNAL_NAME}_GIT_BRANCH}")
  endif()
  set(_GIT_TAG "v${OpenCMISS_${EXTERNAL_NAME}_VERSION}")
  OCCMakeDebug("Git repository information for external project:" 1)
  OCCMakeDebug("  URL:    '${_GIT_REPO_URL}'" 1)
  OCCMakeDebug("  Branch: '${_GIT_BRANCH}'" 1)
  OCCMakeDebug("  Tag:    '${_GIT_TAG}'" 1)
   
  if(EXTERNAL_SOURCE_SUBDIR STREQUAL "")
    set(_SOURCE_DIR "${EXTERNAL_SOURCE_BASE_DIR}/${EXTERNAL_REPO_NAME}")
  else()
    set(_SOURCE_DIR "${EXTERNAL_SOURCE_BASE_DIR}/${EXTERNAL_REPO_NAME}/${EXTERNAL_SOURCE_SUBDIR}")
  endif()
  if(OC_HAVE_MULTICONFIG_ENV)
    set(_BUILD_DIR "${EXTERNAL_BUILD_BASE_DIR}/${EXTERNAL_NAME}")
  else()
    string(TOLOWER ${OC_BUILD_TYPE} _LOWERCASE_BUILD_TYPE)
    set(_BUILD_DIR "${EXTERNAL_BUILD_BASE_DIR}/${EXTERNAL_NAME}/${OC_BUILD_TYPE}")
  endif()
  set(_INSTALL_DIR "${EXTERNAL_INSTALL_BASE_DIR}")
  OCCMakeDebug("Directories for external project:" 1)
  OCCMakeDebug("  Source:  '${_SOURCE_DIR}'" 1)
  OCCMakeDebug("  Build:   '${_BUILD_DIR}'" 1)
  OCCMakeDebug("  Install: '${_INSTALL_DIR}'" 1)

  # Determine download, update, configure, build, and install cmake options and definitions
  set(_DOWNLOAD_OPTIONS )
  set(_UPDATE_OPTIONS )
  set(_CONFIGURE_OPTIONS )
  set(_BUILD_OPTIONS --build ${_BUILD_DIR} ${OC_CMAKE_BUILD_FLAGS})
  set(_INSTALL_OPTIONS --install ${_BUILD_DIR})
  set(_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${_INSTALL_DIR}")
  if(OC_HAVE_MULTICONFIG_ENV)
    list(APPEND _CONFIGURE_OPTIONS "--config=<$<CONFIG>>")
    list(APPEND _BUILD_OPTIONS "--config=<$<CONFIG>>")
    list(APPEND _INSTALL_OPTIONS "--config=<$<CONFIG>>")
  endif()
  list(APPEND _CMAKE_ARGS "${OC_EXTERNAL_CMAKE_ARGS}")
  if(NOT EXTERNAL_DEFINES STREQUAL "")
    list(APPEND _CMAKE_ARGS "${EXTERNAL_DEFINES}")
  endif()  
  list(APPEND _DOWNLOAD_OPTIONS "-DOC_BUILD_SYSTEM_ROOT=${OC_BUILD_SYSTEM_ROOT}")
  list(APPEND _DOWNLOAD_OPTIONS "-DOC_GIT_SOURCE_DIR=${_SOURCE_DIR}")
  list(APPEND _DOWNLOAD_OPTIONS "-DOC_GIT_WORKING_DIR=${_BUILD_DIR}")
  list(APPEND _DOWNLOAD_OPTIONS "-DOC_GIT_URL=${_GIT_REPO_URL}")
  list(APPEND _DOWNLOAD_OPTIONS "-DOC_GIT_REPO=${_G3IT_REPO}")
  list(APPEND _DOWNLOAD_OPTIONS "-DOC_GIT_BRANCH=${_GIT_BRANCH}")
  list(APPEND _DOWNLOAD_OPTIONS "-DOC_GIT_TAG=${_GIT_TAG}")
  if(OC_DEVELOPER)
    list(APPEND _DOWNLOAD_OPTIONS "-DOC_DEVELOPER=ON")    
  endif()
  
  list(APPEND _UPDATE_OPTIONS "-DOC_BUILD_SYSTEM_ROOT=${OC_BUILD_SYSTEM_ROOT}")
  list(APPEND _UPDATE_OPTIONS "-DOC_GIT_SOURCE_DIR=${_SOURCE_DIR}")
  list(APPEND _UPDATE_OPTIONS "-DOC_GIT_WORKING_DIR=${_BUILD_DIR}")
  list(APPEND _UPDATE_OPTIONS "-DOC_GIT_URL=${_GIT_REPO_URL}")
  list(APPEND _UPDATE_OPTIONS "-DOC_GIT_REPO=${_GIT_REPO}")
  list(APPEND _UPDATE_OPTIONS "-DOC_GIT_BRANCH=${_GIT_BRANCH}")
  list(APPEND _UPDATE_OPTIONS "-DOC_GIT_TAG=${_GIT_TAG}")
  if(OC_DEVELOPER)
    list(APPEND _UPDATE_OPTIONS "-DOC_DEVELOPER=ON")    
  endif()
  
  # Create the list of dependencies
  #set(_DEPENDENCIES_TARGETS )
  #foreach(_EXTERNAL ${EXTERNAL_DEPENDENCIES})
  #  string(TOLOWER ${_EXTERNAL} _LOWER_EXTERNAL)
  #  list(APPEND _DEPENDENCIES_TARGETS "${_LOWER_EXTERNAL}")
  #endforeach()

  OCCMakeDebug("_CMAKE_ARGS: '${_CMAKE_ARGS}'." 1)
  OCCMakeDebug("_DOWNLOAD_OPTIONS: '${_DOWNLOAD_OPTIONS}'." 1)
  OCCMakeDebug("_UPDATE_OPTIONS: '${_UPDATE_OPTIONS}'." 1)
  OCCMakeDebug("_CONFIGURE_OPTIONS: '${_CONFIGURE_OPTIONS}'." 1)
  OCCMakeDebug("_BUILD_OPTIONS: '${_BUILD_OPTIONS}'." 1)
  OCCMakeDebug("_INSTALL_OPTIONS: '${_INSTALL_OPTIONS}'." 1)

  if(OC_CMAKE_DEBUG)
    set(_EXTERNAL_PROJECT_LOGS "")
  else()
    set(_EXTERNAL_PROJECT_LOGS "ON")
  endif()
  
  ExternalProject_Add(${EXTERNAL_NAME}
    LIST_SEPARATOR ${OC_CMAKE_SEPARATOR}
    # Directory options
    PREFIX "${_BUILD_DIR}/prefix"
    SOURCE_DIR "${_SOURCE_DIR}"
    BINARY_DIR "${_BUILD_DIR}"
    INSTALL_DIR "${_INSTALL_DIR}"
    # Download options
    DOWNLOAD_COMMAND ${CMAKE_COMMAND} ${OC_CMAKE_FLAGS} "${_CMAKE_ARGS}" ${_DOWNLOAD_OPTIONS} -P ${OC_INSTALL_ROOT}/share/CMake/Scripts/OCDownloadGitRepository.cmake
    # Update options
    UPDATE_COMMAND ${CMAKE_COMMAND} ${OC_CMAKE_FLAGS} "${_CMAKE_ARGS}" ${_UPDATE_OPTIONS} -P ${OC_INSTALL_ROOT}/share/CMake/Scripts/OCUpdateGitRepository.cmake
    # Patch options
    # Configure options
    CMAKE_COMMAND ${CMAKE_COMMAND} ${OC_CMAKE_FLAGS} ${_CONFIGURE_OPTIONS}
    CMAKE_ARGS "${_CMAKE_ARGS}"
    # Build options
    BUILD_COMMAND ${CMAKE_COMMAND} ${_BUILD_OPTIONS}
    # Install options
    INSTALL_COMMAND ${CMAKE_COMMAND} ${_INSTALL_OPTIONS}
    # Test options
    # Output log options
    # Target options
    #DEPENDS ${_DEPENDENCIES_TARGETS}
    DEPENDS ${EXTERNAL_DEPENDENCIES}
    # Miscellaneous options
    LOG_DOWNLOAD ${_EXTERNAL_PROJECT_LOGS}
    LOG_UPDATE ${_EXTERNAL_PROJECT_LOGS}
    LOG_CONFIGURE ${_EXTERNAL_PROJECT_LOGS}
    LOG_BUILD ${_EXTERNAL_PROJECT_LOGS}
    LOG_INSTALL ${_EXTERNAL_PROJECT_LOGS}
   )

  unset(_EXTERNAL_PROJECT_LOGS)
  unset(_INSTALL_DIR)
  unset(_BUILD_DIR)
  unset(_SOURCE_DIR)
  unset(_GIT_TAG)
  unset(_GIT_REPO_URL)
  unset(_GIT_URL)
  unset(_LOWER_EXTERNAL_NAME)

endfunction()
