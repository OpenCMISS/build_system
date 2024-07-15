#[=======================================================================[.rst:
OpenCMISS LLVM Toolchain script
-------------------------------

OpenCMISS script to set the LLVM toolchain compilers.

#]=======================================================================]

find_program(OC_CMAKE_C_COMPILER clang REQUIRED NO_CACHE)
find_program(OC_CMAKE_CXX_COMPILER clang++ REQUIRED NO_CACHE)
find_program(OC_CMAKE_Fortran_COMPILER flang REQUIRED NO_CACHE)
