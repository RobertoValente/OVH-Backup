#!/bin/bash

echo '/* =============================================== */'
echo '/* == Updating and Installing What Is Necessary == */'
sudo apt update -y && sudo apt upgrade -y
sudo apt install nodejs -y
sudo apt install npm -y
sudo apt install git -y
sudo apt install vsftpd -y
echo '/* =============================================== */'
echo '/* =============================================== */'

echo '/* =============================================== */'
echo '/* ================== HD Setup =================== */'

lsblk
read -p 'Disk: ' disk
mount | grep $disk

echo '/* === Type The Letters In The Following Order === */'
echo '> g'
echo '> p'
echo '> n + Press <Enter> + Press <Enter> + Press <Enter>'
echo '> w'
echo '/* =============================================== */'

read -p 'Insert your Username: ' username
sudo fdisk /dev/$disk
read -p 'Folder Name of the Disk: ' folderdisk
sudo mkfs.exfat -n $folderdisk /dev/$disk
df -h
sudo mkdir /media/$folderdisk
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
