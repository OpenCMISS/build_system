#[=======================================================================[.rst:
OpenCMISS Intel Toolchain script
--------------------------------

OpenCMISS script to set the Intel toolchain compilers.

#]=======================================================================]

find_program(OC_CMAKE_C_COMPILER icx REQUIRED NO_CACHE)
find_program(OC_CMAKE_CXX_COMPILER icpx REQUIRED NO_CACHE)
find_program(OC_CMAKE_Fortran_COMPILER ifx REQUIRED NO_CACHE)
