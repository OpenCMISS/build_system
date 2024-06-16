#[=======================================================================[.rst:
OpenCMISS LLVM Toolchain script
-------------------------------

OpenCMISS script to set the LLVM toolchain compilers.

#]=======================================================================]

find_program(CMAKE_C_COMPILER NAMES clang REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES clang++ REQUIRED)
find_program(CMAKE_Fortran_COMPILER NAMES flang REQUIRED)
