OpenCMISS Build System
======================

Basic instructions for building the OpenCMISS computational library.

The build system is 99% done so this documentation is interim, more detailed documentation will follow.

1. Install Linux OS or VM etc.

2. Install necessary pre-requisite packages.

   - For Ubuntu

     sudo git install git cmake gfortran pkg-config bison flex libmpich-dev liblapack-dev libblas-dev

   - For Fedora

     sudo git dnf install cmake gcc-gfortran pkgconf bison flex mpich-devel lapack-devel blas-devel

3. Create a directory for OpenCMISS and change directory into it e.g.,

   mkdir ~/OpenCMISS
   cd ~/OpenCMISS

4. Create some sub-directories

   mkdir setup
   mkdir src
   cd src
   mkdir dependencies

5. There is a small bug in the git repository handling. Until I get a chance to fix the bug the git commands are disabled
   and we will just get the repositories manually. It only has to be done once. This will eventually change.

   git clone https://github.com/OpenCMISS/libOpenCMISS.git

   mkdir dependencies

   cd dependencies

   git clone https://github.com/OpenCMISS-Dependencies2/FieldML-API.git
   cd FieldML-API
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/GKlib.git
   cd GKlib
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/hdf5.git
   cd hdf5
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/hypre.git
   cd hypre
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/lapack.git
   cd lapack
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/libcellml.git
   cd libcellml
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/libxml2.git
   cd libxml2
   git fetch --all --tags --prune
   git checkout tags/v2.9.11 -b opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/METIS.git
   cd METIS
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/mumps.git
   cd mumps
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/ParMETIS.git
   cd ParMETIS
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/petsc.git
   cd petsc
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/scalapack.git
   cd scalapack
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/scotch.git
   cd scotch
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/slepc.git
   cd slepc
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/superlu.git
   cd superlu
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/superlu_dist.git
   cd superlu_dist
   git checkout opencmiss_develop
   cd ..
   git clone https://github.com/OpenCMISS-Dependencies2/zlib.git
   cd zlib
   git checkout opencmiss_develop
   cd ../../..

6. Create the build system files

   cd setup
   cmake -DOpenCMISS_ROOT=~/OpenCMISS -DOpenCMISS_TOOLCHAIN=gnu -DOpenCMISS_MPI=mpich ../build_system/.
   make create_configuration

7. Check the variables are OK, for example for GNU 13.2 with mpich, ..

   cd ~/OpenCMISS/build/configs/x86_64-linux/gnu-C13.2-gnu-F13.2/mpi-mpich-system/Release

   in the Variables directory are the variables that control this configuration of OpenCMISS. Edit if required or
   just use the current defaults

8. Build OpenCMISS

   make

   
   
