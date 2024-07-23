#[=======================================================================[.rst:
OpenCMISS Configure
--------------------

Handles all code for the configuration for OpenCMISS and its dependencies.

#]=======================================================================]

include(OCSetupExternal)

set(OC_KNOWN_DEPENDENCIES
  cellml-api
  csim
  cube4
  FieldML-API
  HDF5
  HYPRE
  lapack
  libcellml
  LibXml2
  llvm-project
  METIS
  mpich
  MUMPS
  ompi
  opari2
  otf2
  papi
  ParMETIS
  petsc
  scalapack
  scalasca
  SCOTCH
  slepc
  SuiteSparse
  sundials
  SuperLU
  SuperLU_DIST
  SuperLU_MT
  tau2
  ZLIB
  CACHE INTERNAL "List of known dependencies and tools for OpenCMISS." FORCE
)

set(OC_DEPENDENCIES_WITH_MPI
  HDF5
  MUMPS
  ParMETIS
  PETSc
  SCOTCH
  SLEPc
  SuperLU_DIST
  CACHE INTERNAL "List of OpenCMISS dependencies that use MPI." FORCE
)
  
if(OC_CMAKE_STAGE STREQUAL "configure")
  OCCMakeDebug("Creating configuration target specific code...." 1)
 
  # Include the configuration variables that define the build and the dependencies.
  include(OpenCMISS_Variables)

  # Set up base directories for source, build and install
  set(OC_SOURCE_BASE_DIR "${OC_SOURCE_ROOT}")
  set(OC_MPI_BUILD_BASE_DIR "${OC_BUILD_ROOT}/${OC_MPI_ARCH_PATH}")
  set(OC_NOMPI_BUILD_BASE_DIR "${OC_BUILD_ROOT}/${OC_NOMPI_ARCH_PATH}")
  set(OC_MPI_INSTALL_BASE_DIR "${OC_INSTALL_ROOT}/${OC_MPI_ARCH_PATH}")
  set(OC_NOMPI_INSTALL_BASE_DIR "${OC_INSTALL_ROOT}/${OC_NOMPI_ARCH_PATH}")
  set(OC_DEPENDENCIES_SOURCE_BASE_DIR "${OC_DEPENDENCIES_SOURCE_ROOT}/dependencies")
  set(OC_DEPENDENCIES_MPI_BUILD_BASE_DIR "${OC_DEPENDENCIES_BUILD_ROOT}/${OC_MPI_ARCH_PATH}/dependencies")
  set(OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR "${OC_DEPENDENCIES_BUILD_ROOT}/${OC_NOMPI_ARCH_PATH}/dependencies")
  set(OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR "${OC_DEPENDENCIES_INSTALL_ROOT}/${OC_MPI_ARCH_PATH}")
  set(OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR "${OC_DEPENDENCIES_INSTALL_ROOT}/${OC_NOMPI_ARCH_PATH}")
  OCCMakeDebug("" 1)
  OCCMakeDebug("Base directories for the configuration:" 1)
  OCCMakeDebug("  OpenCMISS:" 1)
  OCCMakeDebug("    Source:          '${OC_SOURCE_BASE_DIR}'" 1)
  OCCMakeDebug("    MPI Build:       '${OC_MPI_BUILD_BASE_DIR}'" 1)
  OCCMakeDebug("    Non MPI Build:   '${OC_NOMPI_BUILD_BASE_DIR}'" 1)
  OCCMakeDebug("    MPI Install:     '${OC_MPI_INSTALL_BASE_DIR}'" 1)
  OCCMakeDebug("    Non MPI Install: '${OC_NOMPI_INSTALL_BASE_DIR}'" 1)
  OCCMakeDebug("  Dependencies:" 1)
  OCCMakeDebug("    Source:          '${OC_DEPENDENCIES_SOURCE_BASE_DIR}'" 1)
  OCCMakeDebug("    MPI Build:       '${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}'" 1)
  OCCMakeDebug("    Non MPI Build:   '${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}'" 1)
  OCCMakeDebug("    MPI Install:     '${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}'" 1)
  OCCMakeDebug("    Non MPI Install: '${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}'" 1)
  
  # Work out any settings based on the variables
  
  if(OpenCMISS_DEPENDENCIES_BUILD_PRECISION MATCHES "[Ss]")
    set(OC_DEPENDENCIES_SINGLE_REAL_PRECISION ON)
  else()
    set(OC_DEPENDENCIES_SINGLE_REAL_PRECISION OFF)
  endif()
  if(OpenCMISS_DEPENDENCIES_BUILD_PRECISION MATCHES "[Dd]")
    set(OC_DEPENDENCIES_DOUBLE_REAL_PRECISION ON)
  else()
    set(OC_DEPENDENCIES_DOUBLE_REAL_PRECISION OFF)
  endif()
  if(OpenCMISS_DEPENDENCIES_BUILD_PRECISION MATCHES "[Cc]")
    set(OC_DEPENDENCIES_SINGLE_COMPLEX_PRECISION ON)
  else()
    set(OC_DEPENDENCIES_SINGLE_COMPLEX_PRECISION OFF)
  endif()
  if(OpenCMISS_DEPENDENCIES_BUILD_PRECISION MATCHES "[Zz]")
    set(OC_DEPENDENCIES_DOUBLE_COMPLEX_PRECISION ON)
  else()
    set(OC_DEPENDENCIES_DOUBLE_COMPLEX_PRECISION OFF)
  endif()

  # Work out any additional requirements across dependencies

  # CUDA
  if(OpenCMISS_WITH_CUDA)
    # We have CUDA
    enable_language(CUDA)
    include(CheckLanguage)
    check_language(CUDA)
  endif()

  # Python

  # Multithreading
  if(OC_MULTITHREADING_OPENMP)
    
    # We need OpenMP
    find_package(OpenMP)
    
  elseif(OC_MULTITHREADING_OPENACC)
    
    # We need OpenACC
    find_package(OpenACC)
    
  endif()

  set(_LANGUAGES )
  list(APPEND _LANGUAGES "Fortran")
  list(APPEND _LANGUAGES "C")
  list(APPEND _LANGUAGES "CXX")
  if(OC_USE_CUDA)
    list(APPEND _LANGUAGES "CUDA")
  endif()
  set(OC_LANGUAGES "${_LANGUAGES}" CACHE STRING "OpenCMISS languages for building." FORCE)

  OCCMakeDebug("  Languages:" 1)
  OCCMakeDebug("    OC_LANGUAGES: '${OC_LANGUAGES}'" 1)

  # Fix up MPI compiler wrapper for Intel/Intel
  if(OC_TOOLCHAIN_INTEL)
    if(OC_MPI_INTEL)
      find_program(MPI_C_COMPILER NAMES mpiicx REQUIRED)
      find_program(MPI_CXX_COMPILER NAMES mpiicpx REQUIRED)
      find_program(MPI_Fortran_COMPILER NAMES mpiifx REQUIRED)
    endif()
  endif()
  
  # Determine external defines.

  set(OC_EXTERNAL_CMAKE_ARGS "-DCMAKE_MODULE_PATH=${OC_INSTALL_ROOT}/share/CMake/Scripts${OC_CMAKE_SEPARATOR}${OC_INSTALL_ROOT}/share/CMake/Modules/FindModuleWrappers")
  if(NOT OC_HAVE_MULTICONFIG_ENV)
    list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
  endif()
  if(DEFINED OC_CMAKE_DEBUG)
    list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DOC_CMAKE_DEBUG=ON")
    list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DOC_CMAKE_DEBUG_LEVEL=${OC_CMAKE_DEBUG_LEVEL}")
  endif()
  if(OpenCMISS_WITH_MPI)
    list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DCMAKE_PREFIX_PATH=${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}${OC_CMAKE_SEPARATOR}${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}")
    set(CMAKE_PREFIX_PATH ${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR} ${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR})
  else()
    list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DCMAKE_PREFIX_PATH=${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}")
    set(CMAKE_PREFIX_PATH "${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}")
  endif()
  foreach(_language ${OC_LANGUAGES})
    if(CMAKE_${_language}_COMPILER)
      list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DCMAKE_${_language}_COMPILER=${CMAKE_${_language}_COMPILER}")
      list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DCMAKE_${_language}_FLAGS_DEBUG=${CMAKE_${_language}_FLAGS_DEBUG}")
      list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DCMAKE_${_language}_FLAGS_RELEASE=${CMAKE_${_language}_FLAGS_RELEASE}")
    endif()
    if(OpenCMISS_WITH_MPI)
      if(MPI_${_language}_COMPILER)
        list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DMPI_${_language}_COMPILER=${MPI_${_language}_COMPILER}")
        list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DMPI_${_language}_COMPILE_OPTIONS=${MPI_${_language}_COMPILE_OPTIONS}")
        list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DMPI_${_language}_COMPILE_DEFINITIONS=${MPI_${_language}_COMPILE_DEFINITIONS}")
        list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DMPI_${_language}_INCLUDE_DIRS=${MPI_${_language}_INCLUDE_DIRS}")
        list(APPEND OC_EXTERNAL_CMAKE_ARGS "-DMPI_${_language}_LINK_FLAGS=${MPI_${_language}_LINK_FLAGS}")
        list(APPEND OC_EXTETNAL_CMAKE_ARGS "-DMPI_${_language}_LIBRARIES=${MPI_${_language}_LIBRARIES}")
      endif()
    endif()
  endforeach()
  unset(_language)
  
  # Determine what dependencies are required. To do this we go through
  # in reverse order to the dependencies tree.

  set(OC_DEPENDENCIES_LIST )

  set(OC_EXTERNAL_IS_MAIN ON)
  set(OC_EXTERNAL_ISNT_MAIN OFF)
  set(OpenCMISS_WITHOUT_MPI OFF)
 
  # ZLIB
  if(OpenCMISS_USE_ZLIB)
    # Using ZLIB
    # Set ZLIB forward/backward dependencies
    set(OC_ZLIB_FORWARD_DEPENDENCIES LibXml2 HDF5 SCOTCH CSIM LLVM)
    set(OC_ZLIB_BACKWARD_DEPENDENCIES )
    # See if we can find ZLIB
    find_package(ZLIB)
    if(NOT ZLIB_FOUND)
      # Add and configure an OpenCMISS version of ZLIB
      set(OC_ZLIB_NAME "ZLIB")
      set(OC_ZLIB_REPO_NAME "zlib")
      set(OC_ZLIB_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      OCAddExternal(
	"${OC_ZLIB_NAME}"
	"${OC_ZLIB_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_ZLIB_DEFINES}"
	"${OC_ZLIB_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET ZLIB)
	add_library(ZLIB ALIAS ZLIB::ZLIB)
      endif()
    endif()
    list(APPEND OC_DEPENDENDICES_LIST ${ZLIB_BACKWARD_TARGET})
  endif()

  # LibXML2
  if(OpenCMISS_USE_LibXml2)
    # Using LibXML2
    # Set LibXML2 forward/backward dependencies
    set(OC_LibXml2_FORWARD_DEPENDENCIES CSIM LLVM FieldML-API libCellML)
    if(OpenCMISS_LibXml2_WITH_ZLIB)
      set(OC_LibXml2_BACKWARD_DEPENDENCIES ZLIB)
    else()
      set(OC_LibXml2_BACKWARD_DEPENDENCIES )
    endif()
    # See if we can find LibXML2
    find_package(LibXml2)
    if(NOT LibXml2_FOUND)
      # Add and configure an OpenCMISS version of LibXml2
      set(OC_LibXml2_NAME "LibXml2")
      set(OC_LibXml2_REPO_NAME "libxml2")
      set(OC_LibXml2_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      #For now no python, otherwise work out where the python site-packages should be installed.
      list(APPEND OC_LibXml2_DEFINES "-DLIBXML2_WITH_PYTHON=OFF")
      if(OC_BUILD_TYPE_RELEASE)
	list(APPEND OC_LibXml2_DEFINES "-DLIBXML2_WITH_DEBUG=OFF")
      endif()
      if(OC_BUILD_TYPE_DEBUG)
	list(APPEND OC_LibXml2_DEFINES "-DLIBXML2_WITH_DEBUG=ON")
      endif()
      list(APPEND OC_LibXml2_DEFINES "-DLIBXML2_WITH_TESTS=${OpenCMISS_WITH_DEPENDENCIES_TESTS}")
      list(APPEND OC_LibXml2_DEFINES "-DLIBXML2_WITH_ZLIB=${OpenCMISS_LibXml2_WITH_ZLIB}")
      list(APPEND OC_LibXml2_DEFINES "-DLIBXML2_WITH_LZMA=${OpenCMISS_LibXml2_WITH_LZMA}")
      OCAddExternal(
	"${OC_LibXml2_NAME}"
	"${OC_LibXml2_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_LibXml2_DEFINES}"
	"${OC_LibXml2_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET LibXml2)
	add_library(LibXml2 ALIAS LibXml2::LibXml2)
      endif()
    endif()
    list(APPEND OC_DEPENDENDICES_LIST ${LibXml2_BACKWARD_TARGET})
  endif()
  
  # BLAS/LAPACK
  if(OpenCMISS_USE_BLAS_LAPACK)
    # Using BLAS/LAPACK
    # Set BLAS/LAPACK forward/backward dependencies
    set(OC_BLAS_LAPACK_FORWARD_DEPENDENCIES ParMETIS SuiteSparse MUMPS SuperLU SuperLU_MT SuperLU_DIST SUNDIALS HYPRE PETSc OpenCMISS)
    set(OC_BLAS_LAPACK_BACKWARD_DEPENDENCIES )
    # See if we can find BLAS and LAPACK
    # TODO: Search for and optimised BLAS/LAPACK    
    find_package(BLAS)
    find_package(LAPACK)
    if(NOT (BLA_FOUND AND LAPACK_FOUND))
      # Add and configure an OpenCMISS version of BLAS/LAPACK
      set(OC_BLAS_LAPACK_NAME "BLAS_LAPACK")
      set(OC_BLAS_LAPACK_REPO_NAME "lapack")
      set(OC_BLAS_LAPACK_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_BLAS_LAPACK_DEFINES "-DBUILD_INDEX64=${OpenCMISS_LARGE_INDICES}")
      list(APPEND OC_BLAS_LAPACK_DEFINES "-DBUILD_TESTING=${OpenCMISS_WITH_DEPENDENCIES_TESTS}")
      list(APPEND OC_BLAS_LAPACK_DEFINES "-DBUILD_SINGLE=${OC_DEPENDENCIES_SINGLE_REAL_PRECISION}")
      list(APPEND OC_BLAS_LAPACK_DEFINES "-DBUILD_DOUBLE=${OC_DEPENDENCIES_DOUBLE_REAL_PRECISION}")
      list(APPEND OC_BLAS_LAPACK_DEFINES "-DBUILD_COMPLEX=${OC_DEPENDENCIES_SINGLE_COMPLEX_PRECISION}")
      list(APPEND OC_BLAS_LAPACK_DEFINES "-DBUILD_COMPLEX16=${OC_DEPENDENCIES_DOUBLE_COMPLEX_PRECISION}")
      OCAddExternal(
	"${OC_BLAS_LAPACK_NAME}"
	"${OC_BLAS_LAPACK_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_BLAS_LAPACK_DEFINES}"
	"${OC_BLAS_LAPACK_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET BLAS_LAPACK)
	add_library(BLAS_LAPACK ALIAS LAPACK::LAPACK)
      endif()      
    endif()
    list(APPEND OC_DEPENDENDICES_LIST BLAS_LAPACK)
  endif()
  
  # BLACS/ScaLAPACK
  if(OpenCMISS_USE_BLACS_ScaLAPACK)
    # Using BLACS/ScaLAPACK
    # Set BLACS/ScaLAPACK forward/backward dependencies
    set(OC_BLACS_ScaLAPACK_FORWARD_DEPENDENCIES MUMPS PETSc)
    set(OC_BLACS_ScaLAPACK_BACKWARD_DEPENDENCIES BLAS_LAPACK)
    # See if we can find BLACS/ScaLAPACK
    find_package(ScaLAPACK)
    if(NOT ScaLAPACK_FOUND)
      # Add and configure an OpenCMISS version of BLACS/ScaLAPACK
      set(OC_BLACS_ScaLAPACK_NAME "BLACS_ScaLAPACK")
      set(OC_BLACS_ScaLAPACK_REPO_NAME "scalapack")
      set(OC_BLACS_ScaLAPACK_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_BLACS_ScaLAPACK_DEFINES "-DUSE_OPTIMIZED_LAPACK_BLAS=${OpenCMISS_OPTIMISED_BLAS_LAPACK}")
      list(APPEND OC_BLACS_ScaLAPACK_DEFINES "-DSCALAPACK_BUILD_TESTS=${OpenCMISS_BLACS_ScaLAPACK_BUILD_TESTS}")
      OCAddExternal(
	"${OC_BLACS_ScaLAPACK_NAME}"
	"${OC_BLACS_ScaLAPACK_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_BLACS_ScaLAPACK_DEFINES}"
	"${OC_BLACS_ScaLAPACK_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET BLACS_ScaLAPACK)
	add_library(BLACS_ScaLAPACK ALIAS scalapack)
      endif()
    endif()
    list(APPEND OC_DEPENDENDICES_LIST BLACS_ScaLAPACK)
  endif()
  
  # HDF5
  if(OpenCMISS_USE_HDF5)
    # Using HDF5
    list(APPEND OC_DEPENDENDICES_LIST HDF5)    
    # Set HDF5 forward/backward dependencies
    set(OC_HDF5_FORWARD_DEPENDENCIES ParMETIS SuiteSparse MUMPS SuperLU SuperLU_MT SuperLU_DIST SUNDIALS HYPRE PETSc OpenCMISS)
    set(OC_HDF5_BACKWARD_DEPENDENCIES )
    if(OpenCMISS_HDF5_WITH_SZip)
      ##TODO Add in SZip - SEE https://github.com/hunter-packages/szip/tree/master
      list(APPEND OC_HDF5_BACKWARD_DEPENDENCIES SZip)
    endif()
    # See if we can find HDF5
    find_package(HDF5)
    if(NOT HDF5_FOUND)
      # Add and configure an OpenCMISS version of HDF5
      set(OC_HDF5_NAME "HDF5")
      set(OC_HDF5_REPO_NAME "hdf5")
      set(OC_HDF5_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_HDF5_DEFINES "-DHDF5_ENABLE_Z_ZLIB_SUPPORT=${OpenCMISS_HDF5_WITH_ZLIB}")
      if(OpenCMISS_HDF5_WITH_ZLIB)
	list(APPEND OC_HDF5_DEFINES "-DZLIB_USE_EXTERNAL=ON")
      endif()
      list(APPEND OC_HDF5_DEFINES "-DHDF5_ENABLE_SZIP_SUPPORT=${OpenCMISS_HDF5_WITH_SZip}")
      if(OpenCMISS_HDF5_WITH_SZip)
	list(APPEND OC_HDF5_DEFINES "-DSZIP_USE_EXTERNAL=ON")
      endif()	
      list(APPEND OC_HDF5_DEFINES "-DHDF5_ENABLE_PARALLEL=${OpenCMISS_HDF5_ENABLE_PARALLEL}")
      OCAddExternal(
	"${OC_HDF5_NAME}"
	"${OC_HDF5_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_HDF5_DEFINES}"
	"${OC_HDF5_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET HDF5)
	if(TARGET hdf5-shared)
	  add_library(HDF5 ALIAS hdf5-shared)
	else()
	  add_library(HDF5 ALIAS hdf5-static)	  
	endif()
      endif()
    endif()
  endif()
  
  # LLVM
  if(OpenCMISS_USE_LLVM)
    # Using LLVM
    list(APPEND OC_DEPENDENDICES_LIST LLVM)
    # Set LLVM forward/backward dependencies
    set(OC_LLVM_FORWARD_DEPENDENCIES libCellML OpenCMISS)
    set(OC_LLVM_BACKWARD_DEPENDENCIES )
    # See if we can find LLVM
    find_package(LLVM)
    if(NOT LLVM_FOUND)
      # Add and configure an OpenCMISS version of LLVM
      set(OC_LLVM_NAME "LLVM")
      set(OC_LLVM_REPO_NAME "llvm-project")
      set(OC_LLVM_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      OCAddExternal(
	"${OC_LLVM_NAME}"
	"${OC_LLVM_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	"llvm"
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_LLVM_DEFINES}"
	"${OC_LLVM_BACKWARD_DEPENDENCIES}"
      )
    endif()
  endif()
  
  # libCellML
  if(OpenCMISS_USE_libCellML)
    # Using libCellML
    list(APPEND OC_DEPENDENDICES_LIST libCellML)
    # Set libCellML forward/backward dependencies
    set(OC_libCellML_FORWARD_DEPENDENCIES OpenCMISS)
    set(OC_libCellML_BACKWARD_DEPENDENCIES )
    # See if we can find libCellML
    find_package(libCellML)
    if(NOT libCellML_FOUND)
      # Add and configure an OpenCMISS version of libCellML
      set(OC_libCellML_NAME "libCellML")
      set(OC_libCellML_REPO_NAME "libcellml")
      set(OC_libCellML_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_libCellML_DEFINES "-DLIBCELLML_BUILD_TYPE=${OC_BUILD_TYPE}")
      list(APPEND OC_libCellML_DEFINES "-DLIBCELLML_BUILD_SHARED=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      OCAddExternal(
	"${OC_libCellML_NAME}"
	"${OC_libCellML_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_libCellML_DEFINES}"
	"${OC_libCellML_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET libCellML)
	if(TARGET cellml)
	  add_library(libCellML ALIAS cellml)
	endif()
      endif()
    endif()
  endif()
  
  # FieldML
  if(OpenCMISS_USE_FieldML)
    # Using FieldML
    list(APPEND OC_DEPENDENDICES_LIST FieldML)
    # Set FieldML forward/backward dependencies
    set(OC_FieldML_FORWARD_DEPENDENCIES OpenCMISS)
    set(OC_FieldML_BACKWARD_DEPENDENCIES LibXml2)
    if(FieldML_WITH_HDF5)
      list(APPEND OC_FieldML_BACKWARD_DEPENDENCIES HDF5)
    endif()
    # See if we can find FieldML
    find_package(FieldML)
    if(NOT FieldML_FOUND)
      # Add and configure an OpenCMISS version of FieldML
      set(OC_FieldML_NAME "FieldML")
      set(OC_FieldML_REPO_NAME "FieldML-API")
      set(OC_FieldML_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_FieldML_DEFINES "-DFIELDML_BUILD_STATIC_LIB=${OpenCMISS_DEPENDENCIES_STATIC_LIBRARIES}")
      list(APPEND OC_FieldML_DEFINES "-DFIELDML_BUILD_TESTING=${OpenCMISS_WITH_DEPENDENCIES_TESTS}")
      list(APPEND OC_FieldML_DEFINES "-DFIELDML_BUILD_JAVA=${OpenCMISS_FieldML_WITH_JAVA_BINDINGS}")
      OCAddExternal(
	"${OC_FieldML_NAME}"
	"${OC_FieldML_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_FieldML_DEFINES}"
	"${OC_FieldML_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET FieldML)
	if(TARGET fieldml-api)
	  add_library(FieldML ALIAS fieldml-api)
	endif()
      endif()
    endif()
  endif()
  
  # SCOTCH
  if(OpenCMISS_USE_SCOTCH)
    # Using SCOTCH
    list(APPEND OC_DEPENDENDICES_LIST SCOTCH)
    # Set SCOTCH forward/backward dependencies
    set(OC_SCOTCH_FORWARD_DEPENDENCIES MUMPS PETSc OpenCMISS)
    if(OpenCMISS_USE_ZLIB)
      list(APPEND OC_SCOTCH_BACKWARD_DEPENDENCIES ZLIB)
    else()
      set(OC_SCOTCH_BACKWARD_DEPENDENCIES )
    endif()
    # See if we can find SCOTCH
    find_package(SCOTCH)
    if(NOT SCOTCH_FOUND)
      # Add and configure an OpenCMISS version of SCOTCH
      set(OC_SCOTCH_NAME "SCOTCH")
      set(OC_SCOTCH_REPO_NAME "scotch")
      set(OC_SCOTCH_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_SCOTCH_DEFINES "-DINTSIZE=$<IF:$<BOOL:${OpenCMISS_LARGE_INDICES}>,64,32>")
      list(APPEND OC_SCOTCH_DEFINES "-DBUILD_PTSCOTCH=${OpenCMISS_WITH_MPI}")
      list(APPEND OC_SCOTCH_DEFINES "-DBUILD_LIBESMUMPS=${OpenCMISS_SCOTCH_WITH_ESMUMPS}")
      list(APPEND OC_SCOTCH_DEFINES "-DBUILD_LIBSCOTCHMETIS=${OpenCMISS_SCOTCH_WITH_SCOTCHMETIS}")
      list(APPEND OC_SCOTCH_DEFINES "-DINSTALL_METIS_HEADERS=${OpenCMISS_SCOTCH_WITH_SCOTCHMETIS}")
      list(APPEND OC_SCOTCH_DEFINES "-DUSE_ZLIB=${OpenCMISS_SCOTCH_WITH_ZLIB}")
      list(APPEND OC_SCOTCH_DEFINES "-DUSE_LZMA=${OpenCMISS_SCOTCH_WITH_LZMA}")
      list(APPEND OC_SCOTCH_DEFINES "-DUSE_BZ2=${OpenCMISS_SCOTCH_WITH_BZip2}")
      OCAddExternal(
	"${OC_SCOTCH_NAME}"
	"${OC_SCOTCH_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_SCOTCH_DEFINES}"
	"${OC_SCOTCH_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET SCOTCH)
	add_library(SCOTCH ALIAS SCOTCH::scotch)
      endif()
    endif()
  endif()
  
  
  # ParMETIS/METIS/GKlib
  if(OpenCMISS_USE_ParMETIS_METIS_GKlib)
    # Using GKlib
    list(APPEND OC_DEPENDENDICES_LIST GKlib)
    # Set GKlib forward/backward dependencies
    set(OC_GKlib_FORWARD_DEPENDENCIES METIS ParMETIS)
    set(OC_GKlib_BACKWARD_DEPENDENCIES )
    # See if we can find GKlib
    find_package(GKlib)
    if(NOT GKlib_FOUND)
      # Add and configure an OpenCMISS version of GKlib
      set(OC_GKlib_NAME "GKlib")
      set(OC_GKlib_REPO_NAME "GKlib")
      set(OC_Gklib_DEFINES )
      list(APPEND OC_GKlib_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      OCAddExternal(
	"${OC_GKlib_NAME}"
	"${OC_GKlib_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OC_DOESNT_USE_MPI}"
	"${OC_GKlib_DEFINES}"
	"${OC_GKlib_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET GKlib)
	add_library(GKlib ALIAS GKlib::GKlib)
      endif()
    endif()
   
    # METIS
    # Using METIS
    list(APPEND OC_DEPENDENDICES_LIST METIS)
    # Set METIS forward/backward dependencies
    set(OC_METIS_FORWARD_DEPENDENCIES ParMETIS MUMPS SuiteSparse SuperLU PETSc OpenCMISS)
    set(OC_METIS_BACKWARD_DEPENDENCIES GKlib)
    # See if we can find METIS
    find_package(METIS)
    if(NOT METIS_FOUND)
      # Add and configure an OpenCMISS version of METIS
      set(OC_METIS_NAME "METIS")
      set(OC_METIS_REPO_NAME "METIS")
      set(OC_METIS_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_METIS_DEFINES "-DSHARED=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      OCAddExternal(
	"${OC_METIS_NAME}"
	"${OC_METIS_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OC_DOESNT_USE_MPI}"
	"${OC_METIS_DEFINES}"
	"${OC_METIS_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET METIS)
	add_library(METIS ALIAS METIS::METIS)
      endif()
    endif()
    
    # ParMETIS
    # Using ParMETIS
    list(APPEND OC_DEPENDENDICES_LIST ParMETIS)
    # Set ParMETIS forward/backward dependencies
    set(OC_ParMETIS_FORWARD_DEPENDENCIES MUMPS SuiteSparse SuperLU_DIST PETSc OpenCMISS)
    set(OC_ParMETIS_BACKWARD_DEPENDENCIES GKlib METIS)
    # See if we can find ParMETIS
    find_package(ParMETIS)
    if(NOT ParMETIS_FOUND)
      # Add and configure an OpenCMISS version of ParMETIS
      set(OC_ParMETIS_NAME "ParMETIS")
      set(OC_ParMETIS_REPO_NAME "ParMETIS")
      set(OC_ParMETIS_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_ParMETIS_DEFINES "-DSHARED=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      OCAddExternal(
	"${OC_ParMETIS_NAME}"
	"${OC_ParMETIS_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_ParMETIS_DEFINES}"
	"${OC_ParMETIS_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET ParMETIS)
	add_library(ParMETIS ALIAS ParMETIS::ParMETIS)
      endif()
    endif()
  endif()
  
  # SuiteSparse
  if(OpenCMISS_USE_SuiteSparse)
    # Using SuiteSparse
    list(APPEND OC_DEPENDENDICES_LIST SuiteSparse)
    # Set SuiteSparse forward/backward dependencies
    set(OC_SuiteSparse_FORWARD_DEPENDENCIES PETSc OpenCMISS)
    set(OC_SuiteSparse_BACKWARD_DEPENDENCIES BLAS_LAPACK)
    # See if we can find SuiteSparse
    find_package(SuiteSparse)
    if(NOT SuiteSparse_FOUND)
      # Add and configure an OpenCMISS version of SuiteSparse
      set(OC_SuiteSparse_NAME "SuiteSparse")
      set(OC_SuiteSparse_REPO_NAME "SuiteSparse")
      set(OC_SuiteSparse_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_SuiteSparse_DEFINES "-DENABLE_CUDA=${OpenCMISS_WITH_CUDA}")
      list(APPEND OC_SuiteSparse_DEFINES "-DGRAPHBLAS_BUILD_STATIC_LIBS=${OpenCMISS_DEPENDENCIES_STATIC_LIBRARIES}")
      OCAddExternal(
	"${OC_SuiteSparse_NAME}"
	"${OC_SuiteSparse_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_SuiteSparse_DEFINES}"
	"${OC_SuiteSparse_BACKWARD_DEPENDENCIES}"
      )
    endif()
  endif()
  
  # SuperLU
  if(OpenCMISS_USE_SuperLU)
    # Using SuperLU
    list(APPEND OC_DEPENDENDICES_LIST SuperLU)
    # Set SuperLU forward/backward dependencies
    set(OC_SuperLU_FORWARD_DEPENDENCIES HYPRE PETSc OpenCMISS)
    set(OC_SuperLU_BACKWARD_DEPENDENCIES BLAS_LAPACK)
    if(OpenCMISS_SuperLU_WITH_METIS)
      list(APPEND OC_SuperLU_BACKWARD_DEPENDENCIES METIS)
    endif()
    # See if we can find SuperLU
    find_package(SuperLU)
    if(NOT SuperLU_FOUND)
      # Add and configure an OpenCMISS version of SuperLU
      set(OC_SuperLU_NAME "SuperLU")
      set(OC_SuperLU_REPO_NAME "superlu")
      set(OC_SuperLU_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_SuperLU_DEFINES "-Denable_internal_blaslib=OFF")
      list(APPEND OC_SuperLU_DEFINES "-Denable_single=${OC_DEPENDENCIES_SINGLE_REAL_PRECISION}")
      list(APPEND OC_SuperLU_DEFINES "-Denable_double=${OC_DEPENDENCIES_DOUBLE_REAL_PRECISION}")
      list(APPEND OC_SuperLU_DEFINES "-Denable_complex=${OC_DEPENDENCIES_SINGLE_COMPLEX_PRECISION}")
      list(APPEND OC_SuperLY_DEFINES "-Denable_complex16=${OC_DEPENDENCIES_DOUBLE_COMPLEX_PRECISION}")
      list(APPEND OC_SuperLU_DEFINES "-Denable_examples=ON")
      list(APPEND OC_SuperLU_DEFINES "-Denable_fortran=ON")
      list(APPEND OC_SuperLU_DEFINES "-Denable_tests=${OpenCMISS_WITH_DEPENDENCIES_TESTS}")
      list(APPEND OC_SuperLU_DEFINES "-DTPL_ENABLE_METISLIB=${OpenCMISS_SuperLU_WITH_METIS}")
      OCAddExternal(
	"${OC_SuperLU_NAME}"
	"${OC_SuperLU_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_SuperLU_DEFINES}"
	"${OC_SuperLU_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET SuperLU)
	add_library(SuperLU ALIAS superlu::superlu)
      endif()
    endif()
  endif()
  
  # SuperLU_DIST
  if(OpenCMISS_USE_SuperLU_DIST)
    # Using SuperLU_DIST
    # Set SuperLU_DIST forward/backward dependencies
    set(OC_SuperLU_DIST_FORWARD_DEPENDENCIES PETSc OpenCMISS)
    list(APPEND OC_DEPENDENDICES_LIST SuperLU_DIST)
    set(OC_SuperLU_DIST_BACKWARD_DEPENDENCIES )
    if(OpenCMISS_SuperLU_DIST_WITH_LAPACK)
      list(APPEND OC_SuperLU_DIST_BACKWARD_DEPENDENCIES BLAS_LAPACK)
    endif()
    if(OpenCMISS_SuperLU_DIST_WITH_ParMETIS)
      list(APPEND OC_SuperLU_DIST_BACKWARD_DEPENDENCIES ParMETIS)
    endif()
    if(OpenCMISS_SuperLU_DIST_WITH_COLAMD)
      list(APPEND OC_SuperLU_DIST_BACKWARD_DEPENDENCIES SuiteSparse)
    endif()
    # See if we can find SuperLU_DIST
    find_package(SuperLU_DIST)
    if(NOT SuperLU_DIST_FOUND)
      # Add and configure an OpenCMISS version of SuperLU_DIST
      set(OC_SuperLU_DIST_NAME "SuperLU_DIST")
      set(OC_SuperLU_DIST_REPO_NAME "superlu_dist")
      set(OC_SuperLU_DIST_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_SuperLU_DIST_DEFINES "-Denable_single=${OC_DEPENDENCIES_SINGLE_REAL_PRECISION}")
      list(APPEND OC_SuperLU_DIST_DEFINES "-Denable_double=${OC_DEPENDENCIES_DOUBLE_REAL_PRECISION}")
      list(APPEND OC_SuperLY_DIST_DEFINES "-Denable_complex16=${OC_DEPENDENCIES_DOUBLE_COMPLEX_PRECISION}")
      list(APPEND OC_SuperLU_DIST_DEFINES "-Denable_examples=ON")
      list(APPEND OC_SuperLU_DIST_DEFINES "-DXSDK_ENABLE_Fortran=ON")
      list(APPEND OC_SuperLU_DIST_DEFINES "-Denable_tests=${OpenCMISS_WITH_DEPENDENCIES_TESTS}")
      list(APPEND OC_SuperLU_DIST_DEFINES "-DTPL_ENABLE_LAPACKLIB=${OpenCMISS_SuperLU_DIST_WITH_LAPACK}")
      list(APPEND OC_SuperLU_DIST_DEFINES "-DTPL_ENABLE_PARMETISLIB=${OpenCMISS_SuperLU_DIST_WITH_ParMETIS}")
      list(APPEND OC_SuperLU_DIST_DEFINES "-DTPL_ENABLE_COLAMD=${OpenCMISS_SuperLU_DIST_WITH_COLAMD}")
      OCAddExternal(
	"${OC_SuperLU_DIST_NAME}"
	"${OC_SuperLU_DIST_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_SuperLU_DIST_DEFINES}"
	"${OC_SuperLU_DIST_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET SuperLU_DIST)
	add_library(SuperLU_DIST ALIAS superlu_dist::superlu_dist)
      endif()
    endif()
  endif()
  
  # SuperLU_MT
  if(OpenCMISS_USE_SuperLU_MT)
    # Using SuperLU_MT
    list(APPEND OC_DEPENDENDICES_LIST SuperLU_MT)
    # Set SuperLU_MT forward/backward dependencies
    set(OC_SuperLU_MT_FORWARD_DEPENDENCIES PETSc OpenCMISS)
    set(OC_SuperLU_MT_BACKWARD_DEPENDENCIES BLAS_LAPACK)
    # See if we can find SuperLU_MT
    find_package(SuperLU_MT)
    if(NOT SuperLU_MT_FOUND)
      # Add and configure an OpenCMISS version of SuperLU_MT
      set(OC_SuperLU_MT_NAME "SuperLU_MT")
      set(OC_SuperLU_MT_REPO_NAME "superlu_mt")
      set(OC_SuperLU_MT_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      OCAddExternal(
	"${OC_SuperLU_MT_NAME}"
	"${OC_SuperLU_MT_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_NOMPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITHOUT_MPI}"
	"${OC_SuperLU_MT_DEFINES}"
	"${OC_SuperLU_MT_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET SuperLU_MT)
	add_library(SuperLU_MT ALIAS superlu_mt::superlu_mt)
      endif()
    endif()
  endif()
  
  # MUMPS
  if(OpenCMISS_USE_MUMPS)
    # Using MUMPS
    list(APPEND OC_DEPENDENDICES_LIST MUMPS)
    # Set MUMPS forward/backward dependencies
    set(OC_MUMPS_FORWARD_DEPENDENCIES PETSc OpenCMISS)
    set(OC_MUMPS_BACKWARD_DEPENDENCIES BLAS_LAPACK)
    if(OpenCMISS_WITH_MPI)
      list(APPEND OC_MUMPS_BACKWARD_DEPENDENCIES BLACS_ScaLAPACK)
      if(OpenCMISS_MUMPS_WITH_ParMETIS)
	list(APPEND OC_MUMPS_BACKWARD_DEPENDENCIES ParMETIS)
      endif()
      if(OpenCMISS_MUMPS_WITH_SCOTCH)
	list(APPEND OC_MUMPS_BACKWARD_DEPENDENCIES SCOTCH)
      endif()
    else()
      if(OpenCMISS_MUMPS_WITH_METIS)
	list(APPEND OC_MUMPS_BACKWARD_DEPENDENCIES METIS)
      endif()
      if(OpenCMISS_MUMPS_WITH_SCOTCH)
	list(APPEND OC_MUMPS_BACKWARD_DEPENDENCIES SCOTCH)
      endif()
    endif()
    # See if we can find MUMPS
    find_package(MUMPS)
    if(NOT MUMPS_FOUND)
      # Add and configure an OpenCMISS version of MUMPS
      set(OC_MUMPS_NAME "MUMPS")
      set(OC_MUMPS_REPO_NAME "mumps")
      set(OC_MUMPS_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_MUMPS_DEFINES "-DPARALLEL=${OpenCMISS_WITH_MPI}")
      list(APPEND OC_MUMPS_DEFINES "-DOPENMP=${OpenCMISS_WITH_OpenMP}")
      list(APPEND OC_MUMPS_DEFINES "-DLARGE_INTEGERS=${OpenCMISS_LARGE_INDICES}")
      list(APPEND OC_MUMPS_DEFINES "-DMETIS_ORDERING=${OpenCMISS_MUMPS_WITH_METIS}")
      list(APPEND OC_MUMPS_DEFINES "-DPARMETIS_ORDERING=${OpenCMISS_MUMPS_WITH_ParMETIS}")
      list(APPEND OC_MUMPS_DEFINES "-DSCOTCH_ORDERING=${OpenCMISS_MUMPS_WITH_SCOTCH}")
      list(APPEND OC_MUMPS_DEFINES "-BUILD_SINGLE=${OC_DEPENDENCIES_SINGLE_REAL_PRECISION}")
      list(APPEND OC_MUMPS_DEFINES "-BUILD_DOUBLE=${OC_DEPENDENCIES_DOUBLE_REAL_PRECISION}")
      list(APPEND OC_MUMPS_DEFINES "-BUILD_COMPLEX=${OC_DEPENDENCIES_SINGLE_COMPLEX_PRECISION}")
      list(APPEND OC_MUMPS_DEFINES "-BUILD_COMPLEX16=${OC_DEPENDENCIES_DOUBLE_COMPLEX_PRECISION}")
      OCAddExternal(
	"${OC_MUMPS_NAME}"
	"${OC_MUMPS_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_MUMPS_DEFINES}"
	"${OC_MUMPS_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET MUMPS)
	add_library(MUMPS ALIAS MUMPS::MUMPS)
      endif()      
    endif()
  endif()  
  
  # HYPRE
  if(OpenCMISS_USE_HYPRE)
    # Using HYPRE
    list(APPEND OC_DEPENDENDICES_LIST HYPRE)
    # Set HYPRE forward/backward dependencies
    set(OC_HYPRE_FORWARD_DEPENDENCIES PETSc OpenCMISS)
    set(OC_HYPRE_BACKWARD_DEPENDENCIES )
    # See if we can find HYPRE
    find_package(HYPRE)
    if(NOT HYPRE_FOUND)
      # Add and configure an OpenCMISS version of HYPRE
      set(OC_HYPRE_NAME "HYPRE")
      set(OC_HYPRE_REPO_NAME "hypre")
      set(OC_HYPRE_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_HYPRE_DEFINES "-DHYPRE_ENABLE_SHARED=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_HYPRE_DEFINES "-DHYPRE_ENABLE_BIGINT=${OpenCMISS_LARGE_INDICES}")
      list(APPEND OC_HYPRE_DEFINES "-DHYPRE_WITH_MPI=${OpenCMISS_WITH_MPI}")
      list(APPEND OC_HYPRE_DEFINES "-DHYPRE_BUILD_TESTS=${OpenCMISS_WITH_DEPENDENCIES_TESTS}")
      OCAddExternal(
	"${OC_HYPRE_NAME}"
	"${OC_HYPRE_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	"src"
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_HYPRE_DEFINES}"
	"${OC_HYPRE_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET HYPRE)
	add_library(HYPRE ALIAS HYPRE::HYPRE)
      endif()      
    endif()
  endif()
  
  # SUNDIALS
  if(OpenCMISS_USE_SUNDIALS)
    # Using SUNDIALS
    list(APPEND OC_DEPENDENDICES_LIST SUNDIALS)
    # Set SUNDIALS forward/backward dependencies
    set(OC_SUNDIALS_FORWARD_DEPENDENCIES PETSc OpenCMISS)
    set(OC_SUNDIALS_BACKWARD_DEPENDENCIES )
    # See if we can find SUNDIALS
    find_package(SUNDIALS)
    if(NOT SUNDIALS_FOUND)
      # Add and configure an OpenCMISS version of SUNDIALS
      set(OC_SUNDIALS_NAME "SUNDIALS")
      set(OC_SUNDIALS_REPO_NAME "sundials")
      set(OC_SUNDIALS_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_SUNDIALS_DEFINES "-DBUILD_STATIC_LIBS=${OpenCMISS_DEPENDENCIES_STATIC_LIBRARIES}")
      list(APPEND OC_SUNDIALS_DEFINES "-DSUNDIALS_PRECISION=${OpenCMISS_REAL_PRECISION}")
      list(APPEND OC_SUNDIALS_DEFINES "-DSUNDIALS_INDEX_SIZE=$<IF:$<BOOL:${OpenCMISS_LARGE_INDICES}>,64,32>")
      list(APPEND OC_SUNDIALS_DEFINES "-DBUILD_FORTRAN_MODULE_INTERFACE=$<STREQUAL:${OpenCMISS_REAL_PRECISION},DOUBLE>")
      list(APPEND OC_SUNDIALS_DEFINES "-DENABLE_MPI=${OpenCMISS_WITH_MPI}")
      list(APPEND OC_SUNDIALS_DEFINES "-DENABLE_OPENMP=${OpenCMISS_WITH_OpenMP}")
      list(APPEND OC_SUNDIALS_DEFINES "-DENABLE_CUDA=${OpenCMISS_WITH_CUDA}")
      list(APPEND OC_SUNDIALS_DEFINES "-DENABLE_LAPACK=${OpenCMISS_SUNDIALS_WITH_BLAS_LAPACK}")
      list(APPEND OC_SUNDIALS_DEFINES "-DENABLE_HYPRE=${OpenCMISS_SUNDIALS_WITH_HYPRE}")
      list(APPEND OC_SUNDIALS_DEFINES "-DENABLE_SuperLU_DIST=${OpenCMISS_SUNDIALS_WITH_SuperLU_DIST}")
      list(APPEND OC_SUNDIALS_DEFINES "-DENABLE_SuperLU_MT=${OpenCMISS_SUNDIALS_WITH_SuperLU_MT}")
      OCAddExternal(
	"${OC_SUNDIALS_NAME}"
	"${OC_SUNDIALS_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_SUNDIALS_DEFINES}"
	"${OC_SUNDIALS_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET SUNDIALS)
	add_library(HYPRE ALIAS SUNDIALS::SUNDIALS)
      endif()      
    endif()
  endif()
  
  # PETSc
  if(OpenCMISS_USE_PETSc)
    # Using PETSc
    list(APPEND OC_DEPENDENDICES_LIST PETSc)
    # Set PETSc forward/backward dependencies
    set(OC_PETSc_FORWARD_DEPENDENCIES SLEPc OpenCMISS)
    set(OC_PETSc_BACKWARD_DEPENDENCIES )
    if(OpenCMISS_PETSc_WITH_BLAS_LAPACK)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES BLAS_LAPACK)
    endif()
    if(OpenCMISS_PETSc_WITH_BLACS_ScaLAPACK)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES BLACS_ScaLAPACK)
    endif()
    if(OpenCMISS_PETSc_WITH_HDF5)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES HDF5)
    endif()
    if(OpenCMISS_PETSc_WITH_HYPRE)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES HYPRE)
    endif()
    if(OpenCMISS_PETSc_WITH_METIS)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES METIS)
    endif()
    if(OpenCMISS_PETSc_WITH_MUMPS)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES MUMPS)
    endif()
    if(OpenCMISS_PETSc_WITH_ParMETIS)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES ParMETIS)
    endif()
    if(OpenCMISS_PETSc_WITH_PTSCOTCH)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES SCOTCH)
    endif()
    if(OpenCMISS_PETSc_WITH_SuiteSparse)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES SuiteSparse)
    endif()
    if(OpenCMISS_PETSc_WITH_SUNDIALS)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES SUNDIALS)
    endif()
    if(OpenCMISS_PETSc_WITH_SuperLU)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES SuperLU)
    endif()
    if(OpenCMISS_PETSc_WITH_SuperLU_DIST)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES SuperLU_DIST)
    endif()
    if(OpenCMISS_PETSc_WITH_ZLIB)
      list(APPEND OC_PETSc_BACKWARD_DEPENDENCIES ZLIB)
    endif()
    # See if we can find PETSc
    find_package(PETSc)
    if(NOT PETSc_FOUND)
      # Add and configure an OpenCMISS version of PETSc
      set(OC_PETSc_NAME "PETSc")
      set(OC_PETSc_REPO_NAME "petsc")
      set(OC_PETSc_DEFINES "-DBUILD_SHARED_LIBS=${OpenCMISS_DEPENDENCIES_SHARED_LIBRARIES}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_MPI_PREFIX=${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_NOMPI_PREFIX=${OC_DEPENDENCIES_NOMPI_INSTALL_BASE_DIR}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_64_BIT_INDICES=${OpenCMISS_LARGE_INDICES}")
      foreach(_language ${OC_LANGUAGES})
	if(CMAKE_${_language}_COMPILER)
	  #list(APPEND OC_PETSc_DEFINES "-DPETSc_${_language}_COMPILER=${CMAKE_${_language}_COMPILER}")
	  list(APPEND OC_PETSc_DEFINES "-DPETSc_${_language}_COMPILER=${MPI_${_language}_COMPILER}")
	  if(OC_DEPENDENCIES_BUILD_TYPE_DEBUG)
	    #list(APPEND OC_PETSc_DEFINES "-DPETSc_${_language}_FLAGS=${CMAKE_${_language}_FLAGS_DEBUG}")
	    list(APPEND OC_PETSc_DEFINES "-DPETSc_${_language}_FLAGS=${MPI_${_language}_FLAGS_DEBUG}")
	  else()
	    #list(APPEND OC_PETSc_DEFINES "-DPETSc_${_language}_FLAGS=${CMAKE_${_language}_FLAGS_RELEASE}")
	    list(APPEND OC_PETSc_DEFINES "-DPETSc_${_language}_FLAGS=${MPI_${_language}_FLAGS_RELEASE}")
	  endif()
	endif()
      endforeach()
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_BLAS_LAPACK=${OpenCMISS_PETSc_WITH_BLAS_LAPACK}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_BLACS_ScaLAPACK=${OpenCMISS_PETSc_WITH_BLACS_ScaLAPACK}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_CUDA=${OpenCMISS_PETSc_WITH_CUDA}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_HDF5=${OpenCMISS_PETSc_WITH_HDF5}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_HYPRE=${OpenCMISS_PETSc_WITH_HYPRE}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_METIS=${OpenCMISS_PETSc_WITH_METIS}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_MPI=${OpenCMISS_WITH_MPI}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_MUMPS=${OpenCMISS_PETSc_WITH_MUMPS}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_ParMETIS=${OpenCMISS_PETSc_WITH_ParMETIS}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_PTSCOTCH=${OpenCMISS_PETSc_WITH_PTSCOTCH}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_SuiteSparse=${OpenCMISS_PETSc_WITH_SuiteSparse}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_SUNDIALS=${OpenCMISS_PETSc_WITH_SUNDIALS}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_SuperLU=${OpenCMISS_PETSc_WITH_SuperLU}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_SuperLU_DIST=${OpenCMISS_PETSc_WITH_SuperLU_DIST}")
      list(APPEND OC_PETSc_DEFINES "-DPETSc_WITH_ZLIB=${OpenCMISS_PETSc_WITH_ZLIB}")
      OCCMakeDebug("OC_PETSc_DEFINES = '${OC_PETSc_DEFINES}'" 1)      
      OCAddExternal(
	"${OC_PETSc_NAME}"
	"${OC_PETSc_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_PETSc_DEFINES}"
	"${OC_PETSc_BACKWARD_DEPENDENCIES}"
      )
    else()
      if(NOT TARGET PETSc)
	add_library(PETSc ALIAS PETSc::PETSc)
      endif()
    endif()
  endif()
  
  # SLEPc
  if(OpenCMISS_USE_SLEPc)
    # Using SLEPc
    list(APPEND OC_DEPENDENDICES_LIST SLEPc)
    # Set SLEPc orward/backward dependencies
    set(OC_SLEPc_FORWARD_DEPENDENCIES OpenCMISS)
    set(OC_SLEPc_BACKWARD_DEPENDENCIES PETSc)
    # See if we can find SLEPc
    find_package(SLEPc)
    if(NOT SLEPc_FOUND)
      # Add and configure an OpenCMISS version of SLEPc
      set(OC_SLEPc_NAME "SLEPc")
      set(OC_SLEPc_REPO_NAME "slepc")
      set(OC_SLEPc_DEFINES "-DSLEPc_PREFIX=${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}")
      OCAddExternal(
	"${OC_SLEPc_NAME}"
	"${OC_SLEPc_REPO_NAME}"
	"${OC_DEPENDENCIES_SOURCE_BASE_DIR}"
	""
	"${OC_DEPENDENCIES_MPI_BUILD_BASE_DIR}"
	"${OC_DEPENDENCIES_MPI_INSTALL_BASE_DIR}"
	"${OC_EXTERNAL_ISNT_MAIN}"
	"${OpenCMISS_WITH_MPI}"
	"${OC_SLEPc_DEFINES}"
	"${OC_SLEPc_BACKWARD_DEPENDENCIES}"
      )
    else()
      
    endif()
  endif()

  # OpenCMISS library
  # Add and configure OpenCMISS
  set(OC_OpenCMISS_NAME "OpenCMISS")
  set(OC_OpenCMISS_REPO_NAME "iron")
  set(OC_OpenCMISS_DEFINES "-DOpenCMISS_ROOT=${OC_SOURCE_BASE_DIR}/${OC_OpenCMISS_REPO_NAME}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_BUILD_SHARED_LIBS=${OpenCMISS_SHARED_LIBRARIES}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_BUILD_STATIC_LIBS=${OpenCMISS_STATIC_LIBRARIES}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_SINGLE_PRECISION=$<STREQUAL:${OpenCMISS_REAL_PRECISION},SINGLE>")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_LARGE_INDICES=${OpenCMISS_LARGE_INDICES}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_C_BINDINGS=${OpenCMISS_WITH_C_BINDINGS}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_Python_BINDINGS=${OpenCMISS_WITH_Python_BINDINGS}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_MPI=${OpenCMISS_WITH_MPI}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_OpenMP=${OpenCMISS_WITH_OpenMP}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_CUDA=${OpenCMISS_WITH_CUDA}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_DIAGNOSTICS=${OpenCMISS_WITH_DIAGNOSTICS}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_NO_CHECKS=${OpenCMISS_WITH_NO_CHECKS}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_NO_PRECHECKS=${OpenCMISS_WITH_NO_PRECHECKS}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_NO_POSTCHECKS=${OpenCMISS_WITH_NO_POSTCHECKS}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_TESTS=${OpenCMISS_WITH_TESTS}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_CellML=${OpenCMISS_USE_CellML}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_CellML_VERSION=${OpenCMISS_CellML_VERSION}")  
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_FieldML=${OpenCMISS_USE_FieldML}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_FieldML_VERSION=${OpenCMISS_FieldML_VERSION}")  
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_HYPRE=${OpenCMISS_USE_HYPRE}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_HYPRE_VERSION=${OpenCMISS_HYPRE_VERSION}")  
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_MUMPS=${OpenCMISS_USE_MUMPS}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_MUMPS_VERSION=${OpenCMISS_MUMPS_VERSION}")  
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_ParMETIS=${OpenCMISS_USE_ParMETIS_METIS_GKlib}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_ParMETIS_VERSION=${OpenCMISS_ParMETIS_VERSION}")  
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_PETSc=${OpenCMISS_USE_PETSc}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_PETSc_VERSION=${OpenCMISS_PETSc_VERSION}")  
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_ScaLAPACK=${OpenCMISS_USE_BLACS_ScaLAPACK}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_ScaLAPACK_VERSION=${OpenCMISS_BLACS_ScaLAPACK_VERSION}")  
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_SLEPc=${OpenCMISS_USE_SLEPc}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_SLEPc_VERSION=${OpenCMISS_SLEPc_VERSION}")  
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_WITH_SUNDIALS=${OpenCMISS_USE_SLEPc}")
  list(APPEND OC_OpenCMISS_DEFINES "-DOpenCMISS_SUNDIALS_VERSION=${OpenCMISS_SUNDIALS_VERSION}")  
  OCAddExternal(
    "${OC_OpenCMISS_NAME}"
    "${OC_OpenCMISS_REPO_NAME}"
    "${OC_SOURCE_BASE_DIR}"
    ""
    "${OC_MPI_BUILD_BASE_DIR}"
    "${OC_MPI_INSTALL_BASE_DIR}"
    "${OC_EXTERNAL_IS_MAIN}"
    "${OpenCMISS_WITH_MPI}"
    "${OC_OpenCMISS_DEFINES}"
    "${OC_DEPENDENCIES_LIST}"
  )
  
endif()
