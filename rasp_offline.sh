#!/bin/bash
sudo timedatectl set-timezone America/Sao_Paulo
FILE="archives2.tar.gz"
wget ftp://teste:@192.168.10.238/$FILE
tar -vxzf $FILE
rm $FILE
sudo dpkg -i archives/*.deb
rm -rf archives/
echo 'dtoverlay=disable-bt' | sudo tee -a /boot/config.txt
sudo systemctl disable hciuart
echo 'dtoverlay=disable-wifi' | sudo tee -a /boot/config.txt
echo 'dtoverlay=i2c-gpio,i2c_gpio_sda=8,i2c_gpio_scl=9' | sudo tee -a /boot/config.txt
awk '{ if ($2 ~ /\/$|\/boot$/) gsub(/defaults/, "defaults,ro"); print}' fstab | sudo tee /etc/fstab
echo 'tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0' | sudo tee -a /etc/fstab
sudo systemctl stop systemd-timesyncd
sudo systemctl disable systemd-timesyncd
sudo systemctl disable dphys-swapfile.service
DIR="/home/pi/deltaway/MT300"
sudo mkdir -p $DIR/Config
sudo mkdir -p $DIR/F{1..4}/Backup
sudo mkdir -p $DIR/F{1..4}/NaoColetadas
sudo mkdir -p $DIR/F{1..4}/Teste
sudo mkdir -p $DIR/lib
sudo mkdir -p $DIR/Log
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
Requires=make-writable.service
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
Requires=make-writable.service
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
Requires=make-writable.service
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
Requires=make-writable.service
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
FILE="formatter.tar.gz"
wget ftp://teste:@192.168.10.238/$FILE
tar -vxzf $FILE
rm $FILE
sudo mv formatter/make-writable.sh /usr/local/bin/
rm -rf formatter
sudo tee -a make-writable.service > /dev/null <<EOT
[Unit]
Description=Make MT300 directory writable
[Service]
ExecStart=/usr/local/bin/make-writable.sh
Type=oneshot
User=root
[Install]
WantedBy=multi-user.target
EOT
sudo mv make-writable.service /etc/systemd/system/
sudo systemctl enable make-writable.service
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
