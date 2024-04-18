#!/usr/bin/env sh
#Purpose: Installs all necesary software on a new machine
#for the use of cfd algorithm development
#Author: Andrew Davis <andrew.davis1104@gmail.com>
#Last updated: 11/06/2023

########## VAriables ##########
#where CGNS is grabbed from
cgns_git=https://github.com/CGNS/CGNS.git
#where HDF5 is grabbed from
hdf5_git=https://github.com/I-am-Andrew-Davis/hdf5-1.10.6.git
#where command is being run from
fresh_install_dir=$PWD
#hdf5 path
hdf5_path=/usr/local/hdf5-1.10.6
#cgns path
cgns_path=/usr/local/CGNS
#visit path
visit_path=/usr/local/visit
#visit tar file name
visit_tar=visit3_3_3.linux-x86_64-debian11.tar.gz
#visit install script
visit_install_script=visit-install3_3_3
#Modules tar file name
modules_tar=Modules.tar.gz
#Modules path
modules_path=/usr/local/Modules
#gcc version file name
gcc_version=gcc-10.2.0
#gcc tar file name
gcc_tar="${gcc_version}.tar.gz"
#gcc path
gcc_path="/usr/local/${gcc_version}"

########## Add contrib non-free and non-free-firmware to /etc/apt/sources.list #########

#sed -r -i 's/^deb(.*)$/deb\1 contrib non-free non-free-firmware/g' /etc/apt/sources.list #UNCOMMENT ME
apt update
########## install software via apt #########

#text:
apt install emacs auctex texlive-full latex2html pdftk xfig tofrodos fonts-hack-ttf
#Development tools:
apt install liblapack-dev libfftw3-dev libfftw3-mpi-dev doxygen graphviz csh dvipng autoconf git gitk subversion cvs mercurial gcc g++ cpp gfortran gdb valgrind cmake cmake-curses-gui libopenmpi-dev openmpi-bin environment-modules libncurses5-dev ncurses-doc libtool automake flex bison bison-doc python3 pandoc clang hwloc libhwloc-dev numactl libnuma-dev linux-perf
#Admin stuff:
apt install cups nmap cifs-utils dstat sysstat ethtool system-config-printer parted gdisk hplip lm-sensors smartmontools dkms firmware-linux dnsutils nfs-common locate iotop rsync strace ldap-utils
#Useful Misc Applications:
apt install thunderbird firefox-esr inkscape gimp xfce4-screenshooter okular gnuplot gv default-jre default-jdk wxmaxima octave hdf-compass tree remmina
#Depencies:
apt install zlib1g-dev libbz2-dev libxi-dev libxmu-dev freeglut3-dev libf2c2-dev libxt-dev libgraphviz-dev libsqlite3-dev sqlite3-doc tk-dev
#Media:
apt-get install smplayer ffmpeg
#To build GCC:
apt-get install libmpfr-dev libgmp-dev libmpc-dev
#Cuda stuff
apt install nvidia-driver firmware-misc-nonfree
apt install nvidia-cuda-toolkit nvidia-cuda-dev

########## install cgns and hdf5 ###########
#step 0: make directories where it will live
mkdir $hdf5_path
mkdir $cgns_path

#Step 1 setup hdf5
cd $hdf5_path
git clone $hdf5_git
#make the parallel version
CC=mpicc ./configure --enable-fortran --enable-parallel --enable-shared --prefix=$hdf5_path/1.10.6_mpi
make -j10
make install
#make the serial version
CC=gcc ./configure --enable-fortran --enable-shared --prefix=$hdf5_path/1.10.6
make -j10
make install
#step 2 setup CGNS
cd $cgns_path
git clone -b master $cgns_git
#make the parallel version
cd src
CC=mpicc LIBS="-ldl -lz" ./configure --prefix=$cgns_path/4.4.0_mpi --with-hdf5=$hdf5_path/1.10.6_mpi  --enable-parallel
make -j10
make install
#make the serial version
CC=gcc LIBS="-ldl -lz" ./configure --prefix=$cgns_path/4.4.0 --with-hdf5=$hdf5_path/1.10.6
make -j10
make install

########## install visit ###########
cd $fresh_install_dir
chmod +x $visit_install_script
./$visit_install_script 3_3_3 linux-x86_64-debian11 $visit_path

########## install gcc version 10.2.0 ###########
cd $fresh_install_dir
tar -xvf $gcc_tar
cd $gcc_version
./contrib/download_prerequisites
cd ..
mkdir objdir
cd objdir
../$gcc_version/configure --prefix=$gcc_path --enable-languages=c,c++,fortran
make -j10
make install
########## Add the module files ###########
cd $fresh_install_dir
tar -xvf $modules_tar
mv Modules $modules_path

########## Add the appropriate commands to .bashrc ###########
echo "source /etc/profile.d/modules.sh" >> ~/.bashrc
echo "module use --append /usr/local/Modules" >> ~/.bashrc
echo "export PATH="/usr/local/visit/bin:$PATH"" >> ~/.bashrc
echo "export PATH="~/.config/emacs/bin/:$PATH"" >> ~/.bashrc
echo "module load gcc_10.2.0/10.2.0 hdf5/1.10.6_serial cgns/4.4.0_serial" >> ~/.bashrc
echo "module list" >> ~/.bashrc
