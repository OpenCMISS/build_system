#[=======================================================================[.rst:
OpenCMISS MSVC Toolchain script
-------------------------------

OpenCMISS script to set the MSVC toolchain compilers.

#]=======================================================================]

find_program(CMAKE_C_COMPILER NAMES cl.exe REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES cl.exe REQUIRED)
find_program(CMAKE_Fortran_COMPILER NAMES ifort.exe REQUIRED)
