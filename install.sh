wget http://sourceforge.net/projects/adi-toolchain/files/2013R1/2013R1-RC1/i386/blackfin-toolchain-2013R1-RC1.i386.tar.bz2
sudo tar xfjv blackfin-toolchain-2013R1-RC1.i386.tar.bz2 -C /
rm blackfin-toolchain-2013R1-RC1.i386.tar.bz2
sudo apt-get update
sudo apt-get install build-essential libelf-dev
echo 'export PATH=$PATH:/opt/uClinux/bfin-uclinux/bin:/opt/uClinux/bfin-linux-uclibc/bin' | cat - ~/.bashrc > temp && mv temp ~/.bashrc
mkdir bin
sudo make install