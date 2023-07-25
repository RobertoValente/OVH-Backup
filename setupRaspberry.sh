#!/bin/bash

echo "Installing the necessary packages..."

sudo apt update -y && sudo apt upgrade -y > /dev/null
echo "Packages has been updated and upgraded"

sudo apt install nodejs -y > /dev/null
echo "Package NodeJS Installed"

sudo apt install npm -y > /dev/null
echo "Package NPM Installed"

sudo apt install git -y > /dev/null
echo "Package GIT Installed"

sudo apt install vsftpd -y > /dev/null
echo "Package VSFTPD Installed"

sudo apt install ntfs-3g -y > /dev/null
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

<<com
echo '/* =============================================== */'
echo '/* == Updating and Installing What Is Necessary == */'
sudo apt update -y && sudo apt upgrade -y
sudo apt install nodejs -y
sudo apt install npm -y
sudo apt install git -y
sudo apt install vsftpd -y
sudo apt install ntfs-3g -y
echo '/* =============================================== */'
echo '/* =============================================== */'

echo '/* =============================================== */'
echo '/* ================== HD Setup =================== */'

lsblk
read -p 'Disk: ' disk
mount | grep $disk

read -p 'Insert your Username: ' username
read -p 'Folder Name of the Disk: ' folderdisk

sudo fdisk /dev/$disk
echo '/* === Type The Letters In The Following Order === */'
echo '> g'
echo '> p'
echo '> n + Press <Enter> + Press <Enter> + Press <Enter>'
echo '> w'
echo '/* =============================================== */'
df -h

sudo mkdir /media/$folderdisk3g
sudo mkfs.exfat -n $folderdisk /dev/$disk

sudo chown -R $username:$username /media/$folderdisk
sudo mount /dev/$disk /media/$folderdisk/ -o uid=$username,gid=$username
lsblk
echo ' '
echo ' '

echo '/* =============================================== */'
echo '/* ================== FTP Setup ================== */'
echo ' '
echo '> To continue the script, create another session and follow the instructions:'
echo '> Run the command: mkdir -p /media/'$folderdisk'/FTP'
echo '> Run: sudo nano /etc/vsftpd.conf'
echo '> Uncomment the following lines: '
echo '   > write_enable=YES'
echo '   > local_umask=022'
echo '   > chroot_local_user=YES'
echo '> Change the line: anonymous_enable=YES to anonymous_enable=NO'
echo '> Add the following lines: '
echo '   > user_sub_token=$USER'
echo '   > local_root=/media/'$folderdisk'/FTP'
echo ' '
echo '/* =============================================== */'
echo '/* =============================================== */'

echo ' '
echo ' '
sudo service vsftpd restart
df -h
#sudo umount /media/$folderdisk
ls -l /dev/disk/by-uuid/
read -p 'UUID of Disk: ' uuid
echo ' '
echo ' '
echo '/* ================== To Finish ================== */'
echo '> sudo nano /etc/fstab'
echo 'Paste this: UUID='$uuid' /media/'$folderdisk'/ ntfs-3g auto,nofail,noatime,users,rw,uid='$username',gid='$username' 0 0'
echo 'Press: Ctrl + X, Ctrl + Y, Enter'
echo '> sudo reboot'
echo 'To check everything, execute the following command to see if the system recognize the hard drive after it turns on:'
echo 'cd /media/'$folderdisk
echo '/* =============================================== */'
com
