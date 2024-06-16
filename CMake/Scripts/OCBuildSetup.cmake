#[=======================================================================[.rst:
OpenCMISS build setup
---------------------

Setup and install all build system files in the build and install directories.

#]=======================================================================]

OCCMakeMessage(STATUS "Setting up build system files...")

set(OC_CMAKE_BUILD_FILES_LIST
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/tester.cmake
  )
set(OC_CMAKE_SCRIPTS_FILES_LIST
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCArchitecturePath.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeMiscellaneous.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCGithub.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCSetupDependency.cmake
  )
set(OC_CMAKE_MODULES_FILES_LIST
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/tester.cmake
  )
set(OC_CMAKE_FIND_MODULE_WRAPPERS_FILES_LIST
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindBLAS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindBZip2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindCellML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindClang.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindCSim.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindCube4.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindFieldML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindGit.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindHDF5.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindHypre.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindLAPACK.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindLibCellML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindLibXml2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindLLVM.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindMETIS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindMPI.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindMUMPS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindOPARI2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindOTF2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindPAPI.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindParMETIS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindPETSc.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindScalasca.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindScoreP.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindScotch.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSLEPc.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSuiteSparse.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSUNDIALS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSuperLU.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSuperLU_DIST.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSuperLU_MT.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindZLIB.cmake
  )
set(OC_CMAKE_TEMPLATE_FILES_LIST
    ${OC_BUILD_SYSTEM_ROOT}/Templates/tester.in.cmake
 )
set(OC_CMAKE_DEPENDENCIES_VARIABLES_FILES_LIST
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_BLAS_LAPACK.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_BZip2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_CellML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_CSim.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_Cube4.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_FieldML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_HDF5.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_HYPRE.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_LAPACK.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_LibCellML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_LibXml2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_LLVM.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_METIS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_MPI.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_MUMPS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_OPARI2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_OTF2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_PAPI.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_ParMETIS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_PETSc.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_Python.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_Scalasca.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_ScoreP.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_Scotch.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_SLEPc.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_SuiteSparse.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_SUNDIALS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Variables/OpenCMISS_Variables_SuperLU.cmake

# Update the CMake files in the build directory

add_custom_target(oc_build_system_update
  ALL
  COMMENT "Updated build system..."
  DEPENDS oc_build_system_build_update oc_build_system_install_update
  )

add_custom_target(oc_build_system_build_update
  COMMENT "Updated build system build directories..."
  DEPENDS ${OC_CMAKE_BUILD_FILES_LIST}
  )

foreach(_BUILD_FILE ${OC_CMAKE_BUILD_FILES_LIST})
  get_filename_component(_FILENAME ${_BUILD_FILE} NAME)
  add_custom_command(TARGET oc_build_system_build_update
    COMMAND ${CMAKE_COMMAND} -E copy ${_BUILD_FILE} ${OC_BUILD_ROOT}/CMake/${_FILENAME}
    )
endforeach()

# Update the CMake files in the install directory

add_custom_target(oc_build_system_install_update
  COMMENT "Updated build system install directories..."
  DEPENDS
  oc_build_system_install_update_find_wrappers
  oc_build_system_install_update_modules
  oc_build_system_install_update_scripts
  oc_build_system_install_update_templates
  )

# Update the CMake find wrapper files in the install directory

add_custom_target(oc_build_system_install_update_find_wrappers
  COMMENT "Updated build system install find wrappers directory..."
  DEPENDS ${OC_CMAKE_FIND_MODULE_WRAPPERS_FILES_LIST}
  )

foreach(_INSTALL_FILE ${OC_CMAKE_FIND_MODULE_WRAPPERS_FILES_LIST})
  get_filename_component(_FILENAME ${_INSTALL_FILE} NAME)
  add_custom_command(TARGET oc_build_system_install_update_find_wrappers
    COMMAND ${CMAKE_COMMAND} -E copy ${_INSTALL_FILE} ${OC_INSTALL_ROOT}/share/CMake/Modules/FindWrappers/${_FILENAME}
    )
endforeach()
  
# Update the CMake module files in the install directory

add_custom_target(oc_build_system_install_update_modules
  COMMENT "Updated build system install modules directory..."
  DEPENDS ${OC_CMAKE_MODULES_FILES_LIST}
  )

foreach(_INSTALL_FILE ${OC_CMAKE_MODULES_FILES_LIST})
  get_filename_component(_FILENAME ${_INSTALL_FILE} NAME)
  add_custom_command(TARGET oc_build_system_install_update_modules
    COMMAND ${CMAKE_COMMAND} -E copy ${_INSTALL_FILE} ${OC_INSTALL_ROOT}/share/CMake/Modules/${_FILENAME}
    )
endforeach()

# Update the CMake script files in the install directory

add_custom_target(oc_build_system_install_update_scripts
  COMMENT "Updated build system install scripts directory..."
  DEPENDS ${OC_CMAKE_SCRIPTS_FILES_LIST}
  )

foreach(_INSTALL_FILE ${OC_CMAKE_SCRIPTS_FILES_LIST})
  get_filename_component(_FILENAME ${_INSTALL_FILE} NAME)
  add_custom_command(TARGET oc_build_system_install_update_scripts
    COMMAND ${CMAKE_COMMAND} -E copy ${_INSTALL_FILE} ${OC_INSTALL_ROOT}/share/CMake/Scripts/${_FILENAME}
    )
endforeach()

# Update the CMake template files in the install directory

add_custom_target(oc_build_system_install_update_templates
  COMMENT "Updated build system install templates directory..."
  DEPENDS ${OC_CMAKE_TEMPLATES_FILES_LIST}
  )

foreach(_INSTALL_FILE ${OC_CMAKE_TEMPLATES_FILES_LIST})
  get_filename_component(_FILENAME ${_INSTALL_FILE} NAME)
  add_custom_command(TARGET oc_build_system_install_update_scripts
    COMMAND ${CMAKE_COMMAND} -E copy ${_INSTALL_FILE} ${OC_INSTALL_ROOT}/share/CMake/Templates/${_FILENAME}
    )
endforeach()
