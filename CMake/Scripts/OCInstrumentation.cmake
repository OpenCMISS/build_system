#[=======================================================================[.rst:
OpenCMISS Instrumentation 
-------------------------

All functions related to OpenCMISS_INSTRUMENTATION

All the short mnemonics for instrumentation are:
        
:gprof: Use GNU gprof instrumentation
:none: Use no instrumentation
:scorep: Use Score-P instrumentation
:vtune: Use Intel VTune instrumentation 

#]=======================================================================]

set(OC_INSTRUMENTATION_GPROF OFF)
set(OC_INSTRUMENTATION_NONE OFF)
set(OC_INSTRUMENTATION_SCOREP OFF)
set(OC_INSTRUMENTATION_VTUNE OFF)
if(DEFINED OpenCMISS_INSTRUMENTATION)
  string(TOLOWER "${OpenCMISS_INSTRUMENTATION}" _LOWERCASE_INSTRUMENTATION)
else()
  if(DEFINED OC_INSTRUMENTATION)
    string(TOLOWER "${OC_INSTRUMENTATION}" _LOWERCASE_INSTRUMENTATION)
  else()
    if(DEFINED ENV{OpenCMISS_INSTRUMENTATION})
      string(TOLOWER "$ENV{OpenCMISS_INSTRUMENTATION}" _LOWERCASE_INSTRUMENTATION)     
    else()
      set(_LOWERCASE_INSTRUMENTATION "none")
    endif()
  endif()
endif()

if(_LOWERCASE_INSTRUMENTATION STREQUAL "gprof")
  set(OC_INSTRUMENTATION "GProf" CACHE STRING "OpenCMISS instrumentation." FORCE)
  set(OC_INSTRUMENTATION_GPROF ON)
elseif(_LOWERCASE_INSTRUMENTATION STREQUAL "none")
  set(OC_INSTRUMENTATION "None" CACHE STRING "OpenCMISS instrumentation." FORCE)
  set(OC_INSTRUMENTATION_NONE ON)
elseif(_LOWERCASE_INSTRUMENTATION STREQUAL "scorep")
  set(OC_INSTRUMENTATION "ScoreP" CACHE STRING "OpenCMISS instrumentation." FORCE)
  set(OC_INSTRUMENTATION_SCOREP ON)    
elseif(_LOWERCASE_INSTRUMENTATION STREQUAL "vtune")
  set(OC_INSTRUMENTATION "VTune" CACHE STRING "OpenCMISS instrumentation." FORCE)
  set(OC_INSTRUMENTATION_VTUNE ON)
else()
  set(OC_INSTRUMENTATION "None" CACHE STRING "OpenCMISS instrumentation." FORCE)
  set(OC_INSTRUMENTATION_NONE ON)
  OCCMakeWarning("The instrumentation of ${_LOWERCASE_INSTRUMENTATION} is unknown. Defaulting to none.")
endif()

OCCMakeDebug("Using an instrumentation of '${OC_INSTRUMENTATION}'." 1)

unset(_LOWERCASE_INSTRUMENTATION)
