#[=======================================================================[.rst:
OpenCMISS FindScoreP
--------------------

An OpenCMISS wrapper to find a Score-P implementation.

#]=======================================================================]

include(OCCMakeMiscFunctions)
include(OCCMakeFindUtilityFunctions)

OCCMakeMessage(STATUS "Trying to find Score-P...")

if(NOT DEFINED SCOREP_FOUND)
  set(SCOREP_FOUND NO)
endif()

if(OpenCMISS_FIND_SYSTEM_SCOREP)
  
  OCCMakeMessage(STATUS "Trying to find Score-P at the system level.")
  
  OCCMakeClearModulePath()

  find_package(ScoreP)

  OCCMakeRestoreModulePath()

endif()

if(NOT SCOREP_FOUND)
  
  OCCMakeMessage(STATUS "Trying to find Score-P in the OpenCMISS build system.")

  # Try and find Score-P in the OpenCMISS install configs

  if(NOT SCOREP_FOUND)

    # Try and find Score-P in the a few standard places

    find_program(SCOREP_CONFIG NAMES scorep-config
      PATHS
      ${SCOREP_CONFIG_PATH}
      $ENV{SCOREP_ROOT}
      /opt/scorep/bin
    )

  if(NOT SCOREP_CONFIG)
    
      OCCMakeMessage(STATUS "Score-P config was not found.")
      set(SCOREP_FOUND FALSE)
      
    else()

      OCCMakeDebug("Score-P library found. Using ${SCOREP_CONFIG}.")

      # Find Score-P compile files
      execute_process(COMMAND ${SCOREP_CONFIG} "--user" "--cppflags" OUTPUT_VARIABLE SCOREP_INCLUDE_DIRS)
      string(REPLACE "-I" ";" SCOREP_INCLUDE_DIRS ${SCOREP_INCLUDE_DIRS})

      # Find Score-P link flags
      execute_process(COMMAND ${SCOREP_CONFIG} "--user" "--ldflags" OUTPUT_VARIABLE _LINK_LD_ARGS)
      string( REPLACE " " ";" _LINK_LD_ARGS ${_LINK_LD_ARGS} )
      foreach( _ARG ${_LINK_LD_ARGS} )
        if(${_ARG} MATCHES "^-L")
          string(REGEX REPLACE "^-L" "" _ARG ${_ARG})
          set(SCOREP_LINK_DIRS ${SCOREP_LINK_DIRS} ${_ARG})
        endif()
      endforeach()

      # Find Score-P link libraries
      execute_process(COMMAND ${SCOREP_CONFIG} "--user" "--libs" OUTPUT_VARIABLE _LINK_LD_ARGS)
      string(REPLACE " " ";" _LINK_LD_ARGS ${_LINK_LD_ARGS} )
      foreach(_ARG ${_LINK_LD_ARGS} )
        if(${_ARG} MATCHES "^-l")
          string(REGEX REPLACE "^-l" "" _ARG ${_ARG})
          find_library(_SCOREP_LIB_FROM_ARG NAMES ${_ARG}
            PATHS
            ${SCOREP_LINK_DIRS}
          )
          if(_SCOREP_LIB_FROM_ARG)
            set(SCOREP_LIBRARIES ${SCOREP_LIBRARIES} ${_SCOREP_LIB_FROM_ARG})
          endif()
          unset(_SCOREP_LIB_FROM_ARG CACHE)
        endif ()
      endforeach()

      set(SCOREP_FOUND TRUE)
      
    endif()

    mark_as_advanced(SCOREP_CONFIG)
    
  endif()
    
endif()
