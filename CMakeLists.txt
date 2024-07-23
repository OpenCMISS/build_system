#[=======================================================================[.rst:
OpenCMISS CMake Build
=====================

The CMake build system to build OpenCMISS and its dependencies.

In general, variable names that start with OC_ are internal
variables. Variables that start with OpenCMISS_ are external variables
that have been specified using -DOpenCMISS_xxx=yyy etc.

#]=======================================================================]

# include basic info such as roots, cmake minimum version, basic functions

# Set and check minimum CMake version required for the build system
# TODO: make warning to be nicer if we have really old versions of CMake

set(OC_CMAKE_MIN_MAJOR_VERSION "3" CACHE INTERNAL "OpenCMISS minimum CMake major version")
set(OC_CMAKE_MIN_MINOR_VERSION "26" CACHE INTERNAL "OpenCMISS minimum CMake minor version")
set(OC_CMAKE_MIN_PATCH_VERSION "0" CACHE INTERNAL "OpenCMISS minimum CMake patch version")
set(OC_CMAKE_MIN_TWEAK_VERSION "0" CACHE INTERNAL "OpenCMISS minimum CMake tweak version")
set(OC_CMAKE_MIN_VERSION "${OC_CMAKE_MIN_MAJOR_VERSION}.${OC_CMAKE_MIN_MINOR_VERSION}.${OC_CMAKE_MIN_PATCH_VERSION}" CACHE INTERNAL "OpenCMISS minimum CMake version")

cmake_minimum_required(VERSION ${OC_CMAKE_MIN_VERSION} FATAL_ERROR)

# Set the version of the OpenCMISS

set(OC_BUILD_SYSTEM_MAJOR_VERSION "0" CACHE INTERNAL "OpenCMISS Build System major version")
set(OC_BUILD_SYSTEM_MINOR_VERSION "9" CACHE INTERNAL "OpenCMISS Build System minor version")
set(OC_BUILD_SYSTEM_PATCH_VERSION "0" CACHE INTERNAL "OpenCMISS Build System patch version")
set(OC_BUILD_SYSTEM_VERSION "${OC_BUILD_SYSTEM_MAJOR_VERSION}.${OC_BUILD_SYSTEM_MINOR_VERSION}.${OC_BUILD_SYSTEM_PATCH_VERSION}" CACHE INTERNAL "OpenCMISS Build System version")

set(OC_CMAKE_SUBDIR "CMake")
set(OC_CMAKE_SCRIPTS_SUBDIR "${OC_CMAKE_SUBDIR}/Scripts")
set(OC_CMAKE_MODULES_SUBDIR "${OC_CMAKE_SUBDIR}/Modules")
set(OC_CMAKE_FIND_MODULES_SUBDIR "${OC_CMAKE_MODULES_SUBDIR}/FindModuleWrappers")
set(OC_CMAKE_TEMPLATES_SUBDIR "${OC_CMAKE_SUBDIR}/Templates")

set(CMAKE_PROJECT_OpenCMISS-Build-System_INCLUDE_BEFORE "${CMAKE_CURRENT_SOURCE_DIR}/${OC_CMAKE_SCRIPTS_SUBDIR}/OCPreProject.cmake")

project(OpenCMISS-Build-System
  LANGUAGES C CXX Fortran
  VERSION ${OC_BUILD_SYSTEM_VERSION}
  DESCRIPTION "OpenCMISS computional environment build system"
  HOMEPAGE_URL "https://www.opencmiss.org/")  

OCCMakeDebug("Current CMake version = ${CMAKE_VERSION}, minimum required CMake version = ${OC_CMAKE_MIN_VERSION}." 1)

# Initialise the build system
if(DEFINED OpenCMISS_CMAKE_STAGE)
  set(OC_CMAKE_STAGE "${OpenCMISS_CMAKE_STAGE}")
else()
  set(OC_CMAKE_STAGE "setup")
endif()
OCCMakeDebug("Current OpenCMISS CMake stage is ${OC_CMAKE_STAGE}." 1)

