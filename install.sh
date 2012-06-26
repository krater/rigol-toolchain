wget http://download.analog.com/27516/distros/debian/apt.key
sudo apt-key add apt.key
mkdir -p /etc/apt/sources.list.d
echo -n deb http://download.analog.com/27516/distros/debian stable main >> blackfin.sources.list
sudo cp blackfin.sources.list /etc/apt/sources.list.d/
rm apt.key*
rm blackfin.sources.list
sudo apt-get update
sudo apt-get install blackfin-toolchain-uclinux build-essential libelf-dev
echo 'export PATH=$PATH:/opt/uClinux/bfin-uclinux/bin:/opt/uClinux/bfin-linux-uclibc/bin' | cat - ~/.bashrc > temp && mv temp ~/.bashrc
sudo make install



