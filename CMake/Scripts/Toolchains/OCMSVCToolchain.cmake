#[=======================================================================[.rst:
OpenCMISS MSVC Toolchain script
-------------------------------

OpenCMISS script to set the MSVC toolchain compilers.

#]=======================================================================]

find_program(OC_CMAKE_C_COMPILER cl REQUIRED)
find_program(OC_CMAKE_CXX_COMPILER cl REQUIRED)
find_program(OC_CMAKE_Fortran_COMPILER ifx REQUIRED)