# Check multi-config environment
get_property(OC_HAVE_MULTICONFIG_ENV GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

# Work out the build system root
if(NOT DEFINED OC_BUILD_SYSTEM_ROOT)
  if(DEFINED OpenCMISS_ROOT)
    set(OC_BUILD_SYSTEM_ROOT "${OpenCMISS_ROOT}/build_system" CACHE PATH "OpenCMISS build system root" FORCE)
  else()
    if(DEFINED OC_ROOT)
      # If we are running from with a cached OC_ROOT variable use that
      set(OC_BUILD_SYSTEM_ROOT "${OC_ROOT}/build_system" CACHE PATH "OpenCMISS build system root" FORCE)
    else()
      # Use the path relative to this CMakeLists.txt script
      get_filename_component(OC_BUILD_SYSTEM_ROOT "${CMAKE_CURRENT_SOURCE_DIR}" REALPATH CACHE)
    endif()
  endif()
endif()

# Options for paths
include(GNUInstallDirs)
set(OC_INSTALL_DATA_SUBDIR "${CMAKE_INSTALL_DATAROOTDIR}" CACHE PATH "Sub-directory under CMAKE_INSTALL_PREFIX for OpenCMISS data.")
set(OC_BUILD_CONFIGS_SUBDIR "/configs" CACHE PATH "Sub-directory under the build root for OpenCMISS configuration data.")

# Determine CMake module and prefix paths
set(OC_CMAKE_MODULE_PATH )
set(OC_CMAKE_PREFIX_PATH )
if(OC_CMAKE_STAGE STREQUAL "setup")
  # Append the build system root scripts directory to the module path
  list(APPEND OC_CMAKE_MODULE_PATH ${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_SCRIPTS_SUBDIR})
  # Append the find module wrappers to the prefix path
  list(APPEND OC_CMAKE_PREFIX_PATH ${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_FIND_MODULES_SUBDIR})
elseif(OC_CMAKE_STAGE STREQUAL "configure")
  if(DEFINED OpenCMISS_CURRENT_CONFIG_DIRECTORY)
    if(DEFINED OpenCMISS_INSTALL_ROOT)
      # Append the install root scripts directory to the module path
      list(APPEND OC_CMAKE_MODULE_PATH "${OpenCMISS_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_SCRIPTS_SUBDIR}")
      # Add in the modules and find module wrappers
      list(APPEND OC_CMAKE_MODULE_PATH "${OpenCMISS_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_MODULES_SUBDIR}")
      list(APPEND OC_CMAKE_MODULE_PATH "${OpenCMISS_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_FIND_MODULES_SUBDIR}")
      # Add in the configure variables directory
      list(APPEND OC_CMAKE_MODULE_PATH "${OpenCMISS_CURRENT_CONFIG_DIRECTORY}/Variables")
      # Add in the find module wrappers to the 
      list(APPEND OC_CMAKE_PREFIX_PATH "${OpenCMISS_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_FIND_MODULES_SUBDIR}")
    else()
      OCCMakeFatalError("Invalid build system setup. In the OpenCMISS configure cmake stage but no install root has been defined.")    
    endif()
  else()
    OCCMakeFatalError("Invalid build system setup. In the OpenCMISS configure cmake stage but no current config directory has been defined.")    
  endif()
elseif(OC_CMAKE_STAGE STREQUAL "build")
  if(NOT DEFINED OpenCMISS_CURRENT_CONFIG_DIRECTORY)
    OCCMakeFatalError("Invalid build system setup. In the OpenCMISS build cmake stage but no current config directory has been defined.")    
  endif()
else()
  OCCMakeFatalError("Invalid build system setup. Unknown OC_CMAKE_STAGE of '${OC_CMAKE_STAGE}'.")
endif()

# Prepend in OpenCMISS paths to the module path
list(PREPEND CMAKE_MODULE_PATH ${OC_CMAKE_MODULE_PATH})
# Prepend in OpenCMISS paths to the prefix path
list(PREPEND CMAKE_PREFIX_PATH ${OC_CMAKE_PREFIX_PATH})

# Do a sanity test on the build system root
list(GET CMAKE_MODULE_PATH 0 _MODULE_PATH_HEAD)
if(NOT EXISTS "${_MODULE_PATH_HEAD}/OCArchitecturePath.cmake")
  OCCMakeFatalError("Incorrect build system setup. Could not find OCArchitecturePath.cmake in '${_MODULE_PATH_HEAD}'.")
endif()
unset(_MODULE_PATH_HEAD)

OCCMakeDebug("Using an OC_CMAKE_MODULE_PATH of '${OC_CMAKE_MODULE_PATH}'" 1)
OCCMakeDebug("Using an OC_CMAKE_PREFIX_PATH of '${OC_CMAKE_PREFIX_PATH}'" 1)

# Define any CMake stuff
include(OCCMakeSetup)

# Define the root paths
include(OCRootPaths)

# This is the support email for general enquiries and support about building OpenCMISS using the CMake build system.
set(OC_BUILD_SUPPORT_EMAIL "developers@opencmiss.org")

#include(OCBuildSetup)

# Determine OS etc.
include(OCOperatingSystems)

# Ensure that the developer/user is set
include(OCRepositories)

# Ensure that Github is setup
include(OCGitHub)

# Ensure that the build type is set
include(OCBuildTypes)

# Ensure that the MPI is set
include(OCMPI)
if(${OC_CMAKE_STAGE} STREQUAL "setup")
  OCSetMPILibrary(OC_MPI_LIB_NAME)
endif()

# Ensure that the instrumentation is set
include(OCInstrumentation)

# Ensure that the multithreading is set
include(OCMultithreading)

# Set up the architecture path
include(OCArchitecturePath)
OCGetArchitecturePath(OC_NOMPI_ARCH_PATH OC_MPI_ARCH_PATH)

OCCMakeDebug("Using OC_CMAKE_FLAGS of '${OC_CMAKE_FLAGS}'" 1)

# Create the setup target

# Determine the configuration directory
if(DEFINED OpenCMISS_CURRENT_CONFIG_DIRECTORY)
  set(OC_CURRENT_CONFIG_DIRECTORY "${OpenCMISS_CURRENT_CONFIG_DIRECTORY}")
else()
  if(OC_HAVE_MULTICONFIG_ENV)
    set(OC_CURRENT_CONFIG_DIRECTORY "${OC_BUILD_ROOT}${OC_BUILD_CONFIGS_SUBDIR}/${OC_MPI_ARCH_PATH}")
  else()
    set(OC_CURRENT_CONFIG_DIRECTORY "${OC_BUILD_ROOT}${OC_BUILD_CONFIGS_SUBDIR}/${OC_MPI_ARCH_PATH}/${OC_BUILD_TYPE}")
  endif()
endif()
OCCMakeDebug("Using a configuration directory of '${OC_CURRENT_CONFIG_DIRECTORY}'" 1)

# Determine the module paths for the current configuration
# TODO: on the configuration and build steps change the module path from the build-system to install?
set(OC_CURRENT_CONFIG_MODULE_PATH "${OC_CURRENT_CONFIG_DIRECTORY}/Variables")
list(PREPEND OC_CURRENT_CONFIG_MODULE_PATH "${CMAKE_MODULE_PATH}")

# Create configuration arguments from the -DOpenCMISS_xxx definitions
set(OC_CURRENT_CONFIG_ARGUMENTS "-DOC_BUILD_SYSTEM_ROOT=${OC_BUILD_SYSTEM_ROOT}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_ROOT=${OC_ROOT}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_INSTALL_ROOT=${OC_INSTALL_ROOT}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_BUILD_ROOT=${OC_BUILD_ROOT}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_SOURCE_ROOT=${OC_SOURCE_ROOT}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEPENDENCIES_INSTALL_ROOT=${OC_DEPENDENCIES_INSTALL_ROOT}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEPENDENCIES_BUILD_ROOT=${OC_DEPENDENCIES_BUILD_ROOT}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEPENDENCIES_SOURCE_ROOT=${OC_DEPENDENCIES_SOURCE_ROOT}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_CMAKE_DEBUG=${OC_CMAKE_DEBUG}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_CMAKE_DEBUG_LEVEL=${OC_CMAKE_DEBUG_LEVEL}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_CMAKE_TRACE=${OC_CMAKE_TRACE}")
if(OC_DEVELOPER)
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEVELOPER=True")
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEVELOPER_GIT_HOST=${OC_DEVELOPER_GIT_HOST}")
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEVELOPER_GIT_ORGANISATION=${OC_DEVELOPER_GIT_ORGANISATION}")
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEVELOPER_GIT_BRANCH=${OC_DEVELOPER_GIT_BRANCH}")
endif()
if(OC_DEVELOPER_DEPENDENCIES)
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEVELOPER_DEPENDENCIES=True")
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEVELOPER_DEPENDENCIES_GIT_HOST=${OC_DEVELOPER_DEPENDENCIES_GIT_HOST}")
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEVELOPER_DEPENDENCIES_GIT_ORGANISATION=${OC_DEVELOPER_DEPENDENCIES_GIT_ORGANISATION}")
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEVELOPER_DEPENDENCIES_GIT_BRANCH=${OC_DEVELOPER_DEPENDENCIES_GIT_BRANCH}")
endif()
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_EXAMPLES_GIT_HOST=${OC_EXAMPLES_GIT_HOST}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_EXAMPLES_GIT_ORGANISATION=${OC_EXAMPLES_GIT_ORGANISATION}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_EXAMPLES_GIT_BRANCH=${OC_EXAMPLES_GIT_BRANCH}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_TOOLCHAIN=${OC_TOOLCHAIN}")
if(NOT OC_HAVE_MULTICONFIG_ENV)
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_BUILD_TYPE=${OC_BUILD_TYPE}")
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_DEPENDENCIES_BUILD_TYPE=${OC_DEPENDENCIES_BUILD_TYPE}")
else()
  # FIX --config=<$CONFIGURATION> ETC.
endif()
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_MPI=${OC_MPI_LIBRARY_NAME}")
if(NOT OC_MPI_NONE)
  list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_MPI_BUILD_TYPE=${OC_MPI_BUILD_TYPE}")
endif()
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_INSTRUMENTATION=${OC_INSTRUMENTATION}")
if(OC_INSTRUMENTATION_SCOREP)
  foreach(_LANGUAGE C CXX Fortran)
    if(CMAKE_${_LANGUAGE}_COMPILER)
      #TODO How is this going to work with OpenCMISS_TOOLCHAIN in the init project? Maybe set OpenCMISS_CMAKE_LANG_COMPILER and then override toolchain?
      string(CONCAT TEMP_${_LANGUAGE}_COMPILER "scorep-" "${CMAKE_${_LANGUAGE}_COMPILER}")
      list(APPEND OC_CURRENT_CONFIG_ARGUMENTS -DCMAKE_${_LANGUAGE}_COMPILER=${TEMP_${_LANGUAGE}_COMPILER})
    endif()
  endforeach()
endif()
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_MULTITHREADING=${OC_MULTITHREADING}")
list(APPEND OC_CURRENT_CONFIG_ARGUMENTS "-DOpenCMISS_CURRENT_CONFIG_DIRECTORY=${OC_CURRENT_CONFIG_DIRECTORY}")

set(OC_VARIABLES_CMAKE_ARGUMENTS
  ${OC_CMAKE_DEFINES}
  -DOC_BUILD_SYSTEM_ROOT=${OC_BUILD_SYSTEM_ROOT}
  -DOC_CURRENT_CONFIG_DIRECTORY=${OC_CURRENT_CONFIG_DIRECTORY}
  -DOC_GIT_HOST=${OC_GIT_HOST} 
  -DOC_GIT_ORGANISATION=${OC_GIT_ORGANISATION} 
  -DOC_GIT_BRANCH=${OC_GIT_BRANCH} 
  -DOC_DEPENDENCIES_GIT_HOST=${OC_DEPENDENCIES_GIT_HOST} 
  -DOC_DEPENDENCIES_GIT_ORGANISATION=${OC_DEPENDENCIES_GIT_ORGANISATION} 
  -DOC_DEPENDENCIES_GIT_BRANCH=${OC_DEPENDENCIES_GIT_BRANCH} 
  -DOC_DEFAULT_USE_NOMPI=${OC_DEFAULT_USE_NOMPI} 
  -DOC_DEFAULT_USE_MPI=${OC_DEFAULT_USE_MPI}
)
 
# Handle the configuration for OpenCMISS
include(OCConfigure)  

###

add_custom_target(setup_directories
  COMMAND ${CMAKE_COMMAND} -E make_directory ${OC_BUILD_ROOT}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${OC_INSTALL_ROOT}
  WORKING_DIRECTORY ${OC_ROOT}
  COMMENT "Creating build and install directories..."
)

add_custom_target(setup_build_system_files
  COMMAND ${CMAKE_COMMAND} ${OC_CMAKE_FLAGS} ${OC_CMAKE_DEFINES}
  -DOC_BUILD_SYSTEM_ROOT=${OC_BUILD_SYSTEM_ROOT}
  -DOC_CURRENT_CONFIG_DIRECTORY=${OC_CURRENT_CONFIG_DIRECTORY}
  -DOC_INSTALL_ROOT=${OC_INSTALL_ROOT}
  -DOC_INSTALL_DATA_SUBDIR=${OC_INSTALL_DATA_SUBDIR}
  -DOC_CMAKE_SCRIPTS_SUBDIR=${OC_CMAKE_SCRIPTS_SUBDIR}
  -DOC_CMAKE_MODULES_SUBDIR=${OC_CMAKE_MODULES_SUBDIR}
  -DOC_CMAKE_FIND_MODULES_SUBDIR=${OC_CMAKE_FIND_MODULES_SUBDIR}
  -DOC_CMAKE_TEMPLATES_SUBDIR=${OC_CMAKE_TEMPLATES_SUBDIR}
  -DOC_CMAKE_MIN_VERSION=${OC_CMAKE_MIN_VERSION}
  -DOC_CMAKE_MODULE_PATH="${OC_CMAKE_MODULE_PATH}"
  -P ${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_SCRIPTS_SUBDIR}/OCInstallBuildSystem.cmake
  DEPENDS setup_directories
  WORKING_DIRECTORY ${OC_ROOT}
  COMMENT "Setting up OpenCMISS build system files..."
)

add_custom_target(setup ALL
  DEPENDS setup_build_system_files
  WORKING_DIRECTORY ${OC_ROOT}
  COMMENT "Setting up OpenCMISS build system..."
)

add_custom_target(create_config_directories
  COMMAND ${CMAKE_COMMAND} -E make_directory ${OC_CURRENT_CONFIG_DIRECTORY}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${OC_CURRENT_CONFIG_DIRECTORY}/Variables
  DEPENDS setup
  WORKING_DIRECTORY ${OC_BUILD_ROOT}
  COMMENT "Creating configuration directories..."
)

add_custom_target(create_config_files
  COMMAND ${CMAKE_COMMAND} ${OC_CMAKE_FLAGS}
  ${OC_VARIABLES_CMAKE_ARGUMENTS}
  -P ${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_SCRIPTS_SUBDIR}/OCInstallVariables.cmake
  DEPENDS create_config_directories
  WORKING_DIRECTORY ${OC_CURRENT_CONFIG_DIRECTORY}
  COMMENT "Creating configuration files..."
)

add_custom_target(create_configuration
  COMMAND ${CMAKE_COMMAND} ${OC_CMAKE_FLAGS}
  ${OC_CURRENT_CONFIG_ARGUMENTS}
  -DOpenCMISS_CMAKE_STAGE="configure"
  ${OC_BUILD_SYSTEM_ROOT}/.
  DEPENDS create_config_files
  WORKING_DIRECTORY ${OC_CURRENT_CONFIG_DIRECTORY}
  COMMENT "Creating OpenCMISS configuration..."
)

add_custom_target(dependencies
  DEPENDS ${OC_DEPENDENCIES_LIST}
  WORKING_DIRECTORY ${OC_CURRENT_CONFIG_DIRECTORY}
  COMMENT "Building OpenCMISS dependencies..."
)

add_custom_target(build_configuration
  COMMAND ${CMAKE_COMMAND} --build ${OC_CURRENT_CONFIG_DIRECTORY}/. ${OC_CMAKE_BUILD_FLAGS} 
  DEPENDS dependencies create_configuration
  WORKING_DIRECTORY ${OC_CURRENT_CONFIG_DIRECTORY}
  COMMENT "Building OpenCMISS configuration..."
)

add_custom_target(opencmiss_all
  ALL
  DEPENDS build_configuration
  WORKING_DIRECTORY ${OC_CURRENT_CONFIG_DIRECTORY}
  COMMENT "Building OpenCMISS..."
)

unset(OC_CMAKE_STAGE)
