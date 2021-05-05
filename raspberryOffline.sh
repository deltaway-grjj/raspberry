#!/bin/bash
wget ftp://teste:@192.168.10.238/packages.tar.gz
tar -xzf packages.tar.gz
sudo dpkg -i ../raspberry/archives/*.deb
echo "END"
