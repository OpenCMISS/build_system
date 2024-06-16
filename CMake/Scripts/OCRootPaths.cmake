#[=======================================================================[.rst:
OpenCMISS root paths 
--------------------

The OpenCMISS root paths determine where on disk the OpenCMISS build
system and source files are located and where the binary files are
built and installed.

The root paths are specified when cmake is invoked by defining
:var:OpenCMISS_xxx_PATH variables e.g.,

.. code-block:: console

$ cmake -DOpenCMISS_ROOT=/path/to/OpenCMISS

The various OpenCMISS CMake path variables that can be defined are:

**OpenCMISS_ROOT**:PATH
  The path to the main top-level OpenCMISS folder on disk. If this
  variable is not defined then it will first be taken from the
  :var:OpenCMISS_ROOT environment variable if it is defined or
  from the directory above the main OpenCMISS build system
  :file:CMakeLists.txt file if not.

**OpenCMISS_INSTALL_ROOT**:PATH
  The path to where OpenCMISS files are installed. If this variable
  is not defined it will default to :var:${OpenCMISS_ROOT}/install.
  
**OpenCMISS_BUILD_ROOT**:PATH
  The path to where OpenCMISS files are built. If this variable
  is not defined it will default to :var:${OpenCMISS_ROOT}/build.

**OpenCMISS_SOURCE_ROOT**:PATH
  The path to where the OpenCMISS source files are located. If
  this variable is not defined it will defaul to
  :var:${OpenCMISS_ROOT}/src.

**OpenCMISS_DEPENDENCIES_ROOT**:PATH
  The path to the main top-level OpenCMISS folder on disk where
  the dependencies are located. In most cases this will be the same
  as :var:OpenCMISS_ROOT and it will default to this value. If it
  is desired to locate the dependencies for OpenCMISS in a separate
  location from OpenCMISS files proper (e.g., one set of
    dependencies and multiple different sources) then this variable
  can be used to locate the dependencies for eachdifferent source.
  The :var:OpenCMISS_DEPENDENCIES_ROOT is the basis
  for :var:OpenCMISS_DEPENDENCIES_INSTALL_ROOT,
  :var:OpenCMISS_DEPENDENCIES_BUILD_ROOT, and
  :var:OpenCMISS_DEPENDENCIES_SOURCE_ROOT.

**OpenCMISS_DEPENDENCIES_INSTALL_ROOT**:PATH
  The path to where OpenCMISS dependency files are installed. If
  this variable is not defined it will default to
  :var:${OpenCMISS_DEPENDENCIES_ROOT}/install.
  
**OpenCMISS_DEPENDENCIES_BUILD_ROOT**:PATH
  The path to where OpenCMISS dependency files are built. If
  this variable is not defined it will default to
  :var:${OpenCMISS_DEPENDENCIES_ROOT}/build.
  
**OpenCMISS_DEPENDENCIES_SOURCE_ROOT**:PATH
  The path to where the OpenCMISS dependency source files are
  located. If this variable is not defined it will default to
  :var:${OpenCMISS_DEPENDENCY_ROOT}/src.

#]=======================================================================]

# Check that OC_BUILD_SYSTEM_ROOT is defined.
if(NOT DEFINED OC_BUILD_SYSTEM_ROOT)
  OCCMakeFatalError("Incorrect build system setup. OC_BUILD_SYSTEM_ROOT is not defined.") 
endif()
OCCMakeDebug("Using an OC_BUILD_SYSTEM_ROOT of '${OC_BUILD_SYSTEM_ROOT}'." 1)

include(GNUInstallDirs)

# Make sure we have and OC_ROOT
if(DEFINED OpenCMISS_ROOT)
  set(OC_ROOT "${OpenCMISS_ROOT}" CACHE PATH "OpenCMISS root directory path." FORCE)
