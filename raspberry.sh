#!/bin/sh
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
