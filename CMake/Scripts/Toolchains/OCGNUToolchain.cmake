#[=======================================================================[.rst:
OpenCMISS GNU Toolchain script
------------------------------

OpenCMISS script to set the GNU toolchain compilers.

#]=======================================================================]

find_program(CMAKE_C_COMPILER NAMES gcc REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES g++ REQUIRED)
find_program(CMAKE_Fortran_COMPILER NAMES gfortran REQUIRED)
