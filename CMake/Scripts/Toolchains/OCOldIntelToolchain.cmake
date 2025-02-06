#[=======================================================================[.rst:
OpenCMISS Old Intel Toolchain script
------------------------------------

OpenCMISS script to set the old Intel toolchain compilers.

#]=======================================================================]

find_program(OC_CMAKE_C_COMPILER icc REQUIRED NO_CACHE)
find_program(OC_CMAKE_CXX_COMPILER icpc REQUIRED NO_CACHE)
find_program(OC_CMAKE_Fortran_COMPILER ifort REQUIRED NO_CACHE)
