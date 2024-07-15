#[=======================================================================[.rst:
OpenCMISS Install build system script
----------------------------------

OpenCMISS CMake script to install all the build system files.

#]=======================================================================]

include(${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_SCRIPTS_SUBDIR}/OCCMakeMiscellaneous.cmake)

set(OC_CMAKE_SCRIPTS_FILES_LIST
  OCArchitecturePath.cmake
  OCBuildTypes.cmake
  OCCMakeFindUtilities.cmake
  OCCMakeMiscellaneous.cmake
  OCCMakeSetup.cmake
  OCConfigure.cmake
  OCDownloadGitRepository.cmake
  OCGitHub.cmake
  OCInstrumentation.cmake
  OCMPI.cmake
  OCMultithreading.cmake
  OCOperatingSystems.cmake
  OCRepositories.cmake
  OCRootPaths.cmake
  OCSetupExternal.cmake
  OCToolchains.cmake
  OCUpdateGitRepository.cmake
)
set(OC_CMAKE_TOOLCHAIN_FILES_LIST
  OCGNUToolchain.cmake
  OCIntelToolchain.cmake
  OCLLVMToolchain.cmake
  OCMSVCToolchain.cmake
)
set(OC_CMAKE_MODULES_FILES_LIST
  )
set(OC_CMAKE_FIND_MODULE_WRAPPERS_FILES_LIST
  FindBLAS.cmake
  FindBZip2.cmake
  FindCellML.cmake
  FindClang.cmake
  FindCOLAMD.cmake
  FindCSim.cmake
  FindCube4.cmake
  FindFieldML.cmake
  FindGit.cmake
  FindGKlib.cmake
  FindHDF5.cmake
  FindHYPRE.cmake
  FindLAPACK.cmake
  FindlibCellML.cmake
  FindLibXml2.cmake
  FindLLVM.cmake
  FindMETIS.cmake
  FindMUMPS.cmake
  FindOPARI2.cmake
  FindOTF2.cmake
  FindPAPI.cmake
  FindParMETIS.cmake
  FindPETSc.cmake
  FindSCALAPACK.cmake
  FindScalasca.cmake
  FindScoreP.cmake
  FindSCOTCH.cmake
  FindSLEPc.cmake
  FindSuiteSparse.cmake
  FindSUNDIALS.cmake
  FindSuperLU.cmake
  FindSuperLU_DIST.cmake
  FindSuperLU_MT.cmake
  FindSZip.cmake
  FindZLIB.cmake
)

foreach(_INSTALL_FILE ${OC_CMAKE_SCRIPTS_FILES_LIST})
  file(INSTALL ${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_SCRIPTS_SUBDIR}/${_INSTALL_FILE}
    DESTINATION ${OC_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_SCRIPTS_SUBDIR}
  )
endforeach()
foreach(_INSTALL_FILE ${OC_CMAKE_TOOLCHAIN_FILES_LIST})
  file(INSTALL ${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_SCRIPTS_SUBDIR}/Toolchains/${_INSTALL_FILE}
    DESTINATION ${OC_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_SCRIPTS_SUBDIR}/Toolchains
  )
endforeach()
#foreach(_INSTALL_FILE "${OC_CMAKE_MODULES_FILES_LIST}")
#  file(INSTALL ${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_MODULES_SUBDIR}/${_INSTALL_FILE}
#    DESTINATION ${OC_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_MODULES_SUBDIR}
#  )
#endforeach()
foreach(_INSTALL_FILE ${OC_CMAKE_FIND_MODULE_WRAPPERS_FILES_LIST})
  file(INSTALL ${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_FIND_MODULES_SUBDIR}/${_INSTALL_FILE}
    DESTINATION ${OC_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_FIND_MODULES_SUBDIR}
  )
endforeach()
# Write the libOpenCMISS setup script
configure_file(${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_TEMPLATES_SUBDIR}/libOpenCMISSSetup.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libOpenCMISSSetup.cmake
  @ONLY
)
file(INSTALL ${CMAKE_CURRENT_BINARY_DIR}/libOpenCMISSSetup.cmake
  DESTINATION ${OC_INSTALL_ROOT}
)
# Write the find libOpenCMISS script
configure_file(${OC_BUILD_SYSTEM_ROOT}/${OC_CMAKE_TEMPLATES_SUBDIR}/FindlibOpenCMISS.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/FindlibOpenCMISS.cmake
  @ONLY
)
file(INSTALL ${CMAKE_CURRENT_BINARY_DIR}/FindlibOpenCMISS.cmake
  DESTINATION ${OC_INSTALL_ROOT}/${OC_INSTALL_DATA_SUBDIR}/${OC_CMAKE_FIND_MODULES_SUBDIR}
)

