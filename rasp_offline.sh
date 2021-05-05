#!/bin/bash
wget ftp://teste:@192.168.10.238/packages.tar.gz
tar -xzf packages.tar.gz
sudo dpkg -i archives/*.deb
echo 'dtoverlay=disable-bt' | sudo tee -a /boot/config.txt
sudo systemctl disable hciuart
echo 'dtoverlay=disable-wifi' | sudo tee -a /boot/config.txt
echo 'dtoverlay=i2c-gpio,i2c_gpio_sda=8,i2c_gpio_scl=9' | sudo tee -a /boot/config.txt
sudo systemctl stop systemd-timesyncd
sudo systemctl disable systemd-timesyncd
sudo systemctl disable dphys-swapfile.service
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
cd ~
wget ftp://teste:@192.168.10.238/package.tar.gz
tar -xzf package.tar.gz
sudo mv ~/package/fsex300-webfont.ttf /usr/share/fonts/fsex300-webfont.ttf
sudo mv ~/package/libdeviceDriver.so ~/deltaway/MT300/libdeviceDriver.so
sudo mv ~/package/libopencv_java451.so ~/deltaway/MT300/lib/libopencv_java451.so
sudo mv ~/package/mt300c.jar ~/deltaway/MT300/mt300c.jar
sudo mv ~/package/mt300m.jar ~/deltaway/MT300/mt300m.jar
MODEL=$(tr -d '\0' </proc/device-tree/model)
if [[ "$MODEL" =~ .*Raspberry[[:space:]]Pi[[:space:]]3[[:space:]]Model[[:space:]]B.* ]]; then
#echo "RPi3"
sudo mv ~/package/deltaway_device_driver_RPi3.ko ~/deltaway/MT300/deltaway_device_driver.ko
sudo tee -a ~/mt300c.service > /dev/null <<EOT
[Unit]
Description=MT300C service
After=sysinit.target
[Service]
ExecStart=/usr/bin/java -Xmx512m -jar mt300c.jar
WorkingDirectory=/home/pi/deltaway/MT300
StandardError=null
StandardOutput=null
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOT
sudo tee -a ~/mt300m.service > /dev/null <<EOT
[Unit]
Description=MT300M service
After=sysinit.target
[Service]
ExecStart=/usr/bin/java -Xmx512m -jar mt300m.jar
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
sudo mv ~/package/deltaway_device_driver_RPi4.ko ~/deltaway/MT300/deltaway_device_driver.ko
sudo tee -a ~/mt300c.service > /dev/null <<EOT
[Unit]
Description=MT300C service
After=sysinit.target
[Service]
ExecStart=/usr/bin/java -Xmx1G -jar mt300c.jar
WorkingDirectory=/home/pi/deltaway/MT300
StandardError=null
StandardOutput=null
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOT
sudo tee -a ~/mt300m.service > /dev/null <<EOT
[Unit]
Description=MT300M service
After=sysinit.target
[Service]
ExecStart=/usr/bin/java -Xmx2G -jar mt300m.jar
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
sudo mv ~/mt300c.service /etc/systemd/system/mt300c.service
sudo systemctl enable mt300c.service
sudo mv ~/mt300m.service /etc/systemd/system/mt300m.service
sudo systemctl enable mt300m.service
#sudo java -jar ~/package/manufatura.jar false
echo "END"
