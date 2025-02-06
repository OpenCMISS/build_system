#[=======================================================================[.rst:
OpenCMISS GNU Toolchain script
------------------------------

OpenCMISS script to set the GNU toolchain compilers.

#]=======================================================================]

find_program(OC_CMAKE_C_COMPILER gcc REQUIRED NO_CACHE)
find_program(OC_CMAKE_CXX_COMPILER g++ REQUIRED NO_CACHE)
find_program(OC_CMAKE_Fortran_COMPILER gfortran REQUIRED NO_CACHE)
