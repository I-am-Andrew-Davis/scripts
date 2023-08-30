#!/usr/bin/env sh
#############################################################
#Author: Andrew Davis
#Email: andrew.davis1104@gmail.com
#Last Updated: 08/28/2023
#Purpose: setups Chord and Chombo on Rivanna HPC cluster
#using only a computing ID. When running a case with chord,
#the module hdf5/1.10.6 and gcc/9.2.0 must be loaded
#NOTE: it is assumed that version 4.4.0 of CGNS is used
#and version 1.10.6 of HDF5 is used.
#############################################################
################## README!!!! ##############################
# The only thing that needs to be changed is the computing ID
# more advanced users can customize installation paths in step 0
#############################################################
#step 0 preliminaries
#computing ID (no spaces anywhere)
computing_ID=gtv6bk
#where CGNS and HDF5 live
install_path=/home/$computing_ID/Codes
#where Chord and Chombo live
chord_chombo_path=/home/$computing_ID/Codes
mkdir $install_path
mkdir $chord_chombo_path
#where Chord is grabbed from
chord_git=https://github.com/I-am-Andrew-Davis/Chord-MMB.git
#where Chombo is grabbed from
chombo_git=https://github.com/I-am-Andrew-Davis/Chombo-MMB.git
#where CGNS is grabbed from
cgns_git=https://github.com/CGNS/CGNS.git
#where HDF5 is grabbed from
hdf5_git=https://github.com/I-am-Andrew-Davis/hdf5-1.10.6.git
#dont change me
chombo_lib_path=$chord_chombo_path/Chombo/lib/mk
hdf5_path=$install_path/hdf5-1.10.6/1.10.6
cgns_path=$install_path/CGNS/4.4.0
module load gcc/9.2.0  openmpi/3.1.6
#used for warnings
hdf5source=1
hdf5install=1
cgnssource=1
cgnsinstall=1
#step 1 setup hdf5
#if you dont have the hdf5 source code, grab it
if [! -d "$install_path/hdf5-1.10.6"];
then
    hdf5source=0 #used for warnings
    cd $install_path
    git clone $hdf5_git
fi
#if you dont have the hdf5 lib installed, install it
if [! -d "$hdf5_path/lib"];
then
    hdf5install=0 #used for warnings
    cd $install_path/hdf5-1.10.6
    CC=mpicc ./configure --enable-fortran --enable-parallel --enable-shared --prefix=$hdf5_path
    make
    make install
fi
#step 2 setup cgns
#if you dont have the cgns source code, grab it
if [! -d "$install_path/CGNS"];
then
    cgnssource=0 #used for warnings
    cd $install_path
    git clone -b master $cgns_git
fi
#if you dont have the cgns lib installed, install it
if [! -d "$cgns_path/lib"];
then
    cgnsinstall=0 #used for warnings
    cd $install_path/CGNS/src
    CC=mpicc LIBS="-ldl -lz" ./configure --prefix=$cgns_path --with-hdf5=$hdf5_path  --enable-parallel
    make
    make install
fi
#step 3 grab chord and Chombo
cd $chord_chombo_path
git clone $chombo_git
git clone $chord_git
mv Chombo-MMB Chombo
mv Chord-MMB chord
#step 4 setup chombo Make.def.local
cd $chord_chombo_path/Chombo
./configure
cd $chombo_lib_path
sed -i "s,HDFINCFLAGS      =,HDFINCFLAGS      = -I$hdf5_path/include,1" Make.defs.local
sed -i "s,HDFLIBFLAGS      = -lhdf5 -lsz -lz -ldl,HDFLIBFLAGS      = -L$hdf5_path/lib -lhdf5 -lz,1" Make.defs.local
sed -i "s,HDFMPIINCFLAGS   =,HDFMPIINCFLAGS   = -I$hdf5_path/include,1" Make.defs.local
sed -i "s,HDFMPILIBFLAGS   = -lhdf5 -lsz -lz -ldl,HDFMPILIBFLAGS   = -L$hdf5_path/lib -lhdf5 -lz,1" Make.defs.local
sed -i "s,CGNSINCFLAGS =,CGNSINCFLAGS = -I$cgns_path/include,1" Make.defs.local
sed -i "s,CGNSLIBFLAGS = -lcgns, CGNSLIBFLAGS = -L$cgns_path/lib -lcgns,1" Make.defs.local

if [[$hdf5source -eq 1]]; then
echo "WARNING: it appears you already have the hdf5-1.10.6 soure code installed... skipping grabbing it"
fi
if [[$hdf5install -eq 1]]; then
echo "WARNING: it appears you already have the hdf5-1.10.6 library installed... skipping installation"
fi
if [[$cgnssource -eq 1]]; then
echo "WARNING: it appears you already have the cgns-4.4.0 soure code installed... skipping grabbing it"
fi
if [[$cgnsinstall -eq 1]]; then
echo "WARNING: it appears you already have the cgns-4.4.0 library installed... skipping installation"
fi
