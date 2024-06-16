#[=======================================================================[.rst:
OpenCMISS Install variables script
----------------------------------

OpenCMISS CMake script to configure and install all the variables
files for a configuration.

#]=======================================================================]

include(${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeMiscellaneous.cmake)

set(OC_VARIABLES_FILES_LIST
  OpenCMISS_Variables
  OpenCMISS_Variables_Dependencies
  Dependencies/OpenCMISS_Variables_BLAS_LAPACK
  Dependencies/OpenCMISS_Variables_BLACS_SCALAPACK
  Dependencies/OpenCMISS_Variables_BZip2
  Dependencies/OpenCMISS_Variables_CellML
  Dependencies/OpenCMISS_Variables_CSim
  Dependencies/OpenCMISS_Variables_Cube4
  Dependencies/OpenCMISS_Variables_FieldML
  Dependencies/OpenCMISS_Variables_GKlib
  Dependencies/OpenCMISS_Variables_HDF5
  Dependencies/OpenCMISS_Variables_HYPRE
  Dependencies/OpenCMISS_Variables_libCellML
  Dependencies/OpenCMISS_Variables_LibXml2
  Dependencies/OpenCMISS_Variables_LLVM
  Dependencies/OpenCMISS_Variables_METIS
  Dependencies/OpenCMISS_Variables_MUMPS
  Dependencies/OpenCMISS_Variables_OPARI2
  Dependencies/OpenCMISS_Variables_OTF2
  Dependencies/OpenCMISS_Variables_PAPI
  Dependencies/OpenCMISS_Variables_ParMETIS
  Dependencies/OpenCMISS_Variables_PETSc
  Dependencies/OpenCMISS_Variables_Scalasca
  Dependencies/OpenCMISS_Variables_ScoreP
  Dependencies/OpenCMISS_Variables_Scotch
  Dependencies/OpenCMISS_Variables_SLEPc
  Dependencies/OpenCMISS_Variables_SuiteSparse
  Dependencies/OpenCMISS_Variables_SUNDIALS
  Dependencies/OpenCMISS_Variables_SuperLU
  Dependencies/OpenCMISS_Variables_SuperLU_DIST
  Dependencies/OpenCMISS_Variables_SuperLU_MT
  Dependencies/OpenCMISS_Variables_SZip
  Dependencies/OpenCMISS_Variables_ZLIB
)

foreach(_VARIABLES_FILE ${OC_VARIABLES_FILES_LIST})
  OCCMakeDebug("Configuring variables file: '${_VARIABLES_FILE}'." 3)
  configure_file(
    "${OC_BUILD_SYSTEM_ROOT}/CMake/Templates/Variables/${_VARIABLES_FILE}.cmake.in"
    "${OC_CURRENT_CONFIG_DIRECTORY}/Variables/${_VARIABLES_FILE}.cmake"
    @ONLY
  )
endforeach()
    
