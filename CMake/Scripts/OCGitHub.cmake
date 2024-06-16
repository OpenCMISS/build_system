#[=======================================================================[.rst:
OpenCMISS Github
----------------

Functions are variables related to OpenCMISS and Github.

#]=======================================================================]

function(OCGetGitURL GIT_HOST GIT_ORGANISATION GIT_URL)

  if(OC_HAVE_GIT)
    if(OC_HAVE_GITHUB_SSH_ACCESS)
      set(_GIT_URL "git@${GIT_HOST}:${GIT_ORGANISATION}")
    else()
      set(_GIT_URL "https://${GIT_HOST}/${GIT_ORGANISATION}")
    endif()
  else()
    OCCMakeFatalError("Non-git access is not implemented.")
  endif()

  set(${GIT_URL} ${_GIT_URL} PARENT_SCOPE)
  OCCMakeDebug("Git URL: '${_GIT_URL}'." 4)

  unset(_GIT_URL)

endfunction()

function(OCGetGitRepositoryURL GIT_URL GIT_REPO_NAME GIT_REPO_URL)

  if(OC_HAVE_GIT)
    set(_GIT_REPO_URL "${GIT_URL}/${GIT_REPO_NAME}.git")
  else()
    OCCMakeFatalError("Non-git access is not implemented.")
  endif()

  set(${GIT_REPO_URL} ${_GIT_REPO_URL} PARENT_SCOPE)
  OCCMakeDebug("Git Repository URL: '${_GIT_REPO_URL}'." 4)

  unset(_GIT_REPO_URL)

endfunction()

# See if we have git
set(OC_HAVE_GIT NO CACHE BOOL "Use git with OpenCMISS." FORCE)
set(OC_HAVE_GITHUB_SSH_ACCESS NO CACHE BOOL "Have SSH access to GitHub." FORCE)
find_package(Git)
if(Git_FOUND)
  set(OC_HAVE_GIT YES CACHE BOOL "Use git with OpenCMISS." FORCE)
  OCCMakeDebug("Using Git. Git executable '${GIT_EXECUTABLE}' (version ${GIT_VERSION_STRING})." 1)
  # Check if we have SSH access to GitHub
  find_program(OC_SSH_EXE ssh)
  if(OC_SSH_EXE)
    OCCMakeDebug("Using ssh. Ssh excutable '${OC_SSH_EXE}'." 1)
    set(OC_HAVE_SSH YES)
    # This command always fail as github doesn't allow ssh access
    execute_process(
      COMMAND ${OC_SSH_EXE} git@github.com
      RESULT_VARIABLE _RESULT
      OUTPUT_VARIABLE _OUT
      ERROR_VARIABLE _ERR
    )
    # So check the contents of the error message for a success message
    if("${_ERR}" MATCHES "successfully authenticated")
      set(OC_HAVE_GITHUB_SSH_ACCESS YES CACHE BOOL "Have SSH access to GitHub" FORCE)
    endif()
    unset(_RESULT)
    unset(_OUT)
    unset(_ERR)
  endif()
  # Construct the git URLs
  set(OC_GITHUB_EXTENSION ".git" CACHE STRING "GitHub repository extension." FORCE)
  if(OC_HAVE_GITHUB_SSH_ACCESS)
    set(OC_GIT_URL "git@${OC_GIT_HOST}:${OC_GIT_ORGANISATION}/" CACHE STRING "OpenCMISS Git repository URL." FORCE)
    set(OC_DEFAULT_GIT_URL "git@${OC_DEFAULT_GIT_HOST}:${OC_DEFAULT_GIT_ORGANISATION}/" CACHE STRING "Default OpenCMISS Git repository URL." FORCE)
    set(OC_DEPENDENCIES_GIT_URL "git@${OC_DEPENDENCIES_GIT_HOST}:${OC_DEPENDENCIES_GIT_ORGANISATION}/" CACHE STRING "OpenCMISS dependencies Git repository URL." FORCE)
    set(OC_DEFAULT_DEPENDENCIES_GIT_URL "git@${OC_DEFAULT_DEPENDENCIES_GIT_HOST}:${OC_DEFAULT_DEPENDENCIES_GIT_ORGANISATION}/" CACHE STRING "Default OpenCMISS dependencies Git repository URL." FORCE)
    set(OC_EXAMPLES_GIT_URL "git@${OC_EXAMPLES_GIT_HOST}:${OC_EXAMPLES_GIT_ORGANISATION}/" CACHE STRING "OpenCMISS examples Git repository URL." FORCE)
    set(OC_DEFAULT_EXAMPLES_GIT_URL "git@${OC_DEFAULT_EXAMPLES_GIT_HOST}:${OC_DEFAULT_EXAMPLES_GIT_ORGANISATION}/" CACHE STRING "Default OpenCMISS examples Git repository URL." FORCE)
  else()
    set(OC_GIT_URL "https://${OC_GIT_HOST}/${OC_GIT_ORGANISATION}/" CACHE STRING "OpenCMISS Git repository URL." FORCE)
    set(OC_DEFAULT_GIT_URL "https://${OC_DEFAULT_GIT_HOST}/${OC_DEFAULT_GIT_ORGANISATION}/" CACHE STRING "Default OpenCMISS Git repository URL." FORCE)
    set(OC_DEPENDENCIES_GIT_URL "https://${OC_DEPENDENCIES_GIT_HOST}/${OC_DEPENDENCIES_GIT_ORGANISATION}/" CACHE STRING "OpenCMISS dependencies Git repository URL." FORCE)
    set(OC_DEFAULT_DEPENDENCIES_GIT_URL "https://${OC_DEFAULT_DEPENDENCIES_GIT_HOST}/${OC_DEFAULT_DEPENDENCIES_GIT_ORGANISATION}/" CACHE STRING "Default OpenCMISS dependencies Git repository URL." FORCE)
    set(OC_EXAMPLES_GIT_URL "https://${OC_EXAMPLES_GIT_HOST}/${OC_EXAMPLES_GIT_ORGANISATION}/" CACHE STRING "OpenCMISS examples Git repository URL." FORCE)
    set(OC_DEFAULT_EXAMPLES_GIT_URL "https://${OC_DEFAULT_EXAMPLES_GIT_HOST}/${OC_DEFAULT_EXAMPLES_GIT_ORGANISATION}/" CACHE STRING "Default OpenCMISS examples Git repository URL." FORCE)
  endif()
