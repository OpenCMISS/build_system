#[=======================================================================[.rst:
OpenCMISS Old Intel Toolchain script
------------------------------------

OpenCMISS script to set the old Intel toolchain compilers.

#]=======================================================================]

find_program(CMAKE_C_COMPILER NAMES icc REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES icpc REQUIRED)
find_program(CMAKE_Fortran_COMPILER NAMES ifort REQUIRED)
