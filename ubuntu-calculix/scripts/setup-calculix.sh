#!/bin/sh

cd $(HOME)
mkdir build-calculix
cd build-calculix

# # Build SPOOLES.2.2 -----------------------------------------------------------
mkdir SPOOLES.2.2
cd SPOOLES.2.2
curl -OL https://netlib.org/linalg/spooles/spooles.2.2.tgz
tar -xzf spooles.2.2.tgz

sed -i "s/  CC = \/usr\/lang-4.0\/bin\/cc/  CC = gcc/" Make.inc
sed -i "s/  OPTLEVEL = -O/  OPTLEVEL = -O2/" Make.inc
make lib
cd ../

# Build ARPACK ----------------------------------------------------------------
curl -OL https://github.com/GeneralElectric/CalculiX/raw/master/src/downloads/arpack96.tar.gz
curl -OL https://github.com/GeneralElectric/CalculiX/raw/master/src/downloads/arpack96_patch.tar.gz
tar zxf arpack96.tar.gz
tar zxf arpack96_patch.tar.gz
cd ARPACK
sed -i "s/home = \$(HOME)\/ARPACK/home = \$(HOME)\/build-calculix\/ARPACK/" ARmake.inc
sed -i "s/PLAT = SUN4/PLAT = Linux/" ARmake.inc
sed -i "s/FC      = f77/FC      = gfortran/" ARmake.inc
sed -i "s/FFLAGS	= -O -cg89/FFLAGS	= -O2 -fallow-argument-mismatch/" ARmake.inc
sed -i "s/MAKE    = \/bin\/make/MAKE    = make/" ARmake.inc
sed -i "s/      EXTERNAL           ETIME/*      EXTERNAL           ETIME/" UTIL/second.f
make lib
cd ../

# Build CalculiX --------------------------------------------------------------
curl -OL http://www.dhondt.de/ccx_2.20.src.tar.bz2
curl -OL http://www.dhondt.de/ccx_2.20.test.tar.bz2
curl -OL http://www.dhondt.de/ccx_2.20.doc.tar.bz2
tar -xf ccx_2.20.src.tar.bz2
tar -xf ccx_2.20.test.tar.bz2
tar -xf ccx_2.20.doc.tar.bz2
cd CalculiX/ccx_2.20/src

sed -i "s/@ARGV=\"ccx_2.20step.c\";/@ARGV=\"CalculiXstep.c\";/" date.pl
sed -i "s/FFLAGS = -Wall -O2/FFLAGS = -Wall -O2 -fallow-argument-mismatch/" Makefile
sed -i "s/..\/..\/..\/ARPACK\/libarpack_INTEL.a /..\/..\/..\/ARPACK\/libarpack_Linux.a /" Makefile
make
mkdir -p /opt/CalculiX
mkdir /opt/CalculiX/bin
cd ../../..
cp -R CalculiX/ccx_2.20/src/ccx_2.20 /opt/CalculiX/bin/ccx
cp -R CalculiX/ccx_2.20/test /opt/CalculiX/test
cp -R CalculiX/ccx_2.20/doc /opt/CalculiX/doc
cd ../
rm -rf build-calculix