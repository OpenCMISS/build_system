#[=======================================================================[.rst:
OpenCMISS Intel Toolchain script
--------------------------------

OpenCMISS script to set the Intel toolchain compilers.

#]=======================================================================]

find_program(CMAKE_C_COMPILER NAMES icx REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES icx REQUIRED)
find_program(CMAKE_Fortran_COMPILER NAMES ifx REQUIRED)
