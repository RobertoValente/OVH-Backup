#!/bin/bash

lsblk
read -p 'Disk: ' disk
mount | grep $disk

echo '/* === Type the letters in the following order === */'
echo '> g'
echo '> p'
echo '> n + Press <Enter> + Press <Enter> + Press <Enter>'
echo '> w'
echo '/* =============================================== */'

sudo fdisk /dev/$disk
read -p 'Folder Name of the Disk: ' folderdisk
sudo mkfs.exfat -n $folderdisk /dev/$disk
df -h
sudo mkdir /media/$folderdisk
read -p 'Username: ' username
sudo chown -R $username:$username /media/$folderdisk
sudo mount /dev/$disk /media/$folderdisk/ -o uid=$username,gid=$username
lsblk
df -h
sudo umount /media/$folderdisk
ls -l /dev/disk/by-uuid/
read -p 'UUID of Disk: ' uuid
echo ' '
echo ' '
echo '/* ================== To Finish ================== */'
echo '> sudo nano /etc/fstab'
echo 'Paste this: UUID='$uuid' /media/'$folderdisk'/ exfat auto,nofail,noatime,users,rw,uid='$username',gid='$username' 0 0'
echo 'Press: Ctrl + X, Ctrl + Y, Enter'
echo '> sudo reboot'
echo 'To check everything, execute the following command to see if the system recognize the hard drive after it turns on:'
echo 'cd /media/'$folderdisk
echo '/* =============================================== */'
