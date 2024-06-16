#[=======================================================================[.rst:
OpenCMISS Multithreading
------------------------

All functions related to OpenCMISS_MULTITHREADING

All the short mnemonics for multithreading are:
        
:none: Do not use any multithreading
:openacc: Use OpenAcc multithreading
:openmp: Use OpenMP multithreading

#]=======================================================================]

set(OC_MULTITHREADING_NONE OFF)
set(OC_MULTITHREADING_OPENACC OFF)
set(OC_MULTITHREADING_OPENMP OFF)
if(DEFINED OpenCMISS_MULTITHREADING)
  string(TOLOWER "${OpenCMISS_MULTITHREADING}" _LOWERCASE_MULTITHREADING)
else()
  if(DEFINED OC_MULTITHREADING)
    string(TOLOWER "${OC_MULTITHREADING}" _LOWERCASE_MULTITHREADING)
  else()
    if(DEFINED ENV{OpenCMISS_MULTITHREADING})
      string(TOLOWER "$ENV{OpenCMISS_MULTITHREADING}" _LOWERCASE_MULTITHREADING)
    else()
      set(_LOWERCASE_MULTITHREADING "none")
    endif()
  endif()
endif()

if(_LOWERCASE_MULTITHREADING STREQUAL "none")
  set(OC_MULTITHREADING "None" CACHE STRING "OpenCMISS multithreading" FORCE)
  set(OC_MULTITHREADING_NONE ON)
elseif(_LOWERCASE_MULTITHREADING STREQUAL "openacc")
  set(OC_MULTITHREADING "OpenACC" CACHE STRING "OpenCMISS multithreading" FORCE)
  set(OC_MULTITHREADING_OPENACC ONE)
elseif(_LOWERCASE_MULTITHREADING STREQUAL "openmp")
  set(OC_MULTITHREADING "OpenMP" CACHE STRING "OpenCMISS multithreading" FORCE)
  set(OC_MULTITHREADING_OPENMP ON)
else()
  set(OC_MULTITHREADING "None" CACHE STRING "OpenCMISS multithreading" FORCE)
  set(OC_MULTITHREADING_NONE ON)
  OCCMakeWarning("The multithreading type of ${_LOWERCASE_MULTITHREADING} is unknown. Defaulting to none.")
endif()

OCCMakeDebug("Using a multithreading of '${OC_MULTITHREADING}'." 1)
  
unset(_LOWERCASE_MULTITHREADING)
  

