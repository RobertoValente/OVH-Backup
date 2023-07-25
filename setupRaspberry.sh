#!/bin/bash

echo "Installing the necessary packages..."

sudo apt update -y && sudo apt upgrade -y
echo "Packages has been updated and upgraded"

sudo apt install nodejs -y
echo "Package NodeJS Installed"

sudo apt install npm -y
echo "Package NPM Installed"

sudo apt install git -y
echo "Package GIT Installed"

sudo apt install vsftpd -y
echo "Package VSFTPD Installed"

sudo apt install ntfs-3g -y
echo "Package NTFTS-3G Installed"

echo " "
echo " "

read -p "Insert your username: " username
read -p "Insert the name of HD's Folder: " folderdisk

sudo mkdir /media/$folderdisk
echo "Folder Created at: /media/" $folderdisk "/"

lsblk
read -p "Insert the name of HD Partition to be mounted: " partition
sudo mount -t ntfs-3g /dev/$partition /media/$folderdisk

echo " "
echo " "

echo "If you want to mount this device automatically in Operative System Startup:"
echo "> Run the command: ls -l /dev/disk/by-uuid/"
echo "> Get the UUID of the device you want for you substitute the 'DEVICE_UUID_HERE' with it"
echo "> Run the command: sudo nano /etc/fstab"
echo "> Add to the end of the file: UUID=DEVICE_UUID_HERE /media/"$folderdisk"/ ntfs-3g auto,nofail,noatime,users,rw 0 0"

echo " "
echo " "

echo "To Turn On FTP:"
echo "> Run the command: sudo mkdir -p /media/"$folderdisk"/FTP"
echo "> Run the command: sudo nano /etc/vsftpd.conf"
echo "> Uncomment the following lines: "
echo "   > write_enable=YES"
echo "   > local_umask=022"
echo "   > chroot_local_user=YES"
echo "> Change the line: anonymous_enable=YES to anonymous_enable=NO"
echo "> Add the following lines: "
echo "   > user_sub_token="$USER""
echo "   > local_root=/media/"$folderdisk"/FTP"
echo "> Run the command: sudo service vsftpd restart"

echo " "
echo " "

echo "Setup Finished!"
