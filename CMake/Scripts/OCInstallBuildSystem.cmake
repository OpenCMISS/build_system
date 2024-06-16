#[=======================================================================[.rst:
OpenCMISS Install build system script
----------------------------------

OpenCMISS CMake script to install all the build system files.

#]=======================================================================]

include(${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeMiscellaneous.cmake)

set(OC_CMAKE_SCRIPTS_FILES_LIST
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCArchitecturePath.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCBuildTypes.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeFindUtilities.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeMiscellaneous.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCCMakeSetup.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCConfigure.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCDownloadGitRepository.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCGitHub.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCInstrumentation.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCMPI.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCMultithreading.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCOperatingSystems.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCRepositories.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCRootPaths.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCSetupExternal.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Scripts/OCUpdateGitRepository.cmake
  )
set(OC_CMAKE_MODULES_FILES_LIST
  )
set(OC_CMAKE_FIND_MODULE_WRAPPERS_FILES_LIST
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindBLAS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindBZip2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindCellML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindClang.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindCOLAMD.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindCSim.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindCube4.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindFieldML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindGit.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindGKlib.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindHDF5.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindHYPRE.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindLAPACK.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindlibCellML.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindLibXml2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindLLVM.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindMETIS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindMUMPS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindOPARI2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindOTF2.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindPAPI.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindParMETIS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindPETSc.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSCALAPACK.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindScalasca.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindScoreP.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindScotch.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSLEPc.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSuiteSparse.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSUNDIALS.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSuperLU.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSuperLU_DIST.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSuperLU_MT.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindSZip.cmake
  ${OC_BUILD_SYSTEM_ROOT}/CMake/Modules/FindModuleWrappers/FindZLIB.cmake
)

foreach(_INSTALL_FILE ${OC_CMAKE_SCRIPTS_FILES_LIST})
  file(INSTALL "${_INSTALL_FILE}"
    DESTINATION ${OC_INSTALL_ROOT}/share/CMake/Scripts
  )
endforeach()
#foreach(_INSTALL_FILE "${OC_CMAKE_MODULES_FILES_LIST}")
#  file(INSTALL "${_INSTALL_FILE}"
#    DESTINATION ${OC_INSTALL_ROOT}/share/CMake/Modules
#  )
#endforeach()
foreach(_INSTALL_FILE ${OC_CMAKE_FIND_MODULE_WRAPPERS_FILES_LIST})
  file(INSTALL "${_INSTALL_FILE}"
    DESTINATION ${OC_INSTALL_ROOT}/share/CMake/Modules/FindModuleWrappers
  )
endforeach()
