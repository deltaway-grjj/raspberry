#!/bin/bash
sudo apt update && sudo apt -y upgrade && sudo apt -y install \
ant \
autoconf \
autoconf-archive \
automake \
build-essential \
bzip2 \
ccache \
clang \
cmake \
file \
ffmpeg \
freeglut3-dev \
gfortran \
git \
git-core \
gzip \
g++ \
libasound2-dev \
libass-dev \
libatlas-base-dev \
libavcodec-dev \
libavformat-dev \
libcanberra-gtk* \
libfreetype6-dev \
libgnutls28-dev \
libgtk-3-dev \
libgtk2.0-dev \
libjpeg-dev \
libpng-dev \
libprotobuf-dev \
libsdl2-dev \
libswscale-dev \
libtiff-dev \
libtool \
libusb-dev \
libv4l-dev \
libva-dev \
libvdpau-dev \
libvorbis-dev \
libx264-dev \
libxcb1-dev \
libxcb-shm0-dev \
libxcb-xfixes0-dev \
libxvidcore-dev \
make \
maven \
nasm \
openjdk-8-jdk \
patch \
perl \
pkg-config \
protobuf-compiler \
python \
swig \
tar \
texinfo \
unzip \
wget \
xmlstarlet \
yasm \
zlib1g \
zlib1g-dev
echo 'dtoverlay=pi3-disable-bt' | sudo tee -a /boot/config.txt
sudo systemctl disable hciuart
echo 'dtoverlay=pi3-disable-wifi' | sudo tee -a /boot/config.txt
sudo systemctl stop systemd-timesyncd
sudo systemctl disable systemd-timesyncd
rm -rf ~/wiringpi/
git clone https://github.com/WiringPi/WiringPi --branch master --single-branch ~/wiringpi/
cd ~/wiringpi/
sudo ./build
cd ~
sudo mkdir -p /home/pi/deltaway/MT300
sudo mkdir -p /home/pi/deltaway/MT300/Config
sudo mkdir -p /home/pi/deltaway/MT300/Log
sudo mkdir -p /home/pi/deltaway/MT300/lib
sudo mkdir -p /home/pi/deltaway/MT300/F{1..4}/Backup
sudo mkdir -p /home/pi/deltaway/MT300/F{1..4}/NaoColetadas
sudo mkdir -p /home/pi/deltaway/MT300/F{1..4}/Teste
MODEL=$(cat /proc/device-tree/model)
if [[ "$MODEL" =~ .*Raspberry[[:space:]]Pi[[:space:]]3[[:space:]]Model[[:space:]]B.* ]]; then
  echo "It's there."
else
echo "Erroooou"
fi
#MODEL=$(cat /proc/device-tree/model)
#VAR='GNU/Linux is an operating system'
#if [[ $VAR == *"Linux"* ]]; then
#  echo "It's there."
#fi