else()
  OCCMakeDebug("Not using Git. No Git executable found." 1)
  set(OC_HAVE_GIT FALSE)
  # TODO: use .zip file
  OCCMakeFatalError("Non-git access not implemented.")
endif()

OCGetGitURL(${OC_GIT_HOST} ${OC_GIT_ORGANISATION} _GIT_URL)
set(OC_GIT_URL "${_GIT_URL}" CACHE STRING "OpenCMISS Git repository URL." FORCE)
OCGetGitURL(${OC_DEFAULT_GIT_HOST} ${OC_DEFAULT_GIT_ORGANISATION} _GIT_URL)
set(OC_DEFAULT_GIT_URL "${_GIT_URL}" CACHE STRING "Default OpenCMISS Git repository URL." FORCE)
OCGetGitURL(${OC_DEPENDENCIES_GIT_HOST} ${OC_DEPENDENCIES_GIT_ORGANISATION} _GIT_URL)
set(OC_DEPENDENCIES_GIT_URL "${_GIT_URL}" CACHE STRING "OpenCMISS dependencies Git repository URL." FORCE)
OCGetGitURL(${OC_DEFAULT_DEPENDENCIES_GIT_HOST} ${OC_DEFAULT_DEPENDENCIES_GIT_ORGANISATION} _GIT_URL)
set(OC_DEFAULT_DEPENDENCIES_GIT_URL "${_GIT_URL}" CACHE STRING "Default OpenCMISS dependencies Git repository URL." FORCE)
OCGetGitURL(${OC_EXAMPLES_GIT_HOST} ${OC_EXAMPLES_GIT_ORGANISATION} _GIT_URL)
set(OC_EXAMPLES_GIT_URL "${_GIT_URL}" CACHE STRING "OpenCMISS examples Git repository URL." FORCE)
OCGetGitURL(${OC_DEFAULT_EXAMPLES_GIT_HOST} ${OC_DEFAULT_EXAMPLES_GIT_ORGANISATION} _GIT_URL)
set(OC_DEFAULT_EXAMPLES_GIT_URL "${_GIT_URL}" CACHE STRING "Default OpenCMISS examples Git repository URL." FORCE)

OCCMakeDebug("Using an OpenCMISS Git URL of '${OC_GIT_URL}'." 1)
OCCMakeDebug("Using a default OpenCMISS Git URL of '${OC_DEFAULT_GIT_URL}'." 1)
OCCMakeDebug("Using an OpenCMISS dependencies Git URL of '${OC_DEPENDENCIES_GIT_URL}'." 1)
OCCMakeDebug("Using a default OpenCMISS dependencies Git URL of '${OC_DEFAULT_DEPENDENCIES_GIT_URL}'." 1)
OCCMakeDebug("Using an OpenCMISS examples Git URL of '${OC_EXAMPLES_GIT_URL}'." 1)
OCCMakeDebug("Using a default OpenCMISS examples Git URL of '${OC_DEFAULT_EXAMPLES_GIT_URL}'." 1)
