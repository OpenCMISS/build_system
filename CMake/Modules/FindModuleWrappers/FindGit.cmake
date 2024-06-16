#[=======================================================================[.rst:
OpenCMISS FindGit
-----------------

An OpenCMISS wrapper to find a git implementation.

#]=======================================================================]


include(OCCMakeMiscellaneous)

#if(OpenCMISS_FIND_SYSTEM_GIT)
  
  OCCMakeMessage(STATUS "Trying to find Git at the system level...")

  set(_ORIGINAL_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
  set(CMAKE_MODULE_PATH "")

  find_package(Git)

  set(CMAKE_MODULE_PATH "${_ORIGINAL_CMAKE_MODULE_PATH}")
  unset(_ORIGINAL_CMAKE_MODULE_PATH)
  
#endif()

#if(NOT GIT_FOUND)
#  
#  OCCMakeMessage(STATUS "Trying to find git in the OpenCMISS build system.")
#    
#endif()
