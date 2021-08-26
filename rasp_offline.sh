#!/bin/bash
sudo timedatectl set-timezone America/Sao_Paulo
#wget ftp://teste:@192.168.10.238/archives.tar.gz
#tar -vxzf archives.tar.gz
#rm archives.tar.gz
#sudo dpkg -i archives/*.deb
#rm -rf archives/
echo 'dtoverlay=disable-bt' | sudo tee -a /boot/config.txt
sudo systemctl disable hciuart
echo 'dtoverlay=disable-wifi' | sudo tee -a /boot/config.txt
echo 'dtoverlay=i2c-gpio,i2c_gpio_sda=8,i2c_gpio_scl=9' | sudo tee -a /boot/config.txt
sudo systemctl stop systemd-timesyncd
sudo systemctl disable systemd-timesyncd
sudo systemctl disable dphys-swapfile.service
DIR="/storage/"
#sudo mkdir $DIR
#sudo mount /dev/sda1 $DIR
#sudo cp /etc/dhcpcd.conf $DIR
#sudo rm /etc/dhcpcd.conf
#sudo ln -s $DIR/dhcpcd.conf /etc/
sudo mkdir -p /home/pi/deltaway/MT300
sudo mkdir -p $DIR/Config
sudo ln -s $DIR/Config/ /home/pi/deltaway/MT300/Config
sudo mkdir -p $DIR/F{1..4}
sudo ln -s $DIR/F1 /home/pi/deltaway/MT300/F1
sudo ln -s $DIR/F2 /home/pi/deltaway/MT300/F2
sudo ln -s $DIR/F3 /home/pi/deltaway/MT300/F3
sudo ln -s $DIR/F4 /home/pi/deltaway/MT300/F4
sudo mkdir -p $DIR/F{1..4}/Backup
sudo mkdir -p $DIR/F{1..4}/NaoColetadas
sudo mkdir -p $DIR/F{1..4}/Teste
sudo mkdir -p /home/pi/deltaway/MT300/lib
sudo mkdir -p $DIR/Log
sudo ln -s $DIR/Log/ /home/pi/deltaway/MT300/Log
wget ftp://teste:@192.168.10.238/package.tar.gz
tar -xzf package.tar.gz
rm package.tar.gz
sudo mv package/fsex300-webfont.ttf /usr/share/fonts/
sudo mv package/libdeviceDriver.so /home/pi/deltaway/MT300/
sudo mv package/libopencv_java452.so /home/pi/deltaway/MT300/lib
sudo mv package/mt300c.jar /home/pi/deltaway/MT300/
sudo mv package/mt300m.jar /home/pi/deltaway/MT300/
MODEL=$(tr -d '\0' </proc/device-tree/model)
if [[ "$MODEL" =~ .*Raspberry[[:space:]]Pi[[:space:]]3[[:space:]]Model[[:space:]]B.* ]]; then
#echo "RPi3"
sudo mv package/deltaway_device_driver_RPi3.ko /home/pi/deltaway/MT300/deltaway_device_driver.ko
sudo tee -a mt300c.service > /dev/null <<EOT
[Unit]
Description=MT300C service
After=sysinit.target
Requires=usb-mount.service
[Service]
ExecStart=/usr/bin/java -server -Xms256m -Xmx256m -XX:+CMSParallelRemarkEnabled -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:MaxGCPauseMillis=10 -jar mt300c.jar
WorkingDirectory=/home/pi/deltaway/MT300
StandardError=null
StandardOutput=null
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOT
sudo tee -a mt300m.service > /dev/null <<EOT
[Unit]
Description=MT300M service
After=sysinit.target
Requires=usb-mount.service
[Service]
ExecStart=/usr/bin/java -server -Xms512m -Xmx512m -XX:+CMSParallelRemarkEnabled -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:MaxGCPauseMillis=10 -jar mt300m.jar
WorkingDirectory=/home/pi/deltaway/MT300
StandardError=null
StandardOutput=null
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOT
elif [[ "$MODEL" =~ .*Raspberry[[:space:]]Pi[[:space:]]4[[:space:]]Model[[:space:]]B.* ]]; then
#echo "RPi4"
sudo mv package/deltaway_device_driver_RPi4.ko /home/pi/deltaway/MT300/deltaway_device_driver.ko
sudo tee -a mt300c.service > /dev/null <<EOT
[Unit]
Description=MT300C service
After=sysinit.target
Requires=usb-mount.service
[Service]
ExecStart=/usr/bin/java -server -Xms256m -Xmx256m -XX:+CMSParallelRemarkEnabled -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:MaxGCPauseMillis=10 -jar mt300c.jar
WorkingDirectory=/home/pi/deltaway/MT300
StandardError=null
StandardOutput=null
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOT
sudo tee -a mt300m.service > /dev/null <<EOT
[Unit]
Description=MT300M service
After=sysinit.target
Requires=usb-mount.service
[Service]
ExecStart=/usr/bin/java -server -Xms512m -Xmx512m -XX:+CMSParallelRemarkEnabled -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:MaxGCPauseMillis=10 -jar mt300m.jar
WorkingDirectory=/home/pi/deltaway/MT300
StandardError=null
StandardOutput=null
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOT
else
echo "NOT SUPPORTED"
fi
rm -rf package/
#sudo tee -a usb-mount.service > /dev/null <<EOT
#[Unit]
#Description=Auto mount USB device
#[Service]
#ExecStart=/bin/bash -c "mount /dev/sda1 $DIR"
#Type=oneshot
#User=root
#[Install]
#WantedBy=multi-user.target
#EOT
#sudo mv usb-mount.service /etc/systemd/system/
#sudo systemctl enable usb-mount.service
sudo mv mt300m.service /etc/systemd/system/
sudo systemctl enable mt300m.service
sudo mv mt300c.service /etc/systemd/system/
sudo systemctl enable mt300c.service
sudo java -jar /tmp/script/manufatura.jar false
sudo useradd -G adm,sudo -M -N -p "$(< /tmp/script/password)"  "$(< /tmp/script/login)"
sudo deluser pi adm
sudo deluser pi sudo
sudo rm -rf /tmp/*
sudo rm -rf /var/log/*
sudo rm -rf /var/tmp/*
sudo rm /etc/sudoers.d/010_pi-nopasswd
echo "END"