else()
  # Check if we have an OpenCMISS_ROOT environment variable
  if(DEFINED ENV{OpenCMISS_ROOT})
    set(OC_ROOT $ENV{OpenCMISS_ROOT} CACHE PATH "OpenCMISS root directory path." FORCE)   
  else()
    # Set the OpenCMISS_ROOT relative to this CMakeLists.txt file
    get_filename_component(OC_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../../.." REALPATH CACHE)       
  endif()
endif()
OCCMakeDebug("Using an OC_ROOT of '${OC_ROOT}'." 1)

# If we have OpenCMISS_INSTALL_ROOT defined then use that otherwise take it from OC_ROOT
if(DEFINED OpenCMISS_INSTALL_ROOT)
  set(OC_INSTALL_ROOT "${OpenCMISS_INSTALL_ROOT}" CACHE PATH "OpenCMISS install root directory path." FORCE)
else()
  if(DEFINED ENV{OpenCMISS_INSTALL_ROOT})
    set(OC_INSTALL_ROOT "$ENV{OpenCMISS_INSTALL_ROOT}" CACHE PATH "OpenCMISS install root directory path." FORCE)
  else()
    set(OC_INSTALL_ROOT "${OC_ROOT}/install" CACHE PATH "OpenCMISS install root directory path." FORCE)
  endif()
endif()
OCCMakeDebug("Using an OC_INSTALL_ROOT of '${OC_INSTALL_ROOT}'." 1)

# If we have OpenCMISS_BUILD_ROOT defined then use that otherwise take it from OC_ROOT
if(DEFINED OpenCMISS_BUILD_ROOT)
  set(OC_BUILD_ROOT "${OpenCMISS_BUILD_ROOT}" CACHE PATH "OpenCMISS build root directory path." FORCE)
else()
  if(DEFINED ENV{OpenCMISS_BUILD_ROOT})
    set(OC_BUILD_ROOT "$ENV{OpenCMISS_BUILD_ROOT}" CACHE PATH "OpenCMISS build root directory path." FORCE)
  else()    
    set(OC_BUILD_ROOT "${OC_ROOT}/build" CACHE PATH "OpenCMISS build root directory path." FORCE)
  endif()
endif()
OCCMakeDebug("Using an OC_BUILD_ROOT of '${OC_BUILD_ROOT}'." 1)

# If we have OpenCMISS_SOURCE_ROOT defined then use that otherwise take it from OC_ROOT
if(DEFINED OpenCMISS_SOURCE_ROOT)
  set(OC_SOURCE_ROOT "${OpenCMISS_SOURCE_ROOT}" CACHE PATH "OpenCMISS source root directory path." FORCE)
else()
  if(DEFINED ENV{OpenCMISS_SOURCE_ROOT})
    set(OC_SOURCE_ROOT "$ENV{OpenCMISS_SOURCE_ROOT}" CACHE PATH "OpenCMISS source root directory path." FORCE)
  else()
    set(OC_SOURCE_ROOT "${OC_ROOT}/src" CACHE PATH "OpenCMISS source root directory path." FORCE)
  endif()
endif()
OCCMakeDebug("Using an OC_SOURCE_ROOT of '${OC_SOURCE_ROOT}'." 1)

# See if we have a dependencies root defined otherwise make it the same as OC_ROOT
if(DEFINED OpenCMISS_DEPENDENCIES_ROOT)
  set(OC_DEPENDENCIES_ROOT "${OpenCMISS_DEPENDENCIES_ROOT}" CACHE PATH "OpenCMISS dependencies root directory path." FORCE)
else()
  # Check if we have an OpenCMISS_DEPENDENCIES_ROOT environment variable
  if(DEFINED ENV{OpenCMISS_DEPENDENCIES_ROOT})
    set(OC_DEPENDENCIES_ROOT "$ENV{OpenCMISS_DEPENDENCIES_ROOT}" CACHE PATH "OpenCMISS dependencies root directory path." FORCE)   
  else()
    # Set the OC_DEPENDENCIES_ROOT to be the same as OC_ROOT
    set(OC_DEPENDENCIES_ROOT "${OC_ROOT}" CACHE PATH "OpenCMISS dependencies root directory path." FORCE)   
  endif()
endif()
OCCMakeDebug("Using an OC_DEPENDENCIES_ROOT of '${OC_DEPENDENCIES_ROOT}'." 1)

# If we have OpenCMISS_DEPENDENCIES_INSTALL_ROOT defined then use that otherwise take it from OC_DEPENDENCIES_ROOT
if(DEFINED OpenCMISS_DEPENDENCIES_INSTALL_ROOT)
  set(OC_DEPENDENCIES_INSTALL_ROOT "${OpenCMISS_DEPENDENCIES_INSTALL_ROOT}" CACHE PATH "OpenCMISS dependencies install root directory path." FORCE)
else()
  if(DEFINED ENV{OpenCMISS_DEPENDENCIES_INSTALL_ROOT})
    set(OC_DEPENDENCIES_INSTALL_ROOT "$ENV{OpenCMISS_DEPENDENCIES_INSTALL_ROOT}" CACHE PATH "OpenCMISS dependencies install root directory path." FORCE)
  else()
    set(OC_DEPENDENCIES_INSTALL_ROOT "${OC_DEPENDENCIES_ROOT}/install" CACHE PATH "OpenCMISS dependencies install root directory path." FORCE)
  endif()
endif()
OCCMakeDebug("Using an OC_DEPENDENCIES_INSTALL_ROOT of '${OC_DEPENDENCIES_INSTALL_ROOT}'." 1)

# If we have OpenCMISS_DEPENDENCIES_BUILD_ROOT defined then use that otherwise take it from OC_DEPENDENCIES_ROOT
if(DEFINED OpenCMISS_DEPENDENCIES_BUILD_ROOT)
  set(OC_DEPENDENCIES_BUILD_ROOT "${OpenCMISS_DEPENDENCIES_BUILD_ROOT}" CACHE PATH "OpenCMISS dependencies build root directory path." FORCE)
else()
  if(DEFINED ENV{OpenCMISS_DEPENDENCIES_BUILD_ROOT})
    set(OC_DEPENDENCIES_BUILD_ROOT "$ENV{OpenCMISS_DEPENDENCIES_BUILD_ROOT}" CACHE PATH "OpenCMISS dependencies build root directory path." FORCE)
  else()
    set(OC_DEPENDENCIES_BUILD_ROOT "${OC_DEPENDENCIES_ROOT}/build" CACHE PATH "OpenCMISS dependencies build root directory path." FORCE)
  endif()
endif()
OCCMakeDebug("Using an OC_DEPENDENCIES_BUILD_ROOT of '${OC_DEPENDENCIES_BUILD_ROOT}'." 1)

# If we have OpenCMISS_DEPENDENCIES_SOURCE_ROOT defined then use that otherwise take it from OC_DEPENDENCIES_ROOT
if(DEFINED OpenCMISS_DEPENDENCIES_SOURCE_ROOT)
  set(OC_DEPENDENCIES_SOURCE_ROOT "${OpenCMISS_DEPENDENCIES_SOURCE_ROOT}" CACHE PATH "OpenCMISS dependencies source root directory path." FORCE)
else()
  if(DEFINED ENV{OpenCMISS_DEPENDENCIES_SOURCE_ROOT})
    set(OC_DEPENDENCIES_SOURCE_ROOT "$ENV{OpenCMISS_DEPENDENCIES_SOURCE_ROOT}" CACHE PATH "OpenCMISS dependencies source root directory path." FORCE)
  else()
    set(OC_DEPENDENCIES_SOURCE_ROOT "${OC_DEPENDENCIES_ROOT}/src" CACHE PATH "OpenCMISS dependencies source root directory path." FORCE)
  endif()
endif()
OCCMakeDebug("Using an OC_DEPENDENCIES_SOURCE_ROOT of '${OC_DEPENDENCIES_SOURCE_ROOT}'." 1)

